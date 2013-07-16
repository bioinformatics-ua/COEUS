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
                var query = initSparqlerQuery();
                // passes standard JSON results object to success callback
                var qEntities = "SELECT DISTINCT ?seed ?s {?seed a coeus:Seed . ?seed dc:title ?s . }";
                console.log(qEntities);
                query.query(qEntities,
                        {success: function(json) {console.log(json);
                                // fill Entities
                                var result=json.results.bindings;
                               // console.log(result);
                                for (var key = 0, size = result.length; key < size; key++) {
                                    var splitedURI=splitURIPrefix(result[key].seed.value);
                                    var seed=getPrefix(splitedURI.namespace)+':'+splitedURI.value;
         
                                    var a = '<li class="span5 clearfix"><div class="thumbnail clearfix"><div class="caption" class="pull-left">'
                                        +'<a href="./'+seed+'" class="btn btn-primary icon  pull-right">Select</a>'
                                        +'<h4>'+result[key].s.value+'</h4>'
                                        +'<small><b>URI: </b><a href="'+result[key].seed.value+'">'+seed+'</a></small>'
                                        +'<a href="#removeModal" class="pull-right" data-toggle="modal" onclick="selectSeed(\''+seed+'\');"><i class="icon-remove"></i></a>'
                                        +'<a href="'+'../seed/edit/'+seed+'" class="pull-right"><i class="icon-edit"></i> </a>'
                                        +'</div></div></li>';
                                    $('#seeds').append(a);

                                }

                            }}
                );


            });
            
            
            function selectSeed(seed) {
                $('#removeModalLabel').html(seed);
            }
            function removeSeed() {
                var seed = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + seed);
                
                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix,seed);
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix,seed);

            }
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">
                <h1>Please, choose the seed:</h1>

            </div>
            <div class=" text-right" >
                <div class="btn-group">
                    <!-- <a href="#cleanModal" data-toggle="modal"  class="btn btn-danger">Clean database</a>-->
               </div>
                <div class="btn-group">
                    <a href="../seed/add/" class="btn btn-success">Add <i class="icon-plus icon-white"></i></a>
                </div>
            </div>
            <ul id="seeds" class="thumbnails">
                
            </ul>

        </div>
        
                        <!-- Modal -->
                <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Remove Seed</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> seed?</p>
                        <p class="text-warning">Warning: All dependents triples are removed too.</p>

                        <div id="result">

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger" onclick="removeSeed();">Remove</button>
                    </div>
                </div>
                        
                               <!-- Modal -->
                <div id="cleanModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closecleanModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Clean database</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to clean all from the COEUS database?</p>
                        <p class="text-error">Warning: This actions performs a SQL TRUNCATE over all tables that will delete all data.</p>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger" onclick="">Clean</button>
                    </div>
                </div>
    </s:layout-component>
</s:layout-render>
