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

            function fillHeader(result) {
                $('#header').html('<h1>Please, choose the seed:<small id="env"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);

                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);
            }
            function refresh() {
                var qSeeds = "SELECT DISTINCT ?seed ?s {?seed a coeus:Seed . ?seed dc:title ?s . }";
                console.log(qSeeds);
                queryToResult(qSeeds, fillSeeds);
            }
            function fillSeeds(result) {
                console.log(result);
                // fill Seeds
                $('#seeds').html('');
                for (var key = 0, size = result.length; key < size; key++) {
                    var splitedURI = splitURIPrefix(result[key].seed.value);
                    var seed = getPrefix(splitedURI.namespace) + ':' + splitedURI.value;

                    var a = '<li class="span5 clearfix"><div class="thumbnail clearfix"><div class="caption" class="pull-left">'
                            + '<a href="./' + seed + '" class="btn btn-primary icon  pull-right">Choose <i class="icon-forward icon-white"></i></a>'
                            + '<h4>' + result[key].s.value + '</h4>'
                            + '<small><b>URI: </b><a href="../../resource/' + splitedURI.value + '">' + seed + '</a></small>'
                            + '<a href="#removeModal" class="pull-right" data-toggle="modal" onclick="selectToRemove(\'' + seed + '\');"><i class="icon-remove"></i></a>'
                            + '<a href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + seed + '\');" class="pull-right"><i class="icon-edit"></i> </a>'
                            + '</div></div></li>';
                    $('#seeds').append(a);

                }

            }

        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">
                <h1>Please, choose the seed:</h1>
            </div>
            <div id="apikey" class="hide"></div>
            <ul class="breadcrumb">
                <li id="breadHome"><i class="icon-home"></i> <span class="divider">/</span></li>
                <li class="active">Seeds</li>
            </ul>
            <div id="info"></div>
            <div class=" text-right" >
                <div class="btn-group">
                    <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="prepareAdd('Seed',lastPath());">Add Seed <i class="icon-plus icon-white"></i></a>
                </div>
                <!-- <div class="btn-group">
                    <a href="../seed/add/" class="btn btn-success">Add Seed <i class="icon-plus icon-white"></i></a>
                </div>-->
            </div>
            <ul id="seeds" class="thumbnails">

            </ul>

        </div>

        <!-- Finally include modals -->
        <%@include file="/setup/modals/add.jsp" %>
        <%@include file="/setup/modals/edit.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
    </s:layout-component>
</s:layout-render>
