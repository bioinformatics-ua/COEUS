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

            <div class="wrapper">

                <!-- Sidebar -->
                <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
                    <!-- Brand and toggle get grouped for better mobile display -->
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="http://bioinformatics.ua.pt/coeus/">COEUS <sub>v2.2</sub></a>
                    </div>

                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse navbar-ex1-collapse">
                        <ul class="nav navbar-nav side-nav">
                            <li id="index" class="sidebaritem"><a href="<c:url value="/overview/" />"><i class="fa fa-eye"></i> Overview</a></li>
                            <li id="sparql" class="sidebaritem"><a href="<c:url value="/sparqler/" />"><i class="fa fa-bar-chart-o"></i> SPARQL</a></li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-caret-square-o-down"></i> LinkedData <b class="caret"></b></a>
                                <ul class="dropdown-menu" id="sidebarseeds">
                                    <li><a href="#">(empty)</a></li>
                                </ul>
                            </li>
                            <!--<li><a href="charts.html"><i class="fa fa-bar-chart-o"></i> Charts</a></li>
                            <li><a href="tables.html"><i class="fa fa-table"></i> Tables</a></li>
                            <li><a href="forms.html"><i class="fa fa-edit"></i> Forms</a></li>
                            <li><a href="typography.html"><i class="fa fa-font"></i> Typography</a></li>-->
                            <li id="textsearch"><a href="<c:url value="/search/" />" ><i class="fa fa-search"></i> Text Search</a></li>
                            <li><a href="<c:url value="/documentation/" />" ><i class="fa fa-book"></i> Documentation</a></li>
                            <li><a data-toggle="modal" data-target="#contact"><i class="fa fa-group"></i> Contacts</a></li>
                            <li style="padding-left: 4px; padding-right: 4px; width: 100%;"><div style="border-top: solid 1px grey;"></div></li>
                            <li id="dashboard" class="sidebaritem"><a href="<c:url value="/manager/seed/" />"><i class="fa fa-dashboard"></i> Setup</a></li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-caret-square-o-down"></i> Manager <b class="caret"></b></a>
                                <ul class="dropdown-menu" >
                                    <li id="environments_setup"><a href="<c:url value="/manager/environments/" />"><i class="fa fa-exchange"></i> Environments</a></li>
                                    <li id="wizard"><a href="<c:url value="/manager/config/" />"><i class="fa fa-wrench"></i> Wizard</a></li>
                                </ul>
                            </li>

                        </ul>



                        <ul class="nav navbar-nav navbar-right navbar-user">
                            <li class="dropdown">
                                <a href="#" onclick="username('#remote_user');" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> Admin <b class="caret"></b></a>
                                <ul class="dropdown-menu hide" id="dropdown_remote_user">
                                    <li><a href="#"><i class="fa fa-star-o"></i> Welcome <span id="remote_user"></span></a></li>
                                    <li class="divider"></li>
                                    <li><a onclick="logout();"><i class="fa fa-power-off"></i> Logout</a></li>
                                </ul>
                            </li>
                            <!--                            <li class="dropdown alerts-dropdown">
                                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-bell"></i> Alerts <span class="badge">3</span> <b class="caret"></b></a>
                                                            <ul class="dropdown-menu">
                                                                <li><a href="#">Default <span class="label label-default">Default</span></a></li>
                                                                <li><a href="#">Primary <span class="label label-primary">Primary</span></a></li>
                                                                <li><a href="#">Success <span class="label label-success">Success</span></a></li>
                                                                <li><a href="#">Info <span class="label label-info">Info</span></a></li>
                                                                <li><a href="#">Warning <span class="label label-warning">Warning</span></a></li>
                                                                <li><a href="#">Danger <span class="label label-danger">Danger</span></a></li>
                                                                <li class="divider"></li>
                                                                <li><a href="#">View All</a></li>
                                                            </ul>
                                                        </li>-->

                        </ul>
                    </div><!-- /.navbar-collapse -->
                </nav>

                <div class="page-wrapper">

                    <s:layout-component name="body">

                    </s:layout-component>

                </div><!-- /#page-wrapper -->

            </div><!-- /#wrapper --> 

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

        </body>

        <footer id="footer">
            <div class="wrapper">
                <div class="page-wrapper">
                    <div class="container">
                        <p class="pull-right"><a href="#" title="Back to top"> <i class="fa fa-arrow-up"></i></a></p>
                        <p class="text-muted credit">&copy; <a target="_blank" title="UA.PT Bioinformatics" href="http://bioinformatics.ua.pt/">University of Aveiro</a> <script> document.write(new Date().getFullYear()); </script> - Support provided by <a href="http://bmd-software.com" target="_blank">BMD Software, LDA</a></p>
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