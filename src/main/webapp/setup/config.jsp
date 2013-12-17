<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">COEUS Setup</s:layout-component>
    <s:layout-component name="custom_scripts"> 
        <script type="text/javascript">

            $(document).ready(function() {
                //changeSidebar('#wizard');
                getConfigData();
                //callURL("../../config/listenv/", envSuccess);
                $('.next').addClass('hide');

                //$('#host').val("localhost");
                //$('#port').val("3306");
                //$('#path').val("coeus");
                //$('#username').val("root");
                //$('#password').val("demo");

                $('#projectName').val("coeus.demo");
                $('#projectHomepage').val("http://bioinformatics.ua.pt/coeus/");
                //$('#WebBase').val("http://localhost:8080/coeus/");
                //$('#Endpoint').val("http://localhost:8080/coeus/sparql");
                //$('#DatasetBase').val("http://bioinformatics.ua.pt/coeus/resource/");
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
                tooltip();

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
                buildApiKeysList();
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
                    $('#tablePrefixes').append('<tr id="prefix_' + r + '"><td>' + i + '</td><td>' + r + '</td><td><a href="' + val + '">' + val + '</a></td><td><button onclick="removeById(\'prefix_' + r + '\',\'tablePrefixes\');" class="btn btn-default" type="button">Remove</button></td></tr>');
                }

            }
            function addPrefix() {
                $('#res').html('');
                var num = $("#tablePrefixes tr").length + 1;
                var key = $('#keyPrefixes').val();
                var value = $('#valuePrefixes').val();
                if ($("#prefix_" + key).html() === undefined) {
                    $('#tablePrefixes').append('<tr id="prefix_' + key + '"><td>' + num + '</td><td>' + key + '</td><td><a href="' + value + '">' + value + '</a></td><td><button onclick="removeById(\'prefix_' + key + '\',\'tablePrefixes\');" class="btn btn-default" type="button">Remove</button></td></tr>');
                    $('#closePrefixesModal').click();
                } else {
                    $('#res').append('<p class="text-warning">This Key already exists.</p>');
                }
                $('#keyPrefixes').val('');
                $('#valuePrefixes').val('');
            }
            function changeProgress(percentage) {
                document.getElementById('bar').style.width = percentage;
            }

            function createEnv() {
                var env = $('#createEnvironment').val();
                if (env !== "") {
                    var url = "../../config/newenv/" + env;
                    $('#envForm').removeClass('has-error');
                    $('#createBtnEnv').addClass('disabled');
                    $('#createBtnEnv').html("Waiting...");
                    callURL(url, createResult.bind(this, "#resultCreateEnv", '#createBtnEnv', '#nextBtnEnv'), showError.bind(this, "#resultCreateEnv", url));
                } else {
                    $('#envForm').addClass('has-error');
                }
            }
            function createDB() {

                // verify all fields:
                var empty = false;
                if ($('#host').val() === '') {
                    $('#urlForm').addClass('has-error');
                    empty = true;
                } else
                    $('#urlForm').removeClass('has-error');
                if ($('#port').val() === '') {
                    $('#urlForm').addClass('has-error');
                    empty = true;
                } else
                    $('#urlForm').removeClass('has-error');
                if ($('#path').val() === '') {
                    $('#urlForm').addClass('has-error');
                    empty = true;
                } else
                    $('#urlForm').removeClass('has-error');
                
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
                    $('#pubbyForm').addClass('has-error');
                    empty = true;
                } else
                    $('#pubbyForm').removeClass('has-error');

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
                    $('#modelForm').addClass('has-error');
                    empty = true;
                } else
                    $('#modelForm').removeClass('has-error');

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
                    $('#modelForm').addClass('has-error');
                    empty = true;
                } else
                    $('#modelForm').removeClass('has-error');

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
                    $(id).html(generateHtmlMessage("Warning!", result.message, "alert-warning"));
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
                $('#resultUpEnv').html(generateHtmlMessage("Error!", textStatus, "alert-danger"));
            }

            function reload() {
                var url = "../../../manager/text/reload?path=/coeus";
                callURL(url, function(result) {
                    console.log(result);
                });
            }
            function fillURL() {
                var projectHomepage = $('#projectHomepage').val();
                $('#DatasetBase').val(projectHomepage + "resource/");
            }
            function sparqlFill() {
                var webBase = $('#WebBase').val();
                $('#Endpoint').val(webBase + "sparql");
            }
            function removeApiKey() {
                var e = document.getElementById("dropdownkeys");
                try {
                    var value = e.options[e.selectedIndex].id;
                    removeById(value, "dropdownkeys");
                    buildInputApi();
                } catch (e) {
                }

            }
            function buildInputApi() {
                var values = [];
                var sel = document.getElementById('dropdownkeys');
                for (var i = 0, n = sel.options.length; i < n; i++) {
                    if (sel.options[i].value) values.push(sel.options[i].value);
                }
                $('#ApiKey').val(values.join("|"));
            }
            function updateApiKeys() {
                var typeahead = $('#putApiKey').val();
                var prop = $('#ApiKey').val();

                if (typeahead !== "" && prop.indexOf(typeahead) === -1) {
                    if (prop !== "")
                        prop = prop + "|";
                    $('#ApiKey').val(prop + typeahead);
                    $('#putApiKey').val("");

                    buildApiKeysList();
                }
            }
            function buildApiKeysList() {
                var array = $('#ApiKey').val().split("|");
                $('#dropdownkeys').html("");
                console.log(array);
                for (var i in array) {
                    $('#dropdownkeys').append('<option id="key_' + array[i] + '">' + array[i] + '</option>');
                }
            }
            function reload() {
                $('.reload').addClass('disabled');
                $('.reload').html('Loading.. <i class="fa fa-spinner fa-spin"></i>');
                reloadContext(function(result) {
                    $('#resultReload').html(generateHtmlMessage(result, '<div>&nbsp;</div><a tabindex="1" id="btnStartBuild" href="../seed/" class="btn btn-success btn-lg" type="button">Start with COEUS<i class="icon-home icon-white"></i></a>', "alert-success"));
                }, function(jqXHR, result) {
                    $('#resultReload').html(generateHtmlMessage('Error! ', result, "alert-danger"));
                });
            }

        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">

            <div id="header" class="page-header">
                <h1>Wizard Setup</h1>
            </div>

            <ol class="breadcrumb">
                <li id="breadHome"><span class="glyphicon glyphicon-home"></span> </li>
                <li class="active">Wizard</li>
            </ol>

            <div id="progress" class="progress progress-striped active" >
                <div id="bar" class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
            </div>
            <div id="result">
            </div>

            <div class="panel panel-primary">
                <div class="panel-heading">
                    <div class="panel-title"><i class="fa fa-wrench"></i> Wizard</div>
                </div>
                <div class="panel-body">
                    <!-- Nav tabs -->
                    <ul class="nav nav-tabs nav-justified" id="myTab">
                        <li><a href="#start" data-toggle="tab">1. Start <i class="glyphicon glyphicon-chevron-right"></i></a>
                        </li>
                        <li><a href="#environment" data-toggle="tab">2. Environment <i class="glyphicon glyphicon-chevron-right"></i></a>
                        </li>
                        <li><a href="#model" data-toggle="tab">3. Model <i class="glyphicon glyphicon-chevron-right"></i></a>
                        </li>
                        <li><a href="#database" data-toggle="tab">4. Database <i class="glyphicon glyphicon-chevron-right"></i></a>
                        </li>
                        <li><a href="#pubby" data-toggle="tab">5. Pubby <i class="glyphicon glyphicon-chevron-right"></i></a>
                        </li>

                        <li><a href="#prefixes" data-toggle="tab">6. Prefixes <i class="glyphicon glyphicon-chevron-right"></i></a>
                        </li>
                        <li><a href="#overview" data-toggle="tab">7. Load <i class="fa fa-flag-checkered"></i></a>
                        </li>

                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div class="tab-pane fade in active" id="start">
                            <div class="text-center" >
                                <div>&nbsp;</div>
                                <p>In this section you will give some information to complete some setup files for COEUS.</p>
                                <p>To begin press the Start Wizard button.</p>
                                <button onclick="$('#myTab li:eq(1) a').tab('show');
                changeProgress('15%');" class="btn btn-lg btn-primary" type="button">Start Wizard <i class="glyphicon glyphicon-play"></i></button>                      
                            </div>
                        </div>
                        <div class="tab-pane fade" id="environment">
                            <div>&nbsp;</div>
                            <p class="container"><span class="label label-info">Info</span> An environment is used to store application settings.</p>
                            <div>&nbsp;</div>
                            <form class="form-horizontal" role="form">
                                <div class="form-group">
                                    <label for="Environment" class="col-sm-2 control-label">Create Environment</label>
                                    <div class="col-sm-10" id="envForm">
                                        <input tabindex="1" id="createEnvironment" name="Environment" type="text" placeholder="Production" class="form-control input-large" autofocus/>
                                        <input id="environment" class="hide" />
                                        <p class="help-block">Name of the Environment used to store application settings.</p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-offset-2 col-sm-10">
                                        <a tabindex="2" onclick="createEnv();" id="createBtnEnv" name="createBtnEnv" class="btn btn-primary">Save Changes</a>
                                    </div>
                                </div>
                            </form>
                            <div id="resultCreateEnv"></div>

                            <ul class="pager" >
                                <li class="previous"> <a onclick="$('#myTab li:eq(0) a').tab('show');
                changeProgress('0%');" >&larr; Previous</a>
                                </li>
                                <li class="next" id="nextBtnEnv"> <a tabindex="3" onclick="$('#myTab li:eq(2) a').tab('show');
                changeProgress('30%');" >Next &rarr;</a>
                                </li>
                            </ul>
                        </div>
                        <div class="tab-pane fade" id="model">
                            <div>&nbsp;</div>
                            <p class="container"><span class="label label-info">Info</span> This section refers to the COEUS ontology model and API access.</p>
                            <div>&nbsp;</div>
                            <form class="form-horizontal" role="form">
                                <div class="row">

                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label class="col-sm-2 control-label" for="Name">Name</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="1" id="Name" name="Name" type="text" placeholder="Uniprot" class="form-control" />
                                            <p class="help-block">Name of the Model</p>
                                        </div>
                                    </div>
                                    <!-- Textarea -->
                                    <div class="form-group col-md-6">
                                        <label  class="col-sm-2 control-label" for="Description">Description</label>
                                        <div class="col-sm-10 controls">
                                            <!--<textarea tabindex="2" id="Description" name="Description">Uniprot Setup Ontology</textarea>-->
                                            <input tabindex="2" id="Description" name="Description" type="text" placeholder="Uniprot Setup Ontology" class="form-control"/>
                                            <p class="help-block">Model Description</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label class="col-sm-2 control-label" for="Ontology">Ontology</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="3" id="Ontology" name="Ontology" type="text" placeholder="http://bioinformatics.ua.pt/coeus/ontology" class="form-control"  />
                                            <p class="help-block">Ontology Location (URL)</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label  class="col-sm-2 control-label" for="KeyPrefix">Prefix</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="4" id="KeyPrefix" name="KeyPrefix" type="text" placeholder="coeus" class="form-control input-mini" />
                                            <p class="help-block">The ontology Key Prefix</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label  class="col-sm-2 control-label"
                                                for="ApiKey">API</label>
                                        <div class="col-sm-10 controls">
                                            <div class="input-group">
                                                <input tabindex="5" id="putApiKey" name="putApiKey" type="text" placeholder="coeus" class="form-control"  />
                                                <span class="input-group-btn" ><button id="btnPlus" class="btn btn-success tip" data-toggle="tooltip" title="Add a API Key to the list" type="button" onclick="updateApiKeys();"><i class="fa fa-plus-circle"></i></button></span>
                                            </div>
                                            <p class="help-block">REST API Key</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label  class="col-sm-2 control-label"
                                                for="Version">Version</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="6" id="Version" name="Version" type="text" placeholder="1.0" class="form-control input-mini" />
                                            <p class="help-block">Ontology Version</p>
                                        </div>
                                    </div>
                                </div>
                                <!-- Text input <div class="control-group">
                                
                                                                    <label class="control-label" for="Built">Built</label>
                                
                                                                    <div class="controls">
                                
                                                                        <label class="checkbox" >
                                
                                                                            <input type="checkbox" id="Built" name="Built">
                                
                                                                        </label>
                                
                                
                                
                                                                        <p class="help-block">Import from the Model</p>
                                
                                                                    </div>
                                
                                                                </div>-->
                                <!-- Text input-->
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label class="col-sm-2 control-label">Keys</label>
                                        <div class="col-sm-10 controls">
                                            <div class="input-group">
                                                <select class="form-control tip" id="dropdownkeys" multiple="multiple" data-toggle="tooltip" title="API Keys List."></select> 
                                                <span class="input-group-btn" >
                                                    <a class="btn btn-danger tip" onclick="removeApiKey();" data-toggle="tooltip" title="Select element to remove."><i class="fa fa-trash-o"></i></a>
                                                </span>
                                            </div>
                                            <p class="help-block">API Keys supported</p>
                                            <input id="ApiKey" type="hidden"/>
                                        </div>

                                    </div>
                                    <div class="form-group col-md-6">
                                        <label  class="col-sm-2 control-label"
                                                for="Debug">Debug</label>
                                        <div class="col-sm-10 controls">
                                            <label  class="checkbox">
                                                <input tabindex="7" type="checkbox" id="Debug" name="Debug" />
                                            </label>
                                            <p class="help-block">Debug Log</p>
                                        </div>
                                    </div>
                                </div>
                                <!-- Text input <div class="control-group">
                                
                                                                    <label class="control-label" for="SetupFile">Setup File</label>
                                
                                                                    <div class="controls">
                                
                                                                        <input id="SetupFile" name="SetupFile" type="text" placeholder="setup.rdf" class="input-xlarge">
                                
                                                                        <p class="help-block">RDF File Location to Import to the DB</p>
                                
                                                                    </div>
                                
                                                                </div>-->
                                <!-- Button -->
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label  class="col-sm-2 control-label"
                                                for="nextBtnModel"></label>
                                        <div class="col-sm-10 controls"> 
                                            <a tabindex="8" onclick="createModel();" id="createBtnModel" class="btn btn-primary">Save Changes</a>
                                        </div>
                                    </div>
                                </div>
                                <div id="resultModel"></div>
                                <ul class="pager" >
                                    <li class="previous">
                                        <a onclick="$('#myTab li:eq(1) a').tab('show');
                changeProgress('15%');" >&larr; Previous</a>
                                    </li>
                                    <li class="next" id="nextBtnModel"> <a tabindex="9" onclick="$('#myTab li:eq(3) a').tab('show');
                changeProgress('45%');" >Next &rarr;</a>
                                    </li>
                                </ul>
                            </form>
                        </div>
                        <div class="tab-pane fade" id="database">
                            <div>&nbsp;</div>
                            <p class="container"><span class="label label-info">Info</span> COEUS needs an mysql database to store data triples.</p>
                            <div>&nbsp;</div>
                            <form class="form-horizontal" role="form">
                                <!-- Text input-->
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="jdbcURL">JDBC URL</label>
                                    <div class="form-inline col-sm-10" id="urlForm">jdbc:mysql://
                                        <input tabindex="1" id="host" name="host" type="text" placeholder="localhost"
                                               class="input-large form-control" /> :
                                        <input tabindex="2" id="port" name="port" type="number" placeholder="3306" 
                                               class="input-mini form-control" /> /
                                        <input tabindex="3" id="path" name="path" type="text" placeholder="coeus"
                                               class="input-mini form-control" />
                                        <p class="help-block">Database connection URL</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="username">Database User</label>
                                    <div class="col-sm-10" id="usernameForm">
                                        <input tabindex="4" id="username" name="username" type="text" class="input-large form-control" />
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="form-group">
                                    <label class="col-sm-2 control-label " for="password">Database Password</label>
                                    <div class="col-sm-10" id="passwordForm">
                                        <input tabindex="5" id="password" name="password" type="password" placeholder=""
                                               class="input-large form-control" />
                                        <p class="help-block">The user must have privileges to create the DB and the tables structure.</p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"  for="createBtnDb"></label>
                                    <div class="col-sm-offset-2 col-sm-10"> 
                                        <a tabindex="6" onclick="createDB();" id="createBtnDb" name="createBtnDb" class="btn btn-primary">Save Changes</a>
                                    </div>
                                </div>

                            </form>
                            <div id="resultCreateDb"></div>
                            <ul class="pager" >
                                <li class="previous">
                                    <a onclick="$('#myTab li:eq(2) a').tab('show');
                changeProgress('30%');" >&larr; Previous</a>
                                </li>
                                <li class="next" id="nextBtnDb"> 
                                    <a tabindex="7" onclick="$('#myTab li:eq(4) a').tab('show');
                changeProgress('60%');" >Next &rarr;</a>
                                </li>
                            </ul>
                        </div>
                        <div class="tab-pane fade" id="pubby">
                            <div>&nbsp;</div>
                            <p class="container"><span class="label label-info">Info</span> COEUS make use of <a href="http://wifo5-03.informatik.uni-mannheim.de/pubby/" target="_blank">Pubby</a> capabilities to provide a LinkedData interface.</p>                                        
                            <div>&nbsp;</div>
                            <form id="pubbyForm" class="form-horizontal" role="form">
                                <div class="row">
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label class="col-sm-2 control-label" for="projectHomepage">URL</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="1" id="projectHomepage" name="projectHomepage" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="form-control" onkeyup="fillURL();"/>
                                            <p class="help-block">A project homepage or similar URL, for linking in page titles.</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label class="col-sm-2 control-label">Name</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="2" id="projectName" name="projectName" type="text" placeholder="coeus.demo" class="form-control" />
                                            <p class="help-block">The name of the project, for display in page titles.</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label class="col-sm-2 control-label" for="DatasetBase">Dataset Base</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="5" id="DatasetBase" name="DatasetBase" type="text" value="http://bioinformatics.ua.pt/coeus/resource/" class="form-control" disabled/>
                                            <p class="help-block">The common URI prefix of the resource identifiers in the SPARQL dataset.
                                                Only resources with this prefix will be mapped and made available by Pubby.</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label class="col-sm-2 control-label" for="WebResourcePrefix">Web Resource Prefix</label>
                                        <div class="col-sm-10 controls">
                                            <input tabindex="6" id="WebResourcePrefix" name="WebResourcePrefix" type="text" placeholder="resource/" class="form-control" disabled/>
                                            <p class="help-block">Prefix to the mapped web URIs.</p>
                                            <br />
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label  class="control-label col-sm-2 " for="WebBase">Web Base</label>
                                        <div class="col-sm-10 controls">
                                            <div class="input-group">
                                                <input tabindex="4" id="WebBase" name="WebBase" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="form-control" onkeyup="sparqlFill();"/>
                                                <span class="input-group-btn" ><button id="btnPlus" class="btn btn-info tip" data-toggle="tooltip" title="Auto-detect the application path" type="button" onclick="$('#WebBase').val(getApplicationPath());
                sparqlFill();">Auto-Detect</button></span>
                                            </div>
                                            <p class="help-block">The root URL where the Pubby web application is installed.</p>
                                        </div>
                                    </div>
                                    <!-- Text input-->
                                    <div class="form-group col-md-6">
                                        <label class="control-label col-sm-2 " for="Endpoint">SPARQL</label>
                                        <div class=" col-sm-10 controls">
                                            <input tabindex="3" id="Endpoint" name="Endpoint" type="text" placeholder="http://bioinformatics.ua.pt/coeus/sparql" class="form-control" />
                                            <p class="help-block">The internal URL of the SPARQL endpoint whose data we want to expose.</p>
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
                                    <!-- Button -->
                                    <div class="form-group col-md-6">
                                        <label class="control-label col-sm-2 " for="nextBtnPubby"></label>
                                        <div class="controls col-sm-10"> <a tabindex="7" onclick="createPubby();" id="createBtnPubby" class="btn btn-primary">Save Changes</a>
                                        </div>
                                    </div>
                                    <!-- Info -->
                                    <div class="form-group col-md-6">
                                        <label class="control-label col-sm-2"></label>
                                        <div class="col-sm-10 controls">
                                            </div>
                                    </div>
                                </div>
                            </form>
                            <div id="resultPubby"></div>


                            <ul class="pager" >
                                <li class="previous">
                                    <a onclick="$('#myTab li:eq(3) a').tab('show');
                changeProgress('45%');" >&larr; Previous</a>
                                </li>
                                <li class="next" id="nextBtnPubby"> <a tabindex="8" onclick="$('#myTab li:eq(5) a').tab('show');
                changeProgress('75%');">Next &rarr;</a>
                                </li>
                            </ul>
                        </div>

                        <div class="tab-pane fade" id="prefixes">
                            <div>&nbsp;</div>
                            <p class="container"><span class="label label-info">Info</span> In this section you must add all ontologies that you may use with COEUS. All ontology properties are automatic loaded.</p>                                        

                            <div class="text-right">
                                <button onclick="" class="btn btn-success" href="#prefixesModal" role="button"
                                        data-toggle="modal" type="button">Add <i class="glyphicon glyphicon-plus "></i>
                                </button>
                            </div>
                            <div class="container">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Prefix</th>
                                            <th>URL</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tablePrefixes"></tbody>
                                </table>

                                <div class="control-group">
                                    <label class="control-label" for="nextBtnPrefixes"></label>
                                    <div class="controls">
                                        <button onclick="createPrefixes();" id="createBtnPrefixes" class="btn btn-primary">Save Changes</button>
                                    </div>
                                </div>

                            </div>
                            <div>&nbsp;</div>
                            <div id="resultPrefixes"></div>
                            <ul class="pager" >
                                <li class="previous">
                                    <a onclick="$('#myTab li:eq(4) a').tab('show');
                changeProgress('60%');" >&larr; Previous</a>
                                </li>
                                <li class="next" id="nextBtnPrefixes"> <a onclick="$('#myTab li:eq(6) a').tab('show');
                changeProgress('100%');" >Next &rarr;</a>
                                </li>
                            </ul>
                        </div>
                        <div class="tab-pane fade " id="overview">
                            <div>&nbsp;</div>
                            <p class="text-center">You have successfully finished the Setup Wizard.</p>
                            <div id="resultReload" class="text-center">
                                <div class="alert alert-warning ">
                                    <strong>Now your application server needs to load the new configurations.</strong> 
                                    <div>&nbsp;</div>
                                    <button class="btn btn-warning btn-lg reload" onclick="reload();" role="button">Load <i class="fa fa-download"></i></button>
                                    <a class="btn btn-default btn-lg" href="../config/" role="button">Run Again <i class="fa fa-undo"></i></a>
                                    <div>&nbsp;</div>

                                </div>
                            </div>
                            

                            <ul class="pager">
                                <li class="previous">
                                    <a onclick="$('#myTab li:eq(5) a').tab('show');
                changeProgress('75%');" >&larr; Previous</a>
                                </li>
                            </ul>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Modal -->
            <div id="prefixesModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="prefixesModal" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" id="closePrefixesModal" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                            <h3 class="modal-title" id="prefixesModalLabel">Add Prefix</h3>
                        </div>
                        <div class="modal-body">

                            <div id="keyPrefixesForm" class="form-group">
                                <label class="control-label" for="title">Key</label>
                                <input class="input-mini form-control" id="keyPrefixes" type="text" placeholder="dc" > <i class="icon-question-sign" data-toggle="tooltip" title="The Key of the prefix" ></i>
                            </div>
                            <div id="valuePrefixesForm" class="form-group"> 
                                <label class="control-label" for="label">Value</label>
                                <input class="form-control" id="valuePrefixes" type="text" placeholder="http://purl.org/dc/elements/1.1/"> <i class="icon-question-sign" data-toggle="tooltip" title="The prefix URL" ></i>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
                            <button class="btn btn-success" id="addPrefixButton" onclick="addPrefix();">Add <i class="icon-plus icon-white"></i></button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </s:layout-component>
</s:layout-render>
