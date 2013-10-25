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
        <script src="<c:url value="/assets/js/bootstrap-tooltip.js" />"></script>
        <script type="text/javascript">

            $(document).ready(function() {

                //header name
                var path = lastPath();
                $('#header').html('<h1>Environment<small> ' + path + '</small></h1>');

                callURL("../../../config/getmap/" + path, getMapSuccess, getMapError);

            });
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
            
            function getMapError(result, text) {
                console.log(text);
            }
            
            function updateFilesOnEnv(){
                    callURL("../../../config/pubby/" + encodeBars(generateMap()), upEnvResult, upEnvFail);
            }
            function upEnvResult(result) {
                console.log(result);
                if (result.status === 100) {
                    window.location = document.referrer;
                    //$('#resultUpEnv').html(generateHtmlMessage("Success!", "Configurations saved on environment <strong>"+env+"</strong>. Please, press the next button.", "alert-success"));
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

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>

            <div class="row-fluid">


                <form id="connections" class="form-horizontal">
                    <fieldset>
                        <h4>Database Configuration:</h4>

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
                                <input id="password" name="password" type="text" class="input-large">
                            </div>
                        </div>

                        <h4>Pubby Configuration:</h4>

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

                            <div class="controls">
                                <a onclick="updateFilesOnEnv();" id="btnUpEnv" name="btnUpEnv" class="btn btn-primary">Save Configuration</a>
                                or <button type="button" id="done" class="btn btn-danger" onclick="window.history.back(-1);">Cancel</button>

                            </div>
                        </div>

                        <div id="resultUpEnv">

                        </div>


                    </fieldset>
                </form>
            </div>


        </div>



        <!-- Modal -->
        <div id="errorModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3 id="myModalLabel">Output</h3>
            </div>
            <div class="modal-body">
                <div id="result">

                </div>
                <!-- <div id="titleResult">
 
                 </div>
                 <div id="labelResult">
 
                 </div>
                 <div id="commentResult">
 
                 </div>
                 <div id="seedResult">
 
                 </div>
                 <div id="typeResult">
 
                 </div>-->
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                <button class="btn btn-primary" onclick="submit();">Retry</button>
            </div>
        </div>


    </s:layout-component>
</s:layout-render>
