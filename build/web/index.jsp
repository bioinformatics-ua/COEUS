<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>COEUS | Enabling Knowledge</title>
        <meta name="description" content="COEUS Semantic Web Application Framework">
        <meta name="author" content="Pedro Lopes pedrolopes@ua.pt">

        <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
        <!--[if lt IE 9]>
          <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

        <!-- Le styles -->
        <link href="assets/css/bootstrap.css" rel="stylesheet">

        <!-- Le fav and touch icons -->
        <link rel="shortcut icon" href="assets/img/favicon.ico">
        <link rel="apple-touch-icon" href="assets/img/apple-touch-icon.png">
        <link rel="apple-touch-icon" sizes="72x72" href="assets/img/apple-touch-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="114x114" href="assets/img/apple-touch-icon-114x114.png">
    </head>

    <body>

        <div class="topbar">
            <div class="fill">
                <div class="container">
                    <h3><a href="/coeus/"><img src="/coeus/assets/img/coeus_bw.png" /></a></h3>
                    <ul>
                        <li><a href="/coeus/documentation/">Documentation</a></li>
                        <li><a href="/coeus/science/">Science</a></li>
                        <li><a href="/coeus/sparqler/">SPARQL</a></li>
                        <li><a id="contact" href="#">Contact</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div id="modal" class="well modal-backdrop" style="border: none; padding: 40px;display: none; width: 100%; height: 100%;">
            <div class="modal" style="position: relative; top: auto; left: auto; margin: 0 auto; z-index: 1000; margin-top: 64px;">
                <div class="modal-header">
                    <h3>Contact Information</h3>
                    <a href="#" class="close closer">&times;</a>
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
                    <a href="#" class="btn secondary closer">Close</a>
                </div>
            </div>
        </div>
        <div class="container">


            <!-- Main hero unit for a primary marketing message or call to action -->
            <div class="hero-unit">                
                <img src="assets/img/coeus_left.png" class="logo_right" />
                <h1>Hello, Semantic Web!</h1>
                <p><em>Ipsa scientia potestas est.</em> Knowledge itself is power.<br />Next-generation Semantic Web Application Framework.</p>
                <p><a class="btn primary large" target="_blank" href="/coeus/api/omim:104300">Take the TestDrive &raquo;</a></p>
            </div>

            <!-- Example row of columns -->
            <div class="row">
                <div class="span6">
                    <h2>What?</h2>
                    <p>COEUS is a next-generation semantic web-powered knowledge management framework. It is targeted at rapid application deployment of new applications in any research field, supported by a comprehensive ontology and RDF-based configuration files.</p>
                    <p><a class="btn" href="/coeus/documentation/">Check the Documentation &raquo;</a></p>
                </div>
                <div class="span5">
                    <h2>How?</h2>
                    <p>With COEUS anyone can deploy customized mini-warehouses - Knwoledge Seeds. Each seed provides an API for internal and external usage, enabling the connection of multiple seeds. With multiple seeds connected, their content can be federated, resulting in a truly semantic knowledge federation network - the Knowledge Garden. </p>
                    <!--<p><a class="btn" href="#">View details &raquo;</a></p>-->
                </div>
                <div class="span5">
                    <h2>Requirements?</h2>
                    <p>COEUS is deployed as a Java web application for Tomcat. It includes a building engine to gather content according to the configuration file; an API, with internal methods and external access through REST and SPARQL; and STREAM, the default data browser.<br>
                        The list of requirements is composed of an Apache Tomcat Server (version 6 up) and a SQL database (COEUS works with <a href="http://openjena.org/SDB/" target="_blank">Jena SDB</a>).</p>
                    <p><a class="btn primary" href="/coeus/documentation/#download">Download &raquo;</a></p>
                </div>
            </div>

            <footer>
                <blockquote>
                    <p>&copy; University of Aveiro 2011</p>
                    <small>Under Development by <a href="http://pedrolopes.net" target="_blank">@pedrolopes</a></small>
                </blockquote>
            </footer>

        </div> 

        <!-- /container -->
        <!-- JavaScript at the bottom for fast page loading -->

        <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline -->
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="assets/js/jquery-1.6.2.min.js"><\/script>')</script>


        <!-- scripts concatenated and minified via ant build script-->
        <script defer src="assets/js/plugins.js"></script>
        <!-- end scripts-->


        <!-- Change UA-XXXXX-X to be your site's ID -->
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
        <script>
            $(document).ready(function(){   
                $('#contact').click(function(){
                    $('#modal').fadeIn('slow'); 
                });
                
                $('.closer').click(function(){
                    $('#modal').fadeOut('slow');
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
