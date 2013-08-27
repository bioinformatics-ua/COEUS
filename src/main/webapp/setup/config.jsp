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
        <script src="<c:url value="/assets/js/coeus.api.js" />"></script>
        <script type="text/javascript">

            $(document).ready(function() {
                getConfigData();
                callURL("../../config/listenv/", envSuccess);


                $('#host').val("localhost");
                $('#port').val("3306");
                $('#path').val("coeus");
                $('#username').val("demo");
                $('#password').val("demo");

                $('#projectName').val("coeus.demo");
                $('#projectHomepage').val("http://bioinformatics.ua.pt/coeus/");
                $('#WebBase').val("http://localhost:8080/coeus/");
                $('#Endpoint').val("http://localhost:8080/coeus/sparql");
                $('#DatasetBase').val("http://bioinformatics.ua.pt/coeus/resource/");
                $('#WebResourcePrefix').val("resource/");
                
                //console.log(JSON.parse(generateMap()));

            });

            function generateMap() {

                var environment = $('#createEnvironment').val();

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
                    "$conf:webResourcePrefix": webResourcePrefix,
                    "$environment": environment
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
                $('#Setup').val(result.config.setup);

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

                //progress bar exit
                document.getElementById('bar').style.width = "100%";
                $('#progress').addClass('hide');
                document.getElementById('bar').class = "hide";

            }
            function save() {
                var url = "../../config/";

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

                // fill the config field
                var json = {
                    "config":
                            {"name": $('#Name').val(),
                                "description": $('#Description').val(),
                                "keyprefix": $('#KeyPrefix').val(),
                                "version": $('#Version').val(),
                                "ontology": $('#Ontology').val(),
                                "setup": $('#Setup').val(),
                                "sdb": "sdb.ttl",
                                "predicates": "predicates.csv",
                                "built": $('#Built').is(':checked'),
                                "debug": $('#Debug').is(':checked'),
                                "apikey": $('#ApiKey').val(),
                                "environment": $('#environment').val()
                            }
                };

                //fill the prefixes field
                var jsonObj = JSON.parse(JSON.stringify(json));
                jsonObj.prefixes = {};

                for (var i in tableArray) {
                    jsonObj.prefixes[tableArray[i][1]] = tableArray[i][2];
                }

                //send to server
                var send = url + "putconfig/" + encodeBars(JSON.stringify(jsonObj));
                console.log(send);
                //callAPI(send, "#result");

                //progress bar init
                document.getElementById('bar').style.width = "10%";
                $('#progress').removeClass('hide');
                $('#btnSave').html("Saving...");
                $('#btnSave').addClass('disabled');

                callURL(send, saveSuccess, saveError);
            }
            function saveSuccess(data) {
                console.log(data);
                
                if (data.status === 100) {
                    $('#resultSave').html(generateHtmlMessage("Success!", "All Saved. Now you can start build the COEUS Model.", "alert-success"));
                } else {
                    $('#resultSave').html(generateHtmlMessage("Warning!", data.message));
                }
                
                $('#btnSave').removeClass('disabled');
                $('#btnSave').html("Save it!");

                //progress bar exit
                document.getElementById('bar').style.width = "100%";
                $('#progress').addClass('hide');
                document.getElementById('bar').class = "hide";
            }
            function saveError(jqXHR, textStatus) {
                console.log(textStatus);
                $('#resultSave').html(generateHtmlMessage("ERROR!", textStatus));
            }
            function addPrefix() {
                $('#res').html('');
                var num = $("#tablePrefixes tr").length + 1;
                var key = $('#keyPrefixes').val();
                var value = $('#valuePrefixes').val();
                if ($("#prefix_" + key).html() === undefined) {
                    $('#tablePrefixes').append('<tr id="prefix_' + key + '"><td>' + num + '</td><td>' + key + '</td><td><a href="' + value + '">' + value + '</a></td><td><button onclick="removeById(\'prefix_' + key + '\',\'tablePrefixes\');" class="btn btn" type="button">Remove</button></td></tr>');
                } else {
                    $('#res').append('<p class="text-warning">This Key already exists.</p>');
                }
            }
            function changeTab(old_tab, new_tab) {
                $(old_tab).removeClass('active');
                $(new_tab).addClass('active');
            }

            function createEnv() {
                var env = $('#createEnvironment').val();
                if (env !== "")
                    callURL("../../config/newenv/" + env, createEnvResult, createEnvFail);
                    
            }

            function createEnvResult(result) {
                console.log(result);
                var env = $('#createEnvironment').val();
                if (result.status === 100) {
                    $('#environment').val(env);
                    $('#resultCreateEnv').html(generateHtmlMessage("Success!", "Environment <strong>"+env+"</strong> created. Please, configure it now.", "alert-success"));
                    $('#connections').removeClass('hide');
                } else {
                    $('#resultCreateEnv').html(generateHtmlMessage("Warning!", result.message));
                }

            }

            function createEnvFail(jqXHR, textStatus) {
                $('#resultCreateEnv').html(generateHtmlMessage("Error!", textStatus, "alert-error"));
            }
            
            function updateFilesOnEnv(){
                var env = $('#environment').val();
                if (env !== "")
                    callURL("../../config/putmap/" + encodeBars(generateMap()), upEnvResult, upEnvFail);
            }
            
            function upEnvResult(result) {
                console.log(result);
                var env = $('#environment').val();
                if (result.status === 100) {
                    $('#resultUpEnv').html(generateHtmlMessage("Success!", "Configurations saved on environment <strong>"+env+"</strong>. Please, press the next button.", "alert-success"));
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
                <h1>COEUS Setup</h1>
            </div>

            <div id="progress" class="progress progress-striped active" >
                <div id="bar" class="bar" style="width: 10%;"></div>
            </div>
            <div id="result">
            </div>
            <div class="tabbable"> <!-- Only required for left/right tabs -->
                <ul class="nav nav-tabs">
                    <li id="litab0" class="active"><a href="#tab0" data-toggle="tab">Start</a></li>
                    <li id="litab1" ><a href="#tab1" data-toggle="tab">Environment</a></li>
                    <li id="litab2" ><a href="#tab2" data-toggle="tab">Model</a></li>
                    <li id="litab3"><a href="#tab3" data-toggle="tab">Prefixes</a></li>
                    <li id="litab4"><a href="#tab4" data-toggle="tab">Finish</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab0">
                        <div class="text-center" style="height: 400px">
                            <p>In this section you will give some information to complete some setup files for COEUS.</p>
                            <p>To begin press the Start Wizard button.</p>
                            <a onclick="changeTab('#litab0', '#litab1');" href="#tab1" data-toggle="tab" class="btn btn-large btn-warning" type="button">Start Wizard <i class="icon-play icon-white"></i></a>
                            <p></p>
                            <p>If you do not want to change the configurations files, please skip this wizard.</p>
                            <a href="../seed/" class="btn btn-large" type="button">Skip <i class="icon-fast-forward"></i></a>
                        </div>

                    </div>
                    <div class="tab-pane" id="tab1">
                        <form class="form-horizontal" id="formCreateEnv">
                            <fieldset>
                                <legend>1.Environment</legend>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Environment">Create Environment</label>
                                    <div class="controls">
                                        <input id="createEnvironment" name="Environment" type="text" placeholder="Production" class="input-large"> <input id="environment" class="hide"></input>
                                        <p class="help-block">Name of the Environment</p>
                                    </div>
                                </div>

                                <!-- Button -->
                                <div class="control-group">
                                    <label class="control-label" for="btnCreateEnv"></label>
                                    <div class="controls">
                                        <a onclick="createEnv();" id="btnCreateEnv" name="btnCreateEnv" class="btn btn-success">Create <i class="icon-plus icon-white"></i></a>
                                    </div>
                                </div>
                                
                                <div id="resultCreateEnv">
                                    
                                </div>

                            </fieldset>
                        </form>
                        <form id="connections" class="form-horizontal hide">
                            <fieldset>
                                <legend>2.Database</legend>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="jdbcURL">JDBC URL</label>
                                    <div class="controls">
                                        jdbc:mysql://
                                        <input id="host" name="host" type="text" placeholder="localhost" class="input-large">
                                        : <input id="port" name="jdbcURL" type="text" placeholder="3306" class="input-mini">
                                        / <input id="path" name="path" type="text" placeholder="coeus" class="input-mini">

                                        <p class="help-block">Database connection URL</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="username">Database User</label>
                                    <div class="controls">
                                        <input id="username" name="username" type="text" placeholder="demo" class="input-large">

                                    </div>

                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="password">Database Password</label>
                                    <div class="controls">
                                        <input id="password" name="password" type="text" placeholder="demo" class="input-large">

                                    </div>
                                </div>

                                <legend>3.Pubby</legend>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="projectName">Project Name</label>
                                    <div class="controls">
                                        <input id="projectName" name="projectName" type="text" placeholder="coeus.demo" class="input-large">
                                        <p class="help-block">The name of the project, for display in page titles.</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="projectHomepage">Project Homepage</label>
                                    <div class="controls">
                                        <input id="projectHomepage" name="projectHomepage" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="input-xlarge">
                                        <p class="help-block">A project homepage or similar URL, for linking in page titles.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="WebBase">Web Base</label>
                                    <div class="controls">
                                        <input id="WebBase" name="WebBase" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="input-xlarge">
                                        <p class="help-block">The root URL where the Pubby web application is installed.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Endpoint">Sparql Enpoint</label>
                                    <div class="controls">
                                        <input id="Endpoint" name="Endpoint" type="text" placeholder="http://bioinformatics.ua.pt/coeus/sparql" class="input-xlarge">
                                        <p class="help-block">The URL of the SPARQL endpoint whose data we want to expose.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="DatasetBase">Dataset Base</label>
                                    <div class="controls">
                                        <input id="DatasetBase" name="DatasetBase" type="text" placeholder="http://bioinformatics.ua.pt/coeus/resource/" class="input-xlarge">
                                        <p class="help-block">The common URI prefix of the resource identifiers in the SPARQL dataset. Only resources with this prefix will be mapped and made available by Pubby.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="WebResourcePrefix">Web Resource Prefix</label>
                                    <div class="controls">
                                        <input id="WebResourcePrefix" name="WebResourcePrefix" type="text" placeholder="resource/" class="input-large">
                                        <p class="help-block">Prefix to the mapped web URIs.</p>
                                        <br/>
                                        <p class="help-block">For more information please visit the <a href="http://wifo5-03.informatik.uni-mannheim.de/pubby/">Pubby Homepage</a>.</p>

                                    </div>
                                </div>
                                
                                <!-- Button -->
                                <div class="control-group">
                                    <label class="control-label" for="btnUpEnv"></label>
                                    <div class="controls">
                                        <a onclick="updateFilesOnEnv();" id="btnUpEnv" name="btnUpEnv" class="btn btn-danger">Save Configuration</a>
                                    </div>
                                </div>
                                
                                <div id="resultUpEnv">
                                    
                                </div>


                            </fieldset>
                        </form>

                        <div class="text-left">
                            <a onclick="changeTab('#litab1', '#litab2');" href="#tab2" data-toggle="tab" class="btn btn-warning" type="button">Next <i class="icon-forward icon-white"></i></a>
                        </div>
                    </div>
                    <div class="tab-pane" id="tab2">
                        <form class="form-horizontal">
                            <fieldset>
                                <legend>4.Model Configurations</legend>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Name">Name</label>
                                    <div class="controls">
                                        <input id="Name" name="Name" type="text" placeholder="Uniprot" class="input-large">
                                        <p class="help-block">Name of the Model</p>
                                    </div>
                                </div>

                                <!-- Textarea -->
                                <div class="control-group">
                                    <label class="control-label" for="Description">Description</label>
                                    <div class="controls">                     
                                        <textarea id="Description" name="Description">Uniprot Setup Ontology</textarea>
                                        <p class="help-block">Model Description</p>
                                    </div>

                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="KeyPrefix">Key Prefix</label>
                                    <div class="controls">
                                        <input id="KeyPrefix" name="KeyPrefix" type="text" placeholder="coeus" class="input-large">
                                        <p class="help-block">The ontology prefix</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="ApiKey">Api Key</label>
                                    <div class="controls">
                                        <input id="ApiKey" name="ApiKey" type="text" placeholder="coeus|uavr" class="input-large">
                                        <p class="help-block">REST Api Key</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Version">Version</label>
                                    <div class="controls">
                                        <input id="Version" name="Version" type="text" placeholder="1.0" class="input-mini">
                                        <p class="help-block">Ontology Version</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Built">Built</label>
                                    <div class="controls">
                                        <label class="checkbox" >
                                            <input type="checkbox" id="Built" name="Built">
                                        </label>

                                        <p class="help-block">Import from the Model</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Debug">Debug</label>
                                    <div class="controls">
                                        <label class="checkbox" >
                                            <input type="checkbox" id="Debug" name="Debug">
                                        </label>
                                        <p class="help-block">Debug Log</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Ontology">Ontology</label>
                                    <div class="controls">
                                        <input id="Ontology" name="Ontology" type="text" placeholder="http://bioinformatics.ua.pt/coeus/ontology" class="input-xlarge">
                                        <p class="help-block">Ontology Location</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="SetupFile">Setup File</label>
                                    <div class="controls">
                                        <input id="SetupFile" name="SetupFile" type="text" placeholder="setup.rdf" class="input-xlarge">
                                        <p class="help-block">RDF File Location to Import to the DB</p>
                                    </div>
                                </div>
                                <div class="text-left">
                                    <a onclick="changeTab('#litab2', '#litab3');" href="#tab3" data-toggle="tab" class="btn btn-warning" type="button">Next <i class="icon-forward icon-white"></i></a>
                                </div>


                            </fieldset>
                        </form>

                    </div>
                    <div class="tab-pane" id="tab3">
                        <legend>5.Prefix Configurations</legend>
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
                        <div class="text-right">
                            <button onclick="" class="btn btn-success" href="#prefixesModal" role="button" data-toggle="modal" type="button">Add <i class="icon-plus icon-white"></i></button>
                        </div>
                        <div class="text-left">
                            <a onclick="changeTab('#litab3', '#litab4');" href="#tab4" data-toggle="tab" class="btn btn-warning" type="button">Next <i class="icon-forward icon-white"></i></a>
                        </div>


                    </div> 
                    <div class="tab-pane" id="tab4">
                        <div class="text-center" style="height: 200px">
                            <p>In order to save your progress press the Save button, please.</p>
                            <p class="text-warning">Warning: If you leaves this wizard without save it, some configurations will be lost.</p>
                            <button id="btnSave" onclick="save();" class="btn btn-large btn-danger" type="button">Save it! <i class="icon-briefcase icon-white"></i></button>
                            <br/><br/>
                            <div id="resultSave" class="text-left" style="width: 50%; margin-left: auto;margin-right: auto">
                            </div>
                        </div>
                        <div class="text-center" style="height: 200px">
                            <p>After saving the configurations you can start build the model for your application:</p>
                            <a id="btnStartBuild" href="../seed/" class="btn btn-warning" type="button">Build Model <i class="icon-home icon-white"></i></a>

                        </div>
                    </div>

                </div>



            </div>


            <!-- Modal -->
            <div id="prefixesModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="prefixesModal" aria-hidden="true">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
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




        </s:layout-component>
    </s:layout-render>
