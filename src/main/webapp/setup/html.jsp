<%@include file="/layout/taglib.jsp" %>
<s:layout-definition>
    <!DOCTYPE html>
    <html>
        <head>
            <link rel="author" href="<c:url value="/humans.txt" />" />
            <link rel="icon" type="image/ico" href="<c:url value="/favicon.ico" />"></link> 
            <meta name="description" content="COEUS semantic web linkeddata linked data services rest integration heterogeneous distributed knowledge federation">
            <meta name="author" content="Pedro Lopes pedrolopes@ua.pt">
            <title><s:layout-component name="title">COEUS Setup</s:layout-component></title>
            <s:layout-component name="style">
                <jsp:include page="/layout/style.jsp" />
            </s:layout-component>            
        </head>
        <body>
            <noscript>
            <div id="js">
                COEUS requires that you enable Javascript.<br /><br /><br /><a href="http://support.google.com/bin/answer.py?hl=en&answer=23852" target="_blank">Take a look here if you do not know how.</a>
            </div>
            </noscript>
            <div class="navbar navbar-inverse navbar-fixed-top">
                <div class="navbar-inner">
                    <div class="container">
                        <a class="brand" href="<c:url value="/" />">COEUS</a>

                        <div class="nav-collapse collapse">
                            <ul class="nav">
                                <li class="active"><a href="<c:url value="/manager/seed/" />">Home</a></li>

                                <li><a href="<c:url value="/manager/seed/" />">Seeds</a></li>
<!--
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Manager <b class="caret"></b></a>
                                    <ul class="dropdown-menu">
                                        <li><a id="entity" href="#">Entities</a></li>
                                        <li><a href="#">Concepts</a></li>
                                        <li><a href="#">Resources</a></li>
                                        <li class="divider"></li>
                                        <li><a href="#">View All</a></li>
                                    </ul>
                                </li>
-->
                                <li><a href="<c:url value="/manager/config/" />">Setup</a></li>

                                <li><a href="<c:url value="/documentation/" />">Documentation</a></li>

                                <li><a data-toggle="modal" data-target="#contact" href="#contact">Contact</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div><!-- contact modal box -->

            <div id="contact" class="modal hide fade" role="dialog" aria-labelledby="contact" aria-hidden="true">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">�</button>

                    <h3>Contact Information</h3>
                </div>

                <div class="modal-body">
                    <address>
                        <strong>Pedro Lopes</strong><br>
                        <a href="http://pedrolopes.net" target="_blank">@pedrolopes</a><br>
                        DETI/IEETA, University of Aveiro<br>
                        Campus Universitario de Santiago<br>
                        3810 - 193 Aveiro<br>
                        Portugal
                    </address>
                </div>

                <div class="modal-footer">
                    <a href="mailto:pedrolopes@ua.pt?subject=[COEUS] feedback" class="btn btn-info">Send Mail <i class="icon-envelope icon-white"></i></a>
                </div>
            </div>

            <s:layout-component name="body">
            </s:layout-component>
            
            <footer class="footer">
                <div class="container">
                    <span class="span2 pull-right"><a href="#">Back to top</a></span>
                    <p>&nbsp;</p>
                    <p>&copy; <a target="_blank" title="UA.PT Bioinformatics" href="http://bioinformatics.ua.pt/">University of Aveiro</a> 2013
                        <br />
                        Support provided by <a href="http://bmd-software.com" target="_blank">BMD Software, LDA</a>
                        <br />
                        <small>Under Development by <a href="http://pedrolopes.net" target="_blank">@pedrolopes</a> <a href="mailto:pedrolopes@ua.pt?subject=[COEUS] feedback"><i class="icon-envelope"></i></a></small>
                        <br />
                        <a href="http://getbootstrap.com/" title="Go to Bootstrap" target="_blank"><small>Layout with Bootstrap</small></a>
                    </p>
                </div>
            </footer>
        </body>
        <s:layout-component name="scripts">
            <jsp:include page="/layout/script.jsp" />
        </s:layout-component>
        <s:layout-component name="custom_scripts">
        </s:layout-component>
    </html>
</s:layout-definition>