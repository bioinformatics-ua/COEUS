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
        <link href="assets/css/docs.css" rel="stylesheet">
        <link href="assets/css/coeus.css" rel="stylesheet">

        <!-- Le fav and touch icons -->
        <link rel="shortcut icon" href="assets/img/favicon.ico">
    </head>

    <body>

        <div class="topbar">
            <div class="fill">
                <div class="container">
                    <h3><a href="#">COEUS</a></h3>
                    <ul>
                        <li><a href="documentation/">Documentation</a></li>
                        <li><a href="science/">Science</a></li>
                        <li><a href="sparqler/">SPARQL</a></li>
                        <li><a id="contact" data-controls-modal="modal" data-backdrop="true" href="#">Contact</a></li>
                    </ul>
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
        <div class="container">
            <!-- Main hero unit for a primary marketing message or call to action -->
            <div class="hero-unit">                
                <img src="assets/img/coeus_left.png" class="logo_right" />
                <h1>Hello, Semantic Web!</h1>
                <p><em>Ipsa scientia potestas est.</em> Knowledge itself is power.<br />Next-generation Semantic Web Application Framework.</p>
                <p><a class="btn primary large" href="sparqler/">Take the TestDrive &raquo;</a></p>
            </div>

            <!-- Example row of columns -->
            <div class="row">
                <div class="span6">
                    <h2>What?</h2>
                    <p>COEUS is a next-generation semantic web-powered knowledge management framework. It is targeted at rapid application deployment of new applications in any research field, supported by a comprehensive ontology and RDF-based configuration files.</p>
                    <p><a class="btn" href="documentation/">Check the Documentation &raquo;</a></p>
                </div>
                <div class="span5">
                    <h2>How?</h2>
                    <p>With COEUS anyone can deploy customized mini-warehouses - Knwoledge Seeds. Each seed provides an API for internal and external usage, enabling the connection of multiple seeds. With multiple seeds connected, their content can be federated, resulting in a truly semantic knowledge federation network - the Knowledge Garden. </p>
                </div>
                <div class="span5">
                    <h2>Benefits?</h2>
                    <ul>
                        <li>Semantically aggregate and connect data distributed among distinct resources.</li>
                        <li>Take advantage of Semantic Web technologies for improved integration, presentation and augmentation of data.</li>
                        <li>Explore holistic data perspectives using advanced knowledge federation strategies.</li>
                        <li>Rapidly build innovative desktop, web or mobile applications.</li>
                    </ul>
                    <p><a class="btn primary" href="documentation/#download">Download &raquo;</a></p>
                </div>
            </div>

            <footer>
                <blockquote>
                    <p>&copy; University of Aveiro 2011</p>
                    <small>Under Development by <a href="http://pedrolopes.net" target="_blank">@pedrolopes</a></small>
                </blockquote>
            </footer>

        </div> <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="assets/js/jquery-1.6.2.min.js"><\/script>')</script>
        <script defer src="assets/js/bootstrap-modal.js"></script>       
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
