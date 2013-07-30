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
            });

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
                $('#Environment').val(result.config.environment);
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
                    var val = json[r];console.log(r);
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
                                "sdb": "newsaggregator/sdb.ttl",
                                "predicates": "newsaggregator/predicates.csv",
                                "built": $('#Built').is(':checked'),
                                "debug": $('#Debug').is(':checked'),
                                "apikey": $('#ApiKey').val(),
                                "environment": $('#Environment').val()
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
                callAPI(send, "#result");

                if (document.getElementById('result').className === 'alert alert-success') {
                    window.location.reload();
                }
            }

            function addPrefix() {
                $('#res').html('');
                var num = $("#tablePrefixes tr").length+1;
                var key = $('#keyPrefixes').val();
                var value = $('#valuePrefixes').val();
                if ($("#prefix_" + key).html() === undefined) {
                    $('#tablePrefixes').append('<tr id="prefix_' + key + '"><td>' + num + '</td><td>' + key + '</td><td><a href="' + value + '">' + value + '</a></td><td><button onclick="removeById(\'prefix_' + key + '\',\'tablePrefixes\');" class="btn btn" type="button">Remove</button></td></tr>');
                } else {
                    $('#res').append('<p class="text-warning">This Key already exists.</p>');
                }
            }


        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <br/><br/>
        <div class="container">

            <div id="header" class="page-header">
                <h1>Configuration Page</h1>
            </div>
            <div id="progress" class="progress progress-striped active" >
                <div id="bar" class="bar" style="width: 10%;"></div>
            </div>
            <div class="tabbable"> <!-- Only required for left/right tabs -->
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab1" data-toggle="tab">Configuration</a></li>
                    <li><a href="#tab2" data-toggle="tab">Prefixes</a></li>
                    <li><a href="#tab3" data-toggle="tab">Predicates</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab1">
                        <form class="form-horizontal">
                            <fieldset>

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

                                <!-- Select Basic -->
                                <div class="control-group">
                                    <label class="control-label" for="Environment">Environments</label>
                                    <div class="controls">
                                        <select id="Environment" name="Environment" class="input-large">
                                            <option>production</option>
                                        </select>
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



                            </fieldset>
                        </form>

                    </div>
                    <div class="tab-pane" id="tab2">
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
                            <button onclick="" class="btn btn-success" href="#prefixesModal" role="button" data-toggle="modal" type="button">Add</button>
                        </div>

                    </div> 
                    <div class="tab-pane" id="tab3">
                        <p>Predicates..</p>
                    </div>
                    <div class="text-left">
                        <button onclick="save();" class="btn btn-primary" type="button">Save</button></div>
                    <div id="result">
                    </div>
                </div>

                <div id="result">
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


                    <div id="res">

                    </div>

                </div>
                <div class="modal-footer">
                    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                    <button class="btn btn-success" id="addPrefixButton" onclick="addPrefix();">Add</button>
                </div>
            </div>




        </s:layout-component>
    </s:layout-render>
