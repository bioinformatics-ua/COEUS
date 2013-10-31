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