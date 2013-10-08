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
        <script src="<c:url value="/assets/js/coeus.api.js" />"></script>
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
                    if (event.charCode === 13)
                        if (document.getElementById('addModal').style.display === "block" && document.activeElement.getAttribute('id') === "addModal")
                            add();
                    if (document.getElementById('editModal').style.display === "block" && document.activeElement.getAttribute('id') === "editModal")
                        edit();
                };
            });

            var timer;
            var delay = 1000;

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
                            + '<a href="#removeModal" class="pull-right" data-toggle="modal" onclick="selectSeed(\'' + seed + '\');"><i class="icon-remove"></i></a>'
                            + '<a href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + seed + '\');" class="pull-right"><i class="icon-edit"></i> </a>'
                            + '</div></div></li>';
                    $('#seeds').append(a);

                }

            }
            //Edit functions
            function prepareEdit(individual) {
                //reset values
                $('#editResult').html("");
                document.getElementById('editURI').innerHTML = individual;
                $('#editTitle').val("");
                $('#editLabel').val("");
                $('#editComment').val("");

                var q = "SELECT ?label ?title ?comment {" + individual + " dc:title ?title . " + individual + " rdfs:label ?label . " + individual + " rdfs:comment ?comment }";
                queryToResult(q, fillEdit);
            }
            function fillEdit(result) {
                //var resultTitle = json.results.bindings[0].title;
                console.log(result);
                try
                {
                    //PUT VALUES IN THE INPUT FIELD
                    $('#editTitle').val(result[0].title.value);
                    //document.getElementById('title').setAttribute("disabled");
                    $('#editLabel').val(result[0].label.value);
                    $('#editComment').val(result[0].comment.value);
                }
                catch (err)
                {
                    $('#editResult').append(generateHtmlMessage("Error!", "Some fields do not exist." + err, "alert-error"));
                }
                //PUT OLD VALUES IN THE STATIC FIELD
                $('#oldTitle').val($('#editTitle').val());
                $('#oldLabel').val($('#editLabel').val());
                $('#oldComment').val($('#editComment').val());

            }
            function edit() {
                var individual = $('#editURI').html();
                var urlUpdate = "../../api/" + getApiKey() + "/update/";
                var url;
                timer = setTimeout(function() {
                    $('#closeEditModal').click();
                    refresh();
                }, delay);

                if ($('#oldLabel').val() !== $('#editLabel').val()) {
                    url = urlUpdate + individual + "/" + "rdfs:label" + "/xsd:string:" + $('#oldLabel').val() + ",xsd:string:" + $('#editLabel').val();
                    callURL(url, showResult.bind(this, "#editResult", url), (this, "#editResult", url));
                }
                if ($('#oldTitle').val() !== $('#editTitle').val()) {
                    url = urlUpdate + individual + "/" + "dc:title" + "/xsd:string:" + $('#oldTitle').val() + ",xsd:string:" + $('#editTitle').val();
                    callURL(url, showResult.bind(this, "#editResult", url), (this, "#editResult", url));
                }
                if ($('#oldComment').val() !== $('#editComment').val()) {
                    url = urlUpdate + individual + "/" + "rdfs:comment" + "/xsd:string:" + $('#oldComment').val() + ",xsd:string:" + $('#editComment').val();
                    callURL(url, showResult.bind(this, "#editResult", url), (this, "#editResult", url));
                }
            }
            //End of Edit functions
            //Remove functions
            function selectSeed(seed) {
                $('#removeResult').html("");
                $('#removeModalLabel').html(seed);
            }
            function remove() {
                var seed = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + seed);

                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix, seed, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix, seed, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));

                timer = setTimeout(function() {
                    $('#closeRemoveModal').click();
                    refresh();
                }, delay);

            }
            //End of Remove functions
            function changeURI(id, value) {
                document.getElementById(id).innerHTML = 'coeus:seed_' + value.split(' ').join('_');
            }
            function add() {

                var type = 'Seed';
                var individual = $('#uri').html();
                var title = $('#title').val();
                var label = $('#label').val();
                var comment = $('#comment').val();
                var urlWrite = "../../api/" + getApiKey() + "/write/";

                // verify all fields:
                var empty = false;
                if (title === '') {
                    $('#titleForm').addClass('controls control-group error');
                    empty = true;
                } else
                    $('#titleForm').removeClass('controls control-group error');
                if (label === '') {
                    $('#labelForm').addClass('controls control-group error');
                    empty = true;
                } else
                    $('#labelForm').removeClass('controls control-group error');
                if (comment === '') {
                    $('#commentForm').addClass('controls control-group error');
                    empty = true;
                } else
                    $('#commentForm').removeClass('controls control-group error');
                if (!empty) {
                    var array = new Array();
                    var urlIndividual = urlWrite + individual + "/rdf:type/owl:NamedIndividual";
                    var urlType = urlWrite + individual + "/rdf:type/coeus:" + type;
                    var urlTitle = urlWrite + individual + "/dc:title/xsd:string:" + title;
                    var urlLabel = urlWrite + individual + "/rdfs:label/xsd:string:" + label;
                    var urlComment = urlWrite + individual + "/rdfs:comment/xsd:string:" + comment;
                    array.push(urlIndividual, urlType, urlTitle, urlLabel, urlComment);
                    submitIfNotExists(array, individual);
                }
            }
            function submitIfNotExists(array, individual) {
                var qSeeds = "SELECT (COUNT(*) AS ?total) {" + individual + " ?p ?o }";
                queryToResult(qSeeds, function(result) {
                    console.log(result[0].total.value);
                    if (result[0].total.value == 0) {
                        array.forEach(function(url) {
                            callURL(url, showResult.bind(this, "#addResult", url), showError.bind(this, "#addResult", url));
                        });
                        timer = setTimeout(function() {
                            $('#closeAddModal').click();
                            refresh();
                        }, delay);
                    } else {
                        $('#addResult').append(generateHtmlMessage("Warning!", "This individual already exists.", "alert-warning"));
                        refresh();
                    }
                });
            }
            function showResult(id, url, result) {
                if (result.status === 100) {
                    $(id).append(generateHtmlMessage("Success!", url + "</br>" + result.message, "alert-success"));
                }
                else {
                    clearTimeout(timer);
                    $(id).append(generateHtmlMessage("Warning!", url + "</br>Status Code:" + result.status + " " + result.message, "alert-warning"));
                }
            }

            function showError(id, url, jqXHR, result) {
                clearTimeout(timer);
                $(id).append(generateHtmlMessage("Server error!", url + "</br>Status Code:" + result.status + " " + result.message, "alert-error"));
            }

            function cleanAddModal() {
                $('#addResult').html("");
                $('#title').val("");
                $('#label').val("");
                $('#comment').val("");
                document.getElementById('uri').innerHTML = 'coeus:seed_';
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
                    <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="cleanAddModal();">Add Seed <i class="icon-plus icon-white"></i></a>
                </div>
                <!-- <div class="btn-group">
                    <a href="../seed/add/" class="btn btn-success">Add Seed <i class="icon-plus icon-white"></i></a>
                </div>-->
            </div>
            <ul id="seeds" class="thumbnails">

            </ul>

        </div>

        <!-- Modal -->
        <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3 >Remove Seed</h3>
            </div>
            <div class="modal-body">
                <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> seed?</p>
                <p class="text-warning">Warning: All dependents triples are removed too.</p>

                <div id="removeResult"></div>

            </div>

            <div class="modal-footer">
                <button id="btnCloseModal" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button class="btn btn-danger" onclick="remove();">Remove <i class="icon-trash icon-white"></i></button>
            </div>
        </div>

        <!-- add Modal -->
        <div id="addModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button id="closeAddModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3>Add Seed</h3>
            </div>
            <div class="modal-body">
                <div id="addResult"></div>
                <p class="help-block">A Seed defines a single framework instance used to store a container of information. Seed individuals are connected to entities. </p>
                <p class="lead" >Seed URI - <span class="lead text-info" id="uri" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

                <div id="titleForm" >
                    <label class="control-label" for="title">Title</label>
                    <input id="title" type="text" placeholder="Ex: Uniprot" onkeyup="changeURI('uri', this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Seed." ></i>
                </div>
                <div id="labelForm"> 
                    <label class="control-label" for="label">Label</label>
                    <input id="label" type="text" placeholder="Ex: Uniprot Entity"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Seed." ></i>
                </div>
                <div id="commentForm">
                    <label class="control-label" for="comment">Comment</label> 
                    <textarea rows="4" style="max-width: 500px;width: 400px;" id="comment" type="text" placeholder="Ex: Describes the Uniprot Seed..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Seed." ></i>
                </div>

            </div>

            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button class="btn btn-primary" onclick="add();">Save Changes</button>
            </div>
        </div>

        <!-- edit Modal -->
        <div id="editModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button id="closeEditModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3>Edit Seed</h3>
            </div>
            <div class="modal-body">
                <div id="editResult"></div>
                <p class="help-block">A Seed defines a single framework instance used to store a container of information. Seed individuals are connected to entities. </p>
                <p class="lead" >Seed URI - <span class="lead text-info" id="editURI" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

                <div id="editTitleForm" >
                    <label class="control-label" for="title">Title</label>
                    <input id="editTitle" type="text" placeholder="Ex: Uniprot" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Seed." ></i>
                    <input type="hidden" id="oldTitle" value=""/>
                </div>
                <div id="editLabelForm"> 
                    <label class="control-label" for="label">Label</label>
                    <input id="editLabel" type="text" placeholder="Ex: Uniprot Entity"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Seed." ></i>
                    <input type="hidden" id="oldLabel" value=""/>
                </div>
                <div id="editCommentForm">
                    <label class="control-label" for="comment">Comment</label> 
                    <textarea rows="4" style="max-width: 500px;width: 400px;" id="editComment" type="text" placeholder="Ex: Describes the Uniprot Seed..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Seed." ></i>
                    <input type="hidden" id="oldComment" value=""/>
                </div>

            </div>

            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button class="btn btn-primary" onclick="edit();">Save Changes</button>
            </div>
        </div>


    </s:layout-component>
</s:layout-render>
