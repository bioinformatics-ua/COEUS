<%@include file="taglib.jsp" %>
<s:layout-definition>
    <!DOCTYPE html>
    <html>
        <head>
            <link rel="author" href="<c:url value="/humans.txt" />" />
            <link rel="icon" type="image/ico" href="<c:url value="/favicon.ico" />"></link> 
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="description" content="COEUS semantic web linkeddata linked data services rest integration heterogeneous distributed knowledge federation">
            <meta name="author" content="Pedro Lopes pedrolopes@ua.pt; Pedro Sernadela sernadela@ua.pt; Jose Luis Oliveira jlo@ua.pt">
            <title><s:layout-component name="title">COEUS</s:layout-component></title>
            <s:layout-component name="style">
                <jsp:include page="style.jsp" />
            </s:layout-component>
        </head>
        <body>
            <noscript>
            <div id="js">
                COEUS requires that you enable Javascript.<br /><br /><br /><a href="http://support.google.com/bin/answer.py?hl=en&answer=23852" target="_blank">Take a look here if you do not know how.</a>
            </div>
            </noscript>


            <nav class="navbar navbar-fixed-top navbar-inverse" role="navigation">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="<c:url value="/" />">COEUS Framework</a>
                    </div>

                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse navbar-ex1-collapse">
                        <ul class="nav navbar-nav">
                            <li class="active"><a href="<c:url value="/" />"><i class="glyphicon glyphicon-home"></i> Home</a></li>
                            <li><a target="_blank" href="<c:url value="/overview/" />"><i class="glyphicon glyphicon-send"></i> Live Demo</a></li>
                            <li><a target="_blank" href="<c:url value="/documentation/" />"><i class="glyphicon glyphicon-book"></i> Documentation</a></li>
                            <li><a data-toggle="modal" data-target="#contact" href="#contact"><i class="glyphicon glyphicon-envelope"></i> Contact</a></li>
                        </ul>
                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container -->
            </nav>

            <!-- contact modal box -->
            <div id="contact" class="modal fade" role="dialog" aria-labelledby="contact" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>

                            <h3 class="modal-title" >Contact Information</h3>
                        </div>

                        <div class="modal-body">
                            <address>
                                <strong>COEUS, A/C Pedro Lopes & Pedro Sernadela</strong><br>
                                DETI/IEETA, University of Aveiro<br>
                                Campus Universitario de Santiago<br>
                                3810 - 193 Aveiro<br>
                                Portugal
                            </address>
                        </div>
                        <div class="modal-footer">
                            <a href="mailto:pedrolopes@ua.pt,sernadela@ua.pt?subject=[COEUS] feedback" class="btn btn-info">Send Mail <i class="icon-envelope icon-white"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <s:layout-component name="body">
            </s:layout-component>

        </body>

        <footer id="footer">
            <div class="">
                <div class="page-wrapper">
                    <div class="container">
                        <p class="pull-right"><a href="#" title="Back to top"> <i class="fa fa-arrow-up"></i></a></p>
                        <p class="text-muted credit">&copy; <a target="_blank" title="UA.PT Bioinformatics" href="http://bioinformatics.ua.pt/">University of Aveiro</a> <script> document.write(new Date().getFullYear()); </script> - Support provided by <a href="http://bmd-software.com" target="_blank">BMD Software, LDA</a> <a href="http://getbootstrap.com/" title="Go to Bootstrap" target="_blank"><small>(Layout with Bootstrap)</small></a></p> 
                    </div>
                </div>
            </div>
        </footer> 


        <s:layout-component name="scripts">
            <jsp:include page="script.jsp" />
        </s:layout-component>
        <s:layout-component name="custom_scripts">
           
        </s:layout-component>
    </html>
</s:layout-definition>