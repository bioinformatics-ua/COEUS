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

            });


            function refresh() {
                var qconcept = "SELECT DISTINCT ?concept ?c ?label ?entity ?builtNp{" + lastPath() + " coeus:includes ?entity . ?entity coeus:isEntityOf ?concept . ?concept dc:title ?c . ?concept rdfs:label ?label . OPTIONAL{ ?concept coeus:builtNp ?builtNp}}";
                queryToResult(qconcept, fillListOfConcepts);
            }

            function fillListOfConcepts(result) {
                $('#concepts').html("");
                for (var key in result) {
                    var concept = 'coeus:' + splitURIPrefix(result[key].concept.value).value;
                    var a = '<tr id="box_' + splitURIPrefix(result[key].concept.value).value + '"><td><input type="checkbox" id="checkbox_' + splitURIPrefix(result[key].concept.value).value + '"> <a class="tip" data-toggle="tooltip" title="View in browser" target="_blank" href="../../resource/' + splitURIPrefix(result[key].concept.value).value + '">'
                            + splitURIPrefix(result[key].concept.value).value + '</a></td><td>'
                            + result[key].c.value + '</td><td>'
                            + result[key].label.value + '</td><td><a class="tip" data-toggle="tooltip" title="View in browser" target="_blank" href="../../resource/' + splitURIPrefix(result[key].entity.value).value + '">'
                            + splitURIPrefix(result[key].entity.value).value + '</td><td>'
                            // + '<div class="btn-group">'
                            // + '<a class="btn btn-default" href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + concept + '\');">Edit <i class="fa fa-edit"></i></a>'
                            // + '<button class="btn btn-default" href="#removeModal" role="button" data-toggle="modal" onclick="selectToRemove(\'' + concept + '\')">Remove <i class="fa fa-trash-o"></i></button>'
                            // + '</div>'
                            //+ ' <a href="#addResourceModal" data-toggle="modal" class="btn btn-success tip" data-toggle="tooltip" title="Add Resource to this Concept" onclick="prepareAddResourceModal(\'' + concept + '\');">Resource <i class="fa fa-plus-circle"></i></a>'
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



            // Callback to generate the pages header
            function fillHeader(result) {
                $('#header').html('<h1><span class="tip" data-toggle="tooltip" title="Seed URI">' + lastPath() + '</span><small id="env" class="pull-right tip" data-toggle="tooltip" title="Selected environment"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);
            }

            function generate() {
                var toGenerate = new Array();
                var table = document.getElementById("concepts");
                for (var z = 0; z < table.rows.length; z++) {
                    var checkbox = document.getElementById("check" + table.rows.item(z).id);
                    var splitedConcept = checkbox.id.split("_");
                    var c = splitedConcept[splitedConcept.length - 2] + "_" + splitedConcept[splitedConcept.length - 1];
                    if (checkbox.checked)
                        toGenerate.push(c);
                }
                var conceptsToNanopub = $("#conceptsToNanopub");
                conceptsToNanopub.html("");
                if(toGenerate.length===0) $("#nanopubResult").append(generateHtmlMessage("EMPTY:", "No concepts selected to process.","alert-warning"));
                for (var i in toGenerate) {
                    console.log(toGenerate[i]);
                    conceptsToNanopub.append("<li>" + toGenerate[i] + "</li>");
                    callURL("../../config/nanopub/coeus:"+toGenerate[i], nanopubResult, nanopubResult);
                }
            }

            function nanopubResult(result) {
                var htmlMessage;
                if (result.status === 100) {
                    htmlMessage=generateHtmlMessage("STARTED:", result.message,"alert-success");
                    console.log(result.message);
                } else {
                    htmlMessage=generateHtmlMessage("FAIL:", result.message,"alert-danger");
                    console.log(result.message);
                }
                $("#nanopubResult").append(htmlMessage);
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
                <li class="active">Nanopublications</li>
            </ul>
            <div class="row">
                <div class="col-md-6">
                    <h3>Select the Concepts:</h3>
                </div>
                <div class="col-md-6 text-right">
                    <div class="btn-group"> <a href="#nanopubModal" data-toggle="modal" class="btn btn-success" onclick="generate();">Create Nanopublications <i class="fa fa-cogs icon-white"></i></a>
                    </div>
                </div>
            </div>
            <table class="table table-hover">

                <thead>
                    <tr>
                        <th>Concept</th>
                        <th>Title</th>
                        <th>Label</th>
                        <th>Entity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="concepts">

                </tbody>
            </table>

        </div>

        <!-- Add Existing Selector Modal -->
        <div id="nanopubModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 class="modal-title">Generate Nanopublications</h3>
                    </div>

                    <div class="modal-body">
                        <p>Output:</p>
                        <!--<ul id="conceptsToNanopub"></ul>-->
                        <div id="nanopubResult"></div>
                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
                        <!--<button class="btn btn-info" onclick="window.location.reload();">Done</button>-->
                    </div>
                </div>
            </div>
        </div>
    </s:layout-component>
</s:layout-render>
