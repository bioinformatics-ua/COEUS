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
            /*function appendConcept(data, query, key) {
             $.get(query, function(dataconcepts, status) {
             var c = '';
             for (var k = 0, s = dataconcepts.results.bindings.length; k < s; k++) {
             c += '<li>' + dataconcepts.results.bindings[k].c.value + '</li>';
             }
             $('#' + data[key]).append(c);
             console.log('Append on #' + data[key] + ': ' + c);
             }, 'json');
             }
             
             function fillConcepts(data) {
             console.log('Concepts: ' + data);
             for (var key = 0, size = data.length; key < size; key++) {
             var q = "PREFIX+coeus%3A+%3Chttp%3A%2F%2Fbioinformatics.ua.pt%2Fcoeus%2Fresource%2F%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0A%0D%0ASELECT+DISTINCT+%3Fc+%3Fconcept+%7B%3Fconcept+coeus%3AhasEntity+coeus%3Aentity_" + data[key] + "+.+%3Fconcept+dc%3Atitle+%3Fc%7D";
             var query = "../sparql?query=" + q + "&output=json";
             appendConcept(data, query, key);
             }
             }
             
             function fillEntities() {
             var query = "PREFIX+coeus%3A+%3Chttp%3A%2F%2Fbioinformatics.ua.pt%2Fcoeus%2Fresource%2F%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0A%0D%0ASELECT+DISTINCT+%3Fe+%3Fentity+%7B%3Fs+coeus%3AhasEntity+%3Fentity+.+%3Fentity+dc%3Atitle+%3Fe%7D";
             var q = "../sparql?query=" + query + "&output=json";
             var e = '';
             $.ajax({url: q, dataType: 'json'}).done(function(data) {
             var array = new Array();
             for (var key = 0, size = data.results.bindings.length; key < size; key++) {
             
             array[key] = data.results.bindings[key].e.value;
             
             e += '<p class="text-info">'
             + array[key] + '<ul id=' + array[key] + '></ul></p>';
             
             }
             $('#concepts').append(e);
             fillConcepts(array);
             
             }).fail(function(jqXHR, textStatus) {
             console.log('[COEUS] unable to complete request. ' + textStatus);
             // Server communication error function handler.
             });
             }*/
            $(document).ready(function() {
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
            
            function refresh(){
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
                    c += '<p class="text-info"><a href="../../resource/' + resource + '"><i class="icon-search"></i></a> '
                            + resource 
                            + ' <a href="#editResourceModal" data-toggle="modal" onclick="prepareResourceEdit(\'' + prefix + ':' + resource + '\');"><i class="icon-edit"></i></a>'                            
                            + ' <a href="../resource/edit/' + prefix + ':' + resource + '"><i class="icon-wrench"></i></a>'
                            + ' <a href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'' + prefix + ':' + resource + '\')"><i class="icon-trash"></i></a>'
                            +'</p>';
                }
                //console.log(entity);
                $('#' + concept).append(c);
                //console.log('Append on #' + entity + ': ' + c);

            }

            function fillConcepts(entity, result) {
                var arrayOfConcepts = new Array();
                var c = '';
                for (var i in result) {
                    var auxConcept = splitURIPrefix(result[i].concept.value);
                    var concept = auxConcept.value;
                    var prefix = getPrefix(auxConcept.namespace);
                    var all=prefix + ':'+concept;
                    arrayOfConcepts[i] = concept;
                    c += '<p class="text-warning">'
                            + '<a href="../../resource/' + concept + '"><i class="icon-search"></i></a> '
                            + concept
                            //+ ' <a href="../concept/edit/' + prefix + ':' + concept + '"><i class="icon-edit"></i></a>'
                            + ' <a href="#editModal" data-toggle="modal" onclick="prepareEdit(\''+all+'\');"><i class="icon-edit"></i></a>'
                            //+ ' <a href="../resource/add/' + all + '"><i class="icon-plus-sign"></i></a>'
                            +' <a href="#addResourceModal" data-toggle="modal" onclick="prepareAddResourceModal(\''+all+'\');"><i class="icon-plus-sign"></i></a>'
                            + ' <a href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'' + all + '\')"><i class="icon-trash"></i></a>'
                            + '</p><ul id="' + concept + '"></ul>';
                }
                //console.log(entity);
                $('#' + entity).append(c);
                //console.log('Append on #' + entity + ': ' + c);

                for (i in arrayOfConcepts) {
                    queryResources(arrayOfConcepts[i]);
                }
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
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                var built = result.config.built;
                if (built == false) {
                    $('#btnUnbuild').removeClass("active");
                    $('#btnBuild').addClass("active");
                } else {
                    $('#btnUnbuild').addClass("active");
                    $('#btnBuild').removeClass("active");
                }
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

                    e += '<p class="text-success">'
                            + '<a href="../../resource/' + entity + '"><i class="icon-search"></i></a> '
                            + entity
                            + ' <a href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + prefix + ":" + entity + '\');"><i class="icon-edit"></i></a>'
                           // + ' <a href="../entity/edit/' + prefix + ":" + entity + '"><i class="icon-edit"></i></a> '
                           // + ' <a href="../concept/add/' + prefix + ":" + entity + '"><i class="icon-plus-sign"></i></a> '
                            + ' <a href="#addModal" data-toggle="modal" onclick="prepareAdd(\'Concept\',\'' + prefix + ":" + entity + '\');"><i class="icon-plus-sign"></i></a>'
                           
                            + ' <a href="#removeModal" data-toggle="modal" onclick="selectToRemove(\'' +  prefix + ":" + entity + '\')"><i class="icon-trash"></i></a>' 
                            + '<ul id="' + entity + '"></ul></p>';

                }
                $('#kb').append(e);

                // fill Concepts
                for (var k = 0, s = arrayOfEntities.length; k < s; k++) {
                    //$('#addentity').append('<option>' + arrayOfEntities[k] + '</option>');
                    queryConcepts(arrayOfEntities[k]);
                }
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



        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <div id="apikey" class="hide"></div>
            <ul class="breadcrumb">
                <li id="breadSeed"><i class="icon-home"></i> <span class="divider">/</span> <a href="../seed/">Seeds</a> <span class="divider">/</span></li>
                <li class="active">Dashboard</li>
            </ul>
            <div id="info"></div>
            <div class="row-fluid">
                <div class="span6">
                    <h4>Knowledge Base <small>(Entity-Concept-Resource)</small> <span class="badge" id="triples">0</span></h4>
                    <br/>
                    <div id="kb" >
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
                </div>
                <div class="span6 ">
                    <h4>Actions</h4>

                    <div class="well" style="max-width: 350px; margin: 0 auto 10px;">
                        <a href="#addModal" data-toggle="modal" class="btn btn-large btn-block btn-success" onclick="prepareAdd('Entity',lastPath());">Add Entity <i class="icon-plus icon-white"></i></a>
                        <!--<a onclick="redirect('../entity/add/' + lastPath());" class="btn btn-large btn-block btn-success">Add Entity <i class="icon-plus icon-white"></i></a>-->
                        <a onclick="selectEntity();" class="btn btn-large btn-block btn-primary">Explorer <i class="icon-eye-open icon-white"></i></a>
                    </div>
                    <div class="well" style="max-width: 350px; margin: 0 auto 10px;">
                        <a  onclick="build();" class="btn btn-large btn-block btn-success"><small>(Re)</small>Build <i class="icon-hdd icon-white"></i></a>
                        <div class="btn-group btn-block text-center" data-toggle="buttons-radio">
                            <a type="button" id="btnBuild" onclick="callURL('../../config/changebuilt/false', changeBuiltResult.bind(this, 'false'), changeBuiltResult.bind(this, 'false'), showInfoError);" class="btn btn-large ">KB not Built</a>
                            <a type="button" id="btnUnbuild" onclick="callURL('../../config/changebuilt/true', changeBuiltResult.bind(this, 'true'), changeBuiltResult.bind(this, 'true'), showInfoError);" class="btn btn-large ">KB is Built</a>

                        </div>

                        <a onclick="unbuild();" class="btn btn-large btn-block btn-inverse">Change all Resources to unbuild<i class="icon-pencil icon-white"></i></a>
                        <div class="btn-group btn-block btn-large ">
                            <a class="btn btn-block btn-large dropdown-toggle" data-toggle="dropdown" href="#">
                                Export
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu ">
                                <li><a href="../../config/export/coeus.rdf">RDF</a></li>
                                <li><a href="../../config/export/coeus.ttl">TTL</a></li>
                            </ul>
                        </div>
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
