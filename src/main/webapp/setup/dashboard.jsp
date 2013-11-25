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
                changeSidebar('#dashboard');
                //get seed from url
               
                callURL("../../config/getconfig/", fillHeader);
                callURL("../../config/listenv/", fillEnvironments);

                refresh();

                var qseeds = "SELECT DISTINCT ?seed ?s {?seed a coeus:Seed . ?seed dc:title ?s . }";
                queryToResult(qseeds, function(result) {
                    for (var k in result) {
                        $('#seeds').append('<option>' + splitURIPrefix(result[k].seed.value).value + '</option>');
                    }
                    $('#seeds option:contains(' + lastPath().split('coeus:')[1] + ')').prop({selected: true});
                }
                );
                var seed = lastPath();
                var qEntities = "SELECT (COUNT(*) AS ?triples) {?s a coeus:Item . ?s coeus:hasConcept ?concept . ?concept coeus:hasEntity ?entity . ?entity coeus:isIncludedIn " + seed + "}";
                queryToResult(qEntities, function(result) {
                    $('#triples').html(result[0].triples.value);
                });

            });

            function refresh() {
                var seed = lastPath();
                var qEntities = "SELECT DISTINCT ?entity {" + seed + " coeus:includes ?entity }";
                queryToResult(qEntities, fillEntities);
            }

            function queryConcepts(entity) {
                var qConcepts = "SELECT DISTINCT ?concept {?concept coeus:hasEntity coeus:" + entity + " }";
                queryToResult(qConcepts, fillConcepts.bind(this, entity));
            }
            function queryResources(concept) {
                var qResources = "SELECT DISTINCT ?resource {?resource coeus:isResourceOf coeus:" + concept + " }";
                queryToResult(qResources, fillResources.bind(this, concept));
            }

            function fillResources(concept, result) {
                var arrayOfConcepts = new Array();
                var c = '';
                for (var i in result) {
                    var auxResource = splitURIPrefix(result[i].resource.value);
                    var resource = auxResource.value;
                    var prefix = getPrefix(auxResource.namespace);
                    arrayOfConcepts[i] = resource;
                    
                    var recent_add = $('#resourceURI').html();var recent='';
                    if(recent_add.toString() === (prefix + ':' + resource).toString()) recent=' <span class="label label-warning tip" data-toggle="tooltip" title="Recently added" >New <i class="fa fa-star" ></i></span> ';

                    
                    c += '<p class="text-info treeitem"><a href="../../resource/' + resource + '"><sub><i class="black fa fa-search-plus fa-2x tip" data-toggle="tooltip" title="View in browser" ></i></sub></a> '
                            + resource +recent+ '<span class="showonhover">'
                            + ' <a href="#editResourceModal" data-toggle="modal" onclick="prepareResourceEdit(\'' + prefix + ':' + resource + '\');"><sub><i class="black fa fa-edit fa-2x tip" data-toggle="tooltip" title="Edit"></i></sub></a>'
                            + ' <a href="../selector/' + prefix + ':' + resource + '"><sub><i class="black fa fa-wrench fa-2x tip" data-toggle="tooltip" title="Configuration" ></i></sub></a>'
                            + ' <a href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'' + prefix + ':' + resource + '\')"><sub><i class="black fa fa-trash-o fa-2x tip" data-toggle="tooltip" title="Delete"></i></sub></a>'
                            + '</span></p>';
                }
                //console.log(entity);
                $('#' + concept).append(c);
                //console.log('Append on #' + entity + ': ' + c);

                tooltip();

            }

            function fillConcepts(entity, result) {
                var arrayOfConcepts = new Array();
                var c = '';
                for (var i in result) {
                    var auxConcept = splitURIPrefix(result[i].concept.value);
                    var concept = auxConcept.value;
                    var prefix = getPrefix(auxConcept.namespace);
                    var all = prefix + ':' + concept;
                    arrayOfConcepts[i] = concept;
                    
                    var recent_add = $('#uri').html();var recent='';
                    if(recent_add.toString() === all.toString()) recent=' <span class="label label-warning tip" data-toggle="tooltip" title="Recently added" >New <i class="fa fa-star" ></i></span> ';

                    
                    c += '<p class="text-warning treeitem">'
                            + '<a href="../../resource/' + concept + '"><sub><i class="black fa fa-search-plus fa-2x tip" data-toggle="tooltip" title="View in browser" ></i></sub></a> '
                            + concept + recent+ '<span class="showonhover">'
                            //+ ' <a href="../concept/edit/' + prefix + ':' + concept + '"><i class="icon-edit"></i></a>'
                            + ' <a href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + all + '\');"><sub><i class="black fa fa-edit fa-2x tip" data-toggle="tooltip" title="Edit"></i></sub></a>'
                            //+ ' <a href="../resource/add/' + all + '"><i class="icon-plus-sign"></i></a>'
                            + ' <a href="#addResourceModal" data-toggle="modal" onclick="prepareAddResourceModal(\'' + all + '\');"><sub><i class="black fa fa-plus-circle fa-2x tip" data-toggle="tooltip" title="Add Resource" ></i></sub></a>'
                            + ' <a href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'' + all + '\')"><sub><i class="black fa fa-trash-o fa-2x tip" data-toggle="tooltip" title="Delete"></i></sub></a>'
                            + '</span></p><ul id="' + concept + '"></ul>';
                }
                //console.log(entity);
                $('#' + entity).append(c);
                //console.log('Append on #' + entity + ': ' + c);

                for (i in arrayOfConcepts) {
                    queryResources(arrayOfConcepts[i]);
                }
                tooltip();
            }

            function selectEntity() {
                var path = lastPath();
                window.location = "../entity/" + path;
            }


            function fillEnvironments(result) {
                console.log(result);
                var array = result.environments;
                for (var r in array) {
                    var value = array[r].replace('env_', '');
                    $('#environments').append('<option>' + value + '</option>');
                }
            }

            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1><span class="tip" data-toggle="tooltip" title="Seed URI">' + lastPath() + '</span><small id="env" class="pull-right tip" data-toggle="tooltip" title="Selected environment"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                var built = result.config.built;
                if (built == false) {
                    $('#btnUnbuild').removeClass("active");
                    $('#btnBuild').addClass("active");
                } else {
                    $('#btnUnbuild').addClass("active");
                    $('#btnBuild').removeClass("active");

                    clearInterval(interval);
                    $('#integrationResult').html(generateHtmlMessage("Success!", "Integration is done.", "alert-success"));
                    $('#integration').removeClass("hide");
                    $('#integrationState').html("Integration finished.");
                    $('#integrationProgress').addClass("hide");

                }
                tooltip();
            }

            function fillEntities(result) {
                // fill Entities
                console.log(result);
                $('#kb').html("");
                var arrayOfEntities = new Array();
                var e = '';
                for (var key in result) {
                    var auxEntity = splitURIPrefix(result[key].entity.value);
                    var entity = auxEntity.value;
                    var prefix = getPrefix(auxEntity.namespace);
                    arrayOfEntities[key] = entity;
                    
                    var recent_add = $('#uri').html();var recent='';
                    if(recent_add.toString() === entity.toString()) recent=' <span class="label label-warning tip" data-toggle="tooltip" title="Recently added" >New <i class="fa fa-star" ></i></span> ';

                    e += '<p class="text-success treeitem">'
                            + '<a href="../../resource/' + entity + '"><sub><i class="black fa fa-search-plus fa-2x tip" data-toggle="tooltip" title="View in browser" ></i></sub></a> '
                            + entity + recent+'<span class="showonhover">'
                            + ' <a href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + prefix + ":" + entity + '\');"><sub><i class="black fa fa-edit fa-2x tip" data-toggle="tooltip" title="Edit" ></i></sub></a>'
                            // + ' <a href="../entity/edit/' + prefix + ":" + entity + '"><i class="icon-edit"></i></a> '
                            // + ' <a href="../concept/add/' + prefix + ":" + entity + '"><i class="icon-plus-sign"></i></a> '
                            + ' <a href="#addModal" data-toggle="modal" onclick="prepareAdd(\'Concept\',\'' + prefix + ":" + entity + '\');"><sub><i class="black fa fa-plus-circle fa-2x tip" data-toggle="tooltip" title="Add Concept" ></i></sub></a>'

                            + ' <a href="#removeModal" data-toggle="modal" onclick="selectToRemove(\'' + prefix + ":" + entity + '\')"><sub><i class="black fa fa-trash-o fa-2x tip" data-toggle="tooltip" title="Delete"></i></sub></a>'
                            + '</span><ul id="' + entity + '"></ul></p>';

                }
                $('#kb').append(e);

                // fill Concepts
                for (var k = 0, s = arrayOfEntities.length; k < s; k++) {
                    //$('#addentity').append('<option>' + arrayOfEntities[k] + '</option>');
                    queryConcepts(arrayOfEntities[k]);
                }
                tooltip();
            }

            function changeSeed() {
                var title = $('#seeds').val();
                redirect("../seed/" + "coeus:" + title);
            }

            function changeEnv() {
                var env = $('#environments').val();
                callURL("../../config/upenv/" + env, changeEnvResult, changeEnvResult, showInfoError);
            }
            function changeEnvResult(result) {
                if (result.status === 100)
                    callURL("../../config/getconfig/", fillHeader);
                else
                    $('#info').html(generateHtmlMessage("Warning!", result.message));
            }
            function showInfoError(result, text) {
                $('#info').html(generateHtmlMessage("ERROR!", text, "alert-error"));
            }
            function build() {
                runIntegration();
                callURL("../../config/build/", buildResult);
            }
            function buildResult(result) {
                console.log(result);
            }
            function unbuild() {
                var qresource = "SELECT DISTINCT ?resource {" + lastPath() + " coeus:includes ?entity . ?entity coeus:isEntityOf ?concept . ?concept coeus:hasResource ?resource }";
                queryToResult(qresource, unbuildResult);
            }
            function unbuildResult(result) {
                var urlPrefix = "../../api/" + getApiKey();
                console.log(result);
                $('#info').html('');
                for (var r in result) {
                    var res = splitURIPrefix(result[r].resource.value);
                    var resource = getPrefix(res.namespace) + ":" + res.value;
                    callURL(urlPrefix + "/update/" + resource + "/coeus:built/xsd:boolean:true,xsd:boolean:false", unbuiltResource.bind(this, resource));
                }

            }
            function unbuiltResource(resource, result) {
                if (result.status === 100) {
                    var text = "The " + resource + " has been changed. ";
                    console.log(text);
                    $('#info').append(generateHtmlMessage("Success!", text, "alert-success"));
                }
                else {
                    var text = "The " + resource + " has already unbuild. ";
                    console.log(text);
                    $('#info').append(generateHtmlMessage("Alert!", text, "alert-warning"));
                }
            }
            function changeBuiltResult(bool, result) {
                if (result.status === 100) {
                    var text = "The property built has been changed to " + bool + ".";
                    console.log(text);
                    $('#info').html(generateHtmlMessage("Success!", text, "alert-success"));
                }
                else {
                    var text = "The property built has not been changed to " + bool + ".";
                    console.log(text);
                    $('#info').html(generateHtmlMessage("Alert!", text, "alert-warning"));
                }
            }
            var interval;
            function runIntegration() {
                interval = setInterval(checkIntegration, 2000);
            }

            function checkIntegration() {
                console.log('checkIntegration');
                callURL("../../config/getconfig/", fillHeader);
            }



        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <div id="header" class="page-header"></div>
            <div id="apikey" class="hide"></div>
            <ol class="breadcrumb">
                <li><span class="glyphicon glyphicon-home"></span>
                </li>
                <li id="breadSeed"> <a href="../seed/">Seeds</a> 
                </li>
                <li class="active">Dashboard</li>
            </ol>
            <div id="info"></div>
            <div class="row">
                <div class="col-md-6">
                    <h4><span class="tip" data-toggle="tooltip" title="Hover in the tree elements to make changes">Knowledge Base</span> <small class="tip" data-toggle="tooltip" title="Model structure">(Entity-Concept-Resource)</small> <span class="badge tip" id="triples" data-toggle="tooltip" title="Total of Items (triples)">0</span></h4>
                    <br />
                    <div id="kb">
                        <!--<p class="text-info">Disease</p>
        
                                <ul>
        
                                    <li>OMIM <span class="badge">1123</span></li>
        
                                    <li>Orphanet <span class="badge">133</span></li>
        
                                </ul>
        
                                <p class="text-info">Drug</p>
        
                                <ul>
        
                                    <li>PharmGKB <span class="badge">22331</span></li>
        
                                </ul>-->
                    </div>
                    <a href="#addModal" data-toggle="modal" class="tip btn btn-xs btn-success" onclick="prepareAdd('Entity', lastPath());" data-toggle="tooltip" title="Add entities to build/expand your model"><i class="glyphicon glyphicon-plus icon-white"></i></a>
                </div>
                <div class="col-md-6 ">
                    <h4>Actions</h4>
                    <div class="well" style="max-width: 350px; margin: 0 auto 10px;"> <a href="#addModal" data-toggle="modal" class="btn btn-lg btn-block btn-success"
                                                                                         onclick="prepareAdd('Entity', lastPath());">Add Entity <i class="glyphicon glyphicon-plus icon-white"></i></a>
                        <!--<a
                        onclick="redirect('../entity/add/' + lastPath());" class="btn btn-lg btn-block
                        btn-success">Add Entity <i class="glyphicon glyphicon-plus icon-white"></i></a>--> <a onclick="selectEntity();" class="btn btn-lg btn-block btn-primary">Explorer <i class="glyphicon glyphicon-eye-open icon-white"></i></a>
                        <a
                            onclick="build();" href="#integrationModal" data-toggle="modal" class="btn btn-lg btn-block btn-warning"><small>(Re)</small>Build <i class="glyphicon glyphicon-hdd icon-white"></i>
                        </a>
                    </div>
                    <div class="well" style="max-width: 350px; margin: 0 auto 10px;">
                        <div class="btn-group btn-block text-center" data-toggle="buttons-radio"> <a type="button" id="btnBuild" onclick="callURL('../../config/changebuilt/false', changeBuiltResult.bind(this, 'false'), changeBuiltResult.bind(this, 'false'), showInfoError);"
                                                                                                     class="btn btn-lg ">KB not Built</a>
                            <a type="button" id="btnUnbuild" onclick="callURL('../../config/changebuilt/true', changeBuiltResult.bind(this, 'true'), changeBuiltResult.bind(this, 'true'), showInfoError);"
                               class="btn btn-lg ">KB is Built</a>
                        </div> <a onclick="unbuild();" class="btn btn-lg btn-block btn-inverse">UnBuild Resources <i class="glyphicon glyphicon-pencil icon-white"></i></a>
                        <div
                            class="btn-group btn-block btn-lg "> <a class="btn btn-block btn-lg dropdown-toggle" data-toggle="dropdown"
                                                                href="#">

                                Export

                                <span class="caret"></span>

                            </a>
                            <ul class="dropdown-menu ">
                                <li><a href="../../config/export/coeus.rdf">RDF</a>
                                </li>
                                <li><a href="../../config/export/coeus.ttl">TTL</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="integrationModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button id="closeIntegrationModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 class="modal-title">Integration Process</h3>
                    </div>
                    <div class="modal-body">
                        <p id="integrationState">Integration is running...</p>
                        <div id="integrationProgress" class="progress progress-striped active">
                            <div class="bar" style="width: 100%;"></div>
                        </div>

                        <div id="integrationResult"></div>

                    </div>

                    <div class="modal-footer" id="rmbtns">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Hide</button>
                        <button id="integration" class="btn btn-primary hide loading" onclick="window.location.reload();">Refresh <i class="icon-refresh icon-white"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Finally include modals -->
        <%@include file="/setup/modals/add.jsp" %>
        <%@include file="/setup/modals/addResource.jsp" %>
        <%@include file="/setup/modals/edit.jsp" %>
        <%@include file="/setup/modals/editResource.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
    </s:layout-component>
</s:layout-render>
