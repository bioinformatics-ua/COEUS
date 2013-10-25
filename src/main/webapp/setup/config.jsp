<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/setup/html.jsp">
    <s:layout-component name="title">COEUS Setup</s:layout-component>
    <s:layout-component name="custom_scripts"> 
        <script src="<c:url value="/assets/js/jquery.js" />"></script>
        <script src="<c:url value="/assets/js/coeus.sparql.js" />"></script>
        <script src="<c:url value="/assets/js/coeus.setup.js" />"></script>
        <script type="text/javascript">

            $(document).ready(function() {
                getConfigData();
                callURL("../../config/listenv/", envSuccess);
                $('.pager').addClass('hide');

                $('#host').val("localhost");
                $('#port').val("3306");
                $('#path').val("coeus");
                $('#username').val("root");
                //$('#password').val("demo");

                $('#projectName').val("coeus.demo");
                $('#projectHomepage').val("http://bioinformatics.ua.pt/coeus/");
                $('#WebBase').val("http://localhost:8080/coeus/");
                $('#Endpoint').val("http://localhost:8080/coeus/sparql");
                $('#DatasetBase').val("http://bioinformatics.ua.pt/coeus/resource/");
                $('#WebResourcePrefix').val("resource/");

                //console.log(JSON.parse(generateMap()));

                //Associate Enter key:
                document.onkeypress = function(event) {
                    //Enter key pressed
                    if (event.charCode === 13) {
                        console.log(document.activeElement.getAttribute('id'));
                        if (document.activeElement.getAttribute('id') === ("createBtnEnv"))
                            $('#createBtnEnv').click();
                        if (document.activeElement.getAttribute('id') === ("createBtnDb"))
                            $('#createBtnDb').click();
                        if (document.activeElement.getAttribute('id') === ("createBtnPubby"))
                            $('#createBtnPubby').click();
                        if (document.activeElement.getAttribute('id') === ("createBtnModel"))
                            $('#createBtnModel').click();
                        if (document.activeElement.getAttribute('id') === ("createBtnPrefixes"))
                            $('#createBtnPrefixes').click();

                    }
                };

            });

            function generateMap() {

                var host = $('#host').val();
                var port = $('#port').val();
                var path = $('#path').val();
                var jdbcURL = "jdbc:mysql://" + host + ":" + port + "/" + path + "%3FautoReconnect=true";

                var username = $('#username').val();
                var password = $('#password').val();

                var projectName = $('#projectName').val();
                var projectHomepage = $('#projectHomepage').val();
                var webBase = $('#WebBase').val();
                var endpoint = $('#Endpoint').val();
                var datasetBase = $('#DatasetBase').val();
                var webResourcePrefix = $('#WebResourcePrefix').val();

                var json = {
                    "$sdb:jdbcURL": jdbcURL,
                    "$sdb:sdbUser": username,
                    "$sdb:sdbPassword": password,
                    "$conf:projectName": projectName,
                    "$conf:projectHomepage": projectHomepage,
                    "$conf:webBase": webBase,
                    "$conf:sparqlEndpoint": endpoint,
                    "$conf:datasetBase": datasetBase,
                    "$conf:webResourcePrefix": webResourcePrefix
                };

                return JSON.stringify(json);
            }

            function envSuccess(result) {
                console.log(result);
            }

            function getConfigData() {
                $.ajax({url: "../../config/getconfig/", dataType: 'json'}).done(fillConfig).fail(
                        function(jqXHR, textStatus) {
                            console.log('Call: ' + url + ' ' + 'ERROR: ' + textStatus + '');
                            // Server communication error function handler.
                        });
            }

            function fillConfig(result) {
                console.log(result);

                //fill the config fields
                $('#Name').val(result.config.name);
                $('#Description').val(result.config.description);
                $('#KeyPrefix').val(result.config.keyprefix);
                $('#Version').val(result.config.version);
                $('#Description').val(result.config.description);
                //$('#Environment').val(result.config.environment);
                $('#ApiKey').val(result.config.apikey);
                $('#Ontology').val(result.config.ontology);
                $('#SetupFile').val(result.config.setup);

                if (result.config.built.toString() === "true")
                    $('#Built').prop('checked', true);
                else
                    $('#Built').prop(':checked', false);

                if (result.config.debug.toString() === "true")
                    $('#Debug').prop('checked', true);
                else
                    $('#Debug').prop('checked', false);


                //fill the prefixes table
                var json = (result.prefixes);
                var i = 0;
                for (var r in json) {
                    var val = json[r];
                    i++;
                    $('#tablePrefixes').append('<tr id="prefix_' + r + '"><td>' + i + '</td><td>' + r + '</td><td><a href="' + val + '">' + val + '</a></td><td><button onclick="removeById(\'prefix_' + r + '\',\'tablePrefixes\');" class="btn btn" type="button">Remove</button></td></tr>');
                }

            }
            function addPrefix() {
                $('#res').html('');
                var num = $("#tablePrefixes tr").length + 1;
                var key = $('#keyPrefixes').val();
                var value = $('#valuePrefixes').val();
                if ($("#prefix_" + key).html() === undefined) {
                    $('#tablePrefixes').append('<tr id="prefix_' + key + '"><td>' + num + '</td><td>' + key + '</td><td><a href="' + value + '">' + value + '</a></td><td><button onclick="removeById(\'prefix_' + key + '\',\'tablePrefixes\');" class="btn btn" type="button">Remove</button></td></tr>');
                    $('#closePrefixesModal').click();
                } else {
                    $('#res').append('<p class="text-warning">This Key already exists.</p>');
                }
            }
            function changeTab(old_tab, new_tab, percentage) {
                $(old_tab).removeClass('active');
                $(new_tab).addClass('active');
                document.getElementById('bar').style.width = percentage;
            }

            function createEnv() {
                var env = $('#createEnvironment').val();
                if (env !== "") {
                    var url = "../../config/newenv/" + env;
                    $('#envForm').removeClass('error');
                    $('#createBtnEnv').addClass('disabled');
                    $('#createBtnEnv').html("Waiting...");
                    callURL(url, createResult.bind(this, "#resultCreateEnv", '#createBtnEnv', '#nextBtnEnv'), showError.bind(this, "#resultCreateEnv", url));
                } else {
                    $('#envForm').addClass('controls control-group error');
                }
            }
            function createDB() {

                // verify all fields:
                var empty = false;
                if ($('#url') === '') {
                    $('#urlForm').addClass('controls control-group error');
                    empty = true;
                } else
                    $('#urlForm').removeClass('error');

                if (!empty) {
                    var url = "../../config/db/" + encodeBars(generateMap());
                    $('#createBtnDb').addClass('disabled');
                    $('#createBtnDb').html("Waiting...");
                    callURL(url, createResult.bind(this, "#resultCreateDb", '#createBtnDb', '#nextBtnDb'), showError.bind(this, "#resultCreateDb", url));

                }

            }

            function createPubby() {

                // verify all fields:
                var empty = false;
                if ($('#url') === '') {
                    $('#pubbyForm').addClass('controls control-group error');
                    empty = true;
                } else
                    $('#pubbyForm').removeClass('error');

                if (!empty) {
                    var url = "../../config/pubby/" + encodeBars(generateMap());
                    $('#createBtnPubby').addClass('disabled');
                    $('#createBtnPubby').html("Waiting...");
                    callURL(url, createResult.bind(this, "#resultPubby", '#createBtnPubby', '#nextBtnPubby'), showError.bind(this, "#resultPubby", url));

                }

            }
            function createModel() {

                // verify all fields:
                var empty = false;
                if ($('#ApiKey') === '') {
                    $('#modelForm').addClass('controls control-group error');
                    empty = true;
                } else
                    $('#modelForm').removeClass('error');

                if (!empty) {

                    // fill the config field
                    var json = {
                        "config":
                                {
                                    "name": $('#Name').val(),
                                    "description": $('#Description').val(),
                                    "keyprefix": $('#KeyPrefix').val(),
                                    "version": $('#Version').val(),
                                    "ontology": $('#Ontology').val(),
                                    //"setup": "setup.rdf",
                                    //"sdb": "sdb.ttl",
                                    //"predicates": "predicates.csv",
                                    //"built": "false",
                                    "debug": $('#Debug').is(':checked'),
                                    "apikey": $('#ApiKey').val(),
                                    "wizard": true
                                }
                    };

                    var url = "../../config/config/" + encodeBars(JSON.stringify(json));
                    $('#createBtnModel').addClass('disabled');
                    $('#createBtnModel').html("Waiting...");
                    callURL(url, createResult.bind(this, "#resultModel", '#createBtnModel', '#nextBtnModel'), showError.bind(this, "#resultModel", url));

                }

            }
            function createPrefixes() {

                // verify all fields:
                var empty = false;
                if ($('#ApiKey') === '') {
                    $('#modelForm').addClass('controls control-group error');
                    empty = true;
                } else
                    $('#modelForm').removeClass('error');

                if (!empty) {

                    //Get all prefixes from table
                    var tableArray = [];
                    $("#tablePrefixes tr").each(function() {
                        var arrayOfThisRow = [];
                        var tableData = $(this).find('td');
                        if (tableData.length > 0) {
                            tableData.each(function() {
                                arrayOfThisRow.push($(this).text());
                            });
                            tableArray.push(arrayOfThisRow);
                        }
                    });

                    var json = {"prefixes": {}};

                    for (var i in tableArray) {
                        json.prefixes[tableArray[i][1]] = tableArray[i][2];
                    }
                    console.log(json);
                    var url = "../../config/prefixes/" + encodeBars(JSON.stringify(json));
                    $('#createBtnPrefixes').addClass('disabled');
                    $('#createBtnPrefixes').html("Waiting...");
                    callURL(url, createResult.bind(this, "#resultPrefixes", '#createBtnPrefixes', '#nextBtnPrefixes'), showError.bind(this, "#resultPrefixes", url));

                }

            }


            function createResult(id, btnCreate, btnNext, result) {
                console.log(result);
                $(btnCreate).removeClass('disabled');
                $(btnCreate).html('Save Changes');
                if (result.status === 100) {
                    $(id).html(generateHtmlMessage("Success!", "Please, press next.", "alert-success"));
                    $(btnNext).removeClass('hide');
                } else {
                    $(id).html(generateHtmlMessage("Warning!", result.message));
                }

            }

            function upEnvResult(result) {
                console.log(result);
                var env = $('#environment').val();
                if (result.status === 100) {
                    $('#resultUpEnv').html(generateHtmlMessage("Success!", "Configurations saved on environment <strong>" + env + "</strong>. Please, press the next button.", "alert-success"));
                } else {
                    $('#resultUpEnv').html(generateHtmlMessage("Warning!", result.message));
                }

            }

            function upEnvFail(jqXHR, textStatus) {
                $('#resultUpEnv').html(generateHtmlMessage("Error!", textStatus, "alert-error"));
            }

        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <br/><br/>
        <div class="container">

            <div id="header" class="page-header">
                <h1>COEUS Setup Wizard</h1>
            </div>

            <div id="progress" class="progress progress-striped active" >
                <div id="bar" class="bar" style="width: 0%;"></div>
            </div>
            <div id="result">
            </div>
            <div class="tabbable"> <!-- Only required for left/right tabs href="#tab1" data-toggle="tab"-->
                <ul class="nav nav-tabs">
                    <li id="litab1" class="active"><a >1. Start <i class="icon-chevron-right"></i></a></li>
                    <li id="litab2" ><a >2. Environment <i class="icon-chevron-right"></i></a></li>
                    <li id="litab3" ><a >3. Database <i class="icon-chevron-right"></i></a></li>
                    <li id="litab4" ><a >4. Pubby <i class="icon-chevron-right"></i></a></li>
                    <li id="litab5" ><a >5. Model <i class="icon-chevron-right"></i></a></li>
                    <li id="litab6"><a >6. Prefixes <i class="icon-chevron-right"></i></a></li>
                    <li id="litab7" ><a >7. Finish</a></li>
                </ul>
                <div class="tab-content" style="min-height: 300px">
                    <div class="tab-pane active" id="tab1" >
                        <div class="text-center" >
                            <p>In this section you will give some information to complete some setup files for COEUS.</p>
                            <p>To begin press the Start Wizard button.</p>
                            <button onclick="changeTab('#litab1', '#litab2', '15%');" href="#tab2" data-toggle="tab" class="btn btn-large btn-warning" type="button">Start Wizard <i class="icon-play icon-white"></i></button>
                            <p></p>
                            <p>If you do not want to change the configurations files, please skip this wizard.</p>
                            <button href="../seed/" class="btn btn-large" type="button">Skip <i class="icon-fast-forward"></i></button>
                        </div>

                    </div>
                    <div class="tab-pane" id="tab2">

                        <form class="form-horizontal" name="envForm">
                            <fieldset>
                                <legend>2.Environment</legend>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Environment">Create Environment</label>
                                    <div class="controls" id="envForm">
                                        <input tabindex="1" id="createEnvironment" name="Environment" type="text" placeholder="Production" class="input-large"> <input id="environment" class="hide"></input>
                                        <p class="help-block">Name of the Environment used to store application settings.</p>
                                    </div>
                                </div>
                                <!-- Button -->
                                <div class="control-group">
                                    <label class="control-label" for="createBtnEnv"></label>
                                    <div class="controls">
                                        <a tabindex="2" onclick="createEnv();" id="createBtnEnv" name="createBtnEnv" class="btn btn-primary">Save Changes</a>
                                    </div>
                                </div>

                            </fieldset>
                        </form>


                        <div id="resultCreateEnv"></div>

                        <ul class="pager " id="nextBtnEnv">
                            <!-- <li class="previous  hide" >
                                 <a onclick="changeTab('#litab2', '#litab1');" href="#tab1" data-toggle="tab">&larr; Previous</a>
                             </li>-->
                            <li class="next">
                                <a tabindex="3" onclick="changeTab('#litab2', '#litab3', '30%');" href="#tab3" data-toggle="tab" >Next &rarr;</a>
                            </li>
                        </ul>
                    </div>
                    <div class="tab-pane" id="tab3">

                        <form class="form-horizontal">
                            <fieldset>
                                <legend>3.Database</legend>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="jdbcURL">JDBC URL</label>
                                    <div class="controls" id="urlForm">
                                        jdbc:mysql://
                                        <input tabindex="1" id="host" name="host" type="text" placeholder="localhost" class="input-large">
                                        : <input tabindex="2" id="port" name="jdbcURL" type="text" placeholder="3306" class="input-mini">
                                        / <input tabindex="3" id="path" name="path" type="text" placeholder="coeus" class="input-mini">

                                        <p class="help-block">Database connection URL</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="username">Database User</label>
                                    <div class="controls" id="usernameForm">
                                        <input tabindex="4" id="username" name="username" type="text" class="input-large">

                                    </div>

                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="password">Database Password</label>
                                    <div class="controls" id="passwordForm">
                                        <input tabindex="5" id="password" name="password" type="password" placeholder="demo" class="input-large">
                                        <p class="help-block">The user must have privileges to create the DB and the tables structure.</p>
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label class="control-label" for="createBtnDb"></label>
                                    <div class="controls">
                                        <a tabindex="6" onclick="createDB();" id="createBtnDb" name="createBtnDb" class="btn btn-primary">Save Changes</a>
                                    </div>
                                </div>
                            </fieldset>
                        </form>
                        <div id="resultCreateDb">

                        </div>
                        <ul class="pager" id="nextBtnDb">
                            <!--<li class="previous">
                                <a onclick="changeTab('#litab3', '#litab2');" href="#tab2" data-toggle="tab">&larr; Previous</a>
                            </li>-->
                            <li class="next">
                                <a tabindex="7" onclick="changeTab('#litab3', '#litab4', '45%');" href="#tab4" data-toggle="tab" >Next &rarr;</a>
                            </li>
                        </ul>
                    </div>
                    <div class="tab-pane" id="tab4">

                        <form id="pubbyForm" class="form-horizontal">
                            <fieldset>
                                <legend>4.Pubby</legend>
                                <div class="row-fluid">

                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="projectHomepage">Project Homepage</label>
                                        <div class="controls">
                                            <input tabindex="1" id="projectHomepage" name="projectHomepage" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="input-xlarge">
                                            <p class="help-block">A project homepage or similar URL, for linking in page titles.</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="projectName">Project Name</label>
                                        <div class="controls">
                                            <input tabindex="2" id="projectName" name="projectName" type="text" placeholder="coeus.demo" class="input-large">
                                            <p class="help-block">The name of the project, for display in page titles.</p>
                                        </div>
                                    </div>



                                </div>
                                <div class="row-fluid">
                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="Endpoint">Sparql Enpoint</label>
                                        <div class="controls">
                                            <input tabindex="3" id="Endpoint" name="Endpoint" type="text" placeholder="http://bioinformatics.ua.pt/coeus/sparql" class="input-xlarge">
                                            <p class="help-block">The URL of the SPARQL endpoint whose data we want to expose.</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="WebBase">Web Base</label>
                                        <div class="controls">
                                            <input tabindex="4" id="WebBase" name="WebBase" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="input-large">
                                            <p class="help-block">The root URL where the Pubby web application is installed.</p>
                                        </div>
                                    </div>

                                </div>
                                <div class="row-fluid">
                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="DatasetBase">Dataset Base</label>
                                        <div class="controls">
                                            <input tabindex="5" id="DatasetBase" name="DatasetBase" type="text" placeholder="http://bioinformatics.ua.pt/coeus/resource/" class="input-xlarge">
                                            <p class="help-block">The common URI prefix of the resource identifiers in the SPARQL dataset. Only resources with this prefix will be mapped and made available by Pubby.</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="WebResourcePrefix">Web Resource Prefix</label>
                                        <div class="controls">
                                            <input tabindex="6" id="WebResourcePrefix" name="WebResourcePrefix" type="text" placeholder="resource/" class="input-medium">
                                            <p class="help-block">Prefix to the mapped web URIs.</p>
                                            <br/>

                                        </div>
                                    </div>
                                </div>
                                <!-- Info    -->
                                <div class="control-group">
                                    <label class="control-label"></label>
                                    <div class="controls">
                                        <p class="help-block">For more information please visit the <a href="http://wifo5-03.informatik.uni-mannheim.de/pubby/">Pubby Homepage</a>.</p>
                                    </div>
                                </div>

                                <!-- Button -->
                                <div class="control-group">
                                    <label class="control-label" for="nextBtnPubby"></label>
                                    <div class="controls">
                                        <a tabindex="7" onclick="createPubby();" id="createBtnPubby" class="btn btn-primary">Save Changes</a>
                                    </div>
                                </div>

                                <div id="resultPubby"></div>

                            </fieldset>
                        </form>
                        <ul class="pager" id="nextBtnPubby">
                            <!--<li class="previous">
                                <a onclick="changeTab('#litab4', '#litab3');" href="#tab3" data-toggle="tab">&larr; Previous</a>
                            </li>-->
                            <li class="next">
                                <a tabindex="8" onclick="changeTab('#litab4', '#litab5', '60%');" href="#tab5" data-toggle="tab" >Next &rarr;</a>
                            </li>
                        </ul>

                    </div>
                    <div class="tab-pane" id="tab5">

                        <form class="form-horizontal" id="modelForm">
                            <fieldset>
                                <legend>5.Model Configurations</legend>

                                <div class="row-fluid">

                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="Name">Name</label>
                                        <div class="controls">
                                            <input tabindex="1" id="Name" name="Name" type="text" placeholder="Uniprot" class="input-large">
                                            <p class="help-block">Name of the Model</p>
                                        </div>
                                    </div>

                                    <!-- Textarea -->
                                    <div class="control-group span6">
                                        <label class="control-label" for="Description">Description</label>
                                        <div class="controls">                     
                                            <!--<textarea tabindex="2" id="Description" name="Description">Uniprot Setup Ontology</textarea>-->
                                            <input tabindex="2" id="Description" name="Description" type="text" placeholder="Uniprot Setup Ontology">
                                            <p class="help-block">Model Description</p>
                                        </div>

                                    </div>

                                </div>

                                <div class="row-fluid">

                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="Ontology">Ontology URL</label>
                                        <div class="controls">
                                            <input tabindex="3" id="Ontology" name="Ontology" type="text" placeholder="http://bioinformatics.ua.pt/coeus/ontology" class="input-xlarge">
                                            <p class="help-block">Ontology Location</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="KeyPrefix">Key Prefix</label>
                                        <div class="controls">
                                            <input tabindex="4" id="KeyPrefix" name="KeyPrefix" type="text" placeholder="coeus" class="input-mini">
                                            <p class="help-block">The ontology prefix</p>
                                        </div>
                                    </div>


                                </div>
                                <div class="row-fluid">

                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="ApiKey">Api Key</label>
                                        <div class="controls">
                                            <input tabindex="5" id="ApiKey" name="ApiKey" type="text" placeholder="coeus|uavr" class="input-large">
                                            <p class="help-block">REST Api Key</p>
                                        </div>
                                    </div>


                                    <!-- Text input-->
                                    <div class="control-group span6">
                                        <label class="control-label" for="Version">Version</label>
                                        <div class="controls">
                                            <input tabindex="6" id="Version" name="Version" type="text" placeholder="1.0" class="input-mini">
                                            <p class="help-block">Ontology Version</p>
                                        </div>
                                    </div>

                                </div>


                                <!-- Text input
                                <div class="control-group">
                                    <label class="control-label" for="Built">Built</label>
                                    <div class="controls">
                                        <label class="checkbox" >
                                            <input type="checkbox" id="Built" name="Built">
                                        </label>

                                        <p class="help-block">Import from the Model</p>
                                    </div>
                                </div>-->

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Debug">Debug</label>
                                    <div class="controls">
                                        <label class="checkbox" >
                                            <input tabindex="7" type="checkbox" id="Debug" name="Debug">
                                        </label>
                                        <p class="help-block">Debug Log</p>
                                    </div>
                                </div>

                                <!-- Text input
                                <div class="control-group">
                                    <label class="control-label" for="SetupFile">Setup File</label>
                                    <div class="controls">
                                        <input id="SetupFile" name="SetupFile" type="text" placeholder="setup.rdf" class="input-xlarge">
                                        <p class="help-block">RDF File Location to Import to the DB</p>
                                    </div>
                                </div>-->
                                <!-- Button -->
                                <div class="control-group">
                                    <label class="control-label" for="nextBtnModel"></label>
                                    <div class="controls">
                                        <a tabindex="8" onclick="createModel();" id="createBtnModel" class="btn btn-primary">Save Changes</a>
                                    </div>
                                </div>
                            </fieldset>
                        </form>

                        <div id="resultModel"></div>
                        <ul class="pager" id="nextBtnModel">
                            <!--<li class="previous">
                                <a onclick="changeTab('#litab5', '#litab4');" href="#tab4" data-toggle="tab">&larr; Previous</a>
                            </li>-->
                            <li class="next">
                                <a tabindex="9" onclick="changeTab('#litab5', '#litab6', '75%');" href="#tab6" data-toggle="tab" >Next &rarr;</a>
                            </li>
                        </ul>

                    </div>
                    <div class="tab-pane" id="tab6">

                        <legend>6.Prefix Configurations</legend>
                        <div class="text-right">
                            <button onclick="" class="btn btn-success" href="#prefixesModal" role="button" data-toggle="modal" type="button">Add <i class="icon-plus icon-white"></i></button>
                        </div>
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>
                                        #
                                    </th>
                                    <th>
                                        Prefix
                                    </th>
                                    <th>
                                        URL
                                    </th>
                                    <th>
                                        Actions
                                    </th>
                                </tr>
                            </thead>
                            <tbody id="tablePrefixes">

                            </tbody>
                        </table>

                        <div class="control-group">
                            <label class="control-label" for="nextBtnPrefixes"></label>
                            <div class="controls">
                                <button onclick="createPrefixes();" id="createBtnPrefixes" class="btn btn-primary">Save Changes</button>
                            </div>
                        </div>
                        <div id="resultPrefixes"></div>

                        <ul class="pager" id="nextBtnPrefixes">
                            <!--<li class="previous">
                                <a onclick="changeTab('#litab6', '#litab5');" href="#tab5" data-toggle="tab">&larr; Previous</a>
                            </li>-->
                            <li class="next">
                                <a onclick="changeTab('#litab6', '#litab7', '100%');" href="#tab7" data-toggle="tab" >Next &rarr;</a>
                            </li>
                        </ul>

                    </div> 
                    <div class="tab-pane" id="tab7">
                        <div class="text-center" style="height: 100px">
                            <p>You have <span class="text-success">successful finished</span> the Setup Wizard. You can now start build your application model.</p>
                            <p class="text-error">Warning: It is recommended that you restart your application server to apply the new configurations.</p>

                            <a tabindex="1" id="btnStartBuild" href="../seed/" class="btn btn-info btn-large" type="button">Build Model <i class="icon-home icon-white"></i></a>

                        </div>
                        <div class="text-center" style="height: 200px">
                            <p>
                            <p>If you want to make additional changes please run again this wizard:</p>
                            <a tabindex="2" id="btnStartWizard" href="../config/" class="btn btn-warning btn-large" type="button">Run Again <i class="icon-refresh icon-white"></i></a>

                            </p>

                        </div>

                    </div>

                </div>



            </div>


            <!-- Modal -->
            <div id="prefixesModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="prefixesModal" aria-hidden="true">
                <div class="modal-header">
                    <button type="button" id="closePrefixesModal" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                    <h3 id="prefixesModalLabel">Add Prefix</h3>
                </div>
                <div class="modal-body">

                    <div id="keyPrefixesForm" >
                        <label class="control-label" for="title">Key</label>
                        <input class="input-mini" id="keyPrefixes" type="text" placeholder="dc" > <i class="icon-question-sign" data-toggle="tooltip" title="The Key of the prefix" ></i>
                    </div>
                    <div id="valuePrefixesForm"> 
                        <label class="control-label" for="label">Value</label>
                        <input class="input-xlarge" id="valuePrefixes" type="text" placeholder="http://purl.org/dc/elements/1.1/"> <i class="icon-question-sign" data-toggle="tooltip" title="The prefix URL" ></i>
                    </div>

                </div>
                <div class="modal-footer">
                    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                    <button class="btn btn-success" id="addPrefixButton" onclick="addPrefix();">Add <i class="icon-plus icon-white"></i></button>
                </div>
            </div>

        </div>

    </s:layout-component>
</s:layout-render>
