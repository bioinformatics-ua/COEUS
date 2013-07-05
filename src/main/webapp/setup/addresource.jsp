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
            function fillConceptsExtension(result){
                for(var r in result){
                    var concept=splitURIPrefix(result[r].concept.value);
                    $('#extends').append('<option>'+concept.value+'</option>');
                }
            }
            $(document).ready(function() {

                //header name
                var path = lastPath();
                $('#header').html('<h1>' + path + '<small> env.. </small></h1>');
                
                //fill the concepts extensions
                var q="SELECT ?concept ?c {?concept a coeus:Concept . ?concept dc:title ?c}";
                queryToResult(q,fillConceptsExtension);

                //if the type mode is EDIT
                if (penulPath() === 'edit') {
                    $('#type').html("Edit Resource");
                    $('#submit').html('Edit <i class="icon-edit icon-white"></i>');

                    var query = initSparqlerQuery();
                    var q = "SELECT ?title ?label ?comment ?method ?publisher ?endpoint ?query ?order ?extends {" + path + " dc:title ?title . " + path + " rdfs:label ?label . " + path + " rdfs:comment ?comment . " + path + " coeus:method ?method . " + path + " dc:publisher ?publisher . " + path + " coeus:endpoint ?endpoint . " + path + " coeus:query ?query . " + path + " coeus:order ?order . " + path + " coeus:extends ?extends . }";
                    query.query(q,
                            {success: function(json) {
                                    //var resultTitle = json.results.bindings[0].title;
                                    console.log(q);
                                    $('#header').html('<h1>' + path + '<small> env.. </small></h1>');
                                    //PUT VALUES IN THE INPUT FIELD
                                    $('#title').val(json.results.bindings[0].title.value);
                                    changeURI(json.results.bindings[0].title.value);
                                    document.getElementById('title').setAttribute("disabled");
                                    $('#label').val(json.results.bindings[0].label.value);
                                    $('#comment').val(json.results.bindings[0].comment.value);
                                    $('#method').val(json.results.bindings[0].method.value);
                                    $('#publisher').val(json.results.bindings[0].publisher.value);
                                    $('#endpoint').val(json.results.bindings[0].endpoint.value);
                                    $('#query').val(json.results.bindings[0].query.value);
                                    $('#order').val(json.results.bindings[0].order.value);
                                    $('#extends option:contains(' + splitURIPrefix(json.results.bindings[0].extends.value).value + ')').prop({selected: true});
                                    //$('#extends').val(json.results.bindings[0].extends.value);
                                    //PUT OLD VALUES IN THE STATIC FIELD
                                    //$('#titleForm').append('<input type="hidden" id="'+'oldTitle'+'" value="'+$('#title').val()+'"/>');
                                    $('#labelForm').append('<input type="hidden" id="' + 'oldLabel' + '" value="' + $('#label').val() + '"/>');
                                    $('#commentForm').append('<input type="hidden" id="' + 'oldComment' + '" value="' + $('#comment').val() + '"/>');
                                    $('#methodForm').append('<input type="hidden" id="' + 'oldMethod' + '" value="' + $('#method').val() + '"/>');
                                    $('#publisherForm').append('<input type="hidden" id="' + 'oldPublisher' + '" value="' + $('#publisher').val() + '"/>');
                                    $('#endpointForm').append('<input type="hidden" id="' + 'oldEndpoint' + '" value="' + $('#endpoint').val() + '"/>');
                                    $('#queryForm').append('<input type="hidden" id="' + 'oldQuery' + '" value="' + $('#query').val() + '"/>');
                                    $('#orderForm').append('<input type="hidden" id="' + 'oldOrder' + '" value="' + $('#order').val() + '"/>');
                                    $('#extendsForm').append('<input type="hidden" id="' + 'oldExtends' + '" value="' + splitURIPrefix(json.results.bindings[0].extends.value).value + '"/>');

                                }}
                    );
                }
                //end of EDIT

                //activate tooltip (bootstrap-tooltip.js is need)
                $('.icon-question-sign').tooltip();
            });

            $('#submit').click(function() {
                //EDIT
                if (penulPath() === 'edit') {
                    update();
                } else {
                    //ADD
                    submit();
                }
                //if one fail the others fails too
                if (document.getElementById('result').className === 'alert alert-error') {
                    $('#callModal').click();
                }
                if (document.getElementById('result').className === 'alert alert-success') {
                    window.location = document.referrer;
                }

            });

            function submit() {

                var type = 'Resource';
                var individual = $('#uri').html();
                var title = $('#title').val();
                var label = $('#label').val();
                var comment = $('#comment').val();
                var method = $('#method').val();
                var publisher = $('#publisher').val();
                var endpoint = $('#endpoint').val();
                var query = $('#query').val();
                var order = $('#order').val();
                var concept_ext = $('#extends').val();

                var predType = "rdf:type";
                var predTitle = "dc:title";
                var predLabel = "rdfs:label";
                var predComment = "rdfs:comment";

                var urlWrite = "../../../api/" + getApiKey() + "/write/";

                // verify all fields:
                var empty = false;
                if (title === '') {
                    $('#titleForm').addClass('controls control-group error');
                    empty = true;
                }
                if (label === '') {
                    $('#labelForm').addClass('controls control-group error');
                    empty = true;
                }
                if (comment === '') {
                    $('#commentForm').addClass('controls control-group error');
                    empty = true;
                }
                if (endpoint === '') {
                    $('#endpointForm').addClass('controls control-group error');
                    empty = true;
                }
                if (query === '') {
                    $('#queryForm').addClass('controls control-group error');
                    empty = true;
                }
                if (order === '') {
                    $('#orderForm').addClass('controls control-group error');
                    empty = true;
                }
                if (!empty) {


                    callAPI(urlWrite + individual + "/" + predType + "/owl:NamedIndividual", '#result');
                    callAPI(urlWrite + individual + "/" + predType + "/coeus:" + type, '#result');
                    callAPI(urlWrite + individual + "/" + predTitle + "/xsd:string:" + title, '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:isResourceOf" + "/" + lastPath(), '#result');
                    callAPI(urlWrite + lastPath() + "/" + "coeus:hasResource" + "/" + individual, '#result');
                    callAPI(urlWrite + individual + "/" + predLabel + "/xsd:string:" + label, '#result');
                    callAPI(urlWrite + individual + "/" + predComment + "/xsd:string:" + comment, '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:method" + "/xsd:string:" + method, '#result');
                    callAPI(urlWrite + individual + "/" + "dc:publisher" + "/xsd:string:" + publisher, '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:endpoint" + "/xsd:string:" + endpoint, '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:query" + "/xsd:string:" + query, '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:order" + "/xsd:string:" + order, '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:extends" + "/coeus:" + concept_ext, '#result');
                    callAPI(urlWrite + "coeus:" + concept_ext + "/" + "coeus:isExtendedBy" + "/" + individual , '#result');

                    // /api/coeus/write/coeus:uniprot_Q13428/dc:title/Q13428
                    //window.location = "../entity/";
                }


            }
            function update() {
                var urlUpdate = "../../../api/" + getApiKey() + "/update/";
                var urlDelete = "../../../api/" + getApiKey() + "/delete/";
                var urlWrite = "../../../api/" + getApiKey() + "/write/";
                if ($('#oldLabel').val() !== $('#label').val())
                    callAPI(urlUpdate + lastPath() + "/" + "rdfs:label" + "/xsd:string:" + $('#oldLabel').val() + ",xsd:string:" + $('#label').val(), '#result');
                if ($('#oldComment').val() !== $('#comment').val())
                    callAPI(urlUpdate + lastPath() + "/" + "rdfs:comment" + "/xsd:string:" + $('#oldComment').val() + ",xsd:string:" + $('#comment').val(), '#result');
                if ($('#oldMethod').val() !== $('#method').val())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:method" + "/xsd:string:" + $('#oldMethod').val() + ",xsd:string:" + $('#method').val(), '#result');
                if ($('#oldPublisher').val() !== $('#publisher').val())
                    callAPI(urlUpdate + lastPath() + "/" + "dc:publisher" + "/xsd:string:" + $('#oldPublisher').val() + ",xsd:string:" + $('#publisher').val(), '#result');
                if ($('#oldEndpoint').val() !== $('#endpoint').val())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:endpoint" + "/xsd:string:" + $('#oldEndpoint').val() + ",xsd:string:" + $('#endpoint').val(), '#result');
                if ($('#oldQuery').val() !== $('#query').val())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:query" + "/xsd:string:" + $('#oldQuery').val() + ",xsd:string:" + $('#query').val(), '#result');
                if ($('#oldOrder').val() !== $('#order').val())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:order" + "/xsd:string:" + $('#oldOrder').val() + ",xsd:string:" + $('#order').val(), '#result');
                if ($('#oldExtends').val() !== $('#extends').val()){
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:extends" + "/coeus:" + $('#oldExtends').val() + ",coeus:" + $('#extends').val(), '#result');
                    callAPI(urlDelete + "coeus:" +$('#oldExtends').val() + "/" + "coeus:isExtendedBy" +"/" + lastPath(), '#result');
                    callAPI(urlWrite + "coeus:" +$('#extends').val() + "/" + "coeus:isExtendedBy" +"/" + lastPath(), '#result');
                }
            }

            function changeURI(value) {
                //var specialChars = "!@#$^&%*()+=-[]\/{}|:<>?,. ";
                document.getElementById('uri').innerHTML = 'coeus:resource_' + value.split(' ').join('_');
            }
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <p class="lead" >Resource URI - <a class="lead" id="uri">coeus: </a></p>

            <div class="row-fluid">
                <h4 id="type" >New Resource </h4>
                <div class="span4" >


                    <div id="titleForm" >
                        <label class="control-label" for="title">Title</label>
                        <input id="title" type="text" placeholder="Ex: Uniprot" onkeyup="changeURI(this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the dc:title property" ></i>
                    </div>
                    <div id="labelForm"> 
                        <label class="control-label" for="label">Label</label>
                        <input id="label" type="text" placeholder="Ex: Uniprot Resource"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the rdfs:label property" ></i>
                    </div>
                    <div id="methodForm"> 
                        <label class="control-label" for="label">Method</label>
                        <select id="method" class="span10">
                            <option>cache</option>
                            <option>complete</option>
                            <option>map</option>
                        </select> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:method property" ></i>
                    </div>
                    <div id="publisherForm"> 
                        <label class="control-label" for="label">Publisher</label>
                        <select id="publisher" class="span10">
                            <option>sql</option>
                            <option>csv</option>
                            <option>xml</option>
                            <option>sparql</option>
                            <option>json</option>
                            <option>rdf</option>
                        </select> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:publisher property" ></i>
                    </div>
                    <div id="extendsForm" > 
                        <label class="control-label" for="label">Extends</label>
                        <select id="extends" class="span10">

                        </select> <i class="icon-question-sign" data-toggle="tooltip" title="Select the concept to extends" ></i>
                    </div>
                    <div id="endpointForm"> 
                        <label class="control-label" for="label">Endpoint</label>
                        <input id="endpoint" type="text" placeholder="Ex: http://someurl.com"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:endpoint property" ></i>
                    </div>
                    <div id="queryForm"> 
                        <label class="control-label" for="label">Query</label>
                        <input id="query" type="text" placeholder="Ex: //item"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:query property" ></i>
                    </div>
                    <div id="orderForm"> 
                        <label class="control-label" for="label">Order</label>
                        <input class="input-mini" id="order" type="text" placeholder="Ex: 1"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:order property" ></i>
                    </div>
                    <br/>
                    <div class="span4">
                        <button  type="button" id="submit" class="btn btn-success">Add <i class="icon-plus icon-white"></i> </button>
                    </div>
                    <div class="span4">
                        <button type="button" id="done" class="btn btn-danger" onclick="window.history.back(-1);">Cancel</button>
                    </div>
                </div>
                <div class="span8"></div>
                <div id="commentForm">
                    <label class="control-label" for="comment">Comment</label> 
                    <textarea rows="4" style="max-width: 500px;width: 400px;" id="comment" type="text" placeholder="Ex: Describes the Uniprot Resource"></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the rdfs:comment property" ></i>
                </div>
                

            </div>

            <!-- Aux button to call modal -->
            <button class="hide" type="button"  id="callModal" href="#errorModal" role="button" data-toggle="modal">modal</button>

        </div>



        <!-- Modal -->
        <div id="errorModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3 id="myModalLabel">Output</h3>
            </div>
            <div class="modal-body">
                <div id="result">

                </div>
                <!-- <div id="titleResult">
 
                 </div>
                 <div id="labelResult">
 
                 </div>
                 <div id="commentResult">
 
                 </div>
                 <div id="seedResult">
 
                 </div>
                 <div id="typeResult">
 
                 </div>-->
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                <button class="btn btn-primary" onclick="submit();">Retry</button>
            </div>
        </div>


    </s:layout-component>
</s:layout-render>
