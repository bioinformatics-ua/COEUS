window.onload = function () {
var style = document.createElement('style');
style.type = 'text/css';
style.innerHTML = '#coeus {-webkit-border-image: none;background-color: rgb(217, 237, 247);border-bottom-color: rgb(188, 232, 241);border-bottom-left-radius: 4px;border-bottom-right-radius: 4px;border-bottom-style: solid;border-bottom-width: 1px;border-left-color: rgb(188, 232, 241);border-left-style: solid;border-left-width: 1px;border-right-color: rgb(188, 232, 241);border-right-style: solid;border-right-width: 1px;border-top-color: rgb(188, 232, 241);border-top-left-radius: 4px;border-top-right-radius: 4px;border-top-style: solid;border-top-width: 1px;bottom: 8px;color: rgb(58, 135, 173);display: block;font-family: \'Titillium Web\', \'Helvetica Neue\', Helvetica, Arial, sans-serif;font-size: 10px;height: 20px;line-height: 20px;margin-bottom: 0px;margin-left: 0px;margin-right: 0px;margin-top: 0px;opacity: 0.4;padding-bottom: 2px;padding-left: 2px;padding-right: 2px;padding-top: 2px;position: fixed;right: 8px;text-shadow: rgba(255, 255, 255, 0.498039) 0px 1px 0px;width: 100px;z-index: 1000;text-align: center;}#coeus:hover{opacity: 0.9;}';
var html = document.createElement('div');
html.id = 'coeus';
html.innerHTML = '<a href="http://bioinformatics.ua.pt/coeus" target="_blank" title="Powered by COEUS">Powered by <strong>COEUS</strong></a>';
document.head.insertBefore(style, document.head.childNodes[0]);
document.body.insertBefore(html, document.body.childNodes[0]);	
}