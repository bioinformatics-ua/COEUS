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

            });
            
            var timer;
            var delay = 1000;
            
            function refresh(){
                var qconcept = "SELECT DISTINCT ?concept ?c {" + lastPath() + " coeus:isEntityOf ?concept . ?concept dc:title ?c . }";
                queryToResult(qconcept, fillListOfConcepts);
            }
            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1>' + lastPath() + '<small id="env"> ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);  
            }
            function selectConcept(concept) {
                $('#removeResult').html("");
                $('#removeModalLabel').html('coeus:concept_' + concept.split(' ').join('_'));
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
                    var concept='coeus:'+splitURIPrefix(result[key].concept.value).value;
                    var a = '<tr><td><a href="../../resource/' + splitURIPrefix(result[key].concept.value).value + '">'
                            + result[key].concept.value + '</a></td><td>'
                            + result[key].c.value + '</td><td>'
                            + '<div class="btn-group">'
                            + '<a class="btn btn" href="#editModal" data-toggle="modal" onclick="prepareEdit(\'' + concept + '\');">Edit <i class="icon-edit"></i></a>'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectConcept(\'' + result[key].c.value + '\')">Remove <i class="icon-trash"></i></button>'
                            + '</div>'
                            + ' <a class="btn btn-info" href="../resource/' + concept + '">Show Resources <i class="icon-forward icon-white"></i></a>'
                            
                            +' <a class="dropdown">'
                            +'<button class="dropdown-toggle btn btn-warning" role="button" data-toggle="dropdown" data-target="#">'
                            +'Extensions '
                            +'<b class="caret"></b>'
                            +'</button>'
                            +'<ul class="dropdown-menu" role="menu" aria-labelledby="dropdown" id="'+splitURIPrefix(result[key].concept.value).value+'">'
                                //<li><a href="#">Action</a></li>
                            +'</ul>'
                            +'</a>'
                            
                            + '</td></tr>';
                    $('#concepts').append(a);
                }
                //fill Extensions:
                for(var r in result){
                    var id=splitURIPrefix(result[r].concept.value).value;
                    var ext='coeus:'+id;
                    //FILL THE EXTENSIONS
                    var extensions="SELECT ?resource {"+ext+" coeus:isExtendedBy ?resource }";
                    queryToResult(extensions,fillExtensions.bind(this,id));
                }
            }
            function fillExtensions(id,result){
                for(var rs in result){
                   var r=splitURIPrefix(result[rs].resource.value).value;
                   $('#'+id).append('<li><a tabindex="-1" href="../resource/edit/coeus:'+r+'">coeus:'+r+'</a></li>');
                }
                //console.log('fillExtensions:'+ext);console.log(result)
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
                var concept = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + concept);

                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix, concept, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix, concept, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));

                timer = setTimeout(function() {
                    $('#closeRemoveModal').click();
                    refresh();
                }, delay);

            }
            //End of Remove functions
            function changeURI(id, value) {
                document.getElementById(id).innerHTML = 'coeus:concept_' + value.split(' ').join('_');
            }
            function add() {

                var type = 'Concept';
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
                    var urlHasEntity = urlWrite + individual + "/coeus:hasEntity/" + lastPath();
                    var urlIsEntityOf = urlWrite + lastPath() + "/coeus:isEntityOf/" + individual;
                    array.push(urlIndividual, urlType, urlTitle, urlLabel, urlComment, urlHasEntity, urlIsEntityOf);
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
                document.getElementById('uri').innerHTML = 'coeus:concept_';
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
                        <a href="#addModal" data-toggle="modal" class="btn btn-success" onclick="cleanAddModal();">Add Concept <i class="icon-plus icon-white"></i></a>
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

                <!-- Modal -->
                <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Remove Concept</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> concept?</p>
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
                        <h3>Add Concept</h3>
                    </div>
                    <div class="modal-body">
                        <div id="addResult"></div>
                        <p class="help-block">Concept individuals are area-specific terms, aggregating any number of items and belonging to a unique entity. </p>
                        <p class="lead" >Concept URI - <span class="lead text-info" id="uri" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

                        <div id="titleForm" >
                            <label class="control-label" for="title">Title</label>
                            <input id="title" type="text" placeholder="Ex: HGNC" onkeyup="changeURI('uri', this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Concept." ></i>
                        </div>
                        <div id="labelForm">
                            <label class="control-label" for="label">Label</label>
                            <input id="label" type="text" placeholder="Ex: HGNC Concept"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Concept." ></i>
                        </div>
                        <div id="commentForm">
                            <label class="control-label" for="comment">Comment</label>
                            <textarea rows="4" style="max-width: 500px;width: 400px;" id="comment" type="text" placeholder="Ex: Describes the HGNC Concept..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Concept." ></i>
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
                        <h3>Edit Concept</h3>
                    </div>
                    <div class="modal-body">
                        <div id="editResult"></div>
                        <p class="help-block">Concept individuals are area-specific terms, aggregating any number of items and belonging to a unique entity. </p>
                        <p class="lead" >Concept URI - <span class="lead text-info" id="editURI" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

                        <div id="editTitleForm" >
                            <label class="control-label" for="title">Title</label>
                            <input id="editTitle" type="text" placeholder="Ex: Concept" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Concept." ></i>
                            <input type="hidden" id="oldTitle" value=""/>
                        </div>
                        <div id="editLabelForm">
                            <label class="control-label" for="label">Label</label>
                            <input id="editLabel" type="text" placeholder="Ex: Uniprot Concept"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Concept." ></i>
                            <input type="hidden" id="oldLabel" value=""/>
                        </div>
                        <div id="editCommentForm">
                            <label class="control-label" for="comment">Comment</label>
                            <textarea rows="4" style="max-width: 500px;width: 400px;" id="editComment" type="text" placeholder="Ex: Describes the Uniprot Concept..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Seed." ></i>
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
