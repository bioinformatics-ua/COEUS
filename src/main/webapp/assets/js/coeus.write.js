/**
 * Write map content to seed.
 * 
 * @param {type} subject
 * @param {type} hashmap
 * @param {type} key
 * @returns {Boolean}
 */
function writeToSeed(subject, hashmap, key) {
    var map = '';
    $.each(hashmap, function(k, v) {
        map += k + ',' + v + '|';
    });

    $.ajax({url: './api/' + key + '/write/' + subject + '/' + map.substring(0, map.length), dataType: 'json'}).done(function(data) {
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