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
                var entity = lastPath();

                var qconcept = "SELECT DISTINCT ?seed {" + entity + " coeus:isIncludedIn ?seed }";
                queryToResult(qconcept, fillBreadcumb);

                refresh();

                //header name
                callURL("../../config/getconfig/", fillHeader);

                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);

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
                var qconcept = "SELECT DISTINCT ?concept ?c ?label{" + lastPath() + " coeus:isEntityOf ?concept . ?concept dc:title ?c . ?concept rdfs:label ?label}";
                queryToResult(qconcept, fillListOfConcepts);
            }
            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1><span class="tip" data-toggle="tooltip" title="Entity URI">' + lastPath() + '</span><small id="env" class="pull-right tip" data-toggle="tooltip" title="Selected environment">  ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
            }

            function fillBreadcumb(result) {
                var seed = result[0].seed.value;
                seed = "coeus:" + splitURIPrefix(seed).value;
                $('#breadSeed').html('<a href="../seed/' + seed + '">Dashboard</a>');
                $('#breadEntities').html('<a href="../entity/' + seed + '">Entities</a>');

            }
            function fillListOfConcepts(result) {
                $('#concepts').html("");
                for (var key in result) {
                    var concept = 'coeus:' + splitURIPrefix(result[key].concept.value).value;
                    var a = '<tr><td><a class="tip" data-toggle="tooltip" title="View in browser" target="_blank" href="../../resource/' + splitURIPrefix(result[key].concept.value).value + '">'
                            + splitURIPrefix(result[key].concept.value).value + '</a></td><td>'
                            + result[key].c.value + '</td><td>'
                     + result[key].label.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn-default" href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + concept + '\');">Edit <i class="fa fa-edit"></i></a>'
                            + '<button class="btn btn-default" href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'' + concept + '\')">Remove <i class="fa fa-trash-o"></i></button>'
                            + '</div>'
                            + ' <a href="#addResourceModal" data-toggle="modal" class="btn btn-success tip" data-toggle="tooltip" title="Add Resource to this Concept" onclick="prepareAddResourceModal(\''+concept+'\');">Resource <i class="fa fa-plus-circle"></i></a>'
                            + ' <a class="btn btn-info tip" data-toggle="tooltip" title="Show all Resources of this Concept" href="../resource/' + concept + '">Show Resources <i class="fa fa-forward"></i></a>'

                            + ' <a class="dropdown tip" data-toggle="tooltip" title="Show all Extensios of this Concept">'
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
                tooltip();
            }
            function fillExtensions(id, result) {
                for (var rs in result) {
                    var r = splitURIPrefix(result[rs].resource.value).value;
                    $('#' + id).append('<li><a tabindex="-1" href="../selector/coeus:' + r + '">coeus:' + r + '</a></li>');
                }
                //console.log('fillExtensions:'+ext);console.log(result)
            }

        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <div id="header" class="page-header"></div>
            <div id="apikey" class="hide"></div>
            <ul class="breadcrumb">
                <li id="breadHome"><i class="glyphicon glyphicon-home"></i> </li>
                <li id="breadSeeds"><a href="../seed/">Seeds</a></li>
                <li id="breadSeed"></li>
                <li id="breadEntities"></li>
                <li class="active">Concepts</li>
            </ul>
            <div class="row">
                <div class="col-md-6">
                    <h3>List of Concepts</h3>
                </div>
                <div class="col-md-6 text-right" >
                    <div class="btn-group">
                        <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="prepareAdd('Concept',lastPath());">Add Concept <i class="fa fa-plus-circle icon-white"></i></a>
                    </div>
                </div>
            </div>

                <table class="table table-hover">

                    <thead>
                        <tr>
                            <th>Concept</th>
                            <th>Title</th>
                            <th>Label</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="concepts">

                    </tbody>
                </table>
            
            </div>
        <!-- Finally include modals -->
        <%@include file="/setup/modals/add.jsp" %>
        <%@include file="/setup/modals/addResource.jsp" %>
        <%@include file="/setup/modals/edit.jsp" %>
        <%@include file="/setup/modals/remove.jsp" %>
            </s:layout-component>
        </s:layout-render>
