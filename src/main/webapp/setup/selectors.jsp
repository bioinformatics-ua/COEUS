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
            $(document).ready(function() {
                changeSidebar('#dashboard');
                //header name
                var path = lastPath();
                $('#uri').html(path);
                callURL("../../config/getconfig/", fillHeader);
                //Associate Enter key:
                document.onkeypress = function(event) {
                    //Enter key pressed
                    if (event.charCode === 13) {
                        if (document.getElementById('selectorsModal').style.display === "block" && document.activeElement.getAttribute('id') === "selectorsModal")
                            testMode();
                        if (document.getElementById('selectorsModal').style.display === "block" && document.activeElement.getAttribute('id') === "typeahead")
                            updateSelectorProperties();
                    }
                };

                var q = "SELECT ?publisher {" + path + " dc:publisher ?publisher . }";
                queryToResult(q, function(result) {
                    $('#publisher').html(result[0].publisher.value.toUpperCase());
                }
                );

                refresh();

                //path is a resource
                var qresourceEdit = "SELECT DISTINCT ?seed ?entity ?concept {" + path + " coeus:isResourceOf ?concept . ?concept coeus:hasEntity ?entity . ?entity coeus:isIncludedIn ?seed }";
                queryToResult(qresourceEdit, fillBreadcumb);

                //activate tooltip (bootstrap-tooltip.js is need)
                $('.icon-question-sign').tooltip();



            });

            function refresh() {
                var qselectors = "SELECT * {" + lastPath() + " coeus:loadsFrom ?selector . ?selector dc:title ?title . ?selector rdfs:label ?label . ?selector coeus:property ?property . ?selector coeus:query ?query . OPTIONAL { ?selector coeus:isKeyOf ?key } . OPTIONAL { ?selector coeus:regex ?regex }}";
                queryToResult(qselectors, fillSelectors);
            }

            $('#typeahead').typeahead({
                name: 'properties',
                prefetch: '../../config/properties/',
                remote: '../../config/properties/%QUERY',
                limit: 15
            });

            $('#existingSelector').click(function() {
                //clean all existing selectores
                $('#existingSelectors').html("");
                var selectorsType = 'coeus:' + $('#publisher').html().toUpperCase();
                var resource = $('#uri').html();
                var seed = $('#selectorsSeed').val();
                var existingSelectores = "SELECT DISTINCT ?selector (MIN(?resource) AS ?resource) (MIN(?title) AS ?title) (MIN(?label) AS ?label) (MIN(?property) AS ?property) (MIN(?query) AS ?query) MIN(?regex) (MIN(?key) AS ?key) {" + seed + " coeus:includes ?entity . ?entity coeus:isEntityOf ?concept . ?concept coeus:hasResource ?resource . ?selector coeus:loadsFor ?resource . ?selector a " + selectorsType + " . ?selector dc:title ?title . ?selector rdfs:label ?label . ?selector coeus:property ?property . ?selector coeus:query ?query . OPTIONAL { ?selector coeus:regex ?regex } . FILTER NOT EXISTS { ?selector coeus:isKeyOf ?key } . MINUS {?selector coeus:loadsFor " + resource + "} } GROUP BY ?selector";
                queryToResult(existingSelectores, fillExitingSelectors);

            });

            $('#submit').click(testMode);

            function testMode() {
                //EDIT
                if (penulPath() === 'edit') {
                    update();
                } else {
                    //ADD
                    submit();

                }

            }

            function fillExitingSelectors(result) {
                console.log(result);
                for (var r in result) {
                    try {
                        var key = '';
                        if (result[r].key !== undefined)
                            key = '<span class="label label-success">Key</span>';
                        var regex = '-';
                        if (result[r].regex !== undefined)
                            regex = result[r].regex.value;
                        var sel = splitURIPrefix(result[r].selector.value).value;
                        var a = '<tr><td><a target="_blank" href="../../resource/' + sel + '" class="tip" data-toggle="tooltip" title="View in browser.">'
                                + sel + ' ' + key
                                + '</a></td><td>'
                                + result[r].title.value
                                + '</td><td>'
                                + result[r].query.value + '</td><td>'
                                + result[r].property.value + '</td><td>'
                                // + regex + '</td><td>'
                                + '<div class="btn-group" id="btn' + sel + '">'
                                + '<button class="btn btn-success btn-small" onclick="addExistingSelector(\'' + sel + '\')">Add</button>'
                                + '</div>' + '<div id="result' + sel + '"></div>'
                                + '</td></tr>';

                        $('#existingSelectors').append(a);
                    } catch (e) {
                        console.log('Existing selectors empty error...');
                        console.log(e);
                        //ignore errors
                    }
                }
                tooltip();
            }
            function addExistingSelector(selector) {

                var urlWrite = "../../api/" + getApiKey() + "/write/";
                var url = urlWrite + lastPath() + "/" + "coeus:loadsFrom" + "/coeus:" + selector;
                callURL(url, showResultSelectors.bind(this, selector, "Added"), showErrorSelectors.bind(this, '#existingSelectorsResult', url));
                url = urlWrite + "coeus:" + selector + "/" + "coeus:loadsFor/" + lastPath(), '#result' + selector;
                callURL(url, showResultSelectors.bind(this, selector, "Added"), showErrorSelectors.bind(this, '#existingSelectorsResult', url));

            }

            function showResultSelectors(id, url, result) {
                if (result.status === 100) {
                    $('#result' + id).append(generateHtmlMessage("Success!", "", "alert-success"));
                    $('#btn' + id).addClass('hide');
                    $('#result' + id).html("<span class=\"text-success\">Added</span>");
                    refresh();
                }
                else {
                    $('#existingSelectorsResult').append(generateHtmlMessage("Warning!", url + "</br>Status Code:" + result.status + " " + result.message, "alert-warning"));
                }
            }

            function showErrorSelectors(id, url, jqXHR, result) {
                $(id).append(generateHtmlMessage("Server error!", url + "</br>Status Code:" + result.status + " " + result.message, "alert-danger"));
            }

            function fillConceptsExtension(result) {
                for (var r in result) {
                    var concept = splitURIPrefix(result[r].concept.value);
                    $('#extends').append('<option>' + concept.value + '</option>');
                }
            }
            function fillSelectors(result) {
                console.log(result);
                $('#selectors').html("");
                for (var r in result) {
                    var key = '';
                    if (result[r].key !== undefined)
                        key = '<span class="label label-success tip" data-toggle="tooltip" title="The key selector will be used to generate unique Item individual identifications (i.e. URIs) from the integrated resources.">Key</span>';
                    var regex = '-';
                    if (result[r].regex !== undefined)
                        regex = result[r].regex.value;
                    var uri = splitURIPrefix(result[r].selector.value).value;
                    var a = '<tr><td><a target="_blank" href="../../resource/' + uri + '" class="tip" data-toggle="tooltip" title="View in browser">'
                            + uri + '</a> ' + key + '</td><td>'
                            + result[r].title.value
                            + '</td><td>'
                            + result[r].query.value + '</td><td>'
                            + result[r].property.value + '</td><td>'
                            + regex + '</td><td>'
                            + '<div class="btn-group">'
                            + '<button class="btn btn-default" href="#selectorsModal" role="button" data-toggle="modal" onclick="editSelector(\'' + splitURIPrefix(result[r].selector.value).value + '\')">Edit <i class="fa fa-edit"></i></button>'
                            + '<button class="btn btn-default" href="#removeModal" role="button" data-toggle="modal" onclick="selectSelector(\'' + splitURIPrefix(result[r].selector.value).value + '\')">Remove <i class="fa fa-trash-o"></i></button>'
                            + '</div>'
                            + '</td></tr>';

                    $('#selectors').append(a);
                }
                tooltip();
            }
            function selectSelector(selector) {
                $('#resultSelectorRemove').html('');
                $('#removeType').html('Selector');
                $('#removeModalLabel').html('coeus:' + selector);
                var qTotal = "SELECT (COUNT(?resource) AS ?total) {coeus:" + selector + " coeus:loadsFor ?resource }";
                $('#removeResult').html('');
                $('#btnDetach').remove();

                queryToResult(qTotal, function(result) {
                    var total = result[0].total.value;
                    if (total > 1) {
                        //console.log(selector);
                        var text = 'Info: This selector is associated with more that one resource. You can opt to only detach the selector. ';
                        $('#removeResult').html(text);
                        $('#rmbtns').append('<a class="btn btn-warning loading" id="btnDetach" onclick="detachSelector(\'' + selector + '\');">Detach <i class="icon icon-minus icon-white"></i></a>');
                    }
                });

            }
            function detachSelector(selector) {
                var urlDelete = "../../api/" + getApiKey() + "/delete/";
                //callAPI(urlDelete + lastPath() + "/" + "coeus:isKeyOf" + "/coeus:" + selector, '#res');

                timer = setTimeout(function() {
                    $('#closeRemoveModal').click();
                    refresh();
                }, delay);

                var url = urlDelete + lastPath() + "/" + "coeus:loadsFrom" + "/coeus:" + selector;
                callURL(url, showResult.bind(this, "#removeResult", url), showError.bind(this, "#removeResult", url));
                var url = urlDelete + "coeus:" + selector + "/" + "coeus:loadsFor/" + lastPath();
                callURL(url, showResult.bind(this, "#removeResult", url), showError.bind(this, "#removeResult", url));

            }
            function editSelector(selector) {
                resetSelectorModal();
                $('#selectorsModalLabel').html("Edit Selector");
                console.log($('#selectorsModalLabel').html());
                $('#selectorUri').html("coeus:" + selector);
                var q = "SELECT * {coeus:" + selector + " dc:title ?title . coeus:" + selector + " rdfs:label ?label . coeus:" + selector + " coeus:property ?property . coeus:" + selector + " coeus:query ?query . OPTIONAL { coeus:" + selector + " coeus:isKeyOf ?key } . OPTIONAL { coeus:" + selector + " coeus:regex ?regex }}";
                queryToResult(q, function(result) {
                    //FILL THE VALUES
                    $('#titleSelectors').val(result[0].title.value);
                    //document.getElementById('titleSelectors').setAttribute("disabled");
                    $('#labelSelectors').val(result[0].label.value);
                    $('#propertySelectors').val(result[0].property.value);
                    $('#querySelectors').val(result[0].query.value);
                    if (result[0].regex !== undefined) {
                        $('#regexSelectors').val(result[0].regex.value);
                        $('#oldRegexSelectors').val(result[0].regex.value);
                    } else {
                        $('#regexSelectors').val('');
                        $('#oldRegexSelectors').val('');
                    }
                    if (result[0].key !== undefined) {
                        $('#keySelectorsForm').prop('checked', true);
                        $('#oldKeySelectors').val('true');
                    }
                    else {
                        $('#keySelectorsForm').prop('checked', false);
                        $('#oldKeySelectors').val('false');
                    }
                    //SAVE OLD VALUES IN A STATIC FIELD
                    $('#oldTitleSelectors').val(result[0].title.value);
                    $('#oldLabelSelectors').val(result[0].label.value);
                    $('#oldPropertySelectors').val(result[0].property.value);
                    $('#oldQuerySelectors').val(result[0].query.value);

                    //fill the properties
                    buildSelectoresProperties();
                });

                //$('#callSelectorsModal').click();
            }
            function resetSelectorModal() {
                $('#selectorUri').html("coeus:");
                $('#selectorsModalLabel').html("Add Selector");
                $('#titleSelectors').val("");
                //document.getElementById('titleSelectors').removeAttribute("disabled");
                $('#labelSelectors').val("");
                $('#propertySelectors').val("");
                $('#querySelectors').val("");
                $('#regexSelectors').val("");
                $('#keySelectorsForm').prop('checked', false);
                $('#selectorsResult').html("");
                buildSelectoresProperties();
            }

            function addSelector() {
                var urlWrite = "../../api/" + getApiKey() + "/write/";

                var type = $('#publisher').html().toUpperCase();
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
                var link = $('#uri').html();

                var predType = "rdf:type";
                var predTitle = "dc:title";
                var predLabel = "rdfs:label";

                // verify all fields:
                var empty = false;
                if (title === '') {
                    $('#titleSelectorsForm').addClass('has-error');
                    empty = true;
                }
                if (label === '') {
                    $('#labelSelectorsForm').addClass('has-error');
                    empty = true;
                }
                if (property === '') {
                    $('#propertySelectorsForm').addClass('has-error');
                    empty = true;
                }
                if (query === '') {
                    $('#querySelectorsForm').addClass('has-error');
                    empty = true;
                }
                if (!empty) {

                    timer = setTimeout(function() {
                        $('#closeSelectorsModal').click();
                        refresh();
                    }, delay);

                    var url = urlWrite + individual + "/" + predType + "/owl:NamedIndividual";
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    url = urlWrite + individual + "/" + predType + "/coeus:" + type;
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    url = urlWrite + individual + "/" + predTitle + "/xsd:string:" + title;
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    url = urlWrite + individual + "/" + "coeus:loadsFor" + "/" + link;
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    url = urlWrite + link + "/" + "coeus:loadsFrom" + "/" + individual;
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    url = urlWrite + individual + "/" + predLabel + "/xsd:string:" + label;
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    url = urlWrite + individual + "/" + "coeus:property" + "/xsd:string:" + property;
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    url = urlWrite + individual + "/" + "coeus:query" + "/xsd:string:" + query;
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));

                    if (key) {
                        url = urlWrite + individual + "/" + "coeus:isKeyOf" + "/" + link;
                        callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                        url = urlWrite + link + "/" + "coeus:hasKey" + "/" + individual;
                        callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    }
                    if (regex !== '') {
                        url = urlWrite + individual + "/" + "coeus:regex" + "/xsd:string:" + regex;
                        callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    }

                }
            }
            function submitSelector() {
                if ($('#selectorsModalLabel').html() === "Edit Selector")
                    updateSelector();
                else
                    addSelector();
            }

            function updateSelector() {
                var urlUpdate = "../../api/" + getApiKey() + "/update/";
                var urlDelete = "../../api/" + getApiKey() + "/delete/";
                var urlWrite = "../../api/" + getApiKey() + "/write/";

                var individual = $('#selectorUri').html();
                var link = $('#uri').html();

                timer = setTimeout(function() {
                    $('#closeSelectorsModal').click();
                    refresh();
                }, delay);

                var url;
                if ($('#oldTitleSelectors').val() !== $('#titleSelectors').val()) {
                    url = urlUpdate + individual + "/" + "dc:title" + "/xsd:string:" + $('#oldTitleSelectors').val() + ",xsd:string:" + $('#titleSelectors').val();
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                }
                if ($('#oldLabelSelectors').val() !== $('#labelSelectors').val()) {
                    url = urlUpdate + individual + "/" + "rdfs:label" + "/xsd:string:" + $('#oldLabelSelectors').val() + ",xsd:string:" + $('#labelSelectors').val();
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                }
                if ($('#oldPropertySelectors').val() !== $('#propertySelectors').val()) {
                    url = urlUpdate + individual + "/" + "coeus:property" + "/xsd:string:" + $('#oldPropertySelectors').val() + ",xsd:string:" + $('#propertySelectors').val();
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                }
                if ($('#oldQuerySelectors').val() !== $('#querySelectors').val()) {
                    url = urlUpdate + individual + "/" + "coeus:query" + "/xsd:string:" + encodeBars($('#oldQuerySelectors').val()) + ",xsd:string:" + encodeBars($('#querySelectors').val());
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                }
                if ($('#oldRegexSelectors').val() !== $('#regexSelectors').val()) {
                    if (($('#oldRegexSelectors').val()) !== '' && ($('#regexSelectors').val()) === '') {
                        url = urlDelete + individual + "/" + "coeus:regex" + "/xsd:string:" + $('#oldRegexSelectors').val();
                    } else if (($('#oldRegexSelectors').val()) === '' && ($('#regexSelectors').val() !== '')) {
                        url = urlWrite + individual + "/" + "coeus:regex" + "/xsd:string:" + $('#regexSelectors').val();
                    } else {
                        url = urlUpdate + individual + "/" + "coeus:regex" + "/xsd:string:" + $('#oldRegexSelectors').val() + ",xsd:string:" + $('#regexSelectors').val();
                    }
                    callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                }
                if ($('#oldKeySelectors').val().toString() !== $('#keySelectorsForm').is(':checked').toString()) {
                    //change: false to true
                    if ($('#keySelectorsForm').is(':checked')) {
                        url = urlWrite + individual + "/" + "coeus:isKeyOf" + "/" + link;
                        callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                        url = urlWrite + link + "/" + "coeus:hasKey" + "/" + individual;
                        callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    }//change: true to false
                    else {
                        url = urlDelete + individual + "/" + "coeus:isKeyOf" + "/" + link;
                        callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                        url = urlDelete + link + "/" + "coeus:hasKey" + "/" + individual;
                        callURL(url, showResult.bind(this, "#selectorsResult", url), showError.bind(this, "#selectorsResult", url));
                    }
                }
            }

            function changeSelectorURI(value) {
                //var specialChars = "!@#$^&%*()+=-[]\/{}|:<>?,. ";
                if ($('#selectorsModalLabel').html() === "Add Selector")
                    document.getElementById('selectorUri').innerHTML = 'coeus:selector_' + $('#concept').html().replace('coeus:concept_', '') + '_' + value.split(' ').join('_');
            }
            function fillBreadcumb(result) {
                var seed = result[0].seed.value;
                var entity = result[0].entity.value;
                var concept = result[0].concept.value;
                seed = "coeus:" + splitURIPrefix(seed).value;
                entity = "coeus:" + splitURIPrefix(entity).value;
                concept = "coeus:" + splitURIPrefix(concept).value;
                $('#selectorsSeed').val(seed);
                $('#breadSeed').html('<a href="../seed/' + seed + '">Dashboard</a>');
                $('#breadEntities').html('<a href="../entity/' + seed + '">Entities</a>');
                $('#breadConcepts').html('<a href="../concept/' + entity + '">Concepts</a> ');
                $('#breadResources').html('<a href="../resource/' + concept + '">Resources</a>');
                $('#concept').html(splitURIPrefix(concept).value);
            }
            function keyboard(event) {
                //Enter key pressed
                if (event.charCode === 13)
                    testMode();
            }

            // Callback to generate the pages header 
            function fillHeader(result) {
                $('#header').html('<h1><span class="tip" data-toggle="tooltip" title="Resource URI">' + lastPath() + '</span><small id="env" class="pull-right tip" data-toggle="tooltip" title="Selected environment">  ' + result.config.environment + '</small></h1>');
                $('#apikey').html(result.config.apikey);
            }
            function updateSelectorProperties() {
                var typeahead = $('#typeahead').val();
                var prop = $('#propertySelectors').val();

                if (typeahead !== "" && prop.indexOf(typeahead) === -1) {
                    if (prop !== "")
                        prop = prop + "|";
                    $('#propertySelectors').val(prop + typeahead);
                    $('#typeahead').val("");

                    buildSelectoresProperties();

                }
            }
            function buildSelectoresProperties() {
                var array = $('#propertySelectors').val().split("|");
                $('#dropdownprop').html("");
                console.log(array);
                for (var i in array) {
                    $('#dropdownprop').append('<option id="' + array[i] + '">' + array[i] + '</option>');
                }
            }
            function removeSelectorProperty() {
                var e = document.getElementById("dropdownprop");
                try {
                    var value = e.options[e.selectedIndex].id;
                    removeById(value, "dropdownprop");
                    buildInputProperties();
                } catch (e) {
                }

            }
            function buildInputProperties() {
                var values = [];
                var sel = document.getElementById('dropdownprop');
                for (var i = 0, n = sel.options.length; i < n; i++) {
                    if (sel.options[i].value) values.push(sel.options[i].value);
                }
                $('#propertySelectors').val(values.join("|"));
            }
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <div id="header" class="page-header"></div>
            <div id="apikey" class="hide"></div>
            <div id="concept" class="hide"></div>
            <ul class="breadcrumb">
                <li id="breadHome"><i class="glyphicon glyphicon-home"></i></li>
                <li id="breadSeeds"><a href="../seed/">Seeds</a> </li>
                <li id="breadSeed"></li>
                <li id="breadEntities"></li>
                <li id="breadConcepts"></li>
                <li id="breadResources"></li>
                <li class="active">Configuration</li>
            </ul>
            <div id="info"></div>
            <p class="lead" >Resource URI - <span class="lead text-info" id="uri">coeus: </span></p>

            <div class="row">
                <div id="selectorsForm" class="col-md-10">
                    <label for="selectorsForm">
                        <h4>Selectors Configuration - <span class="text-info tip" data-toggle="tooltip" title="Publisher type" id="publisher"></span></h4>
                    </label>
                    <table class="table table-hover table-bordered col-md-4">
                        <thead>
                            <tr>
                                <th>URI</th>
                                <th>Title</th>
                                <th>Query</th>
                                <th>Property</th>
                                <th>Regex</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="selectors"></tbody>
                    </table>
                    <div class="text-right">
                        <button onclick="resetSelectorModal();" type="button" id="addselector"
                                href="#selectorsModal" role="button" data-toggle="modal" class="btn btn-success">New <i class="fa fa-plus-circle"></i> 
                        </button>
                        <button type="button" id="existingSelector" href="#existingSelectorsModal"
                                role="button" data-toggle="modal" class="btn btn-warning">Existing <i class="fa fa-plus-circle"></i> 
                        </button>
                        <!--<button type="button" id="done" class="btn btn-info" onclick="window.history.back(-1);">Done</button>-->
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div id="selectorsModal" class="modal fade" tabindex="-1" role="dialog"
             aria-labelledby="selectorsModal" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content"></div>
            </div>
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button id="closeSelectorsModal" type="button" class="close" data-dismiss="modal"
                                aria-hidden="true">x</button>
                        <h3 id="selectorsModalLabel" class="modal-title">Add Selector</h3>
                    </div>
                    <div class="modal-body">
                        <div id="selectorsResult"></div>
                        <p class="lead">Selector URI - <span class="lead  text-info" id="selectorUri">coeus: </span>
                        </p>
                        <label label-default="label-default" class="checkbox">
                            <input type="checkbox" id="keySelectorsForm" /><span class="label label-success tip" data-toggle="tooltip" title="The key selector will be used to generate unique Item individual identifications (i.e. URIs) from the integrated resources.">Key</span>
                        </label>
                        <div class="row">
                            <div class="col-md-6">
                                <div id="titleSelectorsForm" class="form-group">
                                    <label for="title">Title</label>
                                    <input id="titleSelectors" type="text" placeholder="Ex: Id" class="form-control tip" data-toggle="tooltip" title="The title (dc:title) property."
                                           onkeyup="changeSelectorURI(this.value);" /> 
                                </div>
                                <div id="labelSelectorsForm" class="form-group">
                                    <label for="label label-default">Label</label>
                                    <input id="labelSelectors" type="text" placeholder="Ex: Uniprot Resource" class="form-control tip" data-toggle="tooltip" title="Add a triple with the rdfs:label property"/> 
                                </div>
                                <div id="querySelectorsForm" class="form-group">
                                    <label for="label label-default">Query</label>
                                    <input id="querySelectors" type="text" placeholder="Ex: /name" class="form-control tip" data-toggle="tooltip" title="Individual object query: CSV (column number), XML (XPath query), SQL (column name), etc. For more, see documentation."/>
                                </div>
                                <div id="regexSelectorsForm" class="form-group">
                                    <label for="regexSelectors">Regex</label>
                                    <input id="regexSelectors" type="text" placeholder="Ex: [0-9]" class="form-control tip" data-toggle="tooltip" title="Regular expression to get Item individual identification token from integrated resources"/>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div id="propertySelectorsForm" >
                                    <div class="form-group">
                                        <label >Search Property</label>
                                        <div class="input-group">
                                            <input class="twitter-typeahead form-control tip" id="typeahead" type="text" data-toggle="tooltip" title="Search and press the plus button to add it to the list"/>
                                            <span class="input-group-btn" ><button id="btnPlus" class="btn btn-success tip" data-toggle="tooltip" title="Add a property to the list" type="button" onclick="updateSelectorProperties();"><i class="fa fa-plus-circle"></i></button></span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <!--<a class="btn btn-sm btn-success" onclick="updateSelectorProperties();"
                                        data-toggle="tooltip" title="Press this button or press Enter to add an
                                        property to the list.">Add to List <i class="glyphicon glyphicon-plus-sign icon-white"></i></a>-->
                                        <label for="dropdownprop">Property List</label>
                                        <div class="input-group">
                                            <select class="form-control tip" id="dropdownprop" multiple="multiple" data-toggle="tooltip" title="Properties define the predicates to where integrated will be loaded to."></select> 
                                            <span class="input-group-btn" ><a class="btn btn-danger tip"
                                                                              onclick="removeSelectorProperty();" data-toggle="tooltip" title="Select one element of list and press this button to remove it."><i class="fa fa-trash-o"></i></a>
                                            </span></div><input id="propertySelectors" type="hidden" />
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" id="oldTitleSelectors" value="" />
                            <input type="hidden" id="oldLabelSelectors" value="" />
                            <input type="hidden" id="oldPropertySelectors" value="" />
                            <input type="hidden" id="oldQuerySelectors" value="" />
                            <input type="hidden" id="oldRegexSelectors" value="" />
                            <input type="hidden" id="oldKeySelectors" value="" />
                            <input type="hidden" id="selectorsSeed" value="" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
                        <button class="btn btn-primary loading" id="addSelectorButton"
                                onclick="submitSelector();">Save Changes</button>
                    </div>
                </div>
            </div>
        </div>



        <!-- Add Existing Selector Modal -->
        <div id="existingSelectorsModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button id="closeExistingSelectorsModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 class="modal-title">Add Existing Selector</h3>
                    </div>

                    <div class="modal-body">
                        <div id="existingSelectorsResult"></div>
                        <table class="table table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>URI</th>
                                    <th>Title</th>
                                    <th>Query</th>
                                    <th>Property</th>
                                    <!--<th>Regex</th>-->
                                    <th>Choose</th>
                                </tr>
                            </thead>
                            <tbody id="existingSelectors">

                            </tbody>
                        </table>
                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                        <!--<button class="btn btn-info" onclick="window.location.reload();">Done</button>-->
                    </div>
                </div>
            </div>
        </div>

        <%@include file="/setup/modals/remove.jsp" %>

    </s:layout-component>
</s:layout-render>
