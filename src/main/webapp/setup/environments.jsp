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
                callURL("../../config/listenv/", fillEnvironments);

            });

            function fillEnvironments(result) {
                console.log(result);
                var array = result.environments;
                $('#environments').html('');
                for (var r in array) {
                    var value = array[r].replace('env_', '');
                    var n = parseInt(r) + 1;
                    $('#environments').append('<tr><td>' + (n) + '</td><td>' + value + '</td><td id="' + value + '"><span class="label label-important">DISABLED</span></td><td>'
                            + '<div class="btn-group">'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectEnv(\'' + value + '\')">Remove</button>'
                            + '</div> '
                            + '<a class="btn btn-warning" href="../environments/edit/' + value + '">Configuration</a> '
                            + '<a id="btn' + value + '" class="btn btn-success" onclick="changeEnv(\'' + value + '\')">Enable</a>'
                            + '</td></tr>');
                }
                callURL("../../config/getconfig/", changeStatus);
            }

            function changeEnv(env) {
                callURL("../../config/upenv/" + env, changeEnvResult, changeEnvResult, changeEnvError);
            }
            function changeEnvResult(result) {
                if (result.status === 100)
                    callURL("../../config/listenv/", fillEnvironments);
                else
                    $('#info').html(generateHtmlMessage("ERROR!", result.message, "alert-error"));
            }
            function changeEnvError(result, text) {
                $('#info').html(generateHtmlMessage("ERROR!", text, "alert-error"));
            }

            function changeStatus(result) {
                $('#' + result.config.environment).html('<span class="label label-success">ENABLED</span>');
                $('#btn' + result.config.environment).addClass('hide');
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
                    $('#resultCreateEnv').html(generateHtmlMessage("Success!", "Environment <strong>" + env + "</strong> created.", "alert-success"));
                    $('#createEnvironment').val('');
                } else {
                    $('#resultCreateEnv').html(generateHtmlMessage("Warning!", result.message));
                }

            }

            function createEnvFail(jqXHR, textStatus) {
                $('#resultCreateEnv').html(generateHtmlMessage("Error!", textStatus, "alert-error"));
            }

            function selectEnv(env) {

                $('#removeModalLabel').html(env);
                console.log($('#removeModalLabel').html());
            }
            function removeEnv() {
                callURL("../../config/delenv/" + $('#removeModalLabel').html(), removeEnvResult);
            }
            function removeEnvResult(result) {
                callURL("../../config/listenv/", fillEnvironments);
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
                    <h3>List of Environments</h3>
                </div>


                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a data-toggle="modal" href="#createEnvironmentModal" class="btn btn-success">Create Environment</a>
                    </div>
                </div>


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

                        <div id="result">

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger" data-dismiss="modal" onclick="removeEnv();">Remove</button>
                    </div>
                </div>

                <!-- Modal -->
                <div id="createEnvironmentModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeEnvironmentModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Create Environment</h3>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal" id="formCreateEnv">
                            <fieldset>


                                <!-- Text input-->
                                <div class="control-group">
                                    <label class="control-label" for="Environment">Create Environment</label>
                                    <div class="controls">
                                        <input id="createEnvironment" name="Environment" type="text" placeholder="Production" class="input-large"> 
                                        <p class="help-block">Name of the Environment</p>
                                    </div>
                                </div>

                                <!-- Button -->
                                <div class="control-group">
                                    <label class="control-label" for="btnCreateEnv"></label>
                                    <div class="controls">
                                        <a onclick="createEnv();" id="btnCreateEnv" name="btnCreateEnv" class="btn btn-success">Create</a>
                                    </div>
                                </div>

                                <div id="resultCreateEnv">

                                </div>

                            </fieldset>
                        </form>
                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-info" data-dismiss="modal"  onclick="$('#resultCreateEnv').html('');
                callURL('../../config/listenv/', fillEnvironments);">Done</button>
                    </div>
                </div>

            </div>

        </s:layout-component>
    </s:layout-render>
