<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
    <head>
        <title>STREM data browser for COEUS | Enabling Knowledge</title>
        <link type="text/css" rel="stylesheet" href="<c:url value="/stream/assets/style/reset.css" />" />
        <link type="text/css" rel="stylesheet" href="<c:url value="/stream/assets/style/base.css" />" />
        <meta name="description" content="">
        <meta name="author" content="">
        <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
        <!--[if lt IE 9]>
          <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

        <!-- Le styles -->
        <link href="../assets/css/bootstrap.css" rel="stylesheet">
        <link href="../assets/css/docs.css" rel="stylesheet">
        <link href="../assets/css/coeus.css" rel="stylesheet">
        <!-- Le fav and touch icons -->
        <link rel="shortcut icon" href="../assets/img/favicon.ico">

    </head>
    <body>
        <!-- Topbar
        ================================================== -->
        <div class="topbar">
            <div class="fill">
                <div class="container">
                    <h3><a href="../">COEUS</a></h3>
                    <ul>
                        <li><a href="../documentation/">Documentation</a></li>
                        <li><a href="../science/">Science</a></li>
                        <li class="active"><a href="../sparqler/">SPARQL</a></li>
                        <li><a id="contact" data-controls-modal="modal" data-backdrop="true" href="#">Contact</a></li>
                    </ul>
                    <form class="pull-right" action="">
                        <input type="text" id="search" placeholder="Search (e.g. omim_114480)" />
                    </form>
                </div>
            </div>
        </div>
        <div id="modal" class="modal hide fade">
            <div class="modal-header">
                <a href="#" class="close">&times;</a>
                <h3>Contact Information</h3>
            </div>
            <div class="modal-body">
                <address>
                    <strong>Pedro Lopes</strong><br/>
                    <a href="http://pedrolopes.net" target="_blank">@pedrolopes</a><br/>
                    DETI/IEETA, University of Aveiro<br />
                    Campus Universitário de Santiago<br />
                    3810 - 193 Aveiro<br/>
                    Portugal
                </address>
            </div>
            <div class="modal-footer">
                <a href="mailto:pedrolopes@ua.pt" class="btn primary">Send Mail</a>
            </div>
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
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="assets/js/jquery-1.6.2.min.js"><\/script>')</script>
        <script defer src="../assets/js/bootstrap-modal.js"></script>        
        <script defer src="../assets/js/bootstrap-dropdown.js"></script>
        <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-12230872-7']);
            _gaq.push(['_trackPageview']);
            (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
        </script>
        <script src="<c:url value="/assets/js/jquery.tmpl.min.js" />" type="text/javascript"></script>
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
                            panel.fadeIn();
                            $('#panel_table').html(table);
                            if(data_id==id) {
                                panel.animate({left: parseInt(panel.css('left'),0) == 0 ? +panel.outerWidth() + 32 : 0});
                            } else {
                                panel.animate({left: parseInt(panel.css('left'),0) == 0 ? +panel.outerWidth() + 32 : 0});
                            }
                            $('.right').fadeOut();
                        });
                        return false;
                    });
                });               

                $('.close').click(function(){
                    var panel= $('.panel');
                    panel.fadeOut().animate({left: parseInt(panel.css('left'),0) == 0 ? + panel.outerWidth() + 32: 0});
                    //panel.;
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
                
                $('#search').keypress(function(e){
                    if ( e.which == 13 ) {
                        e.preventDefault();
                        var urls = window.location.toString().split('/');
                        var uri = "";
                        for (i = 0; i < urls.length - 1; i++) {
                            uri += urls[i] + "/";
                        }window.location = uri + $('#search').attr('value');
                    } 
                });
            });
        </script>
        <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you want to support IE 6.
             chromium.org/developers/how-tos/chrome-frame-getting-started -->
        <!--[if lt IE 7 ]>
          <script src="//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js"></script>
          <script>window.attachEvent('onload',function(){CFInstall.check({mode:'overlay'})})</script>
        <![endif]-->
    </body>
</html>
