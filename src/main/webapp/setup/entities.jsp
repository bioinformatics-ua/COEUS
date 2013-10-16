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
                callURL("../../config/getconfig/", fillHeader);
                refresh();
                //header name
                var path = lastPath();
                $('#breadSeed').html('<a href="../seed/' + path + '">Dashboard</a> <span class="divider">/</span>');

                //activate tooltip (bootstrap-tooltip.js is need)
                $('.icon-question-sign').tooltip();
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

                var qEntities = "SELECT DISTINCT ?entity ?e {" + seed + " coeus:includes ?entity . ?entity dc:title ?e . }";

                queryToResult(qEntities, fillEntities);
            }
            function fillEntities(result) {
                // fill Entities
                $('#entities').html("");
                for (var key in result) {
                    var a = '<tr><td><a href="../../resource/' + splitURIPrefix(result[key].entity.value).value + '">'
                            + result[key].entity.value + '</a></td><td>'
                            + result[key].e.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn" href="#editModal" data-toggle="modal" onclick="prepareEdit(\'coeus:' + splitURIPrefix(result[key].entity.value).value + '\');">Edit <i class="icon-edit"></i></a>'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'coeus:' + splitURIPrefix(result[key].entity.value).value + '\')">Remove <i class="icon-trash"></i></button>'
                            + '</div>'
                            + ' <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="prepareAdd(\'Concept\',\'coeus:'+splitURIPrefix(result[key].entity.value).value+'\');">Concept <i class="icon-plus icon-white"></i></a>'
                            + ' <a class="btn btn-info" href="../concept/coeus:' + splitURIPrefix(result[key].entity.value).value + '">Show Concepts <i class="icon-forward icon-white"></i></a>'
                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                            + '</td></tr>';
                    $('#entities').append(a);
                }
            }



            // Callback to generate the pages header
            function fillHeader(result) {
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);
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
                <li id="breadHome"><i class="icon-home"></i> <span class="divider">/</span></li>
                <li id="breadSeeds"><a href="../seed/">Seeds</a> <span class="divider">/</span> </li>
                <li id="breadSeed"></li>
                <li class="active">Entities</li>
            </ul>
            <div class="row-fluid">

                <div class="span6">
                    <h3>List of Entities</h3>
                </div>

                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="prepareAdd('Entity',lastPath());">Add Entity <i class="icon-plus icon-white"></i></a>
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
</div>
                <!-- Finally include modals -->
                <%@include file="/setup/modals/add.jsp" %>
                <%@include file="/setup/modals/edit.jsp" %>
                <%@include file="/setup/modals/remove.jsp" %>
            </s:layout-component>
        </s:layout-render>
