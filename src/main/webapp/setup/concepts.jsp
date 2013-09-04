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
            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
            }
            function selectConcept(concept) {
                $('#removeModalLabel').html('coeus:concept_' + concept.split(' ').join('_'));
            }
            function removeConcept() {
                var concept = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + concept);

                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix, concept);
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix, concept);

            }
            function fillBreadcumb(result) {
                var seed = result[0].seed.value;
                seed = "coeus:" + splitURIPrefix(seed).value;
                $('#breadSeed').html('<a href="../seed/' + seed + '">Dashboard</a> <span class="divider">/</span>');
                $('#breadEntities').html('<a href="../entity/' + seed + '">Entities</a> <span class="divider">/</span>');
                
            }
            function fillListOfConcepts(result) {
                for (var key in result) {
                    var concept='coeus:'+splitURIPrefix(result[key].concept.value).value;
                    var a = '<tr><td><a href="../../resource/' + splitURIPrefix(result[key].concept.value).value + '">'
                            + result[key].concept.value + '</a></td><td>'
                            + result[key].c.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn" href="../concept/edit/' +concept + '">Edit <i class="icon-edit"></i></a>'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectConcept(\'' + result[key].c.value + '\')">Remove <i class="icon-trash"></i></button>'
                            + '</div>'
                            + ' <a class="btn btn-info" href="../resource/' + concept + '">Show Resources <i class="icon-forward icon-white"></i></a>'
                            
                            +' <a class="dropdown">'
                            +'<button class="dropdown-toggle btn btn-warning" role="button" data-toggle="dropdown" data-target="#">'
                            +'Extensions '
                            +'<b class="caret"></b>'
                            +'</button>'
                            +'<ul class="dropdown-menu" role="menu" aria-labelledby="dropdown" id="'+splitURIPrefix(result[key].concept.value).value+'">'
                                //<li><a href="#">Action</a></li>
                            +'</ul>'
                            +'</a>'
                            
                            + '</td></tr>';
                    $('#concepts').append(a);
                }
                //fill Extensions:
                for(var r in result){
                    var id=splitURIPrefix(result[r].concept.value).value;
                    var ext='coeus:'+id;
                    //FILL THE EXTENSIONS
                    var extensions="SELECT ?resource {"+ext+" coeus:isExtendedBy ?resource }";
                    queryToResult(extensions,fillExtensions.bind(this,id));
                }
            }
            function fillExtensions(id,result){
                for(var rs in result){
                   var r=splitURIPrefix(result[rs].resource.value).value;
                   $('#'+id).append('<li><a tabindex="-1" href="../resource/edit/coeus:'+r+'">coeus:'+r+'</a></li>');
                }
                //console.log('fillExtensions:'+ext);console.log(result)
            }

            $(document).ready(function() {
                var entity = lastPath();

                var qconcept = "SELECT DISTINCT ?seed {" + entity + " coeus:isIncludedIn ?seed }";
                queryToResult(qconcept, fillBreadcumb);

                var qconcept = "SELECT DISTINCT ?concept ?c {" + entity + " coeus:isEntityOf ?concept . ?concept dc:title ?c . }";
                queryToResult(qconcept, fillListOfConcepts);
                
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
                <li class="active">Concepts</li>
            </ul>
            <div class="row-fluid">
                <div class="span6">
                    <h3>List of Concepts</h3>
                </div>
                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a onclick="redirect('../concept/add/' + lastPath())" class="btn btn-success">Add Concept <i class="icon-plus icon-white"></i></a>
                    </div>
                </div>


                <table class="table table-hover">

                    <thead>
                        <tr>
                            <th>Concept</th>
                            <th>Title</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="concepts">

                    </tbody>
                </table>

                <!-- Button to trigger modal -->


                <!-- Modal -->
                <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Remove Concept</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> concept?</p>
                        <p class="text-warning">Warning: All dependents triples are removed too.</p>

                        <div id="result">

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger" onclick="removeConcept();">Remove <i class="icon-trash icon-white"></i></button>
                    </div>
                </div>

            </div>
        </div>
        </s:layout-component>
    </s:layout-render>
