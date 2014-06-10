<%--
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script src="<c:url value="/assets/js/typeahead.js" />"></script>
        <script type="text/javascript">
            $(document).on('click', '.btn-add', function(event) {
                event.preventDefault();

                var field = $(this).closest('.form-group');
                var field_new = field.clone();

                $(this)
                        .toggleClass('btn-default')
                        .toggleClass('btn-add')
                        .toggleClass('btn-danger')
                        .toggleClass('btn-remove')
                        .html('<i class="fa fa-minus-circle"></i>');

                field_new.find('input').val('');
                field_new.insertAfter(field);

                init_typeahead();
                tooltip();

            });

            $(document).on('click', '.btn-remove', function(event) {
                event.preventDefault();
                $(this).closest('.form-group').remove();
            });


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

                init_typeahead();

            });

            function init_typeahead() {
                $('.twitter_typeahead').typeahead({
                    name: 'properties',
                    prefetch: '../../config/properties/',
                    remote: '../../config/properties/%QUERY',
                    limit: 15
                });
            }


            function concepts_relations() {
                var qconcept = "SELECT ?concept_root ?concept_child { ?resource coeus:isResourceOf ?concept_child . ?resource coeus:extends ?concept_root . "
                        + "?concept_root coeus:hasEntity ?entity . ?entity coeus:isIncludedIn " + lastPath() + " . ?concept_child coeus:hasEntity ?entity2 . ?entity2 coeus:isIncludedIn " + lastPath() + " . "
                        + "FILTER (?concept_root != ?concept_child)}";
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

                //Simplify the relations 
                var concept_relations = {};
                for (var key in relations) {
                    var concept_root = splitURIPrefix(relations[key].concept_root.value).value;
                    var concept_child = splitURIPrefix(relations[key].concept_child.value).value;
                    concept_relations[key] = {root: concept_root, child: concept_child};
                }
                console.log(concept_relations);
                //Simplify the result
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
                    html_tree.append('<p></p><li>'
                            + '<i class="fa fa-minus-circle tree-toggle"></i> '
                            + '<a class="btn btn-default btn-tree">' + roots[r].concept + '</a> '
                            + '<span id="items_' + roots[r].concept + '" class="badge tip" title="Data Items"></span> '
                            + '<input title="Include Data Items?" class="tip hide" type="checkbox" name="child_box" value="' + roots[r].concept + '" > '
                            + '<ul class="fa-ul list" id="' + roots[r].concept + '"></ul>'
                            + '</li>');
                    fillAllChilds(concept_relations, roots[r].concept);
                }

                $('.tree-toggle').click(function() {
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

                    $("input:checkbox[name=child_box]").each(function()
                    {
                        this.checked = false;
                        $(this).addClass("hide");
                    });
                    $("input:checkbox[value=" + root + "]").each(function()
                    {
                        $(this).parent("li");
                        $(this).parent("li").children("ul").find("input:checkbox").each(function() {
                            $(this).removeClass("hide");
                        });

                    });

                });
                tooltip();
                for (var r in concept_all) {
                    var qcount = "SELECT (COUNT( * ) AS ?total) { coeus:" + concept_all[r].concept + " coeus:isConceptOf ?item}";
                    queryToResult(qcount, fillItems.bind(this, concept_all[r].concept));
                }
            }

            function fillItems(concept, result) {
                $("#items_" + concept).html(result[0].total.value);
            }

            function fillAllChilds(concept_relations, root) {
                for (var rel in concept_relations) {
                    if (concept_relations[rel].root === root) {
                        $('#' + root).append('<p><li>'
                                + '<i class="fa fa-minus-circle tree-toggle"></i> '
                                + '<a class="btn btn-default btn-tree">' + concept_relations[rel].child + '</a> '
                                + '<span id="items_' + concept_relations[rel].child + '" class="tip badge" title="Data Items"></span> <span> </span>'
                                + '<input title="Include Data Items?" class="tip hide" type="checkbox" name="child_box" value="' + concept_relations[rel].child + '" > '
                                + '<ul class="fa-ul list" id="' + concept_relations[rel].child + '"></ul>'
                                + '</li></p>');
                        fillAllChilds(concept_relations, concept_relations[rel].child);
                    }
                }
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
                    var order = {root: selected_root, childs: [], info: [], prov: []};
                    var i = 0;
                    $("input:checkbox[name=child_box]:checked").each(function()
                    {
                        order["childs"][i] = $(this).val();
                        i++;
                    });
                    //Publication Info
                    var c = 0;
                    var information = [];
                    $("#information").children().each(function() {
                        var p = $(this).find("input[name=predicate]").val();
                        var o = $(this).find("input[name=object]").val();
                        var aux = {predicate: p, object: o};
                        if (p !== "" && o !== "")
                            information[c] = aux;
                        c++;
                    });
                    //information.pop();
                    order["info"] = information;
                    ///Provenace
                    var c = 0;
                    var provenance = [];
                    $("#provenance").children().each(function() {
                        var p = $(this).find("input[name=predicate]").val();
                        var o = $(this).find("input[name=object]").val();
                        var aux = {predicate: p, object: o};
                        if (p !== "" && o !== "")
                            provenance[c] = aux;
                        c++;
                    });
                    //information.pop();
                    order["prov"] = provenance;

                    var send = JSON.stringify(order);
                    console.log(send);
                    callURL("../../config/nanopub/" + send, nanopubResult.bind(this, selected_root), nanopubResult.bind(this, selected_root));

                } else {
                    $("#nanopubResult").append(generateHtmlMessage("EMPTY:", "No concepts selected to process.", "alert-warning"));
                }
            }

            function nanopubResult(root, result) {
                var htmlMessage;
                if (result.status === 100) {
                    htmlMessage = generateHtmlMessage("STARTED:", result.message, "alert-success");
                    console.log(result.message);
                    runParser(root);
                } else {
                    htmlMessage = generateHtmlMessage("FAIL:", result.message, "alert-danger");
                    console.log(result.message);
                }
                $("#nanopubResult").append(htmlMessage);
            }

            var interval;
            function runParser(root) {
                interval = setInterval(checkParser.bind(this, root), 2000);
            }

            function checkParser(root) {
                console.log('checkParser of '+root);
                var q = "SELECT ?built { coeus:" + root + " coeus:builtNp ?built }";
                queryToResult(q, checkParserResult.bind(this, root));
            }

            function checkParserResult(root, result) {
                var built = false;
                try {
                    built = result[0].built.value;
                    if (built === true || built === 'true') {
                        //console.log("clear timer");
                        clearInterval(interval);
                        $('#nanopubResult').append(generateHtmlMessage("FINISH!", "Parsed: " + root+' - <a target="_blank" href="../../resource/' + root+'" >View Nanopubs</a>', "alert-success"));
                        
                    }
                } catch (e) {
                    //ignore
                }
                //console.log(built);
                //tooltip();
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
                    <h3>Nanopub Creator</h3>
                </div>
               
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Concept Relations Tree</h3>
                </div>
                <div class="panel-body">
                    <h4><i class="fa fa-chevron-right"></i> Click on the concept root:</h4>
                    <ul class="fa-ul list" id="tree"></ul>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Publication Info (Optional)</h3>
                </div>
                <div class="panel-body">
                    <h4><i class="fa fa-chevron-right"></i> Add more info about the nanopub:</h4>
                    <div id="information">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-4 input-group"><input type="text" name="predicate" class="twitter_typeahead form-control tip" title="Predicate" data-toggle="tooltip"></div>
                                <div class="col-md-4"><input type="text" name="object" class="form-control tip" title="Object"></div>
                                <div class="col-md-4"><button type="button" class="btn btn-default btn-add"><i class="fa fa-plus"></i></button></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Provenance (Optional)</h3>
                </div>
                <div class="panel-body">
                    <h4><i class="fa fa-chevron-right"></i> Add more provenance info about the nanopub:</h4>
                    <div id="provenance">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-4 input-group"><input type="text" name="predicate" class="twitter_typeahead form-control tip" title="Predicate" data-toggle="tooltip"></div>
                                <div class="col-md-4"><input type="text" name="object" class="form-control tip" title="Object"></div>
                                <div class="col-md-4"><button type="button" class="btn btn-default btn-add"><i class="fa fa-plus"></i></button></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             <div class="text-right">
                    <div class="btn-group"> 
                        <a href="#nanopubModal" data-toggle="modal" data-toggle="tooltip" class="btn btn-success tip" 
                           title="Create Nanopublications from the Concept data Items" onclick="generate();">
                            Build Nanopublications <i class="fa fa-cogs icon-white"></i>
                        </a>
                    </div>
                </div>

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
