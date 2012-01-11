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
        <!-- forker -->
        <a href="https://github.com/pdrlps/COEUS/tree/coeus1.0b" target="_blank" id="forkme">Fork COEUS on GitHub</a>

        <!-- contact modal box -->
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
                <p>"Semantic Web in a box"</p>
                <div style="text-align: center;">
                    <ul class="pills">
                        <li><a href="/coeus/resource/uniprot_P51587">Explore with LinkedData &raquo;</a></li>
                        <li><a href="sparqler/">Test SPARQL Endpoint &raquo;</a></li>
                        <li><a href="https://github.com/pdrlps/COEUS/tree/coeus1.0b" target="_blank">Download 1.0b &raquo;</a></li>
                        <li><a href="documentation/">View Documentation &raquo;</a></li>
                    </ul>
                </div>
            </div>

            <!-- 4 products in one -->

            <div class="page-header">
                <h1>One package, Multiple tools <small>4 products in one</small></h1>
            </div>
            <div class="row">
                <div class="span8">
                    <h2>Data Integration Platform</h2>
                    <ul>
                        <li>Centralize <strong>distributed</strong> and <strong>heterogeneous</strong> data</li>
                        <li>Integrate <strong>CSV</strong>, <strong>SQL</strong>, <strong>XML</strong> or <strong>SPARQL</strong> resources</li>
                        <li>Advanced <strong>Extract-Transform-Load</strong> warehousing features</li>
                        <li>Deploy custom Semantic Web-powered <strong>knowledge bases</strong></li>
                    </ul>
                </div>  
                <div class="span8">
                    <h2>Knowledge Federation Framework</h2>
                    <ul>
                        <li>Launch your custom <strong>application ecosystem</strong></li>
                        <li>Connect multiple applications using <strong>SPARQL Federation</strong></li>
                        <li>Share knoweledge amongst a scalable number of <strong>peers</strong></li>
                    </ul>
                </div>   
            </div>
            <div class="row">
                <div class="span8">
                    <h2>Semantic Web & LinkedData Services</h2>
                    <ul>
                        <li>Publish your knowledge base with <strong>LinkedData</strong></li>
                        <li>Provide custom <strong>SPARQL endpoints</strong></li>
                        <li>Access your data through state-of-the-art <strong>RESTful services</strong></li>
                    </ul>
                </div>   
                <div class="span8">
                    <h2>Rapid Application Deployment</h2>
                    <ul>
                        <li>Enable your independent <strong>application platform</strong></li>
                        <li>Deploy to <strong>desktop</strong>, <strong>web</strong> or <strong>mobile</strong></li>
                        <li>Code your application in any <strong>programming environment</strong></li>
                        <li>Create <strong>highly responsive</strong> and <strong>progressively enhanced</strong> UIs</li>
                    </ul>
                </div>                      
            </div>

            <!-- Info links-->
            <section id="information">
                <div class="page-header">
                    <h1>Basic Information</h1>
                </div>
                <div class="row">
                    <div class="span-one-third">
                        <h6>What?</h6>
                        <p>COEUS is a next-generation semantic web-powered knowledge management framework. It is targeted at rapid application deployment of new applications in any research field, supported by a comprehensive ontology and RDF-based configuration files.</p>
                    </div>
                    <div class="span-one-third">
                        <h6>How?</h6>
                        <p>With COEUS anyone can deploy customized mini-warehouses - Knwoledge Seeds. Each seed provides an API for internal and external usage, enabling the connection of multiple seeds. With multiple seeds connected, their content can be federated, resulting in a truly semantic knowledge federation network - the Knowledge Garden. </p>
                    </div>
                    <div class="span-one-third">
                        <h6>Case Study</h6>
                        <a href="http://bioinformatics.ua.pt/dc4/"><img src="assets/img/dc4.png" width="200" height="29" alt="Diseasecard" /></a>
                        <ul>
                            <li>First COEUS seed</li>
                            <li>Rare disease information integration and enrichment</li>
                            <li>Disease-centric and contextual data exploration</li>
                        </ul>
                        <p><a class="btn primary" href="http://bioinformatics.ua.pt/dc4/">Go to Diseasecard &raquo;</a></p>
                    </div>
                </div>
            </section>

        </div> 
        <footer class="footer">
            <div class="container">
                <p class="right"><a href="#">Back to top</a></p>

                <p>&copy; <a target="_blank" title="UA.PT Bioinformatics" href="http://bioinformatics.ua.pt/">University of Aveiro</a> 2012</p>
                <p><small>Under Development by <a href="http://pedrolopes.net" target="_blank">@pedrolopes</a></small></p>

                <p> <a href="http://twitter.github.com/bootstrap/" target="_blank"><small>Layout with Twitter Bootstrap</small></a></p>
            </div>
        </footer>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
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
