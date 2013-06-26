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
        <script type="text/javascript">
            function deleteEntity(entity){
                alert(entity);
            }

            $(document).ready(function() {

                //fillEntities();
                var sparqler = new SPARQL.Service("../../sparql");
                sparqler.setPrefix("dc", "http://purl.org/dc/elements/1.1/");
                sparqler.setPrefix("rdfs", "http://www.w3.org/2000/01/rdf-schema#");
                sparqler.setPrefix("coeus", "http://bioinformatics.ua.pt/coeus/resource/");

                var query = sparqler.createQuery();
                // passes standard JSON results object to success callback
                var qEntities = "SELECT DISTINCT ?entity ?e {?entity a coeus:Entity . ?entity dc:title ?e . }";

                query.query(qEntities,
                        {success: function(json) {
                                // fill Entities

                                for (var key = 0, size = json.results.bindings.length; key < size; key++) {
                                    var a = '<tr><td><a href=' + json.results.bindings[key].entity.value + '>'
                                            + json.results.bindings[key].entity.value + '</a></td><td>'
                                            + json.results.bindings[key].e.value + '</td><td>'
                                            + '<a href="#deleteModal" role="button" data-toggle="modal" onclick="deleteEntity(\''+json.results.bindings[key].e.value+'\')">Delete</a>'
                                            +'</td></tr>';
                                    $('#entities').append(a);

                                }



                            }}
                );
                //header name
                $.get('../home/config', function(config, status) {
                    console.log(config);
                    $('#header').append('<h1>' + config.config.name + '<small> ' + config.config.environment + '</small></h1>');
                }, 'json');
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <div class="row-fluid">
                <div class="span6">
                    <h3>List of Entities</h3>
                </div>
                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a href="../entity/add" class="btn btn-info">Add Entity</a>
                    </div>
                </div>


                <table class="table table-hover">

                    <thead>
                        <tr>
                            <th>Entity</th>
                            <th>Title</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="entities">

                    </tbody>
                </table>

<!-- Button to trigger modal -->

 
<!-- Modal -->
<div id="deleteModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
    <h3 id="myModalLabel">Delete Entity</h3>
  </div>
  <div class="modal-body">
    <p>One fine body..</p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary">Save changes</button>
  </div>
</div>

            </div>

        </s:layout-component>
    </s:layout-render>
