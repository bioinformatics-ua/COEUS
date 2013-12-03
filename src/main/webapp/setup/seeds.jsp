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
                $('#header').html('<h1>Please, choose the seed:<small id="env" class="pull-right tip" data-toggle="tooltip" title="Selected environment"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                if (result.config.wizard == false)
                    redirect('../config/');
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

                    var a = '<div class="col-sm-6 col-md-5"><div class="thumbnail"><div class="caption clearfix">'
                            + '<a href="./' + seed + '" class="btn btn-primary icon pull-right ">Choose <span class="fa fa-forward"></span></a>'
                            + '<h4>' + result[key].s.value + '</h4>'
                            + '<small><b>URI: </b><a class="tip" data-toggle="tooltip" title="View in browser" target="_blank" href="../../resource/' + splitedURI.value + '">' + seed + '</a></small>'
                            + '<a href="#removeModal" class="pull-right" data-toggle="modal" onclick="selectToRemove(\'' + seed + '\');"><i class="fa fa-trash-o fa-1x tip black" data-toggle="tooltip" title="Delete"></i></a> '
                            + '<a href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + seed + '\');" class="pull-right"> <i class="fa fa-edit fa-1x tip black" data-toggle="tooltip" title="Edit"></i></a> '
                            + '</div></div><div class="row">&nbsp;</div></div>';
                    $('#seeds').append(a);

                }
                tooltip();

            }

        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <div id="header" class="page-header">
                <h1>Please, choose the seed:</h1>
            </div>
            <div id="apikey" class="hide"></div>
            <ol class="breadcrumb">
                <li id="breadHome"><span class="glyphicon glyphicon-home"></span> </li>
                <li class="active">Seeds</li>
            </ol>
            <div id="info"></div>
            <div class=" text-right">
                <div class="btn-group">
                    <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="prepareAdd('Seed', lastPath());">Add Seed <i class="fa fa-plus-circle  icon-white"></i></a>
                </div>
                <div class="row">&nbsp;</div>
                <!-- <div class="btn-group">
                    <a href="../seed/add/" class="btn btn-success">Add Seed <i class="icon-plus icon-white"></i></a>
                </div>-->
            </div>
            <div id="seeds"></div>

        </div>


        <!-- Finally include modals -->
        <%@include file="/setup/modals/add.jsp" %>
        <%@include file="/setup/modals/edit.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
    </s:layout-component>
</s:layout-render>
