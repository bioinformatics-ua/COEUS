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
                                        +'<a href="#" class="pull-right"><i class="icon-remove"></i></a>'
                                        +'<a href="#" class="pull-right"><i class="icon-edit"></i> </a>'
                                        +'</div></div></li>';
                                    $('#seeds').append(a);

                                }

                            }}
                );


            });
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
                    <a href="../seeds/add" class="btn btn-success">Add <i class="icon-plus icon-white"></i></a>
                </div>
            </div>
            <ul id="seeds" class="thumbnails">
                
            </ul>

        </div>
    </s:layout-component>
</s:layout-render>
