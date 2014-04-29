<%@include file="/layout/taglib.jsp" %>
<div class="container">
    <!--    <div class="span2 bs-docs-sidebar pull-left">
            <ul class="nav nav-list bs-docs-sidenav affix">
                <li><a href="#start">Start</a></li>
                <li><a href="#setup">Setup</a></li>
                <li><a href="#seed">Seed</a></li>
                <li><a href="#configuration">Configuration</a></li>
                <li><a href="#build">Build</a></li>
                <li><a href="#publish">Publish</a></li>
                <li><a href="#access">Access</a></li>
            </ul>
        </div>-->
    <!-- Tutorials/SWAT4LS -->
    <section id="start">
        <div class="page-header">
            <h1>Nanopublications <small>(Generation Process)</small></h1>
        </div>

        <p>COEUS has now the capability to share your data in the <a href="http://nanopub.org/nschema" target="_blank">Nanopublication format</a>. With this new plugin you can transform your integrated data in this prominent format by following the next steps:</p>
        <ol>
            <li>Go to the Nanopublication Section on the Dashboard.</li>
            <li>Select the concept root and related data that will generate the nanopublications.</li>
            <li>Fill out the provenance and additional information about the nanopublications.</li>
            <li>Start to Build nanopublications.</li>
            <li>When finished you can view the concept data items according to the nanopublication format.</li>
        </ol>
        <p><a href="<c:url value="/assets/files/nanopub_tutorial.pdf" />" target="_blank" class="btn btn-sm btn-primary">Download tutorial <i class="glyphicon glyphicon-file"></i></a></p>
    </section>
    <!-- Tutorials/SWAT4LS -->
    <section id="start">
        <div class="page-header">
            <h1>SWAT4LS <small>(with web interface)</small></h1>
        </div>
        <p><a href="http://www.swat4ls.org/workshops/edinburgh2013/" target="_blank">Visit website</a><br>
            <strong>December 9-12, 2013</strong> Edinburgh, United Kingdom</p>
        <p>In this tutorial/hands-on session, we will guide you through the process of creating your own custom COEUS knowledge base. You will learn how to:</p>
        <ol>
            <li>Create a new COEUS instance</li>
            <li>From GitHub download to web deployment</li>
            <li>Integrate data from heterogeneous *omics sources into your COEUS knowledge base</li>
            <li>Create your mashup merging multiple datasets</li>
            <li>Explore COEUS API to access aggregated data</li>
            <li>Build new rich web information systems using the API</li>
            <li>Access knowledge federation through the SPARQL and LinkedData interfaces
            </li>
        </ol>
        <p><a href="<c:url value="/assets/files/swat4ls_tutorial.pdf" />" target="_blank" class="btn btn-sm btn-primary">Download tutorial <i class="glyphicon glyphicon-file"></i></a></p>
    </section>
    <!-- Tutorials/START -->
    <section id="start">
        <div class="page-header">
            <h1>Multiple sources <small>(without web interface)</small></h1>
        </div>
        <p>
            In this first tutorial we will build a semantic knowledge base aggregating data from multiple sources. The tutorial configuration and datasets are provided
            on the default COEUS package. These include two examples: 1) COEUS News Aggregator (newsaggregator) and 2) COEUS Protein Integrator (proteinator). <br />
            In the first example COEUS aggregates data from multiple news sources, which are available in RSS/XML format, making
            it fairly easy to load and process. Moreover, the majority of online news outlets provides access to all the news through a RSS feed.
            <br />
            For the second example, COEUS loads imports data from multiple protein-related resources, creating our targeted proteomics knowledge base. Protein entries are created for
            resources from UniProt, PDB, Prosite and InterPro. UniProt entries are also associated with Gene Ontology terms and HGNC genes.
            <br />
            Since most of the tasks are very similar for both problems, this tutorial adequatly highlights the places where the options differ from the news aggregtor to the proteinator. 
            To create these applications, we will proceed as follows:
        <ol>
            <li><a href="#setup">Setup</a> local Java project</li>
            <li>Create COEUS' <a href="#seed">seed</a> setup (the connectors and selectors</li>
            <li>Update COEUS' <a href="#configuration">configuration</a> files</li>                                    
            <li>Launch the <a href="#build">build</a> engine</li>
            <li><a href="#publish">Publish</a> the default web application</li>                                      
            <li><a href="#access">Access</a> the collected data</li>                                      
        </ol>

        </p>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
    <section id="setup">
        <div class="page-header">
            <h2>Setup</h2>
        </div>

        <p>
            To launch our new seed we start by <a href="https://github.com/pdrlps/COEUS/archive/master.zip" target="_blank">downloading the COEUS package from GitHub</a> or <a href="https://github.com/pdrlps/COEUS/tree/master" target="_blank">checking out the source code</a> into a local installation. Further
            information regarding what's included in COEUS' package can be seen in the downloads section of this documentation.
            <br />
            For simplicity purposes, COEUS is provided as a NetBeans web project ready to be open. Hence, we just open the folder on our local NetBeans installation and setup the correct
            library references and select the instance server. By default, the new COEUS seed will run on a <code>/coeus/</code> application path, but we can easily change it in the project properties.
            <br />
            To finish our initial COEUS setup, we just need to create a new database and database user to be used as the triplestore backend by Jena. In this case, we will create a new database
            called <code>coeus</code>, and a new user also called <code>demo</code> (with password <code>demo</code>) with enough permissions to read and write in the database.
        </p>
        <div class="alert alert-info">
            <strong>Note</strong>: <a href="<c:url value="/assets/files/coeus.sql" />" title="Get COEUS database creation SQL">You can download the SQL code to create your database here <i class="icon-download-alt"></i></a>.
        </div>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

    <section id="seed">
        <div class="page-header">
            <h2>Seed</h2>
        </div>
        <p>
            Customizing the seed configuration is the most cumbersome task for COEUS deployment. The seed configuration defines the internal knowledge base structure, the application model, 
            the external resources being loaded and how the heterogeneous data are integrated. To simplify this task, the use of Protege is advised.
            <br >
            A sample seed configuration file is provided for each scenario. These scenarios are further detailed next.
        <dl>
            <dt>News Aggregator</dt>
            <dd>Setup file located in <code>src/java/newsaggregator/setup.rdf</code></dd>
            <dt>Protein Integrator</dt>
            <dd>Setup file located in <code>src/java/proteinator/setup.rdf</code></dd>
        </dl>
        </p>
        <h2>News aggregator</h2>
        <p>
            The first step is to define how our news integration model will map to COEUS' ontology. COEUS' ontology revolves a tree-based structure, <em>Entity-Concept-Item</em>, which will be used to
            organize our data collection in the knowledge base. For this scenario, we want to have a set of news organized according to their original source (an RSS/XML feed). We will use four sports journals: 
            the <a href="http://feeds.reuters.com/reuters/sportsNews" title="Open Reuters sports feed" target="_blank">international Reuters sports section</a>, 
            the <a href="http://feeds.bbci.co.uk/sport/0/rss.xml" title="Open BBC sports feed" target="_blank">british BBC sports section</a>, 
            the <a href="http://estaticos.marca.com/rss/portada.xml" title="Open Marca feed" target="_blank">spanish Marca journal</a> and 
            the <a href="http://www.abola.pt/rss/index.aspx" title="Open A Bola feed" target="_blank">portuguese A Bola journal</a>.
            For this matter, we will have the following structure:
        <ul>
            <li>
                <strong>News</strong> (Entity)
                <ul>
                    <li><strong>Reuters</strong> (Concept) &lt;-&gt; <strong>Reuters</strong> (Resource)</li>
                    <li><strong>BBC</strong> (Concept) &lt;-&gt; <strong>BBC</strong> (Resource)</li>
                    <li><strong>Marca</strong> (Concept) &lt;-&gt; <strong>Marca</strong> (Resource)</li>
                    <li><strong>A Bola</strong> (Concept) &lt;-&gt; <strong>A Bola</strong> (Resource)</li>
                </ul>
            </li>
        </ul>
        Each of the news' entries will be read and translated into a new Item individual, associated with the original source. Next, we detail some samples for the RDF describing the entities, concepts, resource connectors and selectors to integrate these data in a new COEUS seed. <br/>
        These examples can be found in the COEUS package.
        </p>
        <div class="bs-docs-example">
            We start with a new Entity, News, that will aggregate the news outlet concepts.
        </div>
        <pre class="prettyprint lang-xml linenums">
&lt;owl:NamedIndividual rdf:about="http://bioinformatics.ua.pt/coeus/resource/entity_News"&gt;
    &lt;rdf:type rdf:resource="http://bioinformatics.ua.pt/coeus/resource/Entity"/&gt;
    &lt;rdfs:label rdf:datatype="&xsd;string"&gt;entity_news&lt;/rdfs:label&gt;
    &lt;dc:title rdf:datatype="&xsd;string"&gt;News&lt;/dc:title&gt;
    &lt;rdfs:comment rdf:datatype="&xsd;string"&gt;News entity for COEUS News Aggregator&lt;/rdfs:comment&gt;
    &lt;isIncludedIn rdf:resource="http://bioinformatics.ua.pt/coeus/resource/seed_coeusna"/&gt;
&lt;/owl:NamedIndividual&gt;</pre>

        <div class="bs-docs-example">
            Next, we add the concept individuals for each of the news outlet we want to integrate. Only two of the four required concepts are shown next.
        </div>
        <pre class="prettyprint lang-xml linenums">
&lt;owl:NamedIndividual rdf:about="http://bioinformatics.ua.pt/coeus/resource/concept_Reuters"&gt;
    &lt;rdf:type rdf:resource="http://bioinformatics.ua.pt/coeus/resource/Concept"/&gt;
    &lt;rdfs:label rdf:datatype="&xsd;string"&gt;concept_reuters&lt;/rdfs:label&gt;
    &lt;dc:title rdf:datatype="&xsd;string"&gt;Reuters&lt;/dc:title&gt;
    &lt;hasEntity rdf:resource="http://bioinformatics.ua.pt/coeus/resource/entity_News"/&gt;
    &lt;isExtendedBy rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_Reuters"/&gt;
    &lt;hasResource rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_Reuters"/&gt;
&lt;/owl:NamedIndividual&gt;
       
&lt;owl:NamedIndividual rdf:about="http://bioinformatics.ua.pt/coeus/resource/concept_BBC"&gt;
    &lt;rdf:type rdf:resource="http://bioinformatics.ua.pt/coeus/resource/Concept"/&gt;
    &lt;rdfs:label rdf:datatype="&xsd;string"&gt;concept_bbc&lt;/rdfs:label&gt;
    &lt;dc:title rdf:datatype="&xsd;string"&gt;BBC&lt;/dc:title&gt;
    &lt;hasEntity rdf:resource="http://bioinformatics.ua.pt/coeus/resource/entity_News"/&gt;
    &lt;hasResource rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_BBC"/&gt;
    &lt;isExtendedBy rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_BBC"/&gt;
&lt;/owl:NamedIndividual&gt;</pre>

        <div class="bs-docs-example">
            Each concept can have one or more resource connectors associated with (whether directly or through extensions). In the following example, we detail the resource connector (<code>resource_BBC</code>) 
            and the associated selectors (targeted <code>xml_BBC_id</code>, <code>xml_BBC_title</code>, and the generic <code>xml_description</code>).
            to integrate data for the BBC concept.
        </div>
        <pre class="prettyprint lang-xml linenums">
&lt;owl:NamedIndividual rdf:about="http://bioinformatics.ua.pt/coeus/resource/resource_BBC"&gt;
    &lt;rdf:type rdf:resource="http://bioinformatics.ua.pt/coeus/resource/Resource"/&gt;
    &lt;rdfs:label rdf:datatype="&xsd;string"&gt;resource_bbc&lt;/rdfs:label&gt;
    &lt;query rdf:datatype="&xsd;string"&gt;//item&lt;/query&gt;
    &lt;order rdf:datatype="&xsd;integer"&gt;1&lt;/order&gt;
    &lt;dc:title rdf:datatype="&xsd;string"&gt;BBC&lt;/dc:title&gt;
    &lt;rdfs:comment rdf:datatype="&xsd;string"&gt;Resource loader for BBC XML feeds.&lt;/rdfs:comment&gt;
    &lt;method rdf:datatype="&xsd;string"&gt;cache&lt;/method&gt;
    &lt;endpoint rdf:datatype="&xsd;string"&gt;http://feeds.bbci.co.uk/sport/0/rss.xml&lt;/endpoint&gt;
    &lt;dc:publisher rdf:datatype="&xsd;string"&gt;xml&lt;/dc:publisher&gt;
    &lt;extends rdf:resource="http://bioinformatics.ua.pt/coeus/resource/concept_BBC"/&gt;
    &lt;isResourceOf rdf:resource="http://bioinformatics.ua.pt/coeus/resource/concept_BBC"/&gt;
    &lt;hasKey rdf:resource="http://bioinformatics.ua.pt/coeus/resource/xml_BBC_id"/&gt;
    &lt;loadsFrom rdf:resource="http://bioinformatics.ua.pt/coeus/resource/xml_BBC_id"/&gt;
    &lt;loadsFrom rdf:resource="http://bioinformatics.ua.pt/coeus/resource/xml_BBC_title"/&gt;
    &lt;loadsFrom rdf:resource="http://bioinformatics.ua.pt/coeus/resource/xml_description"/&gt;
    &lt;loadsFrom rdf:resource="http://bioinformatics.ua.pt/coeus/resource/xml_link"/&gt;
    &lt;loadsFrom rdf:resource="http://bioinformatics.ua.pt/coeus/resource/xml_date"/&gt;
&lt;/owl:NamedIndividual&gt;

&lt;owl:NamedIndividual rdf:about="http://bioinformatics.ua.pt/coeus/resource/xml_BBC_id"&gt;
    &lt;rdf:type rdf:resource="http://bioinformatics.ua.pt/coeus/resource/XML"/&gt;
    &lt;rdfs:label rdf:datatype="&xsd;string"&gt;xml_bbc_id&lt;/rdfs:label&gt;
    &lt;dc:title rdf:datatype="&xsd;string"&gt;BBC identifier&lt;/dc:title&gt;
    &lt;regex rdf:datatype="&xsd;string"&gt;[0-9]{5,}&lt;/regex&gt;
    &lt;property rdf:datatype="&xsd;string"&gt;dc:identifier&lt;/property&gt;
    &lt;query rdf:datatype="&xsd;string"&gt;guid&lt;/query&gt;
    &lt;loadsFor rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_BBC"/&gt;
    &lt;isKeyOf rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_BBC"/&gt;
&lt;/owl:NamedIndividual&gt;

&lt;owl:NamedIndividual rdf:about="http://bioinformatics.ua.pt/coeus/resource/xml_BBC_title"&gt;
    &lt;rdf:type rdf:resource="http://bioinformatics.ua.pt/coeus/resource/XML"/&gt;
    &lt;rdfs:label rdf:datatype="&xsd;string"&gt;xml_bbc_title&lt;/rdfs:label&gt;
    &lt;dc:title rdf:datatype="&xsd;string"&gt;BBC entry title&lt;/dc:title&gt;
    &lt;property rdf:datatype="&xsd;string"&gt;dc:title&lt;/property&gt;
    &lt;query rdf:datatype="&xsd;string"&gt;title&lt;/query&gt;
    &lt;loadsFor rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_BBC"/&gt;
&lt;/owl:NamedIndividual&gt;

&lt;owl:NamedIndividual rdf:about="http://bioinformatics.ua.pt/coeus/resource/xml_description"&gt;
    &lt;rdf:type rdf:resource="http://bioinformatics.ua.pt/coeus/resource/XML"/&gt;
    &lt;rdfs:label rdf:datatype="&xsd;string"&gt;xml_description&lt;/rdfs:label&gt;
    &lt;property rdf:datatype="&xsd;string"&gt;dc:description&lt;/property&gt;
    &lt;query rdf:datatype="&xsd;string"&gt;description&lt;/query&gt;
    &lt;dc:title rdf:datatype="&xsd;string"&gt;entry description&lt;/dc:title&gt;
    &lt;loadsFor rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_ABola"/&gt;
    &lt;loadsFor rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_BBC"/&gt;
    &lt;loadsFor rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_Marca"/&gt;
    &lt;loadsFor rdf:resource="http://bioinformatics.ua.pt/coeus/resource/resource_Reuters"/&gt;
&lt;/owl:NamedIndividual&gt;</pre>

        <p>
            With similar models defined for all the resources that will be integrated, we are now ready to configure our seed and get it ready for deployment.
        </p>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

    <section id="configuration">
        <div class="page-header">
            <h2>Configuration</h2>
        </div>
        <p>
            With the project code and the database setup in place, we can customize the configuration for each of the components provided in COEUS' package. We need to provide custom configurations
            for:
        <ul>
            <li>
                COEUS
                <ul>
                    <li>Seed ontology</li>
                    <li>Seed integration setup</li>
                    <li>Seed configuration</li>
                    <li>Seed web settings</li>
                </ul>
            </li>
            <li>Jena</li>
            <li>Joseki</li>
            <li>Pubby</li>
        </ul>
        </p>
        <h2>COEUS</h2>
        <h3>Seed ontology</h3>
        <p>
            In spite of Semantic Web's "reuse instead of rewrite" motto, in more complex scenarios we must create our own ontologies to deal with all the specificities of the new systems we are developing.
            This is not needed for these tutorials, where we will reuse existing ontologies such as Dublin Core or the Resource Description Framework Schema. Furthermore, COEUS ontology includes a broad
            number of object and data properties to further enhance our data integration efforts.
            <br />
            For now, we will stick to using COEUS' ontology, available at <code>http://bioinformatics.ua.pt/coeus/ontology/</code>.
        </p>
        <h3>Seed integration setup</h3>
        <p>
            The seed integration setup file was configured previously in Protege, defining the internal seed structure, the external resources to load, and the set of connectors and selectors for each integrated concept.
            <br />
            As mentioned, the setup files for each example are as follows.
        <dl>
            <dt>News Aggregator</dt>
            <dd>Setup file located in <code>src/java/newsaggregator/setup.rdf</code></dd>
            <dt>Protein Integrator</dt>
            <dd>Setup file located in <code>src/java/proteinator/setup.rdf</code></dd>
        </dl>
        </p>
        <h3>Seed configuration</h3>
        <p>
            The seed configuration file, <code>src/config.js</code>, stores the main application properties, setting these definitios for usage during the entire seed workflow.
        </p>
        <div class="bs-docs-example">
            This example details the seed configuration file used for the news aggregator sample.
        </div>
        <pre class="prettyprint lang-js linenums">
{
    "config": {
        "name": "coeus.NA",
        "description": "COEUS News Aggregator",
        "keyprefix":"coeus",
        "version": "1.0a",
        "ontology": "http://bioinformatics.ua.pt/coeus/ontology/",
        "setup": "newsaggregator/setup.rdf",
        "sdb":"newsaggregator/sdb.ttl",
        "predicates":"newsaggregator/predicates.csv",
        "built": false,
        "debug": true,
        "environment": "production"
    },
    "prefixes" : {
        "coeus": "http://bioinformatics.ua.pt/coeus/resource/",
        "owl2xml":"http://www.w3.org/2006/12/owl2-xml#",
        "xsd": "http://www.w3.org/2001/XMLSchema#",
        "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
        "owl": "http://www.w3.org/2002/07/owl#",
        "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "dc": "http://purl.org/dc/elements/1.1/",
    }
}</pre>
        <p>
            The COEUS package includes two sample configuration files, each for its tutorial.
        <dl>
            <dt>News Aggregator</dt>
            <dd>Configuration file located in <code>src/java/newsaggregator/config.js</code></dd>
            <dt>Protein Integrator</dt>
            <dd>Configuration file located in <code>src/java/proteinator/config.js</code></dd>
        </dl>
        COEUS' configuration properties are listed and detailed next, with values examplifying the protein integration scenario. All properties are mandatory.
        </p>
        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Property</th>
                    <th>Description</th>
                    <th>Sample</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>config.name</code></td>
                    <td>The seed default name.</td>
                    <td>proteinator</td>
                </tr>
                <tr>
                    <td><code>config.description</code></td>
                    <td>A sample seed description.</td>
                    <td>COEUS Protein Data Aggregator (Proteinator)</td>
                </tr>                    
                <tr>
                    <td><code>config.keyprefix</code></td>
                    <td>The default prefix to be used throughout the seed knowledge base. Should be set to the seed ontology prefix.</td>
                    <td>coeus</td>
                </tr>              
                <tr>
                    <td><code>config.version</code></td>
                    <td>The application version.</td>
                    <td>1.0a</td>
                </tr>              
                <tr>
                    <td><code>config.ontology</code></td>
                    <td>Valid URI for the base seed ontology location.</td>
                    <td>http://bioinformatics.ua.pt/coeus/ontology/</td>
                </tr>          
                <tr>
                    <td><code>config.setup</code></td>
                    <td>Seed setup file location (relative to project base).</td>
                    <td>proteinator/setup.rdf</td>
                </tr>          
                <tr>
                    <td><code>config.sdb</code></td>
                    <td>Jena SDB configuration file base location (relative to project base). This filename will be prepended to the working environment.</td>
                    <td>proteinator/sdb.ttl</td>
                </tr>      
                <tr>
                    <td><code>config.predicates</code></td>
                    <td>Predicates file location (relative to project base). The predicates file is a unique text-file including the list of all the predicates to use in the COEUS seed (one per line).</td>
                    <td>proteinator/predicates.csv</td>
                </tr>        
                <tr>
                    <td><code>config.apikey</code></td>
                    <td>String set for defining the valid API keys for client applications. API keys are basic strings, delimited by <strong>|</strong>. API keys are used in services with <strong>write</strong> access to the knowledge base to prevent abuse. <br/>Using <strong>*</strong> in this property will validate all values.</td>
                    <td>coeus|sdjkfhs8374</td>
                </tr> 
                <tr>
                    <td><code>config.built</code></td>
                    <td>Defines if the seed has been built or not (must be set to built once the knowledge base has been populated).</td>
                    <td>true</td>
                </tr> 
                <tr>
                    <td><code>config.debug</code></td>
                    <td>Defines if the debugging mode is on. With debug <strong>true</strong> the application output is more verbose.</td>
                    <td>true</td>
                </tr>
                <tr>
                    <td><code>config.environment</code></td>
                    <td>Sets the environment variable. Appended to the SDB configuration file location (with <strong>_</strong>). This allows for multiple environment settings, for production, testing...</td>
                    <td>production</td>
                </tr>
                <tr>
                    <td><code>prefixes</code></td>
                    <td>Defines the list of ontology prefixes being used in the seed.</td>
                    <td><em>See above</em></td>
                </tr>
            </tbody>
        </table>
        <h3>Web settings</h3>
        <p>
            Web application settings are Tomcat-wide settings for our server. The complex definitions are already configured, to launch a new seed we just need to customize 
            the application description and the location of the Joseki and Pubby libraries.<br />The following table details the properties that can be configured.
        </p>
        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Property</th>
                    <th>Description</th>
                    <th>Sample</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>&lt;description&gt;</code></td>
                    <td>Application description for Tomcat server.</td>
                    <td>COEUS: Semantic Web Application Framework</td>
                </tr>
                <tr>
                    <td><code>&lt;display-name&gt;</code></td>
                    <td>Application name for Tomcat server.</td>
                    <td>COEUS</td>
                </tr>
                <tr>
                    <td><code>&lt;servlet&gt; org.joseki.rdfserver.config</code></td>
                    <td>Joseki configuration file location (relative to server base).</td>
                    <td>proteinator/joseki.ttl</td>
                </tr>
                <tr>
                    <td><code>&lt;context-param&gt; config-file</code></td>
                    <td>Pubby configuration file location (relative to source base).</td>
                    <td>classes/proteinator/pubby.ttl</td>
                </tr>
            </tbody>
        </table>

        <h2>Jena</h2>
        With COEUS we use Jena internally for the knowledge base and triplestore management. By default, we use a MySQL triplestore with the SDB connection from Jena.
        This implies that we have to configure the connection string settings for the SDB database location. <br />For this tutorial, we will continue using the database we have 
        previously setup.
        <br />
        For each scenario, the Jena sample configuration files are organized as follows:
        <dl>
            <dt>News Aggregator</dt>
            <dd>SDB configuration file located in <code>src/java/newsaggregator/sdb_production.ttl</code></dd>
            <dt>Protein Integrator</dt>
            <dd>SDB configuration file located in <code>src/java/proteinator/sdb_production.ttl</code></dd>
        </dl>
        <div class="alert alert-info"><strong>Note</strong>: Further information regarding Jena's configuration can be found in the original <a href="http://jena.apache.org/documentation/sdb/store_description.html" target="_blank" title="Jump to Jena documentation">package documentation</a>.</div>
        <h2>Joseki</h2>
        The Joseki library is used to provide the SPARQL endpoint feature for COEUS. Joseki configuration is similar to Jena's, hence, we need to setup the database connection
        string to access our COEUS demo database.
        <br />
        For each scenario, the Joseki sample configuration files are organized as follows:
        <dl>
            <dt>News Aggregator</dt>
            <dd>SDB configuration file located in <code>src/java/newsaggregator/joseki.ttl</code></dd>
            <dt>Protein Integrator</dt>
            <dd>SDB configuration file located in <code>src/java/proteinator/joseki.ttl</code></dd>
        </dl>
        <div class="alert alert-info"><strong>Note</strong>: Further information regarding Joseki's configuration can be found in the original <a href="http://jena.apache.org/documentation/serving_data/index.html" target="_blank" title="Jump to Joseki's documentation">package documentation</a>.</div>
        <h2>Pubby</h2>
        To deliver collected data through a LinkedData interface COEUS uses the Pubby library. Pubby connects to any available SPARQL endpoint and enables accessing the data with RDF
        browsers or through regular web pages. Like Jena and Joseki, Pubby uses a .ttl configuration file to store the SPARQL endpoint connection data.
        <br/>
        For each scenario, the Pubby sample configuration files are organized as follows:
        <dl>
            <dt>News Aggregator</dt>
            <dd>SDB configuration file located in <code>src/java/newsaggregator/pubby.ttl</code></dd>
            <dt>Protein Integrator</dt>
            <dd>SDB configuration file located in <code>src/java/proteinator/pubby.ttl</code></dd>
        </dl>
        <div class="alert alert-info"><strong>Note</strong>: Further information regarding Pubby's configuration can be found in the original <a href="http://wifo5-03.informatik.uni-mannheim.de/pubby/" target="_blank" title="Jump to Pubby's documentation">package documentation</a>.</div>
    </section>

    <section id="build">
        <div class="page-header">
            <h2>Build</h2>
        </div>
        <p>
            With all the files configuration set up in COEUS we are now ready to start importing data into our own knowledge base. This is an automated process and to do this we simply need to execute a single Java method.
            <br />
            The main process will boot the system and, if the application is not build, load the data into the knowledge base. <br />
            The application startup/loading process works as follows:
        <ol>
            <li>Load application configuration from <code>config.js</code></li>
            <li>
                Seed is <strong>not built</strong>
                <ol>
                    <li>Connect to SDB Storage</li>
                    <li>Start API</li>
                    <li>Load seed predicates </li>
                    <li>Start build process and import data</li>
                </ol>
                Seed is <strong>built</strong>
                <ol>
                    <li>Connect to SDB Storage</li>
                    <li>Start API</li>
                    <li>Load seed predicates </li>
                </ol>
            </li>
            <li>Deploy seed</li>

        </ol>
        </p>
        <div class="bs-docs-example">
            To start the build process, we need to open the <strong>Run</strong> class in the <code>pt.ua.bioinformatics.coeus.common</code> package.
        </div>
        <pre class="prettyprint lang-java linenums">
// Start build process            
Boot.start();</pre>
        <div class="bs-docs-example">
            In alternative, we can load each resource individually (enabling multithreaded import operations) using the SingleImport method.
        </div>
        <pre class="prettyprint lang-java linenums">
// Import single resource (threaded) example
SingleImport single = new SingleImport("resource_go");
Thread t = new Thread(single);
t.start();</pre>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
    <section id="publish">
        <div class="page-header">
            <h2>Publish</h2>
        </div>
        <p>
            Once data are completely loaded in the seed, we just need to update the application settings and deploy the seed in Tomcat server.<br />
            To set the application to server mode, the following <code>config.js</code> configuration properties must be changed:
        <dl>
            <dt><code>config.built</code></dt>
            <dd>Must be changed to <strong>true</strong>. The application is already built.</dd>
            <dt><code>config.debug</code></dt>
            <dd>Can be changed to <strong>false</strong>. With the debug mode on the server output will be much more verbose.</dd>
        </dl>
        </p>
        <p>
            With these changes, the application is ready for deployment.
        </p>
        <div class="alert alert-warning"><strong>Warning</strong>: Beware that you need to update your Jena, Joseki and Pubby connection settings if you are changing the working environment to a distinct production server.</div>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
    <section id="access">
        <div class="page-header">
            <h2>Access</h2>
        </div>
        <p>
            With our COEUS seed online we can use any of the <a href="#api" id="show_api" title="Jump to API documentation">API</a> methods to access integrated data. 
            <br />
            Next, we have two quick SPARQL queries to obtain the data from the seeds configured in both tutorial scenarios.
        <div class="bs-docs-example">
            The following query lists complete info for all the news in the News Aggregator seed.
        </div>
        <pre class="prettyprint lang-java linenums">
PREFIX coeus:   &lt;http://bioinformatics.ua.pt/coeus/resource/&gt;
PREFIX rdf:  &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;
PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;
PREFIX diseasecard:   &lt;http://bioinformatics.ua.pt/diseasecard/resource/&gt;
PREFIX dc:   &lt;http://purl.org/dc/elements/1.1/&gt;

SELECT ?item ?title ?description {
?item a coeus:Item .
?item dc:title ?title .
?item dc:description ?description .
?item dc:date ?date
}</pre>
        <div class="bs-docs-example">
            The following query lists complete info for all the news in the News Aggregator seed.
        </div>
        <pre class="prettyprint lang-java linenums">
PREFIX coeus:   &lt;http://bioinformatics.ua.pt/coeus/resource/&gt;
PREFIX rdf:  &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;
PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;
PREFIX diseasecard:   &lt;http://bioinformatics.ua.pt/diseasecard/resource/&gt;
PREFIX dc:   &lt;http://purl.org/dc/elements/1.1/&gt;

SELECT ?item ?title ?description {
?item a coeus:Item .
?item dc:title ?title .
?item dc:description ?description .
?item dc:date ?date
}</pre>
        </p>
    </section>

</div>
