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
                //refresh();
                //header name
                var path = lastPath();
                $('#breadSeed').html('<a href="../seed/' + path + '">Dashboard</a>');

                $('#concepts').on("change", function() {
                    console.log(this.value);

                });
                concepts_relations();


            });


            function concepts_relations() {
                var qconcept = "SELECT ?concept_root ?concept_child { ?resource coeus:isResourceOf ?concept_child . ?resource coeus:extends ?concept_root . ?concept_root coeus:hasEntity ?entity . ?entity coeus:isIncludedIn " + lastPath() + " . ?concept_child coeus:hasEntity ?entity2 . ?entity2 coeus:isIncludedIn " + lastPath() + " . FILTER (?concept_root != ?concept_child)}";
                queryToResult(qconcept, concepts_all);
            }

            function concepts_all(relations) {
                var qconcept = "SELECT DISTINCT ?concept { ?concept a coeus:Concept . ?concept coeus:hasEntity ?entity . ?entity coeus:isIncludedIn " + lastPath() + "}";
                queryToResult(qconcept, fillTree.bind(this, relations));
            }

            function fillTree(relations, result) {
                //console.log(relations);
                //console.log(result);
                var html_tree = $('#tree');
                html_tree.html("");

                //Simplify the result 
                var concept_relations = {};
                for (var key in relations) {
                    var concept_root = splitURIPrefix(relations[key].concept_root.value).value;
                    var concept_child = splitURIPrefix(relations[key].concept_child.value).value;
                    concept_relations[key] = {root: concept_root, child: concept_child};
                }
                console.log(concept_relations);
                //Simplify the relations
                var concept_all = {};
                for (var key in result) {
                    var concept = splitURIPrefix(result[key].concept.value).value;
                    concept_all[key] = {concept: concept};
                }
                console.log(concept_all);
                //get concepts root
                var roots = new Array();
                for (var a in concept_all) {
                    var b = true;
                    for (var r in concept_relations) {
                        if (concept_all[a].concept === concept_relations[r].child)
                            b = false;
                    }
                    if (b)
                        roots.push(concept_all[a]);
                }
                console.log(roots);
                //Put the roots in the tree
                for (var r in roots) {
                    html_tree.append('<p></p><li><i class="fa fa-minus-circle tree-toggle"></i> <a class="btn btn-default btn-tree">' + roots[r].concept + '</a> <ul class="fa-ul list" id="' + roots[r].concept + '"></ul></li>');
                    fillAllChilds(concept_relations, roots[r].concept);
                }

                $('.tree-toggle').click(function() {
                    //console.log();
                    var isExpanded = contains(this.className, "fa-minus-circle");
                    if (isExpanded)
                        $(this).removeClass("fa-minus-circle").addClass("fa-plus-circle");
                    else
                        $(this).removeClass("fa-plus-circle").addClass("fa-minus-circle");
                    $(this).parent().children('ul.list').toggle(200);
                });
                $('.btn-tree').click(function() {
                    $('.btn-tree').removeClass("btn-info").addClass("btn-default");
                    $(this).addClass("btn-info");
                    var root = $(this).html();
                    console.log(root);

                    $("input:checkbox[name=child_box]").each(function()
                    {
                        this.checked = false;
                        $(this).removeClass("hide");
                    });
                    $("input:checkbox[value=" + root + "]").each(function()
                    {
                        $(this).addClass("hide");
                        console.log($(this));

                    });

                });
                tooltip();


            }

            function fillAllChilds(concept_relations, root) {
                for (var rel in concept_relations) {
                    if (concept_relations[rel].root === root) {
                        //$('#' + root).append('<p><li><input type="checkbox" name="child_box" value="' + concept_relations[rel].child + '"> <label class="btn btn-default tree-toggle"><i class="fa fa-minus-circle"></i> ' + concept_relations[rel].child + ' </label> <ul class="fa-ul list" id="' + concept_relations[rel].child + '"></ul></li></p>');
                        $('#' + root).append('<p><li><i class="fa fa-minus-circle tree-toggle"></i> <a class="btn btn-default btn-tree">' + concept_relations[rel].child + '</a> <input title="Include Data Items?" class="tip" type="checkbox" name="child_box" value="' + concept_relations[rel].child + '" ><ul class="fa-ul list" id="' + concept_relations[rel].child + '"></ul></li></p>');
                        fillAllChilds(concept_relations, concept_relations[rel].child);
                    }
                }
            }

            function refresh() {
                var qconcept = "SELECT DISTINCT ?concept ?c ?label ?entity ?builtNp{" + lastPath() + " coeus:includes ?entity . ?entity coeus:isEntityOf ?concept . ?concept dc:title ?c . ?concept rdfs:label ?label . OPTIONAL{ ?concept coeus:builtNp ?builtNp}}";
                queryToResult(qconcept, fillListOfConcepts);
            }

            function fillListOfConcepts(result) {
                $('#concepts').html("");
                for (var key in result) {
                    var concept = 'coeus:' + splitURIPrefix(result[key].concept.value).value;
                    var a = '<option>' + concept + '</option>';
                    $('#concepts').append(a);
                }
                //fill Extensions:
//                for (var r in result) {
//                    var id = splitURIPrefix(result[r].concept.value).value;
//                    var ext = 'coeus:' + id;
//                    //FILL THE EXTENSIONS
//                    var extensions = "SELECT ?resource {" + ext + " coeus:isExtendedBy ?resource }";
//                    queryToResult(extensions, fillExtensions.bind(this, id));
//                }
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
                var selected_root = document.querySelector('a.btn-tree.btn-info');
                $("#nanopubResult").html("");
                if (selected_root !== null) {
                    selected_root = $(selected_root).html();
                    //console.log(selected_root.value);
                    var order = {root: selected_root, childs: []};
                    var i = 0;
                    $("input:checkbox[name=child_box]:checked").each(function()
                    {
                        order["childs"][i] = $(this).val();
                        i++;
//                        var path=new Array();
//                        path.push(selected_root.value); 
//                        var p = $(this).parent('li').parent('ul');
//                        while (p.length !== 0 && p[0].id!==selected_root.value) {
//                            path.push(p[0].id);
//                            var p = p.parent('li').parent('ul');
//                        }
//                        path.push($(this).val()); 

                        //order["childs"]=$(this).val();
                        //order.push(path);

                    });
                    var send = JSON.stringify(order);
                    console.log(send);
                    //callURL("../../config/nanopub/" + send, nanopubResult, nanopubResult);
                    //$('#' + selected_root.value);

                } else {
                    $("#nanopubResult").append(generateHtmlMessage("EMPTY:", "No concepts selected to process.", "alert-warning"));
                }
//                var toGenerate = new Array();
//                var table = document.getElementById("concepts");
//                for (var z = 0; z < table.rows.length; z++) {
//                    var checkbox = document.getElementById("check" + table.rows.item(z).id);
//                    var splitedConcept = checkbox.id.split("_");
//                    var c = splitedConcept[splitedConcept.length - 2] + "_" + splitedConcept[splitedConcept.length - 1];
//                    if (checkbox.checked)
//                        toGenerate.push(c);
//                }
//                var conceptsToNanopub = $("#conceptsToNanopub");
//                conceptsToNanopub.html("");
//                if (toGenerate.length === 0)
//                    $("#nanopubResult").append(generateHtmlMessage("EMPTY:", "No concepts selected to process.", "alert-warning"));
//                for (var i in toGenerate) {
//                    console.log(toGenerate[i]);
//                    conceptsToNanopub.append("<li>" + toGenerate[i] + "</li>");
//                    callURL("../../config/nanopub/coeus:" + toGenerate[i], nanopubResult, nanopubResult);
//                }
            }

            function nanopubResult(result) {
                var htmlMessage;
                if (result.status === 100) {
                    htmlMessage = generateHtmlMessage("STARTED:", result.message, "alert-success");
                    console.log(result.message);
                } else {
                    htmlMessage = generateHtmlMessage("FAIL:", result.message, "alert-danger");
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
                    <h3>Nanopub Creator:</h3>
                </div>
                <div class="col-md-6 text-right">
                    <div class="btn-group"> <a href="#nanopubModal" data-toggle="modal" data-toggle="tooltip" class="btn btn-success tip" title="Create Nanopublications from the Concept data Items" onclick="generate();">Create Nanopublications <i class="fa fa-cogs icon-white"></i></a>
                    </div>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Concept Relations Tree</h3>
                </div>
                <div class="panel-body">
                    <ul class="fa-ul list" id="tree"></ul>
                </div>

            </div>
            <!--<table class="table table-hover">

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
            </table>-->

            <!--<select class="form-control" id="concepts"></select>-->



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
