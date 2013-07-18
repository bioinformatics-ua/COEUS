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

                //header name
                var path = lastPath();
                $('#header').html('<h1>' + path + '<small> env.. </small></h1>');

                //fill the concepts extensions
                var q = "SELECT ?concept ?c {?concept a coeus:Concept . ?concept dc:title ?c}";
                queryToResult(q, fillConceptsExtension);

                //if the type mode is EDIT
                if (penulPath() === 'edit') {
                    $('#type').html("Edit Resource");
                    $('#submit').html('Edit <i class="icon-edit icon-white"></i>');



                    var query = initSparqlerQuery();
                    var q = "SELECT ?title ?label ?comment ?method ?publisher ?endpoint ?query ?order ?extends ?built {" + path + " dc:title ?title . " + path + " rdfs:label ?label . " + path + " rdfs:comment ?comment . " + path + " coeus:method ?method . " + path + " dc:publisher ?publisher . " + path + " coeus:endpoint ?endpoint . " + path + " coeus:query ?query . " + path + " coeus:order ?order . " + path + " coeus:extends ?extends . OPTIONAL{" + path + " coeus:built ?built } }";
                    query.query(q,
                            {success: function(json) {
                                    //var resultTitle = json.results.bindings[0].title;
                                    console.log(json);
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
                                    if (json.results.bindings[0].built !== undefined && json.results.bindings[0].built.value === "true")
                                        $('#built').prop('checked', true);
                                    else
                                        $('#built').prop('checked', false);
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
                                    $('#builtForm').append('<input type="hidden" id="' + 'oldBuilt' + '" value="' + $('#built').is(':checked') + '"/>');

                                }}
                    );
                        
                var qselectors = "SELECT * {" + path + " coeus:loadsFrom ?selector . ?selector dc:title ?title . ?selector rdfs:label ?label . ?selector coeus:property ?property . ?selector coeus:query ?query . OPTIONAL { ?selector coeus:isKeyOf ?key } . OPTIONAL { ?selector coeus:regex ?regex }}";
                queryToResult(qselectors, fillSelectors);
                
               
                    //end of EDIT
                } else {
                    //not showing selectores and built option if one resource is been add 
                    $('#selectorsForm').addClass('hide');
                    $('#builtForm').addClass('hide');
                }
                
               
                //activate tooltip (bootstrap-tooltip.js is need)
                $('.icon-question-sign').tooltip();
            });
            
            $('#existingSelector').click(function() {
                //clean all existing selectores
                $('#existingSelectors').html("");
                var selectorsType='coeus:'+$('#publisher').val().toUpperCase();
                console.log(selectorsType);
                var existingSelectores="SELECT DISTINCT ?selector (MIN(?resource) AS ?resource) (MIN(?title) AS ?title) (MIN(?label) AS ?label) (MIN(?property) AS ?property) (MIN(?query) AS ?query) MIN(?regex) (MIN(?key) AS ?key) {?selector coeus:loadsFor ?resource . ?selector a "+selectorsType+" . ?selector dc:title ?title . ?selector rdfs:label ?label . ?selector coeus:property ?property . ?selector coeus:query ?query . OPTIONAL { ?selector coeus:regex ?regex } . FILTER NOT EXISTS { ?selector coeus:isKeyOf ?key }} GROUP BY ?selector";
                queryToResult(existingSelectores,fillExitingSelectors);
                
            });

            $('#submit').click(function() {
                //EDIT
                if (penulPath() === 'edit') {
                    update();
                } else {
                    //ADD
                    submit();

                }

            });

            function fillExitingSelectors(result){console.log(result);
                
                for (var r in result) {
                    var key = '';
                    if (result[r].key !== undefined)
                        key = '<span class="label label-success">Key</span>';
                    var regex = '-';
                    if (result[r].regex !== undefined)
                        regex = result[r].regex.value;
                    var sel=splitURIPrefix(result[r].selector.value).value;
                    var a = '<tr><td>'
                            + result[r].title.value + ' ' + key
                            + '</td><td>'
                            + result[r].query.value + '</td><td>'
                            + result[r].property.value + '</td><td>'
                            + regex + '</td><td>'
                            + '<div class="btn-group" id="btn'+sel+'">'
                            + '<button class="btn btn-success" onclick="addExistingSelector(\'' + sel + '\')">Add</button>'
                            + '</div>'+'<div id="result'+sel+'"></div>'
                            + '</td></tr>';

                    $('#existingSelectors').append(a);
                }
            }
            function addExistingSelector(selector){
                var urlWrite = "../../../api/" + getApiKey() + "/write/";
                callAPI(urlWrite + lastPath() + "/" + "coeus:loadsFrom" + "/coeus:" + selector, '#result'+ selector);
                callAPI(urlWrite + "coeus:" + selector + "/" + "coeus:loadsFor/" + lastPath(), '#result'+ selector);
                if (document.getElementById('result'+ selector).className === 'alert alert-success') {
                    $('#btn'+selector).addClass('hide');
                    $('#result'+selector).html("Added");
                }   
            }
            function fillConceptsExtension(result) {
                for (var r in result) {
                    var concept = splitURIPrefix(result[r].concept.value);
                    $('#extends').append('<option>' + concept.value + '</option>');
                }
            }
            function fillSelectors(result) {
                console.log(result);
                for (var r in result) {
                    var key = '';
                    if (result[r].key !== undefined)
                        key = '<span class="label label-success">Key</span>';
                    var regex = '-';
                    if (result[r].regex !== undefined)
                        regex = result[r].regex.value;
                    var a = '<tr><td>'
                            + result[r].title.value + ' ' + key
                            + '</td><td>'
                            + result[r].query.value + '</td><td>'
                            + result[r].property.value + '</td><td>'
                            + regex + '</td><td>'
                            + '<div class="btn-group">'
                            + '<button class="btn btn" href="#selectorsModal" role="button" data-toggle="modal" onclick="editSelector(\'' + splitURIPrefix(result[r].selector.value).value + '\')">Edit</button>'
                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectSelector(\'' + splitURIPrefix(result[r].selector.value).value + '\')">Remove</button>'
                            + '</div>'
                            + '</td></tr>';

                    $('#selectors').append(a);
                }
            }
            function selectSelector(selector) {
                $('#removeModalLabel').html('coeus:' + selector);
                var qTotal="SELECT (COUNT(?resource) AS ?total) {coeus:" + selector+" coeus:loadsFor ?resource }";
                $('#rmBodySelectors').html('');
                $('#btnDetach').remove();
                        
                queryToResult(qTotal,function (result){
                    var total=result[0].total.value;
                    if(total>1) {
                        //console.log(selector);
                        var text='Info: This selector is associated with more that one resource. You can opt to only detach the selector. ';
                        $('#rmBodySelectors').html(text);
                        $('#rmbtns').append('<a class="btn btn-warning" id="btnDetach" onclick="detachSelector(\''+selector+'\');">Detach</a>');
                    }
                });
                
            }
            function detachSelector(selector){
                var urlDelete = "../../../api/" + getApiKey() + "/delete/";
                //callAPI(urlDelete + lastPath() + "/" + "coeus:isKeyOf" + "/coeus:" + selector, '#res');
                callAPI(urlDelete + lastPath() + "/" + "coeus:loadsFrom" + "/coeus:" + selector, '#res');
                if (document.getElementById('res').className === 'alert alert-success') {
                    window.location = document.referrer;
                }
            }
            function editSelector(selector) {
                //document.getElementById('myModalLabel').value="Edit Selector";
                $('#selectorsModalLabel').html("Edit Selector");
                $('#addSelectorButton').html("Edit");
                console.log($('#selectorsModalLabel').html());
                $('#selectorUri').html("coeus:" + selector);
                var q = "SELECT * {coeus:" + selector + " dc:title ?title . coeus:" + selector + " rdfs:label ?label . coeus:" + selector + " coeus:property ?property . coeus:" + selector + " coeus:query ?query . OPTIONAL { coeus:" + selector + " coeus:isKeyOf ?key } . OPTIONAL { coeus:" + selector + " coeus:regex ?regex }}";
                queryToResult(q, function(result) {
                    //FILL THE VALUES
                    $('#titleSelectors').val(result[0].title.value);
                    document.getElementById('titleSelectors').setAttribute("disabled");
                    $('#labelSelectors').val(result[0].label.value);
                    $('#propertySelectors').val(result[0].property.value);
                    $('#querySelectors').val(result[0].query.value);
                    if (result[0].regex !== undefined) {
                        $('#regexSelectors').val(result[0].regex.value);
                    } else {
                        $('#regexSelectors').val('');
                    }
                    if (result[0].key !== undefined)
                        $('#keySelectorsForm').prop('checked', true);
                    else
                        $('#keySelectorsForm').prop('checked', false);
                    //SAVE OLD VALUES IN A STATIC FIELD
                    $('#titleSelectorsForm').append('<input type="hidden" id="' + 'oldTitleSelectors' + '" value="' + $('#titleSelectors').val() + '"/>');
                    $('#labelSelectorsForm').append('<input type="hidden" id="' + 'oldLabelSelectors' + '" value="' + $('#labelSelectors').val() + '"/>');
                    $('#propertySelectorsForm').append('<input type="hidden" id="' + 'oldPropertySelectors' + '" value="' + $('#propertySelectors').val() + '"/>');
                    $('#querySelectorsForm').append('<input type="hidden" id="' + 'oldQuerySelectors' + '" value="' + $('#querySelectors').val() + '"/>');
                    $('#regexSelectorsForm').append('<input type="hidden" id="' + 'oldRegexSelectors' + '" value="' + $('#regexSelectors').val() + '"/>');
                    $('#titleSelectorsForm').append('<input type="hidden" id="oldKeySelectors' + '" value="' + $('#keySelectorsForm').is(':checked') + '"/>');

                });

                //$('#callSelectorsModal').click();
            }
            function removeSelector() {
                var selector = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + selector);
                var urlPrefix = "../../../api/" + getApiKey();
                //remove all subjects associated.
                removeAllTriplesFromPredicateAndObject(urlPrefix,"coeus:loadsFrom", selector);
                removeAllTriplesFromPredicateAndObject(urlPrefix,"coeus:isKeyOf", selector);
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix, selector);

            }
            function updatePublisherOnSelectores(urlUpdate, res, oldPublisher, newPublisher) {
                var q = "SELECT * {" + res + " coeus:loadsFrom ?selector}";
                queryToResult(q, function(result) {
                    for (var r in result) {
                        var res = splitURIPrefix(result[r].selector.value);
                        callAPI(urlUpdate + "coeus:" + res.value + "/rdf:type/coeus:" + oldPublisher.toUpperCase() + ",coeus:" + newPublisher.toUpperCase(), '#result');
                    }
                    if (document.getElementById('result').className === 'alert alert-success') {
                        window.location = document.referrer;
                    }
                    //if one fail the others fails too
                    if (document.getElementById('result').className === 'alert alert-error') {
                        $('#callModal').click();
                    }
                });
            }
            function addSelector() {
                var urlWrite = "../../../api/" + getApiKey() + "/write/";

                var type = $('#publisher').val().toUpperCase();
                var individual = $('#selectorUri').html();
                var title = $('#titleSelectors').val();
                var label = $('#labelSelectors').val();
                var property = $('#propertySelectors').val();
                var query = $('#querySelectors').val();
                //TO ALLOW MORE THAN ONE '/'
                query = query.split("/").join("%2F");
                console.log(query);
                var key = $('#keySelectorsForm').is(':checked');
                var regex = $('#regexSelectors').val();

                var predType = "rdf:type";
                var predTitle = "dc:title";
                var predLabel = "rdfs:label";
                var predComment = "rdfs:comment";

                // verify all fields:
                var empty = false;
                if (title === '') {
                    $('#titleSelectorsForm').addClass('controls control-group error');
                    empty = true;
                }
                if (label === '') {
                    $('#labelSelectorsForm').addClass('controls control-group error');
                    empty = true;
                }
                if (property === '') {
                    $('#propertySelectorsForm').addClass('controls control-group error');
                    empty = true;
                }
                if (query === '') {
                    $('#querySelectorsForm').addClass('controls control-group error');
                    empty = true;
                }
                if (!empty) {


                    callAPI(urlWrite + individual + "/" + predType + "/owl:NamedIndividual", '#res');
                    callAPI(urlWrite + individual + "/" + predType + "/coeus:" + type, '#res');
                    callAPI(urlWrite + individual + "/" + predTitle + "/xsd:string:" + title, '#res');
                    callAPI(urlWrite + individual + "/" + "coeus:loadsFor" + "/" + lastPath(), '#res');
                    callAPI(urlWrite + lastPath() + "/" + "coeus:loadsFrom" + "/" + individual, '#res');
                    callAPI(urlWrite + individual + "/" + predLabel + "/xsd:string:" + label, '#res');
                    callAPI(urlWrite + individual + "/" + "coeus:property" + "/xsd:string:" + property, '#res');
                    callAPI(urlWrite + individual + "/" + "coeus:query" + "/xsd:string:" + query, '#res');

                    if (key) {
                        callAPI(urlWrite + individual + "/" + "coeus:isKeyOf" + "/" + lastPath(), '#res');
                        callAPI(urlWrite + lastPath() + "/" + "coeus:hasKey" + "/" + individual, '#res');
                    }
                    if (regex !== '')
                        callAPI(urlWrite + individual + "/" + "coeus:regex" + "/xsd:string:" + regex, '#res');
                    //Update Selectors table
                    if (document.getElementById('res').className === 'alert alert-success') {
                        window.location.reload();
                    }
                    
                    
                }
            }
            function submitSelector() {
                if ($('#selectorsModalLabel').html() === "Edit Selector")
                    updateSelector();
                else
                    addSelector();
            }
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
                    callAPI(urlWrite + individual + "/" + "coeus:endpoint" + "/xsd:string:" + encodeBars(endpoint), '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:query" + "/xsd:string:" + encodeBars(query), '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:order" + "/xsd:string:" + order, '#result');
                    callAPI(urlWrite + individual + "/" + "coeus:extends" + "/coeus:" + concept_ext, '#result');
                    callAPI(urlWrite + "coeus:" + concept_ext + "/" + "coeus:isExtendedBy" + "/" + individual, '#result');

                    // /api/coeus/write/coeus:uniprot_Q13428/dc:title/Q13428
                    //window.location = "../entity/";
                }
                if (document.getElementById('result').className === 'alert alert-success') {
                    window.location = document.referrer;
                }
                //if one fail the others fails too
                if (document.getElementById('result').className === 'alert alert-error') {
                    $('#callModal').click();
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
                if ($('#oldEndpoint').val() !== $('#endpoint').val())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:endpoint" + "/xsd:string:" + encodeBars($('#oldEndpoint').val()) + ",xsd:string:" + encodeBars($('#endpoint').val()), '#result');
                if ($('#oldQuery').val() !== $('#query').val())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:query" + "/xsd:string:" + encodeBars($('#oldQuery').val()) + ",xsd:string:" + encodeBars($('#query').val()), '#result');
                if ($('#oldOrder').val() !== $('#order').val())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:order" + "/xsd:string:" + $('#oldOrder').val() + ",xsd:string:" + $('#order').val(), '#result');
                if ($('#oldExtends').val() !== $('#extends').val()) {
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:extends" + "/coeus:" + $('#oldExtends').val() + ",coeus:" + $('#extends').val(), '#result');
                    callAPI(urlDelete + "coeus:" + $('#oldExtends').val() + "/" + "coeus:isExtendedBy" + "/" + lastPath(), '#result');
                    callAPI(urlWrite + "coeus:" + $('#extends').val() + "/" + "coeus:isExtendedBy" + "/" + lastPath(), '#result');
                }
                if ($('#oldPublisher').val() !== $('#publisher').val()) {
                    callAPI(urlUpdate + lastPath() + "/" + "dc:publisher" + "/xsd:string:" + $('#oldPublisher').val() + ",xsd:string:" + $('#publisher').val(), '#result');
                    updatePublisherOnSelectores(urlUpdate, lastPath(), $('#oldPublisher').val(), $('#publisher').val());
                }
                if ($('#oldBuilt').val().toString() !== $('#built').is(':checked').toString())
                    callAPI(urlUpdate + lastPath() + "/" + "coeus:built" + "/xsd:boolean:" + $('#oldBuilt').val() + ",xsd:boolean:" + $('#built').is(':checked'), '#result');

                if (document.getElementById('result').className === 'alert alert-success') {
                    window.location = document.referrer;
                }
                //if one fail the others fails too
                if (document.getElementById('result').className === 'alert alert-error') {
                    $('#callModal').click();
                }
            }
            function updateSelector() {
                var urlUpdate = "../../../api/" + getApiKey() + "/update/";
                var urlDelete = "../../../api/" + getApiKey() + "/delete/";
                var urlWrite = "../../../api/" + getApiKey() + "/write/";

                var individual = $('#selectorUri').html();
                if ($('#oldTitleSelectors').val() !== $('#titleSelectors').val())
                    callAPI(urlUpdate + individual + "/" + "dc:title" + "/xsd:string:" + $('#oldTitleSelectors').val() + ",xsd:string:" + $('#titleSelectors').val(), '#res');
                if ($('#oldLabelSelectors').val() !== $('#labelSelectors').val())
                    callAPI(urlUpdate + individual + "/" + "rdfs:label" + "/xsd:string:" + $('#oldLabelSelectors').val() + ",xsd:string:" + $('#labelSelectors').val(), '#res');
                if ($('#oldPropertySelectors').val() !== $('#propertySelectors').val())
                    callAPI(urlUpdate + individual + "/" + "coeus:property" + "/xsd:string:" + $('#oldPropertySelectors').val() + ",xsd:string:" + $('#propertySelectors').val(), '#res');
                if ($('#oldQuerySelectors').val() !== $('#querySelectors').val())
                    callAPI(urlUpdate + individual + "/" + "coeus:query" + "/xsd:string:" + encodeBars($('#oldQuerySelectors').val()) + ",xsd:string:" + encodeBars($('#querySelectors').val()), '#res');
                if (($('#oldRegexSelectors').val() !== $('#regexSelectors').val()) && ($('#regexSelectors').val() !== ''))
                    callAPI(urlUpdate + individual + "/" + "coeus:regex" + "/xsd:string:" + $('#oldRegexSelectors').val() + ",xsd:string:" + $('#regexSelectors').val(), '#res');
                if ($('#oldKeySelectors').val().toString() !== $('#keySelectorsForm').is(':checked').toString()) {
                    //change: false to true
                    if ($('#keySelectorsForm').is(':checked')) {
                        callAPI(urlWrite + individual + "/" + "coeus:isKeyOf" + "/" + lastPath(), '#res');
                        callAPI(urlWrite + lastPath() + "/" + "coeus:hasKey" + "/" + individual, '#res');
                    }//change: true to false
                    else {
                        callAPI(urlDelete + individual + "/" + "coeus:isKeyOf" + "/" + lastPath(), '#res');
                        callAPI(urlDelete + lastPath() + "/" + "coeus:hasKey" + "/" + individual, '#res');
                    }
                }
                if (document.getElementById('res').className === 'alert alert-success') {
                    window.location = document.referrer;
                }
            }

            function changeURI(value) {
                //var specialChars = "!@#$^&%*()+=-[]\/{}|:<>?,. ";
                document.getElementById('uri').innerHTML = 'coeus:resource_' + value.split(' ').join('_');
            }
            function changeSelectorURI(value) {
                //var specialChars = "!@#$^&%*()+=-[]\/{}|:<>?,. ";
                document.getElementById('selectorUri').innerHTML = 'coeus:selector_' + value.split(' ').join('_');
            }
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <p class="lead" >Resource URI - <a class="lead" id="uri">coeus: </a></p>

            <div class="row">
                <div id="selectorsForm" class="span10">
                    <label class="control-label" for="selectorsForm"><h4>Selectors Configuration</h4></label> 
                    <table class="table table-hover table-bordered span4">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Query</th>
                                <th>Property</th>
                                <th>Regex</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="selectors">

                        </tbody>
                    </table>
                    <div class="text-right">
                        <button  type="button" id="addselector" href="#selectorsModal" role="button" data-toggle="modal" class="btn btn-success">New <i class="icon-plus icon-white"></i> </button>
                        <button  type="button" id="existingSelector" href="#existingSelectorsModal" role="button" data-toggle="modal" class="btn btn-warning">Existing <i class="icon-plus icon-white"></i> </button>
                        <button type="button" id="done" class="btn btn-info" onclick="window.history.back(-1);">Done</button>
                    </div>

                </div>

            </div>
            <!--EDIT RESOURCE-->
            <div class="row-fluid">
                <h4 id="type" >New Resource </h4>
                <div class="span4" >

                    <div id="builtForm"> 
                        <label class="checkbox" >
                            <input type="checkbox" id="built"><span class="label label-success">Built</span>
                        </label>
                    </div>
                    <div id="titleForm" >
                        <label class="control-label" for="title">Title</label>
                        <input id="title" type="text" placeholder="Ex: Uniprot" onkeyup="changeURI(this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the dc:title property" ></i>
                    </div>
                    <div id="labelForm"> 
                        <label class="control-label" for="label">Label</label>
                        <input id="label" type="text" placeholder="Ex: Uniprot Resource"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the rdfs:label property" ></i>
                    </div>
                    <!--<div id="conceptForm" > 
                        <label class="control-label" for="label">Concept (fix to allow change of concept)</label>
                        <select id="concept" class="span10">

                        </select> <i class="icon-question-sign" data-toggle="tooltip" title="Select the concept associated" ></i>
                    </div>-->
                    <div id="extendsForm" > 
                        <label class="control-label" for="label">Extends</label>
                        <select id="extends" class="span10">

                        </select> <i class="icon-question-sign" data-toggle="tooltip" title="Select the concept to extends" ></i>
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
                    <br/>
                    <div class="span4">
                        <button  type="button" id="submit" class="btn btn-success">Add <i class="icon-plus icon-white"></i> </button>
                    </div>
                    <div class="span4">
                        <button type="button" id="done" class="btn btn-danger" onclick="window.history.back(-1);">Cancel</button>
                    </div>
                    <br/><br/><br/>
                </div>

                <div id="commentForm">
                    <label class="control-label" for="comment">Comment</label> 
                    <textarea rows="4" style="max-width: 500px;width: 400px;" id="comment" type="text" placeholder="Ex: Describes the Uniprot Resource"></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the rdfs:comment property" ></i>
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

            </div>


            <!-- Aux button to call modal -->
            <button class="hide" type="button"  id="callModal" href="#errorModal" role="button" data-toggle="modal">modal</button>
            <button class="hide" type="button"  id="callSelectorsModal" href="#selectorsModal" role="button" data-toggle="modal">selectors</button>

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

        <!-- Modal -->
        <div id="selectorsModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="selectorsModal" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3 id="selectorsModalLabel">Add Selector</h3>
            </div>
            <div class="modal-body">
                <p class="lead" >Selector URI - <a class="lead" id="selectorUri">coeus: </a></p>
                <label class="checkbox" >
                    <input type="checkbox" id="keySelectorsForm"><span class="label label-success">Key</span>
                </label>
                <div id="titleSelectorsForm" >
                    <label class="control-label" for="title">Title</label>
                    <input id="titleSelectors" type="text" placeholder="Ex: Id" onkeyup="changeSelectorURI(this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the dc:title property" ></i>
                </div>
                <div id="labelSelectorsForm"> 
                    <label class="control-label" for="label">Label</label>
                    <input id="labelSelectors" type="text" placeholder="Ex: Uniprot Resource"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the rdfs:label property" ></i>
                </div>
                <div id="propertySelectorsForm"> 
                    <label class="control-label" for="label">Property</label>
                    <input id="propertySelectors" type="text" placeholder="Ex: dc:identifier"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:property property" ></i>
                </div>
                <div id="querySelectorsForm"> 
                    <label class="control-label" for="label">Query</label>
                    <input id="querySelectors" type="text" placeholder="Ex: /name"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:query property" ></i>
                </div>
                <div id="regexSelectorsForm"> 
                    <label class="control-label" for="regexSelectors">Regex</label>
                    <input id="regexSelectors" type="text" placeholder="Ex: [0-9]"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:regex property" ></i>
                </div>

                <div id="res">

                </div>

            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                <button class="btn btn-success" id="addSelectorButton" onclick="submitSelector();">Add</button>
            </div>
        </div>

        <!-- Remove Modal -->
        <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3 >Remove Selector</h3>
            </div>
            <div class="modal-body">
                <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> selector?</p>
                <p class="text-warning">Warning: If you press the remove button all dependents triples are removed too.</p>
                <div id="rmBodySelectors">

                </div>
                <div id="resultRemove">

                </div>

            </div>

            <div class="modal-footer" id="rmbtns">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button class="btn btn-danger" onclick="removeSelector();">Remove</button>
            </div>
        </div>

        <!-- Add Existing Selector Modal -->
        <div id="existingSelectorsModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button id="closeExistingSelectorsModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3 >Add Existing Selector</h3>
            </div>
            <div class="modal-body">
                <table class="table table-hover table-bordered">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Query</th>
                            <th>Property</th>
                            <th>Regex</th>
                            <th>Choose</th>
                        </tr>
                    </thead>
                    <tbody id="existingSelectors">

                    </tbody>
                </table>
            </div>

            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button class="btn btn-info" onclick="window.location.reload();">Done</button>
            </div>
        </div>



    </s:layout-component>
</s:layout-render>
