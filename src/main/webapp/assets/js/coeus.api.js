/**
 * Write triple to seed.
 * 
 * @param {type} subject
 * @param {type} predicate
 * @param {type} object
 * @param {type} key
 * @returns {undefined}
 */
function writeTriple(subject, predicate, object, key) {

    $.ajax({url: './api/' + key + '/write/' + subject + '/' + predicate + '/' + object, dataType: 'json'}).done(function(data) {
        if (data.status === 100) {
            console.log('[COEUS] data successfully written in knowledge base.');
            // All OK function handler.
        } else {
            console.log('[COEUS] unable to write data to knowledge base.\n\tStatus: ' + data.status);
            // Internal server error function handler.
        }
    }).fail(function(jqXHR, textStatus) {
        console.log('[COEUS] unable to complete data write request. ' + textStatus);
        // Server communication error function handler.
    });
}

/**
 * Update triple in the knowledge base.
 * 
 * @param {type} subject
 * @param {type} predicate
 * @param {type} old_object
 * @param {type} new_object
 * @param {type} key
 * @returns {undefined} */
function updateTriple(subject, predicate, old_object, new_object, key) {

    $.ajax({url: './api/' + key + '/update/' + subject + '/' + predicate + '/' + old_object + ',' + new_object, dataType: 'json'}).done(function(data) {
        if (data.status === 100) {
            console.log('[COEUS] data successfully updated in knowledge base.');
            // All OK function handler.
        } else {
            console.log('[COEUS] unable to update data in the knowledge base.\n\tStatus: ' + data.status);
            // Internal server error function handler.
        }
    }).fail(function(jqXHR, textStatus) {
        console.log('[COEUS] unable to complete data update request. ' + textStatus);
        // Server communication error function handler.
    });
}

/**
 * Delete/remove triple of the knowledge base.
 * 
 * @param {type} subject
 * @param {type} predicate
 * @param {type} object
 * @param {type} key
 * @returns {undefined} */
function deleteTriple(subject, predicate, object, key) {

    $.ajax({url: './api/' + key + '/delete/' + subject + '/' + predicate + '/' + object, dataType: 'json'}).done(function(data) {
        if (data.status === 100) {
            console.log('[COEUS] data successfully deleted in knowledge base.');
            // All OK function handler.
        } else {
            console.log('[COEUS] unable to delete data in the knowledge base.\n\tStatus: ' + data.status);
            // Internal server error function handler.
        }
    }).fail(function(jqXHR, textStatus) {
        console.log('[COEUS] unable to complete data delete request. ' + textStatus);
        // Server communication error function handler.
    });
}
/**
 * init service prefix
 * @returns {query} */
function initSparqlerQuery() {
    var sparqler = new SPARQL.Service("/coeus/sparql");

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
function callAPI(url, html) {
    url=encodeURI(url);
    $.ajax({url: url, async: false, dataType: 'json'}).done(function(data) {
        console.log(url + ' ' + data.status);
        if (data.status === 100) {
            //$(html).append('Call: ' + url + '<br/> Message: ' + data.message+'<br/><br/>');
            $(html).addClass('alert alert-success');
        } else {
            $(html).addClass('alert alert-error');
            $(html).append('Call: ' + url + '<br/>Status: ' + data.status + ' Message: ' + data.message + '<br/><br/>');
        }

    }).fail(function(jqXHR, textStatus) {
        $(html).addClass('alert alert-error');
        $(html).append('Call: ' + url + '<br/> ' + 'ERROR: ' + textStatus + '<br/><br/>');
        // Server communication error function handler.
    });
}
function getApiKey() {
    return "coeus";
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
 * remove all subjects and predicates associated. The objects are recursively removed too.
 * 
 * example urlPrefix = "../../api/" + getApiKey() ;
 * 
 * @param {type} urlPrefix
 * @param {type} object
 * @returns {undefined}
 */
function removeAllTriplesFromObject(urlPrefix, object) {
    var query = initSparqlerQuery();
    var qObject = "SELECT ?subject ?predicate {?subject ?predicate " + object + " . }";
    query.query(qObject,
            {success: function(json) {
                    var result = json.results.bindings;
                    console.log(result);
                    for (r in result) {
                        var splitedPredicate = splitURIPrefix(result[r].predicate.value);
                        var splitedSubject = splitURIPrefix(result[r].subject.value);

                        var predicatePrefix = getPrefix(splitedPredicate.namespace);
                        if (predicatePrefix !== '')
                            predicatePrefix = predicatePrefix + ':';
                        var objectPrefix = getPrefix(splitedSubject.namespace);
                        if (objectPrefix !== '')
                            objectPrefix = objectPrefix + ':';
                        else
                            objectPrefix = 'xsd:string:' + objectPrefix;

                        var url = "/delete/"+ objectPrefix + splitedSubject.value + '/' + predicatePrefix + splitedPredicate.value + '/' + object;
                        
                        console.log("Delete call: "+urlPrefix+url);
                        callAPI(urlPrefix + url, "#result");
                        if((splitedPredicate.value!== "includes") & (splitedPredicate.value!== "isEntityOf") & (splitedPredicate.value!== "isConceptOf") & (splitedPredicate.value!== "isResourceOff")) 
                            removeRecursive(urlPrefix,objectPrefix + splitedSubject.value);
                        
                       
                    }
                    

                }}
    );

}

function isModel(key){
    var b=false;
    
    if(key.indexOf("coeus:seed_") !== -1 | key.indexOf("coeus:entity_") !== -1 | key.indexOf("coeus:concept_") !== -1 | key.indexOf("coeus:resource_") !== -1) b=true;

    console.log(key+' '+b);
    return b;
                        
}

function removeRecursive(urlPrefix,subject){
    var query=initSparqlerQuery();
    var qObject = "SELECT ?predicate ?object {"+subject+" ?predicate ?object . }";
    console.log("Recursive call: "+qObject);
    query.query(qObject,
            {success: function(json) {
                    var result = json.results.bindings;
                    
                    for (r in result) {
                      var splitedPredicate = splitURIPrefix(result[r].predicate.value);
                        var splitedObject = splitURIPrefix(result[r].object.value);

                        var predicatePrefix = getPrefix(splitedPredicate.namespace);
                        if (predicatePrefix !== '')
                            predicatePrefix = predicatePrefix + ':';
                        var objectPrefix = getPrefix(splitedObject.namespace);
                        if (objectPrefix !== '')
                            objectPrefix = objectPrefix + ':';
                        else
                            objectPrefix = 'xsd:string:' + objectPrefix;

                        var url = "/delete/"+ subject + '/' + predicatePrefix + splitedPredicate.value + '/' + objectPrefix + splitedObject.value;
                        console.log("Recursive Delete call: "+urlPrefix+url);
                        callAPI(urlPrefix + url, "#result");
                        if(isModel(objectPrefix + splitedObject.value)) {
                           // console.log("Another recursive call: "+url);
                            removeRecursive(urlPrefix,objectPrefix + splitedObject.value);
                        }
                          
                    }


                }}
    );
}

function removeAllTriplesFromSubject(urlPrefix, subject) {
    var query = initSparqlerQuery();
    var qSubject = "SELECT ?predicate ?object {" + subject + " ?predicate ?object . }";
    query.query(qSubject,
            {success: function(json) {
                    var result = json.results.bindings;
                    console.log(result);
                    for (var r in result) {
                        var splitedPredicate = splitURIPrefix(result[r].predicate.value);
                        var splitedObject = splitURIPrefix(result[r].object.value);

                        var predicatePrefix = getPrefix(splitedPredicate.namespace);
                        if (predicatePrefix !== '')
                            predicatePrefix = predicatePrefix + ':';
                        var objectPrefix = getPrefix(splitedObject.namespace);
                        if (objectPrefix !== '')
                            objectPrefix = objectPrefix + ':';
                        else
                            objectPrefix = 'xsd:string:' + objectPrefix;
                        
                        var url = "/delete/"+ subject + '/' + predicatePrefix + splitedPredicate.value + '/' + objectPrefix;
                        //TO ALLOW '/' in the string 
                        if(splitedPredicate.value==='query') url=url+result[r].object.value.split("/").join("%2F"); else url=url+splitedObject.value;
                        
                        callAPI(urlPrefix + url, "#result");

                    }

                    //if success refresh page
                    if (document.getElementById('result').className !== 'alert alert-error') {
                        // window.location="../entity/"+lastPath();
                        console.log("REDIRECTING...");
                        //window.location.reload(true);
                    }
                }}
    );
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
function queryToResult(selectQuery, callback){
    var query = initSparqlerQuery();
    query.query(selectQuery,
            {success: function(json) {
                    var result = json.results.bindings;
                    //console.log(result);
                    callback(result);
                }}
        );
}