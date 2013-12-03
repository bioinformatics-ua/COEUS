<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {
                changeSidebar('#dashboard');
                //header name
                callURL("../../config/getconfig/", fillHeader);

                var concept = lastPath();
                refresh();
                var qresource = "SELECT DISTINCT ?seed ?entity {" + concept + " coeus:hasEntity ?entity . ?entity coeus:isIncludedIn ?seed }";
                queryToResult(qresource, fillBreadcumb);

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
                $('#breadSeed').html('<a href="../seed/' + seed + '">Dashboard</a>');
                $('#breadEntities').html('<a href="../entity/' + seed + '">Entities</a> ');
                $('#breadConcepts').html('<a href="../concept/' + entity + '">Concepts</a> ');
            }

            function refresh() {
                var qresource = "SELECT DISTINCT ?resource ?c ?order ?built ?label ?error {" + lastPath() + " coeus:hasResource ?resource . ?resource dc:title ?c . ?resource coeus:order ?order . ?resource rdfs:label ?label . OPTIONAL{ ?resource coeus:built ?built . ?resource dc:coverage ?error }}";
                queryToResult(qresource, fillListOfResources);

            }

            function fillListOfResources(result) {
                $('#resources').html("");
                console.log(result);
                for (var key = 0, size = result.length; key < size; key++) {
                    var built = '<span class="label label-success">Built</span>';
                    if (result[key].built === undefined || result[key].built.value === "false")
                        built = '<span class="label label-default">not built</span>';
                    var error = '';
                    if (result[key].error !== undefined) error = ' <span class="label label-danger tip" data-toggle="tooltip" title="Click on the resource to view errors">Error</span>';
                    var a = '<tr><td><a class="tip" data-toggle="tooltip" title="View in browser" target="_blank" href="../../resource/' + splitURIPrefix(result[key].resource.value).value + '">'
                            + splitURIPrefix(result[key].resource.value).value + '</a> ' + built + error + '</td><td>'
                            + result[key].c.value + '</td><td>'
                            + result[key].label.value + '</td><td>'
                            + result[key].order.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn-default" href="#editResourceModal" data-toggle="modal" onclick="prepareResourceEdit(\'coeus:' + splitURIPrefix(result[key].resource.value).value + '\');">Edit <i class="fa fa-edit"></i></a>'
                            + '<a class="btn btn-default" href="#removeModal" data-toggle="modal" onclick="selectToRemove(\'coeus:' + splitURIPrefix(result[key].resource.value).value + '\');">Remove <i class="fa fa-trash-o"></i></a> '
                            + '</div>'
                            + ' <a class="btn btn-warning tip" data-toggle="tooltip" title="Resource configuration" href="../selector/coeus:' + splitURIPrefix(result[key].resource.value).value + '">Configuration  <i class="fa fa-wrench icon-white"></i></a> '
                            //+ ' <a class="btn btn-info">Selectors</a>'
                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                            + '</td></tr>';
                    $('#resources').append(a);
                }
                tooltip();
            }

            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1><span class="tip" data-toggle="tooltip" title="Concept URI">' + lastPath() + '</span><small id="env" class="pull-right tip" data-toggle="tooltip" title="Selected environment">  ' + result.config.environment + '</small></h1>');
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
            <div id="header" class="page-header"></div>
            <div id="apikey" class="hide"></div>
            <ul class="breadcrumb">
                <li id="breadHome"><i class="glyphicon glyphicon-home"></i></li>
                <li id="breadSeeds"><a href="../seed/">Seeds</a> </li>
                <li id="breadSeed"></li>
                <li id="breadEntities"></li>
                <li id="breadConcepts"></li>
                <li class="active">Resources</li>
            </ul>
            <div class="row">
                <div class="col-md-6">
                    <h3>List of Resources</h3>
                </div>
                <div class="col-md-6 text-right" >
                    <div class="btn-group">
                        <a href="#addResourceModal" data-toggle="modal" class="btn btn-success" onclick="prepareAddResourceModal(lastPath());">Add Resource <i class="fa fa-plus-circle"></i></a>
                    </div>
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
        <%@include file="/setup/modals/addResource.jsp" %>
        <%@include file="/setup/modals/editResource.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
    </s:layout-component>
</s:layout-render>
