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
        <script src="<c:url value="/assets/js/bootstrap-tooltip.js" />"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                //header name
                callURL("../../config/getconfig/", fillHeader);
                
                var concept = lastPath();
                refresh();
                var qresource = "SELECT DISTINCT ?seed ?entity {" + concept + " coeus:hasEntity ?entity . ?entity coeus:isIncludedIn ?seed }";
                queryToResult(qresource, fillBreadcumb);


                //activate tooltip (bootstrap-tooltip.js is need)
                $('.icon-question-sign').tooltip();
                //Associate Enter key:
                document.onkeypress = function(event) {
                    //Enter key pressed
                    if (event.charCode === 13) {
                        if (document.getElementById('addResourceModal').style.display === "block" && document.activeElement.getAttribute('id') === "addResourceModal")
                            $('#addResource').click();
                        if (document.getElementById('editResourceModal').style.display === "block" && document.activeElement.getAttribute('id') === "editResourceModal")
                            $('#editResource').click();
                        if (document.getElementById('removeModal').style.display === "block" && document.activeElement.getAttribute('id') === "removeModal")
                            $('#remove').click();
                    }
                };
            });
            
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
            
            function refresh() {
                var qresource = "SELECT DISTINCT ?resource ?c ?order ?built ?label{" + lastPath() + " coeus:hasResource ?resource . ?resource dc:title ?c . ?resource coeus:order ?order . ?resource rdfs:label ?label . OPTIONAL{ ?resource coeus:built ?built }}";
                queryToResult(qresource, fillListOfResources);

            }

            function fillListOfResources(result) {
                $('#resources').html("");
                console.log(result);
                for (var key = 0, size = result.length; key < size; key++) {
                    var built = '<span class="label label-success">Built</span>';
                    if (result[key].built === undefined || result[key].built.value === "false")
                        built = '<span class="label ">not built</span>';
                    var a = '<tr><td><a href="../../resource/' + splitURIPrefix(result[key].resource.value).value + '">'
                            + splitURIPrefix(result[key].resource.value).value + '</a> ' + built + '</td><td>'
                            + result[key].c.value + '</td><td>'
                    + result[key].label.value + '</td><td>'
                            + result[key].order.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn" href="#editResourceModal" data-toggle="modal" onclick="prepareResourceEdit(\'coeus:' + splitURIPrefix(result[key].resource.value).value + '\');">Edit <i class="icon-edit"></i></a>'
                            + '<a class="btn btn" href="#removeModal" data-toggle="modal" onclick="selectToRemove(\'coeus:' + splitURIPrefix(result[key].resource.value).value + '\');">Remove <i class="icon-trash"></i></a> '
                            + '</div>'
                            + ' <a class="btn btn-warning" href="../selector/coeus:' + splitURIPrefix(result[key].resource.value).value + '">Configuration  <i class="icon-wrench icon-white"></i></a> '
                            //+ ' <a class="btn btn-info">Selectors</a>'
                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                            + '</td></tr>';
                    $('#resources').append(a);
                }
            }

            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);
            }
            //Edit functions
            
            //End of Edit functions
            
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <div id="apikey" class="hide"></div>
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
                        <a href="#addResourceModal" data-toggle="modal" class="btn btn-success" onclick="prepareAddResourceModal(lastPath());">Add Resource <i class="icon-plus icon-white"></i></a>
                    </div>
                </div>


                <table class="table table-hover">

                    <thead>
                        <tr>
                            <th>Resource</th>
                            <th>Title</th>
                            <th>Label</th>
                            <th>Order</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="resources">

                    </tbody>
                </table>



            </div>
        </div>
        <%@include file="/setup/modals/addResource.jsp" %>
        <%@include file="/setup/modals/editResource.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
    </s:layout-component>
</s:layout-render>
