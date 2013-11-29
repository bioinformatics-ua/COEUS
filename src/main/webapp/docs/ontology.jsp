<%@include file="/layout/taglib.jsp" %>
<div class="container">
    <!--    <div class="span2 bs-docs-sidebar pull-left">
            <ul class="nav nav-list bs-docs-sidenav affix">
                <li><a href="#ontodoc">Ontology</a></li>
    
                <li><a href="#model">Model</a></li>
    
                <li><a href="#abstraction">Abstraction</a></li>
    
                <li><a href="#triplification">Triplification</a></li>
    
                <li><a href="#classes">Classes</a></li>
    
                <li><a href="#properties">Properties</a></li>
            </ul>
        </div>-->

    <!-- Ontology/ONTOLOGY -->
    <section id="ontodoc">
        <div class="page-header">
            <h1>Ontology</h1>
        </div>

        <p>For organising all resources and setting up a new seed, COEUS ontology comes to play.</p>

        <p><a href="../ontology/" target="_blank" class="btn btn-primary">Check it out</a>

            <a href="../ontology/doc" target="_blank" class="btn btn-info">Documentation is also available</a></p>
    </section><!-- Ontology/MODEL -->

    <section id="model">
        <div class="page-header">
            <h1>Model</h1>
        </div>

        <p>To manage as various data organisations as possible, COEUS data structure is organised in a tree: Entity &gt; Concept &gt; Item.<br>
            Entities are classes for the upper data types, Concepts for a middle division and Items for individual level.</p>

        <p>For example, to create a seed with transportation information we might have the following structure:</p>

        <ul>
            <li>
                <strong>Entity</strong>: Vehicle

                <ul>
                    <li>
                        <strong>Concept</strong>: Land

                        <ul>
                            <li><strong>Item</strong>: Car</li>

                            <li><strong>Item</strong>: Motorbike</li>
                        </ul>
                    </li>

                    <li><strong>Concept</strong>: Air</li>

                    <li><strong>Concept</strong>: Water</li>
                </ul>
            </li>
        </ul>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
    <!-- Ontology/ABSTRACTION -->
    <section id="abstraction">
        <div class="page-header">
            <h1>Abstraction</h1>
        </div>

        <p>The abstraction layer used the instance configuration to specify the precise bits of information that will be translated into the knowledge graph.</p>
        <div class="thumbnail">
            <img src="<c:url value="/assets/img/coeus_abstraction.png" />" alt="COEUS abstraction">
        </div>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
    <!-- Ontology/TRIPIFLICATION -->
    <section id="triplification">
        <div class="page-header">
            <h1>Triplification</h1>
        </div>

        <p>During the abstraction process, data are triplified. This means that new triples are generated in real time matching the configured properties. Developers can define the CSV columns, SQL query or XPath evaluation results that will be mapped to a configurable predicate from any ontology.</p>
        <div class="thumbnail">
            <img src="<c:url value="/assets/img/coeus_triplification.png" />" alt="COEUS triplification">
        </div>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
    <!-- Ontology/CLASSES -->
    <section id="classes">
        <div class="page-header">
            <h1>Classes</h1>
        </div>
        <h2>Seed</h2>
        <dl>
            <dt>Seed</dt>

            <dd>A Seed defines a single framework instance. In COEUS? model, Seed individuals are used to store a variety of application settings, such as component information, application descriptions, versioning or authors. Seed individuals are also connected to included entities through the :includes property (inverse of :isIncludedIn). This permits access to all data available in the seed, providing an over-arching entry point to the system information</dd>
        </dl>

        <h2>Entity - Concept - Item</h2>

        <dl >
            <dt>Entity</dt>

            <dd>Entity individuals match the general data terms. These are ?umbrella? elements, grouping concepts with a common set of properties (the :isEntityOf predicate).</dd>

            <dt>Concept</dt>

            <dd>Concept individuals are area-specific terms, aggregating any number of items (the :isConceptOf object property) and belonging to a unique entity (the :hasEntity object property).</dd>

            <dt>Item</dt>

            <dd>Item individuals are the basic terms, with no further granularity and representing unique identifiers from integrated datasets. Item individuals are connected through the :isAssociatedTo object property and linked uniquely to a concept through the :hasConcept predicate.</dd>
        </dl>

        <h2>Resources</h2>

        <dl >
            <dt>Resource</dt>

            <dd>External resource connector.<br />
                Resource individuals are used to store external resource integration properties. The configuration is further specialised with CSV, XML, JSON, RDF, TTL, SQL and SPARQL classes, mapping precise dataset results to the application model, through direct concept relationships. With the :hasResource property, the framework knows exactly what resources are connected to each concept and, subsequently, how to load data for each independent concept, generating new items.</dd>

            <dt>CSV</dt>

            <dd>External CSV selector.<br />Defines individual configuration properties to perform custom data abstractions from CSV files into COEUS' knowledge base.</dd>

            <dt>XML</dt>

            <dd>External XML selector.<br />Defines individual configuration properties to perform custom data abstractions from XML files into COEUS' knowledge base.</dd>

            <dt>JSON</dt>

            <dd>External JSON selector.<br />Defines individual configuration properties to perform custom data abstractions from JSON files into COEUS' knowledge base.</dd>

            <dt>LinkedData</dt>

            <dd>External LinkedData selector.<br />Defines individual configuration properties to perform external data link into COEUS' knowledge base.</dd>

            <dt>RDF</dt>

            <dd>External RDF selector.<br />Defines individual configuration properties to perform data import from RDF files into COEUS' knowledge base.</dd>

            <dt>TTL</dt>

            <dd>External TTL (Turtle) selector.<br />Defines individual configuration properties to perform data import from Turtle files into COEUS' knowledge base.</dd>

            <dt>SQL</dt>

            <dd>External SQL selector.<br />Defines individual configuration properties to perform custom data abstractions from SQL query results into COEUS' knowledge base.</dd>

            <dt>SPARQL</dt>

            <dd>External SPARQL selector.<br />Defines individual configuration properties to perform custom data abstractions from SPARQL query results into COEUS' knowledge base.</dd>
        </dl>
    </section>
    <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>

    <!-- Ontology/PROPERTIES -->
    <section id="properties">
        <div class="page-header">
            <h1>Properties</h1>
        </div>

        <p>One of COEUS' key liberating features (and of the Semantic Web) is the ability to use any ontology internally. Hence, we extend the existing COEUS ontology with well-known properties from external ontologies.</p>

        <h2>Data Properties</h2>

        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Property</th>

                    <th>Description</th>

                    <th>Mandatory</th>

                    <th>Domain</th>

                    <th>Range</th>

                    <th>Sample</th>
                </tr>
            </thead>

            <tbody>

                <tr>
                    <td><code>coeus:endpoint</code></td>

                    <td>
                        Defines a Resource endpoint.

                        <ul>
                            <li>For <strong>CSV</strong> resources, endpoint is the file location URI.</li>

                            <li>For <strong>XML</strong> resources, endpoint is the file location URI.</li>

                            <li>For <strong>JSON</strong> resources, endpoint is the file location URI.</li>

                            <li>For <strong>LD</strong> resources, endpoint is the location URI.</li>

                            <li>For <strong>RDF or TTL</strong> resources, endpoint is the file location URI.</li>

                            <li>For <strong>SQL</strong> resources, endpoint is the database connection string URI.</li>

                            <li>For <strong>SPARQL</strong> resources, endpoint is the SPARQL endpoint URI.</li>
                        </ul>
                        When the resource <strong>extends</strong> another concept, use the <strong>#replace#</strong> keyword to compose the URL with the values from the extended Concept items.
                    </td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource</td>

                    <td>String</td>

                    <td>file:///coeus.xml</td>
                </tr>

                <tr>
                    <td><code>coeus:extension</code></td>

                    <td>Defines the source element for a Resource extension query (where the data comes from).</td>

                    <td><span class="label label-warning">NO</span></td>

                    <td>Resource</td>

                    <td>String</td>

                    <td>rdfs:label</td>
                </tr>

                <tr>
                    <td><code>coeus:line</code></td>

                    <td>Starting line for CSV resource import.</td>

                    <td><span class="label label-warning">NO</span></td>

                    <td>Resource</td>

                    <td>String</td>

                    <td>2</td>
                </tr>

                <tr>
                    <td><code>coeus:loaded</code></td>

                    <td>Defines if a Seed, Entity, Concept is or is not built.</td>

                    <td><span class="label label-warning">NO</span></td>

                    <td>Seed, Entity, Concept</td>

                    <td>Boolean</td>

                    <td>false</td>
                </tr>

                <tr>
                    <td><code>coeus:method</code></td>

                    <td>
                        Defines a Resource integration method.

                        <ul>
                            <li>Use <strong>cache</strong> method to replicate resources in a local semantic warehouse.</li>

                            <li>Use <strong>map</strong> method to establish new mappings amongst existing resources in the knowledge base.</li>

                            <li>Use <strong>complete</strong> method to add new metadata to existing resources in the knowledge base.</li>
                        </ul>
                    </td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource</td>

                    <td>String</td>

                    <td>cache</td>
                </tr>

                <tr>
                    <td><code>coeus:order</code></td>

                    <td>Defines the Resource integration order (ASC).</td>

                    <td><span class="label label-warning">NO</span></td>

                    <td>Resource</td>

                    <td>Integer</td>

                    <td>0 (first)</td>
                </tr>

                <tr>
                    <td><code>coeus:property</code></td>

                    <td>Property selector defining the predicates to where integrated will be loaded to. Multiple predicates can be separated with the pipe (<strong>|</strong>) delimiter.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>CSV, XML, SQL, SPARQL</td>

                    <td>String</td>

                    <td>dc:title</td>
                </tr>

                <tr>
                    <td><code>coeus:query</code></td>

                    <td>
                        Query selector defining the queries to apply to integrated resources for data translation.

                        <ul>
                            <li>For <strong>resources</strong>, this means the global object query. For each individual answer to this query, new Item individuals will be created.

                                <ul>
                                    <li>For <strong>CSV</strong> resources, query is the combination of the headers skip number with the quotes delimiter (Ex: 1|") <a href="#notes">[1]</a>. </li>

                                    <li>For <strong>XML</strong> resources, query is the global XPath query (//entry).</li>

                                    <li>For <strong>JSON</strong> resources, query is the global JSONPath query ($.results.bindings[*]).</li>

                                    <li>For <strong>RDF/TTL</strong> resources, query is the URI or prefix of the individuals to link.</li>

                                    <li>For <strong>SQL</strong> resources, query is the SELECT query (SELECT * FROM ...).</li>

                                    <li>For <strong>SPARQL</strong> resources, query is the SPARQL SELECT query (SELECT ?s ?o { ... }).</li>
                                </ul>
                            </li>

                            <li>For <strong>connectors</strong>, this means the individual object query.

                                <ul>
                                    <li>For <strong>CSV</strong> selectors, query is the column number (0)</li>

                                    <li>For <strong>XML</strong> selectors, query is the internal XPath query (//item).</li>

                                    <li>For <strong>JSON</strong> selectors, query is the internal JSONPath query ($.obj.value).</li>

                                    <li>For <strong>SQL</strong> selectors, query is the query results column name (item).</li>

                                    <li>For <strong>SPARQL</strong> selectors, query is the query results variable name (item).</li>
                                </ul>
                            </li>
                        </ul>
                    </td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource, CSV, XML, SQL, SPARQL</td>

                    <td>String</td>

                    <td>//item</td>
                </tr>

                <tr>
                    <td><code>coeus:regex</code></td>

                    <td>Defines regular expression to get Item individual identification token from integrated resources.</td>

                    <td><span class="label label-success">NO</span></td>

                    <td>CSV, XML, SQL, SPARQL</td>

                    <td>String</td>

                    <td>[0-9]{5,}</td>
                </tr>

                <tr>
                    <td><code>dc:publisher</code></td>

                    <td>Defines the Resource connector type: CSV, XML, JSON, RDF, TTL, SQL or SPARQL. The selectors' configuration will be loaded according to this value.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource</td>

                    <td>String</td>

                    <td>sql</td>
                </tr>

                <tr>
                    <td><code>dc:title</code></td>

                    <td>All individuals must have a valid title.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Any</td>

                    <td>String</td>

                    <td>COEUS</td>
                </tr>

                <tr>
                    <td><code>rdfs:comment</code></td>

                    <td>All individuals must have a valid comment/description.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Any</td>

                    <td>String</td>

                    <td>COEUS is a new semantic web framework.</td>
                </tr>

                <tr>
                    <td><code>rdfs:label</code></td>

                    <td>All individuals must have a valid label.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Any</td>

                    <td>String</td>

                    <td>seed_COEUS</td>
                </tr>
            </tbody>
        </table>

        <h2>Object Properties</h2>

        <table class="table table-condensed table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Property</th>

                    <th>Description</th>

                    <th>Mandatory</th>

                    <th>Domain</th>

                    <th>Range</th>

                    <th>Sample</th>
                </tr>
            </thead>

            <tbody>
                <tr>
                    <td><code>coeus:extends</code></td>

                    <td>A Resource extends a Concept. This means that the subject resource will select data for processing from the concept Item individuals.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource</td>

                    <td>Concept</td>

                    <td>coeus:resource_UniProt <strong>coeus:extends</strong> coeus:concept_UniProt</td>
                </tr>

                <tr>
                    <td><code>coeus:hasConcept</code></td>

                    <td>An Item individual will belong (has) a certain Concept.</td>

                    <td><span class="label">AUTO</span></td>

                    <td>Item</td>

                    <td>Concept</td>

                    <td>coeus:uniprot_P51587 <strong>coeus:hasConcept</strong> coeus:concept_UniProt</td>
                </tr>

                <tr>
                    <td><code>coeus:hasEntity</code></td>

                    <td>A Concept belongs to (has) an Entity.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Concept</td>

                    <td>Entity</td>

                    <td>coeus:concept_UniProt <strong>coeus:hasEntity</strong> coeus:entity_Protein</td>
                </tr>

                <tr>
                    <td><code>coeus:hasKey</code></td>

                    <td>A Resource has a given key selector. The key selector will be used to generate unique Item individual identifications (i.e. URIs) from the integrated resources.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource</td>

                    <td>CSV, XML, SQL, SPARQL</td>

                    <td>coeus:resource_UniProt <strong>coeus:hasKey</strong> coeus:csv_UniProt_id</td>
                </tr>

                <tr>
                    <td><code>coeus:hasResource</code></td>

                    <td>A Concept is related to (has) a Resource. This defines the Resource individual connector that loads the data (generating items) for a given Concept.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Concept</td>

                    <td>Resource</td>

                    <td>coeus:concept_UniProt <strong>coeus:hasResource</strong> coeus:resource_UniProt</td>
                </tr>

                <tr>
                    <td><code>coeus:includes</code></td>

                    <td>Defines which Entity individuals are included in Seed individuals.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Seed</td>

                    <td>Entity</td>

                    <td>coeus:seed_COEUS <strong>coeus:includes</strong> coeus:entity_Protein</td>
                </tr>

                <tr>
                    <td><code>coeus:isAssociatedTo</code></td>

                    <td>Default association between two Item individuals loaded through Resource extensions (in the dependency graph).</td>

                    <td><span class="label">AUTO</span></td>

                    <td>Item</td>

                    <td>Item</td>

                    <td>coeus:uniprot_P51587 <strong>coeus:isAssociatedTo</strong> coeus:hgnc_BRCA2</td>
                </tr>

                <tr>
                    <td><code>coeus:isConceptOf</code></td>

                    <td>A concept individual is the Concept of multiple Item individuals.</td>

                    <td><span class="label">AUTO</span></td>

                    <td>Concept</td>

                    <td>Item</td>

                    <td>coeus:concept_HGNC <strong>coeus:isConceptOf</strong> coeus:hgnc_BRCA2</td>
                </tr>

                <tr>
                    <td><code>coeus:isConnectedTo</code></td>

                    <td>Default association between two Concept individuals. If two concepts are connected, then all their children items will be connected.</td>

                    <td><span class="label label-warning">NO</span></td>

                    <td>Concept</td>

                    <td>Concept</td>

                    <td>coeus:concept_UniProt <strong>coeus:isConnectedTo</strong> coeus:concept_HGNC</td>
                </tr>

                <tr>
                    <td><code>coeus:isEntityOf</code></td>

                    <td>An individual entity is the Entity of one or more Concept individuals.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Entity</td>

                    <td>Concept</td>

                    <td>coeus:entity_Protein <strong>coeus:isEntityOf</strong> coeus:concept_UniProt</td>
                </tr>

                <tr>
                    <td><code>coeus:isExtendedBy</code></td>

                    <td>An individual concept is extended by one or more Resource individuals (the connectors that load the data for the Concept).</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Concept</td>

                    <td>Resource</td>

                    <td>coeus:concept_UniProt <strong>coeus:isExtendedBy</strong> coeus:resource_HGNC</td>
                </tr>

                <tr>
                    <td><code>coeus:isIncludedIn</code></td>

                    <td>An entity individual is included in a seed.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Entity</td>

                    <td>Seed</td>

                    <td>coeus:entity_Protein <strong>coeus:isIncludedIn</strong> coeus:seed_COEUS</td>
                </tr>

                <tr>
                    <td><code>coeus:isKeyOf</code></td>

                    <td>A selector individual act as the loading key for generating unique Item individuals identification (URIs) to a given resource.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>CSV, XML, SQL, SPARQL</td>

                    <td>Resource</td>

                    <td>coeus:csv_UniProt_id <strong>coeus:isKeyOf</strong> coeus:resource_UniProt</td>
                </tr>

                <tr>
                    <td><code>coeus:isResourceOf</code></td>

                    <td>A resource individual is the Resource connector for the given Concept individual.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource</td>

                    <td>Concept</td>

                    <td>coeus:resource_UniProt <strong>coeus:isResourceOf</strong> coeus:concept_UniProt</td>
                </tr>

                <tr>
                    <td><code>coeus:loadsFor</code></td>

                    <td>A CSV, XML, SQL or SPARQL connector loads data for a Resource.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>CSV, XML, SQL, SPARQL</td>

                    <td>Resource</td>

                    <td>coeus:csv_UniProt_id <strong>coeus:loadsFor</strong> coeus:resource_UniProt</td>
                </tr>

                <tr>
                    <td><code>coeus:loadsFrom</code></td>

                    <td>A Resource loads data from a CSV, XML, SQL or SPARQL connector.</td>

                    <td><span class="label label-success">YES</span></td>

                    <td>Resource</td>

                    <td>CSV, XML, SQL, SPARQL</td>

                    <td>coeus:resource_UniProt <strong>coeus:loadsFrom</strong> coeus:csv_UniProt_id</td>
                </tr>
            </tbody>
        </table>
    </section>
    <section id="notes">
        <small >
            <strong>Notes:</strong>
            <p>[1] If query is not provided it will be tested some popular delimiters (such '\t', ';', .. ) with the default values for the quotes delimiter ('"') and for the headers skip number (1).</p>
        </small>
    </section>

</div>