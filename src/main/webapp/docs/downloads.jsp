<%@include file="/layout/taglib.jsp" %>                  
<div class="row">
    <div class="span2 bs-docs-sidebar pull-left">
        <ul class="nav nav-list bs-docs-sidenav affix">
            <li><a href="#package">Package</a></li>

            <li><a href="#requirements">Requirements</a></li>

            <li><a href="#code">Code</a></li>

            <li><a href="#libraries">Libraries</a></li>

            <li><a href="#samples">Samples</a></li>
        </ul>
    </div><!-- Downloads/PACKAGE -->

    <div class="span9 pull-right">
        <section id="package">
            <div class="page-header">
                <h1>Package</h1>
            </div>

            <p><a href="https://github.com/pdrlps/COEUS/archive/master.zip" target="_blank" class="btn btn-large btn-info">Download COEUS</a></p>

            <p>Or you can fork the latest stable version from <a href="https://github.com/pdrlps/COEUS/tree/master" target="_blank">GitHub</a>.</p>
        </section>
        <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

        <!-- Downloads/REQUIREMENTS -->

        <section id="requirements">
            <div class="page-header">
                <h1>Requirements</h1>
            </div>

            <p>Despite COEUS' complexity, you can start your new seed with just a few external tools.<br></p>

            <ul>
                <li><a href="http://www.java.com/en/download/" target="_blank">Latest Java Version</a></li>

                <li><a href="http://netbeans.org/downloads/" target="_blank">NetBeans IDE 7.0+</a> (or your preferred development environment)</li>

                <li><a href="http://tomcat.apache.org/download-70.cgi" target="_blank">Apache Tomcat 6+</a></li>

                <li><a href="http://dev.mysql.com/downloads/" target="_blank">MySQL 5+</a></li>

                <li>Semantic Web technologies skills <span class="label label-warning">(not downloadable)</span></li>
            </ul>

            <p></p>
        </section>
        <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
        <!-- Downloads/CODE -->
        <section id="code">
            <div class="page-header">
                <h1>Code</h1>
            </div>

            <p>COEUS' code is organised in a traditional Maven Java Web application file structure.<br></p>

            <ul>
                <!--<li><code><code>target</code></code>: destination for application builds (on deployment)</li>-->

                <!--<li><code>dist</code>: destination for generated .war file (on deployment)</li>-->

                <li><code>pom.xml</code>: maven configuration file with the libraries dependencies</li>

                <!--<li><code>nbproject</code>: NetBeans configuration stuff</li>-->

                <li>
                    <code>src/main</code>: Java source code and configuration files

                    <ul>
                        <li><code>resources</code>: configuration files and examples</li>

                        <li><code>java</code>: location for main Java source </li>

                        <li><code>webapp</code>: web application source code 

                            <ul>
                                <li><code>assets</code>: location for CSS (<strong>css</strong>), Javascript (<strong>js</strong>) and image (<strong>img</strong>) files</li>

                                <li><code>javadoc</code>: COEUS and libraries generated Javadoc documentation</li>

                                <li><code>META-INF</code>: context information for Tomcat deployment</li>

                                <li><code>ontology</code>: COEUS' ontology documentation</li>

                                <li>
                                    <code>WEB-INF</code>: location for web application configuration file

                                    <ul>
                                        <li><code>templates</code>: location for <strong>pubby</strong> templates</li>
                                    </ul>
                                </li>
                            </ul>

                        </li>
                    </ul>
                </li>

                
            </ul>

            <p></p>
        </section>
        <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
        <!-- Downloads/LIBRARIES -->

        <section id="libraries">
            <div class="page-header">
                <h1>Libraries</h1>
            </div>

            <p></p>

            <p>COEUS follows a "Semantic Web in a box" approach. This means that all the required components to kickstart a new application are available by default in the COEUS package.</p>

            <dl>
                <dt><a href="http://jena.apache.org/" target="_blank">Jena</a></dt>

                <dd>Java framework for building Semantic Web applications.</dd>

                <dt><a href="http://jena.apache.org/documentation/serving_data/" target="_blank">Joseki</a></dt>

                <dd>SPARQL server. It provides REST-style SPARQL HTTP Update, SPARQL Query, and SPARQL Update using the SPARQL protocol over HTTP.</dd>

                <dt><a href="http://www4.wiwiss.fu-berlin.de/pubby/" target="_blank">Pubby</a></dt>

                <dd>A Linked Data Frontend for SPARQL Endpoints.</dd>

                <dt>SPARQL.js</dt>

                <dd>JavaScript library to query remote SPARQL endpoints.</dd>

                <dt><a href="http://www.stripesframework.org/" target="_blank" title="">Stripes</a></dt>

                <dd>Stripes is a presentation framework for building web applications using the latest Java technologies.</dd>

                <dt><a href="http://twitter.github.com/bootstrap/" target="_blank" title="">Bootstrap</a></dt>

                <dd>Sleek, intuitive, and powerful front-end framework for faster and easier web development..</dd>
            </dl>

            <p></p>
        </section>
        <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
        <!-- Downloads/SAMPLES -->

        <section id="samples">
            <div class="page-header">
                <h1>Samples</h1>
            </div>

            <h3>News Aggregator</h3>

            <p>Sample setup for integrating data from RSS/XML news feeds.<br>
                Configuration files available on <code>src/main/resources/newsaggregator</code>.</p>

            <h3>Proteinator</h3>

            <p>Sample setup from multiple proteomics sources. Starting with a list of protein entries (in CSV), loads data for genes from HGNC and protein mappings to Gene Ontology, InterPro, PROSITE and PDB from UniProt's database.<br>
                This example highlights how we can combine data from multiple heterogeneous resource using a single <strong>COEUS</strong> seed configuration.<br>
                Configuration files available on <code>src/main/resources/proteinator</code>.</p>
            
            <h3>Tester</h3>

            <p>Sample setup to test all different connection sources (CSV, XML, JSON, RDF, TTL, SQL and SPARQL).<br>
                Configuration files available on <code>src/main/resources/tester</code>.</p>

        </section>
    </div>
</div>