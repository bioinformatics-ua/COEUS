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
                <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,700italic,300,700' rel='stylesheet' type='text/css' />
                <link href="assets/css/bootstrap.min.css" rel="stylesheet" />               
                <link href="assets/css/docs.css" rel="stylesheet" />
            </head>
            <body>
                <div class="navbar navbar-inverse navbar-fixed-top">
                    <div class="navbar-inner">
                        <div class="container">
                            <a class="brand" href="./">COEUS</a> 
                            <div class="nav-collapse collapse">
                                <ul class="nav">
                                    <li>
                                        <a href="./">Home</a>
                                    </li>
                                    <li>
                                        <a href="documentation/">Documentation</a>
                                    </li>
                                    <li>
                                        <a href="science/">Science</a>
                                    </li>
                                    <li class="active">
                                        <a href="sparqler/">SPARQL</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container space">
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
                 <footer class="footer">
                <div class="container">
                    <span class="span2 pull-right"><a href="#">Back to top</a></span>
                    <p><br /></p>
                    <p> <a target="_blank" title="UA.PT Bioinformatics" href="http://bioinformatics.ua.pt/">University of Aveiro</a> 2013
                        <br />
                        Support provided by <a href="http://bmd-software.com" target="_blank">BMD Software, LDA</a>
                        <br />
                        <small>Under Development by <a href="http://pedrolopes.net" target="_blank">@pedrolopes</a> <a href="mailto:pedrolopes@ua.pt?subject=[COEUS] feedback"><i class="icon-envelope"></i></a></small>
                        <br />
                        <a href="http://twitter.github.com/bootstrap/" target="_blank"><small>Layout with Twitter Bootstrap</small></a>
                    </p>
                </div>
            </footer>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
