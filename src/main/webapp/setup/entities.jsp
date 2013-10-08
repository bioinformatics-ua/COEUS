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
                //header name
                var path = lastPath();
                $('#breadSeed').html('<a href="../seed/' + path + '">Dashboard</a> <span class="divider">/</span>');

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
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + result[key].e.value + '\')">Remove <i class="icon-trash"></i></button>'
                            + '</div>'
                            + ' <a class="btn btn-info" href="../concept/coeus:' + splitURIPrefix(result[key].entity.value).value + '">Show Concepts <i class="icon-forward icon-white"></i></a>'
                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                            + '</td></tr>';
                    $('#entities').append(a);
                }
            }

            function selectEntity(entity) {
                $('#removeResult').html("");
                $('#removeModalLabel').html('coeus:entity_' + entity.split(' ').join('_'));
            }
            function removeEntity() {
                var entity = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + entity);

                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix, entity);
                //remove all predicates and objects associated.
                removeAllTriplesFromSubject(urlPrefix, entity);

            }

            // Callback to generate the pages header
            function fillHeader(result) {
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);
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
                    $('#editResult').append(generateHtmlMessage("Error!", "Some fields do not exist."+err, "alert-error"));
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
            function remove() {
                var entity = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + entity);

                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix, entity, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix, entity, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));

                timer = setTimeout(function() {
                    $('#closeRemoveModal').click();
                    refresh();
                }, delay);

            }
            //End of Remove functions
            function changeURI(id, value) {
                document.getElementById(id).innerHTML = 'coeus:entity_' + value.split(' ').join('_');
            }
            function add() {

                var type = 'Entity';
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
                    var urlIsIncludedIn = urlWrite + individual + "/coeus:isIncludedIn/" + lastPath();
                    var urlIncludes = urlWrite + lastPath() + "/coeus:includes/" + individual;
                    array.push(urlIndividual, urlType, urlTitle, urlLabel, urlComment, urlIsIncludedIn, urlIncludes);
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
                document.getElementById('uri').innerHTML = 'coeus:entity_';
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
                        <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="cleanAddModal();">Add Entity <i class="icon-plus icon-white"></i></a>
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

                <!-- Modal -->
                <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Remove Entity</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> entity?</p>
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
                        <h3>Add Entity</h3>
                    </div>
                    <div class="modal-body">
                        <div id="addResult"></div>
                        <p class="help-block">Entity individuals match the general data terms. These elements grouping concepts with a common set of properties. </p>
                        <p class="lead" >Entity URI - <span class="lead text-info" id="uri" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

                        <div id="titleForm" >
                            <label class="control-label" for="title">Title</label>
                            <input id="title" type="text" placeholder="Ex: Uniprot" onkeyup="changeURI('uri', this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Entity." ></i>
                        </div>
                        <div id="labelForm">
                            <label class="control-label" for="label">Label</label>
                            <input id="label" type="text" placeholder="Ex: Uniprot Entity"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Entity." ></i>
                        </div>
                        <div id="commentForm">
                            <label class="control-label" for="comment">Comment</label>
                            <textarea rows="4" style="max-width: 500px;width: 400px;" id="comment" type="text" placeholder="Ex: Describes the Uniprot Entity..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Entity." ></i>
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
                        <h3>Edit Entity</h3>
                    </div>
                    <div class="modal-body">
                        <div id="editResult"></div>
                        <p class="help-block">Entity individuals match the general data terms. These elements grouping concepts with a common set of properties. </p>
                        <p class="lead" >Entity URI - <span class="lead text-info" id="editURI" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

                        <div id="editTitleForm" >
                            <label class="control-label" for="title">Title</label>
                            <input id="editTitle" type="text" placeholder="Ex: Uniprot" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Entity." ></i>
                            <input type="hidden" id="oldTitle" value=""/>
                        </div>
                        <div id="editLabelForm">
                            <label class="control-label" for="label">Label</label>
                            <input id="editLabel" type="text" placeholder="Ex: Uniprot Entity"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Entity." ></i>
                            <input type="hidden" id="oldLabel" value=""/>
                        </div>
                        <div id="editCommentForm">
                            <label class="control-label" for="comment">Comment</label>
                            <textarea rows="4" style="max-width: 500px;width: 400px;" id="editComment" type="text" placeholder="Ex: Describes the Uniprot Entity..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Seed." ></i>
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
