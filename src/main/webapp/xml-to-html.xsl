<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:res="http://www.w3.org/2005/sparql-results#"
                exclude-result-prefixes="res xsl">
    <xsl:output
        method="xml" 
        indent="yes"
        encoding="UTF-8" 
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
        omit-xml-declaration="no" />

    <xsl:template name="header">
        <div>
            <h2>Header</h2>
            <xsl:for-each select="res:head/res:link"> 
                <p>Link to 
                    <xsl:value-of select="@href"/>
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template name="boolean-result">
        <div>
            <!--      
                <h2>Boolean Result</h2>
            -->      
            <p>ASK => 
                <xsl:value-of select="res:boolean"/>
            </p>
        </div>
    </xsl:template>

    <xsl:template name="vb-result">
        <div>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <xsl:for-each select="res:head/res:variable">
                            <th>
                                <xsl:value-of select="@name"/>
                            </th>
                        </xsl:for-each>
                    </tr>
                </thead>
                <tbody>
                    <xsl:text>
                    </xsl:text>
                    <xsl:for-each select="res:results/res:result">
                        <tr>
                            <xsl:apply-templates select="."/>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="res:result">
        <xsl:variable name="current" select="."/>
        <xsl:for-each select="/res:sparql/res:head/res:variable">
            <xsl:variable name="name" select="@name"/>
            <td>
                <xsl:choose>
                    <xsl:when test="$current/res:binding[@name=$name]">
                        <!-- apply template for the correct value type (bnode, uri, literal) -->
                        <xsl:apply-templates select="$current/res:binding[@name=$name]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- no binding available for this variable in this solution -->
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="res:bnode">
        <xsl:text>_:</xsl:text>
        <xsl:value-of select="text()"/>
    </xsl:template>

    <xsl:template match="res:uri">
        <xsl:variable name="uri" select="text()"/>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="res:literal">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:text>"</xsl:text>

        <xsl:choose>
            <xsl:when test="@datatype">
                <!-- datatyped literal value -->
                ^^&lt;
                <xsl:value-of select="@datatype"/>&gt;
            </xsl:when>
            <xsl:when test="@xml:lang">
                <!-- lang-string -->
                @
                <xsl:value-of select="@xml:lang"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="res:sparql">
        <html lang="en">
            <head>
                <title>SPARQL results - COEUS</title>     
                <link rel="shortcut icon" href="favicon.ico" />           
                <!--<link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,700italic,300,700' rel='stylesheet' type='text/css' />-->
                <link href="assets/css/bootstrap3.css" rel="stylesheet" />         
                <link href="assets/css/setup.css" rel="stylesheet" />
                <link href="assets/css/font-awesome.min.css" rel="stylesheet" />      
                <!--<link href="assets/css/docs.css" rel="stylesheet" />-->
            </head>
            <body>
                
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
                            <a class="navbar-brand" href="http://bioinformatics.ua.pt/coeus/">COEUS <sub>v2.0</sub></a>
                        </div>

                        <!-- Collect the nav links, forms, and other content for toggling -->
                        <div class="collapse navbar-collapse navbar-ex1-collapse">
                            <ul class="nav navbar-nav side-nav">
                               <!-- <li >
                                    <a href="./">
                                        <i class="fa fa-eye"></i> Overview</a>
                                </li>
                                <li>
                                    <a href="./manager/seed/">
                                        <i class="fa fa-dashboard"></i> Dashboard</a>
                                </li>-->
                                <li class="active">
                                    <a href="sparqler/">
                                        <i class="fa fa-arrow-circle-left"></i> Back</a>
                                </li><!--
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                        <i class="fa fa-caret-square-o-down"></i> LinkedData <b class="caret"></b>
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href="#">Seed Item</a>
                                        </li>
                                        <li>
                                            <a href="#">Seed Item</a>
                                        </li>
                                    </ul>
                                </li>-->
                                <!--<li><a href="charts.html"><i class="fa fa-bar-chart-o"></i> Charts</a></li>
                                <li><a href="tables.html"><i class="fa fa-table"></i> Tables</a></li>
                                <li><a href="forms.html"><i class="fa fa-edit"></i> Forms</a></li>
                                <li><a href="typography.html"><i class="fa fa-font"></i> Typography</a></li>
                                <li><a href="bootstrap-elements.html"><i class="fa fa-desktop"></i> Bootstrap Elements</a></li>
                                <li><a href="bootstrap-grid.html"><i class="fa fa-wrench"></i> Bootstrap Grid</a></li>
                                <li>
                                    <a data-toggle="modal" data-target="#contact">
                                        <i class="fa fa-user"></i> Contacts</a>
                                </li>-->

                            </ul>


                            <!--<ul class="nav navbar-nav navbar-right navbar-user">
                                <li class="dropdown messages-dropdown">
                                    <a href="./manager/seed/" class="dropdown-toggle" data-toggle="dropdown">
                                        <i class="fa fa-user"></i> Admin</a>
                                </li>
                                <li class="dropdown alerts-dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                        <i class="fa fa-bell"></i> Alerts <span class="badge">3</span> 
                                        <b class="caret"></b>
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href="#">Default <span class="label label-default">Default</span></a>
                                        </li>
                                        <li>
                                            <a href="#">Primary <span class="label label-primary">Primary</span></a>
                                        </li>
                                        <li>
                                            <a href="#">Success <span class="label label-success">Success</span></a>
                                        </li>
                                        <li>
                                            <a href="#">Info <span class="label label-info">Info</span></a>
                                        </li>
                                        <li>
                                            <a href="#">Warning <span class="label label-warning">Warning</span></a>
                                        </li>
                                        <li>
                                            <a href="#">Danger <span class="label label-danger">Danger</span></a>
                                        </li>
                                        <li class="divider"></li>
                                        <li>
                                            <a href="#">View All</a>
                                        </li>
                                    </ul>
                                </li>

                            </ul>-->
                        </div><!-- /.navbar-collapse -->
                    </nav>

                    <div class="page-wrapper">

                        <div class="container">
                            <div id="header" class="page-header">
                                <h1>SPARQL Results</h1>
                            </div>
                            <ol class="breadcrumb">
                            <li id="breadHome"><span class="glyphicon glyphicon-home"></span> </li>
                            <li>
                                <a href="sparqler/">SPARQL</a></li>
                            <li class="active">Results</li>
                            </ol>
                                
                            <xsl:if test="res:head/res:link">
                                <xsl:call-template name="header"/>
                            </xsl:if>

                            <xsl:choose>
                                <xsl:when test="res:boolean">
                                    <xsl:call-template name="boolean-result" />
                                </xsl:when>

                                <xsl:when test="res:results">
                                    <xsl:call-template name="vb-result" />
                                </xsl:when>

                            </xsl:choose>
                        </div>
                            
                    </div><!-- /#page-wrapper -->

                </div><!-- /#wrapper --> 
                 
            </body>
           
        </html>
    </xsl:template>
</xsl:stylesheet>
