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
                var entity = lastPath();

                var qconcept = "SELECT DISTINCT ?seed {" + entity + " coeus:isIncludedIn ?seed }";
                queryToResult(qconcept, fillBreadcumb);

                refresh();

                //header name
                callURL("../../config/getconfig/", fillHeader);

                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);

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
                var qconcept = "SELECT DISTINCT ?concept ?c {" + lastPath() + " coeus:isEntityOf ?concept . ?concept dc:title ?c . }";
                queryToResult(qconcept, fillListOfConcepts);
            }
            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
            }

            function fillBreadcumb(result) {
                var seed = result[0].seed.value;
                seed = "coeus:" + splitURIPrefix(seed).value;
                $('#breadSeed').html('<a href="../seed/' + seed + '">Dashboard</a> <span class="divider">/</span>');
                $('#breadEntities').html('<a href="../entity/' + seed + '">Entities</a> <span class="divider">/</span>');

            }
            function fillListOfConcepts(result) {
                $('#concepts').html("");
                for (var key in result) {
                    var concept = 'coeus:' + splitURIPrefix(result[key].concept.value).value;
                    var a = '<tr><td><a href="../../resource/' + splitURIPrefix(result[key].concept.value).value + '">'
                            + result[key].concept.value + '</a></td><td>'
                            + result[key].c.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn" href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + concept + '\');">Edit <i class="icon-edit"></i></a>'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'' + concept + '\')">Remove <i class="icon-trash"></i></button>'
                            + '</div>'
                            + ' <a href="#addResourceModal" data-toggle="modal" class="btn btn-success" onclick="prepareAddResourceModal(\''+concept+'\');">Resource <i class="icon-plus icon-white"></i></a>'
                            + ' <a class="btn btn-info" href="../resource/' + concept + '">Resources <i class="icon-forward icon-white"></i></a>'

                            + ' <a class="dropdown">'
                            + '<button class="dropdown-toggle btn btn-warning" role="button" data-toggle="dropdown" data-target="#">'
                            + 'Extensions '
                            + '<b class="caret"></b>'
                            + '</button>'
                            + '<ul class="dropdown-menu" role="menu" aria-labelledby="dropdown" id="' + splitURIPrefix(result[key].concept.value).value + '">'
                            //<li><a href="#">Action</a></li>
                            + '</ul>'
                            + '</a>'

                            + '</td></tr>';
                    $('#concepts').append(a);
                }
                //fill Extensions:
                for (var r in result) {
                    var id = splitURIPrefix(result[r].concept.value).value;
                    var ext = 'coeus:' + id;
                    //FILL THE EXTENSIONS
                    var extensions = "SELECT ?resource {" + ext + " coeus:isExtendedBy ?resource }";
                    queryToResult(extensions, fillExtensions.bind(this, id));
                }
            }
            function fillExtensions(id, result) {
                for (var rs in result) {
                    var r = splitURIPrefix(result[rs].resource.value).value;
                    $('#' + id).append('<li><a tabindex="-1" href="../resource/edit/coeus:' + r + '">coeus:' + r + '</a></li>');
                }
                //console.log('fillExtensions:'+ext);console.log(result)
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
                <li id="breadEntities"></li>
                <li class="active">Concepts</li>
            </ul>
            <div class="row-fluid">
                <div class="span6">
                    <h3>List of Concepts</h3>
                </div>
                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="prepareAdd('Concept',lastPath());">Add Concept <i class="icon-plus icon-white"></i></a>
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
            </div>
            </div>
        <!-- Finally include modals -->
        <%@include file="/setup/modals/add.jsp" %>
        <%@include file="/setup/modals/addResource.jsp" %>
        <%@include file="/setup/modals/edit.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
            </s:layout-component>
        </s:layout-render>
