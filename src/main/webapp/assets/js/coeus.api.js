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
    var sparqler = new SPARQL.Service("../../sparql");

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
        if (prefixes[key] === uri) return key;   
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

    $.ajax({url: url, async: false, dataType: 'json'}).done(function(data) {
        console.log(url + ' ' + data.status);
        if (data.status === 100) {
            //$(html).append('Call: ' + url + '<br/> Message: ' + data.message+'<br/><br/>');
            $(html).addClass('alert alert-success');
        } else {
            $(html).append('Call: '+url + '<br/>Status: ' + data.status + ' Message: ' + data.message+'<br/><br/>');
            $(html).addClass('alert alert-error');
        }

    }).fail(function(jqXHR, textStatus) {
        $(html).addClass('alert alert-error');
        $(html).html('Call: '+url + '<br/> ' + 'ERROR: ' + textStatus+'<br/><br/>');
        // Server communication error function handler.
    });
}
function getApiKey() {
   return "coeus";
}