<%@include file="/layout/taglib.jsp" %>
<div class="container">
    <!--    <div class="span2 bs-docs-sidebar pull-left">
            <ul id="nav_api" class="nav nav-list bs-docs-sidenav affix">
                <li><a href="#java">Java</a></li>
    
                <li><a href="#rest">REST</a></li>
    
                <li><a href="#sparql">SPARQL</a></li>
    
                <li><a href="#linkeddata">LinkedData</a></li>
    
                <li><a href="#javascript">Javascript</a></li>
            </ul>
        </div>-->

    <!-- API/JAVA -->

    <section id="java">
        <div class="page-header">
            <h1>Java</h1>
        </div>

        <h2>API</h2>

        <p>How are your Javadoc reading skills?<br>
            The Java documentation is pretty self-explanatory. For interacting with the knowledge base, use the <a title="Go to COEUS' API Javadoc" href="http://bioinformatics.ua.pt/coeus/javadoc/pt/ua/bioinformatics/coeus/api/API.html" target="_blank">API</a> class to add new triples and perform SPARQL queries directly.</p>

        <p><a class="btn right btn-info" href="../javadoc/" target="_blank" title="Go to COEUS' Javadoc">View Java Documentation</a></p>

        <div class="bs-docs-example">
            API call to retrieve data matching the given triple wildcards.
        </div>
        <pre class="prettyprint lang-java linenums">
/* Invoke getTriple(...); */
pt.ua.bioinformatics.api.API.getTriple(?coeus:uniprot_P51587?, ?p?, ?o?, ?xml?);                                </pre> 


        <div class="bs-docs-example">
            API call to perform given SPARQL query, with results in desired format (encapsulated in String).
        </div>
        <pre class="prettyprint lang-java linenums">
/* Invoke select(...); */
pt.ua.bioinformatics.api.API.select("SELECT ...", "js", false);                                </pre>
        <div class="bs-docs-example">
            API call to add new triples to the knowledge base.
        </div>
        <pre class="prettyprint lang-java linenums">
/* Invoke addStatement(...); */
pt.ua.bioinformatics.api.API.addStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), Boot.getAPI().createResource(PrefixFactory.decode(obj)));                                </pre>
        <h2>Factories</h2>

        <p>COEUS includes multiple factories to perform quick transformation between URIs, concepts, strings, prefixes, etc. We use these static methods throughout the entire framework, thus facilitating string-based data conversions.</p>

        <h3>Prefix Factory</h3>

        <p>The prefix factory is utility class for Prefix information and transformations. This class stores an internal prefix map, enabling quick composition or decomposition of full object URIs.</p>

        <div class="bs-docs-example">
            Get the URI for a given prefix.
        </div>
        <pre class="prettyprint lang-java linenums">
/* Invoke getURIForPrefix(...); */
pt.ua.bioinformatics.api.PrefixFactory.getURIForPrefix("rdfs");                                </pre>

        <div class="bs-docs-example">
            Encode a full URI into a prefixed string. For example, <span class="label label-info">http://bioinformatics.ua.pt/coeus/resource/Item</span> into <span class="label label-info">coeus:Item</span>. The opposite is also available with the decode() method.
        </div>
        <pre class="prettyprint lang-java linenums">
/* Invoke encode(...); */
pt.ua.bioinformatics.api.PrefixFactory.encode("http://bioinformatics.ua.pt/coeus/resource/Item");                                </pre>

        <h3>Item Factory</h3>

        <p>The item factory is a utility class for Item transformation tasks, such as getting an identifier from the full individual item label.</p>

        <div class="bs-docs-example">
            Retrieves the identifier token from a given item (both full URI or encoded string).
        </div>
        <pre class="prettyprint lang-java linenums">
/* Invoke getTokenFromItem...); */
pt.ua.bioinformatics.api.ItemFactory.getTokenFromItem("http://bioinformatics.ua.pt/coeus/resource/omim_143100");                                </pre>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

    <!-- API/REST -->

    <section id="rest">
        <div class="page-header">
            <h1>REST</h1>
        </div>
        <h2>Read access</h2>
        <p>To access all triples in COEUS Semantic Storage, you can combine subjects, objects or predicates wildcards to iteratively get data. The wildcards' usage is highlighted in the following table.</p>

        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Element</th><th>Description</th><th>Sample</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>subject</code></td><td>The existing or matching subject.</td><td>coeus:uniprot_P51582</td>
                </tr>
                <tr>
                    <td><code>predicate</code></td><td>The existing or matching predicate.</td><td>coeus:isAssociatedTo</td>
                </tr>
                <tr>
                    <td><code>object</code></td><td>The existing or matching object.</td><td>obj</td>
                </tr>
                <tr>
                    <td><code>format</code></td><td>The output format.</td><td>csv</td>
                </tr>
            </tbody>
        </table>

        <p>Some data output examples are:</p>

        <ul>
            <!--<li><a href="../api/triple/s/p/o" target="_blank">../api/triple/s/p/o</a> gets all triples: subject(<strong>s</strong>) - predicate(<strong>p</strong>) - object (<strong>o</strong>) in the Knowledge Base</li>-->

            <li><a href="../api/triple/coeus:uniprot_P78312/p/o" target="_blank">../api/triple/coeus:uniprot_P78312/p/o</a> gets all predicates (<strong>p</strong>) and objects (<strong>o</strong>) related to <strong>uniprot_P78312</strong></li>

            <li><a href="../api/triple/coeus:uniprot_P78312/coeus:isAssociatedTo/obj/csv" target="_blank">../api/triple/coeus:uniprot_P78312/coeus:isAssociatedTo/obj/csv</a> gets all objects (<strong>obj</strong>) with a <em>coeus:isAssociatedTo</em> relationship to <strong>uniprot_P78312</strong> (in CSV format)</li>
        </ul>

        <h2>Delete access</h2>
        <p>To delete triples in COEUS Semantic Storage, you must combine the subject, predicate and object wildcard to iteratively remove the data. The delete API URL structure is: </p>
        <ul>
            <li>../api/&lt;<em>API key</em>&gt;/delete/&lt;<em>subject</em>&gt;/<em>&lt;predicate&gt;</em>/&lt;object&gt;</li>
        </ul>
        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Element</th><th>Description</th><th>Sample</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>API key</code></td><td>Value for the seed access API key (defined in <strong>config.js</strong>).</td><td>coeus</td>
                </tr>
                <tr>
                    <td><code>subject</code></td><td>The existing subject.</td><td>coeus:uniprot_P51582</td>
                </tr>
                <tr>
                    <td><code>predicate</code></td><td>The existing predicate.</td><td>coeus:isAssociatedTo</td>
                </tr>
                <tr>
                    <td><code>object</code></td><td>The existing object.</td><td>coeus:go_GO:0033593</td>
                </tr>
            </tbody>
        </table>

        <p>Some examples are:</p>

        <ul>
            <li>../api/<em>api_key</em>/delete/<em>coeus:uniprot_Q13428</em>/<em>dc:title</em>/Q13428</li>
        </ul>
        <ul>
            <li>../api/<em>api_key</em>/delete/<em>coeus:uniprot_P51587</em>/<em>coeus:isAssociatedTo</em>/coeus:go_GO:0033593</li>
        </ul>

        <h2>Write access</h2>
        <p>COEUS write API provides a simple URL to add new triples to a seed's knowledge base. This enables also writing sets of triples by being invoked recursively. The write API URL structure is: </p>
        <ul>
            <li>../api/&lt;<em>API key</em>&gt;/write/&lt;<em>subject</em>&gt;/<em>&lt;predicate&gt;</em>/&lt;object&gt;</li>
        </ul>
        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Element</th><th>Description</th><th>Sample</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>API key</code></td><td>Value for the seed access API key (defined in <strong>config.js</strong>).</td><td>coeus</td>
                </tr>
                <tr>
                    <td><code>subject</code></td><td>The subject to write.</td><td>coeus:uniprot_P51582</td>
                </tr>
                <tr>
                    <td><code>predicate</code></td><td>The predicate to write.</td><td>coeus:isAssociatedTo</td>
                </tr>
                <tr>
                    <td><code>object</code></td><td>The object to write.</td><td>coeus:go_GO:0033593</td>
                </tr>
            </tbody>
        </table>

        <p>Some examples are:</p>

        <ul>
            <li>../api/<em>api_key</em>/write/<em>coeus:uniprot_Q13428</em>/<em>dc:title</em>/Q13428</li>
        </ul>
        <ul>
            <li>../api/<em>api_key</em>/write/<em>coeus:uniprot_P51587</em>/<em>coeus:isAssociatedTo</em>/coeus:go_GO:0033593</li>
        </ul>

        <h2>Update Access</h2>
        <p>
            COEUS update API provides a straightforward URL to update exiting triples in the knowledge base. The main difference between the delete or write API calls is the adding of the new object separated by a comma:<br/>
        </p>
        <ul>
            <li>../api/&lt;<em>API key</em>&gt;/update/&lt;<em>subject</em>&gt;/<em>&lt;predicate&gt;</em>/<em>&lt;old_object&gt;</em>,&lt;new_object&gt;</li>
        </ul>
        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Element</th><th>Description</th><th>Sample</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>API key</code></td><td>Value for the seed access API key (defined in <strong>config.js</strong>).</td><td>coeus</td>
                </tr>
                <tr>
                    <td><code>subject</code></td><td>The existing subject.</td><td>coeus:uniprot_P51582</td>
                </tr>
                <tr>
                    <td><code>predicate</code></td><td>The existing predicate.</td><td>coeus:isAssociatedTo</td>
                </tr>
                <tr>
                    <td><code>old_object,new_object</code></td><td>Combination of the existing object (old_object) and the new one (new_object).</td><td>coeus:go_GO:0033593, coeus:pdb_1N0W</td>
                </tr>
            </tbody>
        </table>
        <p>Some examples include:</p>

        <ul>
            <li>../api/<em>api_key</em>/update/<em>coeus:uniprot_Q13428</em>/<em>dc:title</em>/BRCA2_HUMAN,TCOF_HUMAN</li>
        </ul>
        <ul>
            <li>../api/<em>api_key</em>/update/<em>coeus:uniprot_P51587</em>/<em>coeus:isAssociatedTo</em>/coeus:go_GO:0033593,coeus:pdb_1N0W</li>
        </ul>

        <p>For XSD types just append the datatype (xsd:int, xsd:string,..) at the start of the literal:</p>

        <ul>
            <li>../api/<em>api_key</em>/update/<em>coeus:resource_BBC</em>/<em>dc:creator</em>/xsd:string:pdrlps,xsd:string:uavr</li>
        </ul>

        <p>
            The write/delete/update REST API returns a JSON object with the server response. The <strong>status</strong> field of that object contains a numeric value with the write operation output.
        </p>
        <dl>
            <dt>100</dt>
            <dd>All OK, triples written/deleted/updated to knowledge base.</dd>
            <dt>200</dt>
            <dd>Error adding/deleting/updating triples to knowledge base (check exception output).</dd>
            <dt>201</dt>
            <dd>Invalid subject.</dd>
            <dt>202</dt>
            <dd>Invalid predicate.</dd>
            <dt>203</dt>
            <dd>Invalid object.</dd>
            <dt>403</dt>
            <dd>Forbidden access, invalid API key.</dd>
        </dl>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

    <!-- API/SPARQL -->

    <section id="sparql">
        <div class="page-header">
            <h1>SPARQL</h1>
        </div>

        <p>All data collected in a COEUS instance can be accessed through a SPARQL endpoint and taking advantage of SPARQL's advanced querying features.</p>

        <p>The endpoint default location is at <span class="label label-info">/sparql</span>.</p>

        <div class="bs-docs-example">
            Query to get specific object data, in this case retrieves all predicates and objects for the individual created from UniProt's P51587 entry.
        </div>
        <pre class="prettyprint lang-sql linenums">
PREFIX coeus: &lt;http://bioinformatics.ua.pt/coeus/resource/&gt;

SELECT ?p ?o {coeus:uniprot_P51587 ?p ?o}                                </pre>

        <h3>SPARQL Federation</h3>

        <p>With the SPARQL endpoint online, querying multiple distributed COEUS instances is a straightforward process. Moreover, additional knowledge bases with public SPARQL endpoints can also be put into the mix, providing an holistic perspective over a distributed knowledge network.</p>

        <div class="bs-docs-example">
            Query to retrieve data from multiple COEUS seeds and external knowledge bases.
        </div>
        <pre class="prettyprint lang-sql linenums">
PREFIX coeus: &lt;http://bioinformatics.ua.pt/coeus/resource/&gt;
PREFIX dc: &lt;http://purl.org/dc/elements/1.1/&gt;
PREFIX diseasome: &lt;http://www4.wiwiss.fu-berlin.de/diseasome/resource/diseasome/&gt;
PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;
PREFIX coeus: &lt;http://bioinformatics.ua.pt/coeus/&gt;

SELECT ?pdb ?mesh
WHERE{
    {
        SERVICE &lt;http://www4.wiwiss.fu-berlin.de/diseasome/sparql&gt;
        {
                &lt;http://www4.wiwiss.fu-berlin.de/diseasome/resource/genes/BRCA2&gt; rdfs:label ?label
        }
    }
    {
        SERVICE &lt;http://bioinformatics.ua.pt/coeus/sparql&gt;
        {
                _:gene dc:title ?label.
                _:gene coeus:isAssociatedTo ?uniprot
        }
    }
    {
        SERVICE &lt;http://bioinformatics.ua.pt/coeus/sparql&gt;
        {
                ?uniprot coeus:isAssociatedTo ?pdb.
                ?pdb coeus:hasConcept coeus:concept_PDB
        }
    }
}
}                                </pre>

        <p><a class="btn right btn-info" href="../sparqler/">Test it here</a></p>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

    <!-- API/LINKEDDATA -->

    <section id="linkeddata">
        <div class="page-header">
            <h1>LinkedData</h1>
        </div>

        <p>COEUS publishes all data through LinkedData patterns &amp; guidelines by default. With <a href="http://www4.wiwiss.fu-berlin.de/pubby/" target="_blank">pubby</a> included in all COEUS seeds, data is easily available to external appications.<br>
            Using the <em>../resource/*</em> pattern, you can access object data in the web or RDF browsers.</p>

        <ul>
            <li><a href="../resource/uniprot_P78312">../resource/uniprot_P78312</a> HTML page for UniProt P78312</li>

            <li><a href="../data/uniprot_P78312?output=xml">../data/uniprot_P78312?output=xml</a> RDF content for UniProt P78312</li>
        </ul>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

    <!-- API/JAVASCRIPT -->

    <section id="javascript">
        <div class="page-header">
            <h1>Javascript</h1>
        </div>
        <h2>Data Access</h2>
        <p>Easily perform SPARQL queries to your COEUS-generated endpoint with this new library.<br>
            Check the documentation and the library at <a class="btn" href="<c:url value="/assets/js/coeus.sparql.js" />" target="_blank" title="Open COEUS Javascript SPARQL library">../assets/js/coeus.sparql.js</a>.</p>
        <h2>Changes on Seed</h2>
        <p>
            COEUS Write/Update/Delete API can be easily accessed in Javascript. <br />Check the documentation and sample at <a class="btn" href="<c:url value="/assets/js/coeus.api.js" />" target="_blank" title="Open COEUS Javascript SPARQL library">../assets/js/coeus.api.js</a>.</p>
        </p>
    </section>
</div>