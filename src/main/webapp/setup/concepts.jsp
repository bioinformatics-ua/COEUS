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

            function selectConcept(concept) {
                $('#removeModalLabel').html('coeus:concept_' + concept.split(' ').join('_'));
            }
            function removeConcept() {
                var concept = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + concept);
                
                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix,concept);
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix,concept);

            }

            $(document).ready(function() {
                var entity = lastPath();
                var query = initSparqlerQuery();
                
                var qconcept = "SELECT DISTINCT ?seed {" + entity + " coeus:isIncludedIn ?seed }";

                query.query(qconcept,
                        {success: function(json) {
                                var seed=json.results.bindings[0].seed.value;
                                seed="coeus:"+splitURIPrefix(seed).value;
                                $('#breadSeed').html('<a href="../seed/'+seed+'">Seed</a> <span class="divider">/</span>');
                                $('#breadEntity').html('<a href="../entity/'+seed+'">Entities</a> <span class="divider">/</span>');   
                    }}
                );
                
                var qconcept = "SELECT DISTINCT ?concept ?c {" + entity + " coeus:isEntityOf ?concept . ?concept dc:title ?c . }";

                query.query(qconcept,
                        {success: function(json) {
                                // fill Entities

                                for (var key = 0, size = json.results.bindings.length; key < size; key++) {
                                    var a = '<tr><td><a href=' + json.results.bindings[key].concept.value + '>'
                                            + json.results.bindings[key].concept.value + '</a></td><td>'
                                            + json.results.bindings[key].c.value + '</td><td>'
                                            + '<div class="btn-group">'
                                            + '<a class="btn btn" href="../concept/edit/coeus:'+splitURIPrefix(json.results.bindings[key].concept.value).value+'">Edit</a>'
                                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectConcept(\'' + json.results.bindings[key].c.value + '\')">Remove</button>'
                                            + '</div>'
                                            + ' <a class="btn btn-info">Resources</a>'
                                            + ' <a class="btn btn-warning">Extensions</a>'
                                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                                            + '</td></tr>';
                                    $('#concepts').append(a);

                                }



                            }}
                );
                //header name
                var path = lastPath();
                $('#header').append('<h1>' + path + '<small> env.. </small></h1>');
                
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <ul class="breadcrumb">
                <li id="breadSeed"></li>
                <li id="breadEntity"></li>
                <li class="active">Concepts</li>
            </ul>
            <div class="row-fluid">
                <div class="span6">
                    <h3>List of Concepts</h3>
                </div>
                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a onclick="redirect('../concept/add/' + lastPath())" class="btn btn-success">Add Concept</a>
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
                        <button class="btn btn-danger" onclick="removeConcept();">Remove</button>
                    </div>
                </div>

            </div>

        </s:layout-component>
    </s:layout-render>
