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
                refresh();
            });

            function refresh() {
                callURL("../../config/listenv/", fillEnvironments);
            }

            function fillEnvironments(result) {
                console.log(result);
                var array = result.environments;
                $('#environments').html('');
                for (var r in array) {
                    var value = array[r].replace('env_', '');
                    var n = parseInt(r) + 1;
                    $('#environments').append('<tr><td>' + (n) + '</td><td>' + value + '</td><td id="' + value + '"><span class="label label-important">DISABLED</span></td><td>'
                            + '<div class="btn-group">'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectEnv(\'' + value + '\')">Remove <i class="icon-trash"></i></button>'
                            + '</div> '
                            + '<a id="pubby' + value + '" class="btn btn-warning hide" data-toggle="modal" href="#pubbyModal" onclick="prepareChange(\'' + value + '\');">Pubby <i class="icon-wrench icon-white"></i></a> '
                            //+ '<a class="btn btn-warning" href="../environments/edit/' + value + '">Pubby <i class="icon-wrench icon-white"></i></a> '
                            + '<a id="db' + value + '" class="btn btn-warning hide" data-toggle="modal" href="#dbModal" onclick="prepareChange(\'' + value + '\');">DB <i class="icon-wrench icon-white"></i></a> '
                            + '<a id="clean' + value + '" class="btn btn-danger hide" href="#cleanModal" data-toggle="modal" onclick="selectEnv(\'' + value + '\')">Clean DB <i class="icon-file icon-white"></i></a> '
                            + '<a id="btn' + value + '" class="btn btn-success" onclick="changeEnv(\'' + value + '\')">Enable <i class="icon-ok-circle icon-white"></i></a>'
                            + '</td></tr>');
                }
                callURL("../../config/getconfig/", changeStatus);
            }

            function changeEnv(env) {
                $('#btn' + env).addClass('disabled');
                $('#btn' + env).html('Enabling..');
                var url = "../../config/upenv/" + env;
                callURL(url, changeEnvResult.bind(this, env), showError.bind(this, '#info', url));
            }
            function changeEnvResult(env, result) {
                $('#btn' + env).removeClass('disabled');
                $('#btn' + env).html('Enable <i class="icon-ok-circle icon-white"></i>');
                if (result.status === 100) {
                    refresh();
                }
                else {
                    $('#info').html(generateHtmlMessage("ERROR!", result.message, "alert-error"));
                }
            }

            function changeStatus(result) {
                $('#' + result.config.environment).html('<span class="label label-success">ENABLED</span>');
                $('#db' + result.config.environment).removeClass('hide');
                $('#pubby' + result.config.environment).removeClass('hide');
                $('#clean' + result.config.environment).removeClass('hide');
                $('#btn' + result.config.environment).addClass('hide');
            }

            function selectEnv(env) {
                $('#cleanModalLabel').html(env);
                $('#removeModalLabel').html(env);
            }
            function removeEnv() {
                timer = setTimeout(function() {
                    $('#closeRemoveModal').click();
                    refresh();
                }, delay);
                var url = "../../config/delenv/" + $('#removeModalLabel').html();
                callURL(url, showResult.bind(this, '#resultRemove', url), showError.bind(this, '#resultRemove', url));
            }

            function cleanDB() {
                timer = setTimeout(function() {
                    $('#closeCleanModal').click();
                }, 2000);
                var url = "../../config/cleandb/" + $('#cleanModalLabel').html();
                callURL(url, showResult.bind(this, '#resultClean', ""), showError.bind(this, '#resultClean', url));
            }
            function changeDB() {
                timer = setTimeout(function() {
                    $('#closeDbModal').click();
                }, 2000);
                var url = "../../config/changedb/" + encodeBars(generateDbMap());
                callURL(url, showResult.bind(this, '#resultDb', url), showError.bind(this, '#resultDb', url));
            }
            function changePubby() {
                timer = setTimeout(function() {
                    $('#closePubbyModal').click();
                }, 2000);
                var url = "../../config/changepubby/" + encodeBars(generatePubbyMap());
                callURL(url, showResult.bind(this, '#resultPubby', url), showError.bind(this, '#resultPubby', url));
            }

            function generateDbMap() {

                var host = $('#host').val();
                var port = $('#port').val();
                var path = $('#path').val();
                var jdbcURL = "jdbc:mysql://" + host + ":" + port + "/" + path + "%3FautoReconnect=true";

                var username = $('#username').val();
                var password = $('#password').val();

                var json = {
                    "$sdb:jdbcURL": jdbcURL,
                    "$sdb:sdbUser": username,
                    "$sdb:sdbPassword": password
                };

                return JSON.stringify(json);
            }
            function generatePubbyMap() {

                var projectName = $('#projectName').val();
                var projectHomepage = $('#projectHomepage').val();
                var webBase = $('#WebBase').val();
                var endpoint = $('#Endpoint').val();
                var datasetBase = $('#DatasetBase').val();
                var webResourcePrefix = $('#WebResourcePrefix').val();


                var json = {
                    "$conf:projectName": projectName,
                    "$conf:projectHomepage": projectHomepage,
                    "$conf:webBase": webBase,
                    "$conf:sparqlEndpoint": endpoint,
                    "$conf:datasetBase": datasetBase,
                    "$conf:webResourcePrefix": webResourcePrefix
                };

                return JSON.stringify(json);
            }

            function getMapSuccess(result) {

                //fill boxs with values
                var jdbcURL = result["$sdb:jdbcURL"].replace("jdbc:mysql://", "").replace("?autoReconnect=true", "");
                $('#host').val(jdbcURL.split(":", 2)[0]);
                $('#port').val(jdbcURL.split(":", 2)[1].split("/", 2)[0]);
                $('#path').val(jdbcURL.split("/", 2)[1]);

                $('#username').val(result["$sdb:sdbUser"]);
                $('#password').val(result["$sdb:sdbPassword"]);

                $('#projectName').val(result["$conf:projectName"]);
                $('#projectHomepage').val(result["$conf:projectHomepage"]);
                $('#WebBase').val(result["$conf:webBase"]);
                $('#Endpoint').val(result["$conf:sparqlEndpoint"]);
                $('#DatasetBase').val(result["$conf:datasetBase"]);
                $('#WebResourcePrefix').val(result["$conf:webResourcePrefix"]);

            }
            function prepareChange(env) {
                $('#dbEnviroment').html(env);
                $('#pubbyEnviroment').html(env);
                $('#resultDb').html('');
                $('#resultPubby').html('');
                callURL("../../config/getmap/" + env, getMapSuccess, showError.bind(this, '#resultDb', ""));
            }


        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">
                <h1>Environments Setup</h1>
            </div>

            <div id="info">
            </div>

            <div class="row-fluid">



                <div class="span6">
                    <p class="text-error">ATTENTION: Every change in this page needs a server restart.</p>
                    <h3>List of Environments</h3>
                </div>


                <!-- <div class="span6 text-right" >
                     <div class="btn-group">
                         <a href="../config/" class="btn btn-success">Create Environment <i class="icon-plus icon-white"></i></a>
                     </div>
                 </div>-->


                <table class="table table-hover">

                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="environments">

                    </tbody>
                </table>

                <!-- Button to trigger modal -->


                <!-- Modal -->
                <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Remove Environment</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> environment?</p>
                        <p class="text-warning">Warning: All configurations are removed.</p>

                        <div id="resultRemove">

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger loading" onclick="removeEnv();">Remove</button>
                    </div>
                </div>

                <!-- Modal -->
                <div id="cleanModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeCleanModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3>Clean Database</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to clean all content of <strong><a class="text-error" id="cleanModalLabel"></a></strong> environment database?</p>
                        <p class="text-warning">Warning: All content will be removed from this database.</p>

                        <div id="resultClean">

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger loading" onclick="cleanDB();">Clean <i class="icon-warning-sign icon-white"></i></button>
                    </div>
                </div>

                <!-- Modal -->
                <div id="dbModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeDbModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3>Database of <span id="dbEnviroment" class="text-info">none</span></h3>
                    </div>
                    <div class="modal-body">
                        <form id="connectionsDb" class="">
                            <fieldset>

                                <!-- URL-->
                                <label class="control-label" for="jdbcURL"><strong>JDBC URL</strong></label>
                                <div class="controls">
                                    jdbc:mysql://
                                    <input id="host" name="host" type="text" placeholder="localhost" class="input-large">
                                    : <input id="port" name="jdbcURL" type="text" placeholder="3306" class="input-mini">
                                    / <input id="path" name="path" type="text" placeholder="coeus" class="input-mini">
                                </div>

                                <label class="control-label" for="username"><strong>Database User</strong></label>
                                <div class="controls">
                                    <input id="username" name="username" type="text" placeholder="demo" class="input-large">

                                </div>

                                <label class="control-label" for="password"><strong>Database Password</strong></label>
                                <div class="controls">
                                    <input id="password" name="password" type="password" class="input-large">
                                </div>

                            </fieldset>
                        </form>

                        <div id="resultDb"></div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-primary loading" onclick="changeDB();">Save Changes</button>
                    </div>
                </div>

                <!-- Modal -->
                <div id="pubbyModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closePubbyModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3>Pubby of <span id="pubbyEnviroment" class="text-info">none</span></h3>
                    </div>
                    <div class="modal-body">
                        <form id="connectionsDb" class="">
                            <fieldset>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="projectName"><strong>Project Name</strong></label>
                                    <div class="controls">
                                        <input id="projectName" name="projectName" type="text" placeholder="coeus.demo" class="input-large">
                                        <p class="help-block">The name of the project, for display in page titles.</p>
                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="projectHomepage"><strong>Project Homepage</strong></label>
                                    <div class="controls">
                                        <input id="projectHomepage" name="projectHomepage" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="input-xlarge">
                                        <p class="help-block">A project homepage or similar URL, for linking in page titles.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="WebBase"><strong>Web Base</strong></label>
                                    <div class="controls">
                                        <input id="WebBase" name="WebBase" type="text" placeholder="http://bioinformatics.ua.pt/coeus/" class="input-xlarge">
                                        <p class="help-block">The root URL where the Pubby web application is installed.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Endpoint"><strong>SPARQL Enpoint</strong></label>
                                    <div class="controls">
                                        <input id="Endpoint" name="Endpoint" type="text" placeholder="http://bioinformatics.ua.pt/coeus/sparql" class="input-xlarge">
                                        <p class="help-block">The URL of the SPARQL endpoint whose data we want to expose.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="DatasetBase"><strong>Dataset Base</strong></label>
                                    <div class="controls">
                                        <input id="DatasetBase" name="DatasetBase" type="text" placeholder="http://bioinformatics.ua.pt/coeus/resource/" class="input-xlarge">
                                        <p class="help-block">The common URI prefix of the resource identifiers in the SPARQL dataset. Only resources with this prefix will be mapped and made available by Pubby.</p>
                                    </div>
                                </div>
                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="WebResourcePrefix"><strong>Web Resource Prefix</strong></label>
                                    <div class="controls">
                                        <input id="WebResourcePrefix" name="WebResourcePrefix" type="text" placeholder="resource/" class="input-large">
                                        <p class="help-block">Prefix to the mapped web URIs.</p>
                                        <br/>
                                        <p class="help-block">For more information please visit the <a href="http://wifo5-03.informatik.uni-mannheim.de/pubby/">Pubby Homepage</a>.</p>

                                    </div>
                                </div>

                            </fieldset>
                        </form>

                        <div id="resultPubby"></div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-primary loading" onclick="changePubby();">Save Changes</button>
                    </div>
                </div>

            </div>

        </s:layout-component>
    </s:layout-render>
