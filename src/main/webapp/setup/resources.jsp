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

            function selectResource(resource) {
                $('#removeModalLabel').html('coeus:resource_' + resource.split(' ').join('_'));
            }
            function removeResource() {
                var resource = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + resource);

                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix, resource);
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix, resource);
            }
            function fillBreadcumb(result) {
                console.log(result);
                var seed = result[0].seed.value;
                var entity = result[0].entity.value;
                seed = "coeus:" + splitURIPrefix(seed).value;
                entity = "coeus:" + splitURIPrefix(entity).value;
                $('#breadSeed').html('<a href="../seed/' + seed + '">Dashboard</a> <span class="divider">/</span>');
                $('#breadEntities').html('<a href="../entity/' + seed + '">Entities</a> <span class="divider">/</span>');
                $('#breadConcepts').html('<a href="../concept/' + entity + '">Concepts</a> <span class="divider">/</span>');
            }
            function fillListOfResources(result) {
                for (var key = 0, size = result.length; key < size; key++) {
                    var built = '<span class="label label-success">Built</span>';
                    if (result[key].built===undefined || result[key].built.value === "false")
                        built = '<span class="label ">not built</span>';
                    var a = '<tr><td><a href="../../resource/' + splitURIPrefix(result[key].resource.value).value + '">'
                            + result[key].resource.value + '</a> '+built+'</td><td>'
                            + result[key].c.value + '</td><td>'
                            + result[key].order.value + '</td><td>'
                            //+ '<div class="btn-group">'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectResource(\'' + result[key].c.value + '\')">Remove <i class="icon-trash"></i></button> '       
                            + '<a class="btn btn-warning" href="../resource/edit/coeus:' + splitURIPrefix(result[key].resource.value).value + '">Configuration  <i class="icon-wrench icon-white"></i></a> '
                            //+ '</div>'
                            //+ ' <a class="btn btn-info">Selectors</a>'
                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                            + '</td></tr>';
                    $('#resources').append(a);
                }
            }
            
            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
            }

            $(document).ready(function() {
                var concept = lastPath();

                var qresource = "SELECT DISTINCT ?seed ?entity {" + concept + " coeus:hasEntity ?entity . ?entity coeus:isIncludedIn ?seed }";
                queryToResult(qresource, fillBreadcumb);

                var qresource = "SELECT DISTINCT ?resource ?c ?order ?built {" + concept + " coeus:hasResource ?resource . ?resource dc:title ?c . ?resource coeus:order ?order . OPTIONAL{ ?resource coeus:built ?built }}";
                queryToResult(qresource, fillListOfResources);
                
                
                //header name
                callURL("../../config/getconfig/", fillHeader);
                
                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);

            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <ul class="breadcrumb">
                 <li id="breadHome"><i class="icon-home"></i> <span class="divider">/</span></li>
                <li id="breadSeeds"><a href="../seed/">Seeds</a> <span class="divider">/</span> </li>
                <li id="breadSeed"></li>
                <li id="breadEntities"></li>
                <li id="breadConcepts"></li>
                <li class="active">Resources</li>
            </ul>
            <div class="row-fluid">
                <div class="span6">
                    <h3>List of Resources</h3>
                </div>
                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a onclick="redirect('../resource/add/' + lastPath())" class="btn btn-success">Add Resource <i class="icon-plus icon-white"></i></a>
                    </div>
                </div>


                <table class="table table-hover">

                    <thead>
                        <tr>
                            <th>Resource</th>
                            <th>Title</th>
                            <th>Order</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="resources">

                    </tbody>
                </table>

                <!-- Button to trigger modal -->


                <!-- Modal -->
                <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Remove Resource</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> resource?</p>
                        <p class="text-warning">Warning: All dependents triples are removed too.</p>

                        <div id="result">

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger" onclick="removeResource();">Remove <i class="icon-trash icon-white"></i></button>
                    </div>
                </div>
                
            </div>
        </div>
        </s:layout-component>
    </s:layout-render>
