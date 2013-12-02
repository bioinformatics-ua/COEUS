/**
 * COEUS Setup JS functions (included in most pages..)
 */

/**
 * Return the Application path (instance)
 * @returns {String}
 */
function getApplicationPath() {
    return window.location.protocol + '//' + window.location.host + '/' + window.location.pathname.split('/')[1] + '/';
}

/**
 * Return the first pathname (default is 'coeus')
 * @returns {String}
 */
function getFirstPath() {
    return window.location.pathname.split('/')[1];
}

/**
 * init service prefix
 * @returns {query} */
function initSparqlerQuery() {
    var sparqler = new SPARQL.Service("/"+getFirstPath()+"/sparql");

    var prefixes = getPrefixURI();
    for (var key in prefixes) {
        sparqler.setPrefix(key, prefixes[key]);
    }

    var query = sparqler.createQuery();
    return query;
}

function getPrefixURI() {
    var prefixes = {
        dc: "http://purl.org/dc/elements/1.1/",
        rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        rdfs: "http://www.w3.org/2000/01/rdf-schema#",
        coeus: "http://bioinformatics.ua.pt/coeus/resource/",
        owl: "http://www.w3.org/2002/07/owl#"
    };
    return prefixes;
}

/**
 * Get the namespace prefix
 * 
 * @param {type} uri
 * @returns {undefined}
 */
function getPrefix(uri) {
    var prefixes = getPrefixURI();

    for (var key in prefixes) {
        if (prefixes[key] === uri)
            return key;
    }
    return '';
}

/**
 * Split the URI to give the namespace
 * @param {type} uri
 * @returns {splitURIPrefix.mapping}
 */
function splitURIPrefix(uri) {
    var value;
    var uriToSlit = uri;
    if (uriToSlit.indexOf("#") !== -1)
        value = uriToSlit.split('#').pop();
    else
        value = uriToSlit.split('/').pop();
    var namespace = uri.substr(0, uri.length - value.length);

    var mapping = {
        "namespace": namespace,
        "value": value
    };

    return mapping;
}
/**
 * Call api through URL and change the HTML (component id) according to the result.
 * @param {type} url
 * @param {type} html
 * @returns {undefined}
 */
//function callAPI(url, html) {
//    url = encodeURI(url);
//    $.ajax({url: url, async: false, dataType: 'json'}).done(function(data) {
//        console.log(url + ' ' + data.status);
//        if (data.status === 100) {
//            //$(html).append('Call: ' + url + '<br/> Message: ' + data.message+'<br/><br/>');
//            $(html).addClass('alert alert-success');
//        } else {
//            $(html).addClass('alert alert-danger');
//            $(html).append('Call: ' + url + '<br/>Status: ' + data.status + ' Message: ' + data.message + '<br/><br/>');
//        }
//
//    }).fail(function(jqXHR, textStatus) {
//        $(html).addClass('alert alert-danger');
//        $(html).append('Call: ' + url + '<br/> ' + 'ERROR: ' + textStatus + '<br/><br/>');
//        // Server communication error function handler.
//    });
//}
/**
 * Return the first apikey
 * 
 * @returns {unresolved} */
function getApiKey() {
    return document.getElementById('apikey').innerHTML.split('|')[0];
}
/**
 * Return last element divided by / of url
 * @returns {unresolved}
 */
function lastPath() {
    var pathArray = window.location.pathname.split('/');
    var path = pathArray[pathArray.length - 1];
    return path;
}

/**
 * Return penultimate element divided by / of url
 * @returns {unresolved}
 */
function penulPath() {
    var pathArray = window.location.pathname.split('/');
    var path = pathArray[pathArray.length - 2];
    return path;
}

function redirect(location) {
    window.location = location;
}
/**
 * 
 * remove all subjects and predicates associated. 
 * 
 * example urlPrefix = "../../api/" + getApiKey() ;
 * 
 * @param {type} urlPrefix
 * @param {type} object
 * @returns {undefined}
 */
function removeAllTriplesFromObject(urlPrefix, object, showResult, showError) {

    var qObject = "SELECT ?subject ?predicate {?subject ?predicate " + object + " . }";
    queryToResult(qObject, foreachRemoveObjects.bind(this, urlPrefix, object, showResult, showError));
}
function foreachRemoveObjects(urlPrefix, object, showResult, showError, result) {
    console.log(result);
    for (var r in result) {
        var subject = resultToObject(result[r].subject);
        var predicate = resultToPredicate(result[r].predicate);

        var url = "/delete/" + subject.prefix + subject.value + '/' + predicate.prefix + predicate.value + '/' + object;

        console.log("Delete call: " + urlPrefix + url);
        callURL(urlPrefix + url, showResult, showError);
    }
}

/**
 * Clears all unlinked triples in the DB
 * @param {type} urlPrefix
 * @param {type} showResult
 * @param {type} showError
 * @returns {undefined}
 */
function cleanUnlikedTriples(urlPrefix, showResult, showError) {
    console.log("cleanUnlikedTriples call");
    //Clean unlinked entities
    var qEntities = "SELECT * {{ ?entity a coeus:Entity . FILTER NOT EXISTS{ ?entity coeus:isIncludedIn ?seed }}UNION {?entity a coeus:Entity . FILTER NOT EXISTS { ?seed coeus:includes ?entity }} }";
    queryToResult(qEntities, function(result) {
        for (var r in result) {
            var entity = splitURIPrefix(result[r].entity.value);
            var prefix = getPrefix(entity.namespace) + ":";
            removeAllTriplesFromSubject(urlPrefix, prefix + entity.value, showResult, showError);
        }
    });
    //Clean unlinked concepts
    var qConcepts = "SELECT * {{ ?concept a coeus:Concept . FILTER NOT EXISTS{ ?concept coeus:hasEntity ?entity }}UNION {?concept a coeus:Concept . FILTER NOT EXISTS { ?entity coeus:isEntityOf ?concept }} }";
    queryToResult(qConcepts, function(result) {
        for (var r in result) {
            var concept = splitURIPrefix(result[r].concept.value);
            var prefix = getPrefix(concept.namespace) + ":";
            removeAllTriplesFromSubject(urlPrefix, prefix + concept.value, showResult, showError);
        }
    });
    //Clean unlinked resources
    var qResources = "SELECT * {{ ?resource a coeus:Resource . FILTER NOT EXISTS{ ?resource coeus:isResourceOf ?concept} }UNION {?resource a coeus:Resource . FILTER NOT EXISTS { ?concept coeus:hasResource ?resource}} }";
    queryToResult(qResources, function(result) {
        for (var r in result) {
            var resource = splitURIPrefix(result[r].resource.value);
            var prefix = getPrefix(resource.namespace) + ":";
            removeAllTriplesFromSubject(urlPrefix, prefix + resource.value, showResult, showError);
        }
    });
    //Clean unlinked selectores
    var qSelectores = "SELECT * {{ ?selector coeus:property ?property . FILTER NOT EXISTS { ?selector coeus:loadsFor ?resource } }UNION {?selector coeus:property ?property . FILTER NOT EXISTS { ?resource coeus:loadsFrom ?selector}}}";
    queryToResult(qSelectores, function(result) {
        for (var r in result) {
            var selector = splitURIPrefix(result[r].selector.value);
            var prefix = getPrefix(selector.namespace) + ":";
            removeAllTriplesFromSubject(urlPrefix, prefix + selector.value, showResult, showError);
        }
    });
}

//function isModel(key) {
//    var b = false;
//
//    if (key.indexOf("coeus:seed_") !== -1 | key.indexOf("coeus:entity_") !== -1 | key.indexOf("coeus:concept_") !== -1 | key.indexOf("coeus:resource_") !== -1)
//        b = true;
//
//    console.log(key + ' ' + b);
//    return b;
//
//}
//
//function removeRecursive(urlPrefix, subject) {
//    var query = initSparqlerQuery();
//    var qObject = "SELECT ?predicate ?object {" + subject + " ?predicate ?object . }";
//    console.log("Recursive call: " + qObject);
//    query.query(qObject,
//            {success: function(json) {
//                    var result = json.results.bindings;
//
//                    for (var r in result) {
//                        var object = resultToObject(result[r].object);
//                        var predicate = resultToPredicate(result[r].predicate);
//
//                        var url = "/delete/" + subject + '/' + predicate.prefix + predicate.value + '/' + object.prefix + object.value;
//                        console.log("Recursive Delete call: " + urlPrefix + url);
//                        //callAPI(urlPrefix + url, "#result");
//                        if (isModel(object.prefix + object.value)) {
//                            // console.log("Another recursive call: "+url);
//                            //removeRecursive(urlPrefix, object.prefix + object.value);
//                        }
//
//                    }
//
//
//                }}
//    );
//}

/**
 * Remove all triples associated with the subject 
 * 
 * @param {type} urlPrefix
 * @param {type} subject
 * @param {type} showResult
 * @param {type} showError
 * @returns {undefined}
 */
function removeAllTriplesFromSubject(urlPrefix, subject, showResult, showError) {
    var qSubject = "SELECT ?predicate ?object {" + subject + " ?predicate ?object . }";
    queryToResult(qSubject, foreachRemoveSubjects.bind(this, urlPrefix, subject, showResult, showError)
            );
}
function foreachRemoveSubjects(urlPrefix, subject, showResult, showError, result) {
    console.log(result);
    for (var r in result) {
        var object = resultToObject(result[r].object);
        var predicate = resultToPredicate(result[r].predicate);

        var url = "/delete/" + subject + '/' + predicate.prefix + predicate.value + '/' + object.prefix + object.value;
        console.log("Deleting: " + url);
        callURL(urlPrefix + url, showResult, showError);
    }
}

/**
 * Removes all resources errors (dc:coverage property).
 * @param {type} urlPrefix
 * @param {type} showResult
 * @param {type} showError
 * @returns {undefined}
 */
function cleanResourceErrors(urlPrefix,showResult, showError){
    var qCleanErrors = "SELECT ?resource ?object {?resource dc:coverage ?object . ?resource a coeus:Resource}";
    queryToResult(qCleanErrors, foreachCleanResourceErrors.bind(this, urlPrefix, showResult, showError));
}
function foreachCleanResourceErrors(urlPrefix, showResult, showError, result){
    for (var r in result) {
        var object = resultToObject(result[r].object);
        var resource = resultToObject(result[r].resource);

        var url = "/delete/" + resource.prefix + resource.value + '/dc:coverage/' + object.prefix + object.value;
        console.log("Deleting: " + url);
        callURL(urlPrefix + url, showResult, showError);
    }
}
//function removeAllTriplesFromSubjectAndPredicate(urlPrefix, subject, predicate) {
//    var qSubject = "SELECT ?object {" + subject + " " + predicate + " ?object . }";
//    console.log(qSubject);
//    queryToResult(qSubject, function(result) {
//        console.log(result);
//        for (var r in result) {
//            var object = resultToObject(result[r].object);
//
//            var url = "/delete/" + subject + '/' + predicate + '/' + object.prefix + object.value;
//            console.log(url);
//            callAPI(urlPrefix + url, "#result");
//        }
//
//        //if success refresh page
//        if (document.getElementById('result').className !== 'alert alert-danger') {
//            // window.location="../entity/"+lastPath();
//            console.log("REDIRECTING...");
//            //window.location.reload(true);
//        }
//    }
//    );
//}
//function removeAllTriplesFromPredicateAndObject(urlPrefix, predicate, object) {
//    var qSubject = "SELECT ?subject {?subject " + predicate + " " + object + " . }";
//    console.log(qSubject);
//    queryToResult(qSubject, function(result) {
//        console.log(result);
//        for (var r in result) {
//            var subject = resultToPredicate(result[r].subject);
//
//            var url = "/delete/" + subject.prefix + subject.value + '/' + predicate + '/' + object;
//            //console.log(url);
//            callAPI(urlPrefix + url, "#result");
//        }
//    }
//    );
//}

/**
 *  Converts a object from the json result to a url usage
 * @param {type} object
 * @returns {resultToObject.mapping}
 */
function resultToObject(object) {
    var val = object.value;
    var objectPrefix = '';

    if (object.type === "uri") {
        var splitedObject = splitURIPrefix(val);
        val = splitedObject.value;
        objectPrefix = getPrefix(splitedObject.namespace);
    }

    if (objectPrefix !== '')
        objectPrefix = objectPrefix + ':';
    else
        objectPrefix = 'xsd:' + splitURIPrefix(object.datatype).value + ':' + objectPrefix;
    //TO ALLOW '/' in the string call encodeBars(string);
    var mapping = {
        "prefix": objectPrefix,
        "value": encodeBars(val)
    };
    return mapping;
}
/**
 * Converts a predicate from the json result to a url usage
 * @param {type} pred
 * @returns {resultToPredicate.mapping}
 */
function resultToPredicate(pred) {
    var splitedPredicate = splitURIPrefix(pred.value);
    var predicatePrefix = getPrefix(splitedPredicate.namespace);
    if (predicatePrefix !== '')
        predicatePrefix = predicatePrefix + ':';

    var mapping = {
        "prefix": predicatePrefix,
        "value": splitedPredicate.value
    };

    return mapping;

}
/**
 * Do a query to retrive the result in a callback way 
 * 
 * return callback(result);
 * 
 * @param {type} selectQuery
 * @param {type} callback
 * @returns {undefined}
 */
function queryToResult(selectQuery, callback) {
    var query = initSparqlerQuery();
    query.query(selectQuery,
            {success: function(json) {
                    var result = json.results.bindings;
                    //console.log(result);
                    callback(result);
                }}
    );
}

/**
 * Manually encode of some chars (;/#?)
 * @param {type} value
 * @returns {unresolved}
 */
function encodeBars(value) {
    value = value.split(';').join('%3B');
    value = value.split('/').join('%2F');
    value = value.split('#').join('%23');
    value = value.split('?').join('%3F');
    return value;
}
/**
 * Remove an component by id
 * @param {type} childDiv
 * @param {type} parentDiv
 * @returns {undefined}
 */
function removeById(childDiv, parentDiv)
{
    console.log(childDiv + ' ' + parentDiv);
    if (childDiv === parentDiv) {
        alert("The parent div cannot be removed.");
    }
    else if (document.getElementById(childDiv)) {
        var child = document.getElementById(childDiv);
        var parent = document.getElementById(parentDiv);
        parent.removeChild(child);
    }
    else {
        alert("Child div has already been removed or does not exist.");
    }
}

/**
 * Call a url with 2 callbacks functions (success or error)
 * 
 * @param {type} url
 * @param {type} success
 * @param {type} error
 * @returns {undefined}
 */
function callURL(url, success, error) {
    url = encodeURI(url);
    console.log(url);
    $.ajax({url: url, dataType: 'json'}).done(success).fail(error);
}

/**
 * Generate a html code message 
 * Ex: var htmlMessage=generateHtmlMessage("Error!", "It already exists!","alert-danger");
 * 
 * @param {type} strong
 * @param {type} message
 * @param {type} type
 * @returns {String}
 */
function generateHtmlMessage(strong, message, type) {
    var error = '<div class="alert ' + type + '"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>' + strong + '</strong> ' + message + '</div>';
    return error;
}

/**
 * Begin of the code used to manage the modals (Seed,Entity,Concept)
 */

/**
 * Associate click event to loading btn's.
 */
$('.loading').click(function() {
    var text = $(this).html();
    $(this).html('Waiting...');
    $(this).addClass('disabled');
    setTimeout(btnInit.bind(this, text), 1500);

    function btnInit(text) {
        $(this).html(text);
        $(this).removeClass('disabled');
    }
});
//timer for manage success or errors on modals
var timer;
var delay = 1000;

/**
 * Remove the link between the triples and the triples
 * @returns {undefined}
 */
function removeTriples() {
    var individual = $('#removeModalLabel').html();
    console.log('Remove: ' + individual);

    var urlPrefix = "../../api/" + getApiKey();
    //remove all subjects and predicates associated.
    removeAllTriplesFromObject(urlPrefix, individual, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));
    //remove all predicates and objects associated.            
    removeAllTriplesFromSubject(urlPrefix, individual, showResult.bind(this, "#removeResult", ""), showError.bind(this, "#removeResult", ""));

    timer = setTimeout(function() {
        $('#closeRemoveModal').click();
        refresh();
    }, delay);

}
/**
 * remove preview - called before remove
 * @param {type} individual
 * @returns {undefined}
 */
function selectToRemove(individual) {
    $('#removeResult').html("");
    $('#removeModalLabel').html(individual);
    if (individual.indexOf('coeus:entity') === 0) {
        $('#removeType').html("Entity");
    } else if (individual.indexOf('coeus:concept') === 0) {
        $('#removeType').html("Concept");
    } else if (individual.indexOf('coeus:seed') === 0) {
        $('#removeType').html("Seed");
    } else if (individual.indexOf('coeus:resource') === 0) {
        $('#removeType').html("Resource");
    } else {
    }
}
//End of Remove functions
//Edit functions
/**
 * Edit preview for Seed,Entity or Concept
 * @param {type} individual
 * @returns {undefined}
 */
function prepareEdit(individual) {
    //reset values
    $('#editResult').html("");
    document.getElementById('editURI').innerHTML = individual;
    if (individual.indexOf('coeus:entity') === 0) {
        $('#editType').html("Entity");
        $('#helpEdit').html("Entity individuals match the general data terms. These elements grouping concepts with a common set of properties.");
    } else if (individual.indexOf('coeus:concept') === 0) {
        $('#editType').html("Concept");
        $('#helpEdit').html("Concept individuals are area-specific terms, aggregating any number of items and belonging to a unique entity. Concept individuals are also connected to Resources.");
    } else if (individual.indexOf('coeus:seed') === 0) {
        $('#editType').html("Seed");
        $('#helpEdit').html("A Seed defines a single framework instance that permits access to all data available in the seed, providing an over-arching entry point to the system information. Seed individuals are also connected to included entities. ");
    } else {
    }

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
        $('#editResult').append(generateHtmlMessage("Error!", "Some fields do not exist." + err, "alert-danger"));
    }
    //PUT OLD VALUES IN THE STATIC FIELD
    $('#oldTitle').val($('#editTitle').val());
    $('#oldLabel').val($('#editLabel').val());
    $('#oldComment').val($('#editComment').val());

}
/**
 * Function to edit a Seed, Entity or Concept
 * @returns {undefined}
 */
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

/**
 * change the uri when the user fill the title box.
 * @param {type} type
 * @param {type} link
 * @returns {undefined}
 */
function changeURI(id, type, value) {
    document.getElementById(id).innerHTML = 'coeus:' + type.toLowerCase() + '_' + value.split(' ').join('_');
    //auto-fill label and comment
    if (type.toLowerCase() === "resource") {
        document.getElementById('label' + type).value = value + " Label";
        document.getElementById('comment' + type).value = value + " Description";
    } else {
        document.getElementById('label').value = value + " Label";
        document.getElementById('comment').value = value + " Description";
    }
}
/**
 * Function to be called before add a Seed, Entity or Concept
 * @param {type} type
 * @param {type} link
 * @returns {undefined}
 */
function prepareAdd(type, link) {
    $('#addResult').html("");
    $('#title').val("");
    $('#label').val("");
    $('#comment').val("");
    $('#linkedWith').val(link);
    //$('#addType').html(type);
    var individual = 'coeus:' + type.toLowerCase();
    document.getElementById('uri').innerHTML = individual;

    if (individual.indexOf('coeus:entity') === 0) {
        $('#addType').html("Entity");
        $('#helpAdd').html("Entity individuals match the general data terms. These elements grouping concepts with a common set of properties.");
    } else if (individual.indexOf('coeus:concept') === 0) {
        $('#addType').html("Concept");
        $('#helpAdd').html("Concept individuals are area-specific terms, aggregating any number of items and belonging to a unique entity. Concept individuals are also connected to Resources.");
    } else if (individual.indexOf('coeus:seed') === 0) {
        $('#addType').html("Seed");
        $('#helpAdd').html("A Seed defines a single framework instance that permits access to all data available in the seed, providing an over-arching entry point to the system information. Seed individuals are also connected to included entities. ");
    } else {
    }

}
/**
 * Function to add a Seed, Entity or Concept
 * @param {type} id
 * @param {type} url
 * @param {type} result
 * @returns {undefined}
 */
function add() {

    var individual = $('#uri').html();
    var type = $('#addType').html();
    console.log("Adding type: " + type);
    var title = $('#title').val();
    var label = $('#label').val();
    var comment = $('#comment').val();
    var urlWrite = "../../api/" + getApiKey() + "/write/";
    var link = $('#linkedWith').val();

    // verify all fields:
    var empty = false;
    if (title === '') {
        $('#titleForm').addClass('has-error');
        empty = true;
    } else
        $('#titleForm').removeClass('has-error');
    if (label === '') {
        $('#labelForm').addClass('has-error');
        empty = true;
    } else
        $('#labelForm').removeClass('has-error');
    if (comment === '') {
        $('#commentForm').addClass('has-error');
        empty = true;
    } else
        $('#commentForm').removeClass('has-error');
    if (!empty) {
        var array = new Array();
        var urlIndividual = urlWrite + individual + "/rdf:type/owl:NamedIndividual";
        var urlType = urlWrite + individual + "/rdf:type/coeus:" + type;
        var urlTitle = urlWrite + individual + "/dc:title/xsd:string:" + title;
        var urlLabel = urlWrite + individual + "/rdfs:label/xsd:string:" + label;
        var urlComment = urlWrite + individual + "/rdfs:comment/xsd:string:" + comment;
        if (type === 'Entity') {
            var urlIsIncludedIn = urlWrite + individual + "/coeus:isIncludedIn/" + link;
            var urlIncludes = urlWrite + link + "/coeus:includes/" + individual;
            array.push(urlIndividual, urlType, urlTitle, urlLabel, urlComment, urlIsIncludedIn, urlIncludes);
        } else if (type === 'Concept') {
            var urlHasEntity = urlWrite + individual + "/coeus:hasEntity/" + link;
            var urlIsEntityOf = urlWrite + link + "/coeus:isEntityOf/" + individual;
            array.push(urlIndividual, urlType, urlTitle, urlLabel, urlComment, urlHasEntity, urlIsEntityOf);
        } else {
            array.push(urlIndividual, urlType, urlTitle, urlLabel, urlComment);
        }
        submitIfNotExists(array, individual);
    }
}
function submitIfNotExists(array, individual) {
    var qSeeds = "SELECT (COUNT(*) AS ?total) {" + individual + " ?p ?o }";
    queryToResult(qSeeds, function(result) {
        if (result[0].total.value == 0) {

            timer = setTimeout(function() {
                if (individual.indexOf('coeus:resource') === 0) {
                    $('#closeAddResourceModal').click();
                    refresh();
                }
                else {
                    $('#closeAddModal').click();
                    refresh();
                }
            }, delay);

            if (individual.indexOf('coeus:resource') !== 0) {
                var idResult = "#addResult";
            } else {
                var idResult = "#addResourceResult";
            }
            //call the service
            array.forEach(function(url) {
                callURL(url, showResult.bind(this, idResult, url), showError.bind(this, idResult, url));

            });
        } else {
            console.log('This individual ' + individual + ' already exists.');
            if (individual.indexOf('coeus:resource') !== 0) {
                $('#addResult').append(generateHtmlMessage("Warning!", "This individual already exists. Try another title.", "alert-warning"));
            } else {
                $('#addResourceResult').append(generateHtmlMessage("Warning!", "This individual already exists. Try another title.", "alert-warning"));
            }
        }
    });
}
/**
 * show the retrived result in the div (id)
 * 
 * @param {type} id
 * @param {type} url
 * @param {type} result
 * @returns {undefined}
 */
function showResult(id, url, result) {
    if (result.status === 100) {
        $(id).append(generateHtmlMessage("Success!", url + "</br>" + result.message, "alert-success"));
    }
    else {
        clearTimeout(timer);
        $(id).append(generateHtmlMessage("Warning!", url + "</br>Status Code:" + result.status + " " + result.message, "alert-warning"));
    }
}
/**
 * show the error result in the div (id)
 * @param {type} id
 * @param {type} url
 * @param {type} jqXHR
 * @param {type} result
 * @returns {undefined}
 */
function showError(id, url, jqXHR, result) {
    clearTimeout(timer);
    $(id).append(generateHtmlMessage("Server error!", url + "</br>Status Code:" + result.status + " " + result.message, "alert-danger"));
}

/**
 * End of the code used to manage the modals (Seed,Entity,Concept)
 */

/**
 * Begin of the code used to manage the modals (Resource)
 */

/**
 * called before add resource to clean input fields
 * @param {type} link
 * @returns {undefined}
 */
function prepareAddResourceModal(link) {
    $('#addResourceResult').html("");
    $('#titleResource').val("");
    $('#labelResource').val("");
    $('#commentResource').val("");
    document.getElementById('resourceURI').innerHTML = 'coeus:resource';
    $('#method').val("");
    $('#publisher').val("");
    $('#endpoint').val("");
    $('#query').val("");
    $('#order').val("");
    $('#extends').val("");
    $('#resourceLink').val(link);
    publisherChange("Add");
    var q = "SELECT ?concept ?c {?entity coeus:isEntityOf " + link + " . ?seed coeus:includes ?entity . ?concept coeus:hasEntity ?ent . ?ent coeus:isIncludedIn ?seed . ?concept dc:title ?c}";
    queryToResult(q, fillConceptsExtension.bind(this, link));
}
function fillConceptsExtension(link, result) {
    $('#extends').html("");
    $('#editExtends').html("");
    $('#editConcept').html("");
    console.log(result);
    for (var r in result) {
        var concept = splitURIPrefix(result[r].concept.value);
        $('#extends').append('<option>' + concept.value + '</option>');
        $('#editExtends').append('<option>' + concept.value + '</option>');
        $('#editConcept').append('<option>' + concept.value + '</option>');
    }
    //Only on addResource
    if (link !== null)
        $('#extends option:contains(' + link.split(":")[1] + ')').prop({selected: true});
}
/**
 * Add a Resource
 * @returns {undefined}
 */
function addResource() {

    var type = 'Resource';
    var individual = $('#resourceURI').html();
    var title = $('#titleResource').val();
    var label = $('#labelResource').val();
    var comment = $('#commentResource').val();
    var method = $('#method').val();
    var publisher = $('#publisher').val();
    var endpoint = $('#endpoint').val();
    var query = $('#query').val();
    var order = $('#order').val();
    var concept_ext = $('#extends').val();
    var link = $('#resourceLink').val();
    var urlWrite = "../../api/" + getApiKey() + "/write/";

    // verify all fields:
    var empty = false;
    if (title === '') {
        $('#resourceTitleForm').addClass('has-error');
        empty = true;
    } else
        $('#resourceTitleForm').removeClass('has-error');
    if (label === '') {
        $('#resourceLabelForm').addClass('has-error');
        empty = true;
    } else
        $('#resourceLabelForm').removeClass('has-error');
    if (comment === '') {
        $('#resourceCommentForm').addClass('has-error');
        empty = true;
    } else
        $('#resourceCommentForm').removeClass('has-error');
    if ((endpoint === '') | ((!contains(endpoint, "http://")) && (!contains(endpoint, "https://")) && (!contains(endpoint, "file://")) && (!contains(endpoint, "jdbc:")))) {
        $('#endpointForm').addClass('has-error');
        $('#addResourceResult').html(generateHtmlMessage("Endpoint error:", "It can only start with \"http(s)://\" or \"file://\".", "alert-danger"));
        empty = true;
    } else
        $('#endpointForm').removeClass('has-error');
    if (query === '' && publisher !== ("csv")) {
        $('#queryForm').addClass('has-error');
        empty = true;
    } else
        $('#queryForm').removeClass('has-error');
    if (order === '') {
        $('#orderForm').addClass('has-error');
        empty = true;
    } else
        $('#orderForm').removeClass('has-error');
    if (!empty) {
        var array = new Array();
        var urlIndividual = urlWrite + individual + "/rdf:type/owl:NamedIndividual";
        var urlType = urlWrite + individual + "/rdf:type/coeus:" + type;
        var urlTitle = urlWrite + individual + "/dc:title/xsd:string:" + title;
        var urlLabel = urlWrite + individual + "/rdfs:label/xsd:string:" + label;
        var urlComment = urlWrite + individual + "/rdfs:comment/xsd:string:" + comment;
        var urlIsResourceOf = urlWrite + individual + "/" + "coeus:isResourceOf" + "/" + link;
        var urlHasResource = urlWrite + link + "/" + "coeus:hasResource" + "/" + individual;
        var urlMethod = urlWrite + individual + "/" + "coeus:method" + "/xsd:string:" + method;
        var urlPublisher = urlWrite + individual + "/" + "dc:publisher" + "/xsd:string:" + publisher;
        var urlEndpoint = urlWrite + individual + "/" + "coeus:endpoint" + "/xsd:string:" + encodeBars(endpoint);
        var urlQuery = urlWrite + individual + "/" + "coeus:query" + "/xsd:string:" + encodeBars(query);
        var urlOrder = urlWrite + individual + "/" + "coeus:order" + "/xsd:string:" + order;
        var urlExtends = urlWrite + individual + "/" + "coeus:extends" + "/coeus:" + concept_ext;
        var urlIsExtendedBy = urlWrite + "coeus:" + concept_ext + "/" + "coeus:isExtendedBy" + "/" + individual;
        var urlBuilt = urlWrite + individual + "/" + "coeus:built" + "/xsd:boolean:false";

        array.push(urlIndividual, urlType, urlTitle, urlLabel, urlComment, urlIsResourceOf, urlHasResource, urlMethod, urlPublisher, urlEndpoint, urlQuery, urlOrder, urlExtends, urlIsExtendedBy, urlBuilt);
        submitIfNotExists(array, individual);
    }
}
/**
 * Called when user change publisher in the modal Resource
 * @param {type} mode
 * @returns {undefined}
 */
function publisherChange(mode) {

    if (mode === 'edit') {
        //sql
        var publisher = $('#editPublisher').val();
        var sqlEnpointForm = '#editSqlEndpointForm';
        var enpointForm = '#editEndpointForm';
        var endpoint = '#editEndpoint';
        var driverEndpoint = '#editDriverEndpoint';
        var hostEndpoint = '#editHostEndpoint';
        var dbEndpoint = '#editDbEndpoint';
        var portEndpoint = '#editPortEndpoint';
        var userEndpoint = '#editUserEndpoint';
        var passwordEndpoint = '#editPasswordEndpoint';
        //csv
        var query = '#editQuery';
        var queryForm = '#editQueryForm';
        var csvQueryForm = '#editCsvQueryForm';
        var csvQueryDelimiter = '#editCsvQueryDelimiter';
        var csvQueryHeaderSkip = '#editCsvQueryHeaderSkip';
    } else {
        //sql
        var publisher = $('#publisher').val();
        var sqlEnpointForm = '#sqlEndpointForm';
        var enpointForm = '#endpointForm';
        var endpoint = '#endpoint';
        var driverEndpoint = '#driverEndpoint';
        var hostEndpoint = '#hostEndpoint';
        var dbEndpoint = '#dbEndpoint';
        var portEndpoint = '#portEndpoint';
        var userEndpoint = '#userEndpoint';
        var passwordEndpoint = '#passwordEndpoint';
        //csv
        var query = '#query';
        var queryForm = '#queryForm';
        var csvQueryForm = '#csvQueryForm';
        var csvQueryDelimiter = '#csvQueryDelimiter';
        var csvQueryHeaderSkip = '#csvQueryHeaderSkip';
    }

    if (publisher === "sql") {
        $(sqlEnpointForm).removeClass('hide');
        $(enpointForm).addClass('hide');
        var endpoint = $(endpoint).val();
        //Endpoint sqlserver example: jdbc:mysql://host:3306;database=name;user=user;password=pass
        //Endpoint mysql example: jdbc:mysql://host:3306/coeus?user=user&password=pass
        if (endpoint !== "") {
            try {
                var url = endpoint.split("://"); //[jdbc:mysql] :// [host:3306/coeus?user=user&password=pass]
                var driver = url[0].split("jdbc:")[1];
                if (driver === "sqlserver") {
                    //sqlserver
                    var cut = url[1].split(":");
                    var host = cut[0];
                    var cut2 = cut[1].split(";");
                    var port = cut2[0];
                    var db = cut2[1].split("database=")[1];
                    var user = cut2[2].split("user=")[1];
                    var password = cut2[3].split("password=")[1];
                } else {
                    //mysql
                    var splitHost = url[1].split(":"); //[host] : [3306/coeus?user=user&password=pass]
                    var host = splitHost[0];
                    var splitPort = splitHost[1].split("/"); // [3306] / [coeus?user=user&password=pass]
                    var port = splitPort[0];
                    var splitDB = splitPort[1].split("?");// [coeus] ? [user=user&password=pass]
                    var db = splitDB[0];
                    var user = splitDB[1].split("&")[0].split("=")[1];
                    var password = splitDB[1].split("&")[1].split("=")[1];
                }

            } catch (e) {
                //ignore errors
            }

            $(driverEndpoint).val(driver);
            $(hostEndpoint).val(host);
            $(dbEndpoint).val(db);
            $(portEndpoint).val(port);
            $(userEndpoint).val(user);
            $(passwordEndpoint).val(password);
        }

    } else {
        $(sqlEnpointForm).addClass('hide');
        $(enpointForm).removeClass('hide');
    }

    if (publisher === "csv") {
        $(queryForm).addClass('hide');
        $(csvQueryForm).removeClass('hide');

        query = $(query).val();

        if (query !== "") {
            var q = query.split("|");

            $(csvQueryDelimiter).val(q[1]);
            $(csvQueryHeaderSkip).val(q[0]);
        } else {
            $(csvQueryHeaderSkip).val("1");
            refreshQuery();
        }

    }
    else {
        $(csvQueryForm).addClass('hide');
        $(queryForm).removeClass('hide');
    }
}

/**
 * Called when user change endpoint in the modal Resource
 * @param {type} mode
 * @returns {undefined}
 */
function refreshEnpoint(mode) {

    if (mode === 'edit') {
        var portEndpoint = '#editPortEndpoint';
        var userEndpoint = '#editUserEndpoint';
        var passwordEndpoint = '#editPasswordEndpoint';
        var driverEndpoint = '#editDriverEndpoint';
        var hostEndpoint = '#editHostEndpoint';
        var dbEndpoint = '#editDbEndpoint';
        var endpoint = '#editEndpoint';
    } else {
        var portEndpoint = '#portEndpoint';
        var userEndpoint = '#userEndpoint';
        var passwordEndpoint = '#passwordEndpoint';
        var driverEndpoint = '#driverEndpoint';
        var hostEndpoint = '#hostEndpoint';
        var dbEndpoint = '#dbEndpoint';
        var endpoint = '#endpoint';
    }

    if ($(driverEndpoint).val() === "sqlserver") {
        var port = $(portEndpoint).val();
        if (port !== "")
            port = ":" + port;
        var user = $(userEndpoint).val();
        if (user !== "")
            user = ";user=" + user;
        var password = $(passwordEndpoint).val();
        if (password !== "")
            password = ";password=" + password;
        var endpointFinal = "jdbc:" + $(driverEndpoint).val() + "://" + $(hostEndpoint).val() + port + ";database=" + $(dbEndpoint).val() + user + password;
    } else {
        var port = $(portEndpoint).val();
        if (port !== "")
            port = ":" + port;
        var user = $(userEndpoint).val();
        if (user !== "")
            user = "user=" + user;
        var password = $(passwordEndpoint).val();
        if (password !== "")
            password = "password=" + password;
        var endpointFinal = "jdbc:" + $(driverEndpoint).val() + "://" + $(hostEndpoint).val() + port + "/" + $(dbEndpoint).val() + "?" + user + "&" + password;
    }
    $(endpoint).val(endpointFinal);
}

/**
 * Called when user change query in the modal Resource
 * @param {type} mode
 * @returns {undefined}
 */
function refreshQuery(mode) {
    if (mode === 'edit') {
        var delimiter = $('#editCsvQueryDelimiter').val();
        var header = $('#editCsvQueryHeaderSkip').val();
        $('#editQuery').val(header + "|" + delimiter);
    } else {
        var delimiter = $('#csvQueryDelimiter').val();
        var header = $('#csvQueryHeaderSkip').val();
        $('#query').val(header + "|" + delimiter);

    }
}
/**
 * Called before the edit of a Resource
 * @param {type} individual
 * @returns {undefined}
 */
function prepareResourceEdit(individual) {
    //reset values
    $('#editResourceResult').html("");
    document.getElementById('editResourceURI').innerHTML = individual;
    //CLEAN THE INPUT FIELDS
    $('#editResourceTitle').val("");
    $('#editResourceLabel').val("");
    $('#editResourceComment').val("");
    $('#editMethod').val("");
    $('#editPublisher').val("");
    $('#editEndpoint').val("");
    $('#editQuery').val("");
    $('#editOrder').val("");
    $('#editExtends').val("");
    $('#editConcept').val("");
    $('#built').prop('checked', false);

    //CLEAN ALSO OLD VALUES IN THE STATIC FIELD
    $('#oldTitle').val("");
    $('#oldLabel').val("");
    $('#oldComment').val("");
    $('#oldMethod').val("");
    $('#oldPublisher').val("");
    $('#oldEndpoint').val("");
    $('#oldQuery').val("");
    $('#oldOrder').val("");
    $('#oldExtends').val("");
    $('#oldConcept').val("");
    $('#oldBuilt').val("false");

    var q = "SELECT ?concept ?c {?concep coeus:hasResource " + individual + " . ?entity coeus:isEntityOf ?concep . ?seed coeus:includes ?entity . ?concept coeus:hasEntity ?ent . ?ent coeus:isIncludedIn ?seed . ?concept dc:title ?c}";
    queryToResult(q, fillConceptsExtension.bind(this, null));
    var q = "SELECT ?title ?label ?comment ?method ?publisher ?endpoint ?query ?order ?extends ?concept ?built {" + individual + " dc:title ?title . " + individual + " rdfs:label ?label . " + individual + " rdfs:comment ?comment . " + individual + " coeus:method ?method . " + individual + " dc:publisher ?publisher . " + individual + " coeus:endpoint ?endpoint . " + individual + " coeus:query ?query . " + individual + " coeus:order ?order . " + individual + " coeus:extends ?extends . " + individual + " coeus:isResourceOf ?concept . OPTIONAL{" + individual + " coeus:built ?built } }";
    queryToResult(q, fillResourceEdit);

}
function fillResourceEdit(result) {
    console.log(result);
    try
    {
        //PUT VALUES IN THE INPUT FIELD
        $('#editResourceTitle').val(result[0].title.value);
        $('#editResourceLabel').val(result[0].label.value);
        $('#editResourceComment').val(result[0].comment.value);
        $('#editMethod').val(result[0].method.value);
        $('#editPublisher option:contains(' + result[0].publisher.value + ')').prop({selected: true});
        $('#editEndpoint').val(result[0].endpoint.value);
        $('#editQuery').val(result[0].query.value);
        $('#editOrder').val(result[0].order.value);
        $('#editExtends option:contains(' + splitURIPrefix(result[0].extends.value).value + ')').prop({selected: true});
        $('#editConcept option:contains(' + splitURIPrefix(result[0].concept.value).value + ')').prop({selected: true});
        if (result[0].built !== undefined && result[0].built.value === "true")
            $('#built').prop('checked', true);
        else
            $('#built').prop('checked', false);
    }
    catch (err)
    {
        $('#editResourceResult').append(generateHtmlMessage("Error!", "Some fields do not exist." + err, "alert-danger"));
    }
    //PUT OLD VALUES IN THE STATIC FIELD
    $('#oldResourceTitle').val($('#editResourceTitle').val());
    $('#oldResourceLabel').val($('#editResourceLabel').val());
    $('#oldResourceComment').val($('#editResourceComment').val());
    $('#oldMethod').val($('#editMethod').val());
    $('#oldPublisher').val($('#editPublisher').val());
    $('#oldEndpoint').val($('#editEndpoint').val());
    $('#oldQuery').val($('#editQuery').val());
    $('#oldOrder').val($('#editOrder').val());
    $('#oldExtends').val(splitURIPrefix(result[0].extends.value).value);
    $('#oldConcept').val(splitURIPrefix(result[0].concept.value).value);
    $('#oldBuilt').val($('#built').is(':checked'));
    //change publisher according to the result
    publisherChange('edit');

}

/**
 * Called when a Resource is edited / updated
 * @returns {undefined}
 */
function editResource() {
    var individual = $('#editResourceURI').html();
    var urlUpdate = "../../api/" + getApiKey() + "/update/";
    var urlDelete = "../../api/" + getApiKey() + "/delete/";
    var urlWrite = "../../api/" + getApiKey() + "/write/";
    var url;
    var array = new Array();

    if ($('#oldResourceLabel').val() !== $('#editResourceLabel').val()) {
        url = urlUpdate + individual + "/" + "rdfs:label" + "/xsd:string:" + $('#oldResourceLabel').val() + ",xsd:string:" + $('#editResourceLabel').val();
        array.push(url);
    }
    if ($('#oldResourceTitle').val() !== $('#editResourceTitle').val()) {
        url = urlUpdate + individual + "/" + "dc:title" + "/xsd:string:" + $('#oldResourceTitle').val() + ",xsd:string:" + $('#editResourceTitle').val();
        array.push(url);
    }
    if ($('#oldResourceComment').val() !== $('#editResourceComment').val()) {
        url = urlUpdate + individual + "/" + "rdfs:comment" + "/xsd:string:" + $('#oldResourceComment').val() + ",xsd:string:" + $('#editResourceComment').val();
        array.push(url);
    }
    if ($('#oldMethod').val() !== $('#editMethod').val()) {
        url = urlUpdate + individual + "/" + "coeus:method" + "/xsd:string:" + $('#oldMethod').val() + ",xsd:string:" + $('#editMethod').val();
        array.push(url);
    }
    if ($('#oldEndpoint').val() !== $('#editEndpoint').val()) {
        url = urlUpdate + individual + "/" + "coeus:endpoint" + "/xsd:string:" + encodeBars($('#oldEndpoint').val()) + ",xsd:string:" + encodeBars($('#editEndpoint').val());
        array.push(url);
    }
    if ($('#oldQuery').val() !== $('#editQuery').val()) {
        url = urlUpdate + individual + "/" + "coeus:query" + "/xsd:string:" + encodeBars($('#oldQuery').val()) + ",xsd:string:" + encodeBars($('#editQuery').val());
        array.push(url);
    }
    if ($('#oldOrder').val() !== $('#editOrder').val()) {
        url = urlUpdate + individual + "/" + "coeus:order" + "/xsd:string:" + $('#oldOrder').val() + ",xsd:string:" + $('#editOrder').val();
        array.push(url);
    }
    if ($('#oldExtends').val() !== $('#editExtends').val()) {
        url = urlUpdate + individual + "/" + "coeus:extends" + "/coeus:" + $('#oldExtends').val() + ",coeus:" + $('#editExtends').val();
        array.push(url);
        url = urlDelete + "coeus:" + $('#oldExtends').val() + "/" + "coeus:isExtendedBy" + "/" + individual;
        array.push(url);
        url = urlWrite + "coeus:" + $('#editExtends').val() + "/" + "coeus:isExtendedBy" + "/" + individual;
        array.push(url);
    }
    if ($('#oldConcept').val() !== $('#editConcept').val()) {
        url = urlUpdate + individual + "/" + "coeus:isResourceOf" + "/coeus:" + $('#oldConcept').val() + ",coeus:" + $('#editConcept').val();
        array.push(url);
        url = urlDelete + "coeus:" + $('#oldConcept').val() + "/" + "coeus:hasResource" + "/" + individual;
        array.push(url);
        url = urlWrite + "coeus:" + $('#editConcept').val() + "/" + "coeus:hasResource" + "/" + individual;
        array.push(url);
    }
    if ($('#oldPublisher').val() !== $('#editPublisher').val()) {
        url = urlUpdate + individual + "/" + "dc:publisher" + "/xsd:string:" + $('#oldPublisher').val() + ",xsd:string:" + $('#editPublisher').val();
        updatePublisherOnSelectores(urlUpdate, individual, $('#oldPublisher').val(), $('#editPublisher').val());
        array.push(url);
    }
    if ($('#oldBuilt').val().toString() !== $('#built').is(':checked').toString()) {
        url = urlUpdate + individual + "/" + "coeus:built" + "/xsd:boolean:" + $('#oldBuilt').val() + ",xsd:boolean:" + $('#built').is(':checked');
        array.push(url);
    }

    timer = setTimeout(function() {
        $('#closeEditResourceModal').click();
        refresh();
    }, delay);

    array.forEach(function(url) {
        callURL(url, showResult.bind(this, "#editResourceResult", url), showError.bind(this, "#editResourceResult", url));
    });
}
/**
 * Update all selectors type (csv,xml,sql,..) of the resource when the resource publisher change.
 * @param {type} urlUpdate
 * @param {type} res
 * @param {type} oldPublisher
 * @param {type} newPublisher
 * @returns {undefined}
 */
function updatePublisherOnSelectores(urlUpdate, res, oldPublisher, newPublisher) {
    var q = "SELECT * {" + res + " coeus:loadsFrom ?selector}";
    queryToResult(q, function(result) {
        for (var r in result) {
            var res = splitURIPrefix(result[r].selector.value);
            var url = urlUpdate + "coeus:" + res.value + "/rdf:type/coeus:" + oldPublisher.toUpperCase() + ",coeus:" + newPublisher.toUpperCase();
            callURL(url, showResult.bind(this, "#editResourceResult", url), showError.bind(this, "#editResourceResult", url));
        }
    });
}

/**
 * End of the code used to manage the modals (Resource)
 */

/**
 * activate tooltip (bootstrap-tooltip.js is need)
 * @returns {undefined}
 */
function tooltip() {
    $('.tip').tooltip();
}

/**
 * Loads LinkedData seeds on sidebar
 * @returns {undefined}
 */
function loadSeedsOnSidebar() {
    var qSeeds = "SELECT DISTINCT ?seed {?seed a coeus:Seed . ?seed dc:title ?s . }";
    queryToResult(qSeeds, function(result) {
        $('#sidebarseeds').html('');
        for (var key in result) {
            var splitedURI = splitURIPrefix(result[key].seed.value);
            var a = '<li><a href="/'+getFirstPath()+'/resource/' + splitedURI.value + '"><i class="fa fa-circle-o"></i> ' + splitedURI.value + '</a></li>';//TODO: FIX THAT LINK
            $('#sidebarseeds').append(a);
        }
        console.log("INFO: All seeds loaded on sidebar.");
    });

}
/**
 * Change sidebar active attribute
 * @param {type} id
 * @returns {undefined}
 */
function changeSidebar(id) {
    $('.sidebaritem').removeClass('active');
    $(id).addClass('active');
}

/**
 * Reload the context of the coeus application
 * 
 * @param {type} success
 * @param {type} error
 * @returns {undefined}
 */
function reloadContext(success, error) {
    var url = "/manager/text/reload?path=/"+getFirstPath();
    $.ajax({url: url, dataType: 'text'}).done(success).fail(error);
}

/**
 * return true if the pattern match the string value
 * @param {type} value
 * @param {type} pattern
 * @returns {Boolean}
 */
function contains(value, pattern) {
    if (value.indexOf(pattern) !== -1)
        return true;
    else
        return false;
}
/**
 * logout remote user
 * @returns {undefined}
 */
function logout(){
    var url = getApplicationPath()+"config/logout/";
    callURL(url, logoutResult, logoutResult);
}
function logoutResult(result){
    if(result.status===100){
        redirect(getApplicationPath());
    }else{
        console.log(result.message);
    }
}

/**
 * Put the remote user on the divId
 * @param {type} divId
 * @returns {undefined}
 */
function username(divId){
    var url = getApplicationPath()+"config/username/";
    callURL(url, usernameResult.bind(this,divId), usernameResult.bind(this,divId));
}
function usernameResult(divId,result){
    if(result.status===100){
        $(divId).html(result.message);
        $("#dropdown_remote_user").removeClass("hide");
    }else{
        redirect(getApplicationPath()+"manager/seed/");
    }
}