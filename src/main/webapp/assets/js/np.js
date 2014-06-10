/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//service location
var SERVICE="http://bioinformatics.ua.pt/rdf-converter/service/url/";

function convert(server, title){
    //console.log(server);
    //console.log(title);
    $.post(SERVICE, server+"nanopub/"+title, postTrigCallback.bind(this,title));
}

function postTrigCallback(title,data, status) {
    //console.log(data);
    //console.log(status);
    var contentType = 'application/trig';
    var blob = new Blob([data], {'type': contentType});
    var url = window.URL.createObjectURL(blob);
    var download = document.getElementById("download");
    download.setAttribute("href", url);
    download.setAttribute("download", title+'.trig');
    download.click();
}

