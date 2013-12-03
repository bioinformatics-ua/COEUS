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
                callURL("../../config/getconfig/", fillHeader);
                refresh();
                //header name
                var path = lastPath();
                $('#breadSeed').html('<a href="../seed/' + path + '">Dashboard</a>');

                //Associate Enter key:
                document.onkeypress = function(event) {
                    //Enter key pressed
                    if (event.charCode === 13) {
                        if (document.getElementById('addModal').style.display === "block" && document.activeElement.getAttribute('id') === "addModal")
                            $('#add').click();
                        if (document.getElementById('editModal').style.display === "block" && document.activeElement.getAttribute('id') === "editModal")
                            $('#edit').click();
                        if (document.getElementById('removeModal').style.display === "block" && document.activeElement.getAttribute('id') === "removeModal")
                            $('#remove').click();
                    }
                };
            });



            function refresh() {
                var seed = lastPath();

                var qEntities = "SELECT DISTINCT ?entity ?e ?label {" + seed + " coeus:includes ?entity . ?entity dc:title ?e . ?entity rdfs:label ?label}";

                queryToResult(qEntities, fillEntities);
            }
            function fillEntities(result) {
                // fill Entities
                $('#entities').html("");
                for (var key in result) {
                    var a = '<tr><td><a class="tip" data-toggle="tooltip" title="View in browser" target="_blank" href="../../resource/' + splitURIPrefix(result[key].entity.value).value + '">'
                            + splitURIPrefix(result[key].entity.value).value + '</a></td><td>'
                            + result[key].e.value + '</td><td>'
                            + result[key].label.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn-default" href="#editModal" data-toggle="modal" onclick="prepareEdit(\'coeus:' + splitURIPrefix(result[key].entity.value).value + '\');">Edit <i class="fa fa-edit"></i></a>'
                            + '<button class="btn btn-default" href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'coeus:' + splitURIPrefix(result[key].entity.value).value + '\')">Remove <i class="fa fa-trash-o"></i></button>'
                            + '</div>'
                            + ' <a href="#addModal" data-toggle="modal" class="btn btn-success tip" data-toggle="tooltip" title="Add Concept to this Entity" onclick="prepareAdd(\'Concept\',\'coeus:' + splitURIPrefix(result[key].entity.value).value + '\');">Concept <i class="fa fa-plus-circle icon-white"></i></a>'
                            + ' <a class="btn btn-info tip" href="../concept/coeus:' + splitURIPrefix(result[key].entity.value).value + '" data-toggle="tooltip" title="Show all Concepts of this Entity" >Show Concepts <i class="fa fa-forward icon-white"></i></a>'
                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                            + '</td></tr>';
                    $('#entities').append(a);
                }
                tooltip();
            }



            // Callback to generate the pages header
            function fillHeader(result) {
                $('#header').html('<h1><span class="tip" data-toggle="tooltip" title="Seed URI">' + lastPath() + '</span><small id="env" class="pull-right tip" data-toggle="tooltip" title="Selected environment"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);
            }



        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <div id="header" class="page-header"></div>
            <div id="apikey" class="hide"></div>
            <ul class="breadcrumb">
                <li id="breadHome"><i class="glyphicon glyphicon-home"></i></li>
                <li id="breadSeeds"><a href="../seed/">Seeds</a></li>
                <li id="breadSeed"></li>
                <li class="active">Entities</li>
            </ul>
            <div class="row">
                <div class="col-md-6">
                    <h3>List of Entities</h3>
                </div>
                <div class="col-md-6 text-right">
                    <div class="btn-group"> <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="prepareAdd('Entity', lastPath());">Add Entity <i class="fa fa-plus-circle icon-white"></i></a>
                    </div>
                </div>
            </div>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Entity</th>
                        <th>Title</th>
                        <th>Label</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="entities"></tbody>
            </table>

        </div>
        <!-- Finally include modals -->
        <%@include file="/setup/modals/add.jsp" %>
        <%@include file="/setup/modals/edit.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
    </s:layout-component>
</s:layout-render>
