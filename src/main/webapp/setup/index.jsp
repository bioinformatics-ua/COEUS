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
                            + prefix + ":" + resource + ' <a href="../resource/edit/' + prefix + ':' + resource
                            + '"><i class="icon-wrench"></i></a></p>';
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
                    arrayOfConcepts[i] = concept;
                    c += '<p class="text-warning">'
                            +'<a href="../../resource/' + concept + '"><i class="icon-search"></i></a> ' 
                            + prefix + ":" + concept 
                            + ' <a href="../concept/edit/' + prefix + ':' + concept + '"><i class="icon-edit"></i></a>'
                            + ' <a href="../resource/add/' + prefix + ':' + concept + '"><i class="icon-plus-sign"></i></a>'
                          +'</p><ul id="' + concept + '"></ul>';
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
            }

            function fillEntities(result) {
                // fill Entities
                console.log(result);
                var arrayOfEntities = new Array();
                var e = '';
                for (var key in result) {
                    var auxEntity = splitURIPrefix(result[key].entity.value);
                    var entity = auxEntity.value;
                    var prefix = getPrefix(auxEntity.namespace);
                    arrayOfEntities[key] = entity;

                    e += '<p class="text-success">'
                            +'<a href="../../resource/' + entity + '"><i class="icon-search"></i></a> '
                            + prefix + ":" + entity 
                            +' <a href="../entity/edit/' + prefix + ":" + entity + '"><i class="icon-edit"></i></a> '
                            +' <a href="../entity/add/' + lastPath() + '"><i class="icon-plus-sign"></i></a> '
                          +'<ul id="' + entity + '"></ul></p>';

                }
                $('#kb').append(e);

                // fill Concepts
                for (var k = 0, s = arrayOfEntities.length; k < s; k++) {
                    //$('#addentity').append('<option>' + arrayOfEntities[k] + '</option>');
                    queryConcepts(arrayOfEntities[k]);
                }
            }

            $(document).ready(function() {
                //get seed from url
                var seed = lastPath();
                callURL("../../config/getconfig/", fillHeader);
                callURL("../../config/listenv/", fillEnvironments);

                var qEntities = "SELECT DISTINCT ?entity {" + seed + " coeus:includes ?entity }";
                queryToResult(qEntities, fillEntities);

                var qseeds = "SELECT DISTINCT ?seed ?s {?seed a coeus:Seed . ?seed dc:title ?s . }";
                queryToResult(qseeds, function(result) {
                    for (var k in result) {
                        $('#seeds').append('<option>' + splitURIPrefix(result[k].seed.value).value + '</option>');
                    }
                    $('#seeds option:contains(' + lastPath().split('coeus:')[1] + ')').prop({selected: true});
                }
                );

                var qEntities = "SELECT (COUNT(*) AS ?triples) {?s ?p ?o}";
                queryToResult(qEntities, function(result) {
                    $('#triples').html(result[0].triples.value);
                });
                
            });

            function changeSeed() {
                var title = $('#seeds').val();
                redirect("../seed/" + "coeus:" + title);
            }

            function changeEnv() {
                var env = $('#environments').val();
                callURL("../../config/upenv/" + env, changeEnvResult, changeEnvResult, changeEnvError);
            }
            function changeEnvResult(result) {
                if (result.status === 100)
                    callURL("../../config/getconfig/", fillHeader);
                else
                    $('#info').html(generateHtmlMessage("Warning!", result.message));
            }
            function changeEnvError(result, text) {
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
                for (var r in result) {
                    var res = splitURIPrefix(result[r].resource.value);
                    var resource = getPrefix(res.namespace) + ":" + res.value;
                    callURL(urlPrefix + "/update/" + resource + "/coeus:built/xsd:boolean:true,xsd:boolean:false", unbuiltResource.bind(this, resource));
                }

            }
            function unbuiltResource(resource, result) {
                if (result.status === 100)
                    console.log("The " + resource + " has been changed. ");
                else
                    console.log("The " + resource + " has already unbuild. ");
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
                <div id="kb"class="span6">
                    <h4>Knowledge Base <small>(Entity-Concept)</small> <span class="badge" id="triples">0</span></h4>
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
                <div class="span6">
                    <h4>Actions</h4>

                    <div class="row-fluid">
                        <div class="span4">
                            Seeds
                        </div>
                        <div  class="span4">
                            <select class="span10" id="seeds">

                            </select>
                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a onclick="changeSeed();" class="btn btn-danger">Change seed <i class="icon-refresh icon-white"></i></a>
                            </div>
                        </div>
                    </div>

                    <div class="row-fluid">
                        <div class="span4">
                            Environments
                        </div>
                        <div class="span4">
                            <select class="span10" id="environments">
                            </select>
                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a onclick="changeEnv();" class="btn btn-danger">Change environment <i class="icon-refresh icon-white"></i></a>
                            </div>
                        </div>
                    </div>

                    <div class="row-fluid">
                        <div class="span4">
                            <div class="btn-group">
                                <a onclick="build();" class="btn btn-large btn-success">Rebuild <i class="icon-hdd icon-white"></i></a>
                                <a onclick="unbuild();" class="btn btn-large btn-inverse">Unbuild <i class="icon-pencil icon-white"></i></a>
                            </div></div>
                        <div class="span4">

                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a onclick="selectEntity();" class="btn btn-large btn-primary">Show Entities <i class="icon-forward icon-white"></i></a>

                            </div>

                        </div>
                    </div>

                    <div class="row-fluid">
                        <div class="span4">
                        </div>
                        <div class="span4">

                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                                    Export
                                    <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a href="../../config/export/coeus.rdf">RDF</a></li>
                                    <li><a href="../../config/export/coeus.ttl">TTL</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>




                </div>
            </div>



        </div>

    </s:layout-component>
</s:layout-render>
