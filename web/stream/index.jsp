<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>STREAM - COEUS Data Browser</title>
        <link type="text/css" rel="stylesheet" href="<c:url value="/stream/assets/style/reset.css" />" />
        <link type="text/css" rel="stylesheet" href="<c:url value="/stream/assets/style/base.css" />" />
        <script src="<c:url value="/stream/assets/script/jquery.min.js" />" type="text/javascript"></script>
        <script src="<c:url value="/stream/assets/script/jquery.tmpl.min.js" />" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                // load item associated elements
                $.getJSON(window.location + '.json', function(data) {
                    $('.left').html('');
                    $.each(data.results.bindings, function(i,k) {
                        var result = {};
                        result.full = k.s.value;
                        var tmp = result.full.split("/");
                        var item = tmp[tmp.length - 1].split("_");                        
                        result.full = k.s.value;
                        result.id = tmp[tmp.length - 1];
                        result.type = item[0];
                        result.value = item[1];
                        $('#container').find('#blockTemplate').tmpl(result).appendTo('.left');
                    });
                    $('.block_value').click(function() {
                        var id = $(this).attr('id');
                        var data_id= $(".data").html();
                        var panel= $('.panel');
                        var panel_width=$('.panel').css('left');
                        
                        $('#item_id').html(id);
                        $.getJSON(window.location + '.info', function(data) {
                            var table = '<ul>';
                            $.each(data.results.bindings, function(i,k) {
                                switch(k.p.value)
                                {
                                    case 'http://purl.org/dc/elements/1.1/title':
                                        $('#item_title').html(k.o.value);
                                        break;
                                    case 'http://www.w3.org/2000/01/rdf-schema#comment':
                                        $('#panel_comment').html(k.o.value);
                                        break;
                                    default:
                                        table += '<li>' + k.o.value + '<ul><li>' + k.p.value + '</li></ul></li>';

                                }
                            });
                            table += '</ul>';
                            
                            $('#panel_table').html(table);
                            if(data_id==id) {
                                panel.animate({left: parseInt(panel.css('left'),0) == 0 ? +panel.outerWidth() : 0});
                            } else {
                                if(panel_width=='441px') {

                                } else {
                                    panel.animate({left: parseInt(panel.css('left'),0) == 0 ? +panel.outerWidth() : 0});
                                }
                            }
                            $('.right').fadeOut();
                        });
                        return false;
                    });
                });               

                $('.close').click(function(){
                    var panel= $('.panel');
                    panel.animate({left: parseInt(panel.css('left'),0) == 0 ? +panel.outerWidth() : 0});
                    $('.right').fadeIn();
                    return false;
                });

                // load initial item data
                var url = window.location.toString();
                var loc = url.split("/");
                var item_id = loc[loc.length - 1];
                $('#item_id').html(item_id);
                $.getJSON(window.location + '.info', function(data) {
                    var table = '<ul>';
                    $.each(data.results.bindings, function(i,k) {
                        $('#start_title').html('');
                        switch(k.p.value)
                        {
                            case 'http://purl.org/dc/elements/1.1/title':
                                $('#start_title').html(k.o.value);
                                break;
                            case 'http://www.w3.org/2000/01/rdf-schema#comment':
                                $('.comment').html(k.o.value);
                                break;
                            case 'http://bioinformatics.ua.pt/coeus/isAssociatedTo':
                                break;
                            default:
                                table += '<li>' + k.o.value + '<ul><li>' + k.p.value + '</li></ul></li>';
                        }
                    });
                    table += '</ul>';
                    $('.start_table').html(table);
                });

                $('.search_button').click(function() {
                    var v = $('#search_text').attr('value');
                    window.location = "http://bioinformatics.ua.pt/coeus/api/" + v;
                });
            });

        </script>
    </head>
    <body>
        <!-- header -->
        <div id="top">
            <div id="logo">
                <a href="/coeus/api/omim:104300" target="_top"><img src="<c:url value="/stream/assets/image/stream_logo.png" />" alt="stream_logo" width="157" height="30" /></a>
            </div>
            <div id="header"><input type="text" id="search_text" /><a class="search_button" href="#">Search &raquo;</a></div>
        </div>
        <!-- main container -->
        <div id='container'>
            <script id="blockTemplate" type="text/x-jquery-tmpl">
                <div class="block" id="${actionBean.js_id}">
                    <div class="block_content">
                        <div class="block_type">${actionBean.js_type}</div>
                        <div class="block_value">${actionBean.js_value}</div>
                        <div class="block_full"><a href="http://bioinformatics.ua.pt/coeus/api/${actionBean.js_id}" target="_top">${actionBean.js_full}</a></div>
                    </div>
                </div>
            </script>
            <div class='right'>
                <div class="title">
                    <span id="start_title">NO INFO</span>
                    <div class="comment"></div>
                </div>
                <div class="start_table">

                </div>
            </div>
            <div id="panel-frame">
                <div class="panel">
                    <div class="head">
                        <div id="item_title"></div><div id="close"><span><a class="close">Close</a></span></div>
                    </div>
                    <div class="data">
                        <div id="panel_comment">
                            
                        </div>
                        <div id="panel_table">
                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="left">
            </div>
        </div>
    </body>
</html>
