<%@include file="/layout/taglib.jsp" %>
<div class="container">
<!--    <div class="span2 bs-docs-sidebar pull-left">
        <ul class="nav nav-list bs-docs-sidenav affix">
            <li><a href="#formats">Formats</a></li>

            <li><a href="#datasources">Data Sources</a></li>
        </ul>
    </div>-->

        <section id="formats">
            <div class="page-header">
                <h1>Formats</h1>
            </div>

            <p>The following code snippets highlight how to configure data loading from the various supported formats. The examples include one resource connector and one or more selectors.</p>

            <h2>XML (RSS)</h2>

            <div class="bs-docs-example">
                This configuration specifies how to extract data from an RSS/XML feed. This example was taken from the News Aggregator tutorial.
            </div>
            <pre class="prettyprint linenums">
# Resource configuration for BBC Sport News feed
coeus:resource_BBC coeus:endpoint "http://feeds.bbci.co.uk/sport/0/rss.xml"^^&lt;&xsd;string&gt;;
    coeus:extends coeus:concept_BBC;
    coeus:hasKey coeus:xml_BBC_id;
    coeus:isResourceOf coeus:concept_BBC;
    coeus:loadsFrom coeus:xml_BBC_id,
        coeus:xml_BBC_title,
        coeus:xml_description,
        coeus:xml_link;
    coeus:method "cache"^^&lt;&xsd;string&gt;;
    coeus:order "1"^^&lt;&xsd;integer&gt;;
    coeus:query "//item"^^&lt;&xsd;string&gt;;
    dc:publisher "xml"^^&lt;&xsd;string&gt;;
    dc:title "BBC"^^&lt;&xsd;string&gt;;
    a coeus:Resource,
        owl:NamedIndividual;
    rdfs:comment "Resource loader for BBC XML feeds."^^&lt;&xsd;string&gt;;
    rdfs:label "resource_bbc"^^&lt;&xsd;string&gt;.
    
# Loading news identifiers from XML XPath queries
coeus:xml_BBC_id coeus:isKeyOf coeus:resource_BBC;
    coeus:loadsFor coeus:resource_BBC;
    coeus:property "dc:identifier"^^&lt;&xsd;string&gt;;
    coeus:query "guid"^^&lt;&xsd;string&gt;;
    coeus:regex "[0-9]{5,}"^^&lt;&xsd;string&gt;;
    dc:title "BBC identifier"^^&lt;&xsd;string&gt;;
    a coeus:XML,
        owl:NamedIndividual;
    rdfs:label "xml_bbc_id"^^&lt;&xsd;string&gt;.

# Loading news titles from XML XPath queries
coeus:xml_BBC_title coeus:loadsFor coeus:resource_BBC;
    coeus:property "dc:title"^^&lt;&xsd;string&gt;;
    coeus:query "title"^^&lt;&xsd;string&gt;;
    dc:title "BBC entry title"^^&lt;&xsd;string&gt;;
    a coeus:XML,
        owl:NamedIndividual;
    rdfs:label "xml_bbc_title"^^&lt;&xsd;string&gt;.

# Loading news descriptions from XML XPath queries
coeus:xml_description coeus:loadsFor coeus:resource_BBC;
    coeus:property "dc:description"^^&lt;&xsd;string&gt;;
    coeus:query "description"^^&lt;&xsd;string&gt;;
    dc:title "entry description"^^&lt;&xsd;string&gt;;
    a coeus:XML,
        owl:NamedIndividual;
    rdfs:label "xml_description"^^&lt;&xsd;string&gt;.

# Loading news links from XML XPath queries
coeus:xml_link coeus:loadsFor coeus:resource_BBC;
    coeus:property "dc:publisher"^^&lt;&xsd;string&gt;;
    coeus:query "link"^^&lt;&xsd;string&gt;;
    dc:title "entry link"^^&lt;&xsd;string&gt;;
    a coeus:XML,
        owl:NamedIndividual;
    rdfs:label "xml_link"^^&lt;&xsd;string&gt;.</pre>

            <h2>SQL</h2>

            <div class="bs-docs-example">
                This resource definition describes how to load data from SQL query results.                    
            </div>
            <pre class="prettyprint linenums">
# Resource configuration for generic SQL resource
coeus:&coeus;resource_SomeSQL coeus:endpoint "jdbc:mysql://localhost:3306/\"db_name\"?user=\"user\"&password=\"pwd\""^^&lt;&xsd;string&gt;;
	coeus:hasKey coeus:&coeus;sql_id;
	coeus:isResourceOf coeus:&coeus;concept_SQL;
	coeus:loadsFrom coeus:&coeus;sql_id;
	coeus:method "cache"^^&lt;&xsd;string&gt;;
	coeus:order "20"^^&lt;&xsd;integer&gt;;
	coeus:query "SELECT b AS entry FROM hummer WHERE rel=37";
	dc:description "Resource connecting SQL information."^^&lt;&xsd;string&gt;;
	dc:publisher "sql"^^&lt;&xsd;string&gt;;
	dc:title "SomeSQL"^^&lt;&xsd;string&gt;;
	a coeus:&coeus;Resource,
		owl:NamedIndividual;
	rdfs:comment "Resource connecting SQL information."^^&lt;&xsd;string&gt;;
	rdfs:label "resource_somesql"^^&lt;&xsd;string&gt;.
	
# Loading data identifiers from SQL query "entry" variable
coeus:&coeus;sql_id coeus:isKeyOf coeus:&coeus;resource_SomeSQL;
	coeus:loadsFor coeus:&coeus;resource_SomeSQL;
	coeus:property "dc:title|dc:identifier"^^&lt;&xsd;string&gt;;
	coeus:query "entry"^^&lt;&xsd;string&gt;;
	dc:description "SQL identifier for data."^^&lt;&xsd;string&gt;;
	a coeus:&coeus;SQL,
		owl:NamedIndividual;
	rdfs:comment "SQL identifier for data."^^&lt;&xsd;string&gt;;
	rdfs:label "sql_id"^^&lt;&xsd;string&gt;.</pre>

            <h2>CSV</h2>

            <div class="bs-docs-example">
                This sample configuration details how to specify data imports from CSV files into COEUS' knowledge base. This example was taken from the Proteinator tutorial.                    
            </div>
            <pre class="prettyprint linenums">
# UniProt Resource configuration
coeus:resource_UniProt coeus:endpoint "http://www.uniprot.org/uniprot/?query=breast+cancer+AND+taxonomy%3a%22Homo+sapiens+%5b9606%5d%22&force=yes&format=tab&columns=id,entry%20name,reviewed,protein%20names,genes,organism,length"^^&lt;&xsd;string&gt;;
	coeus:extends coeus:concept_UniProt;
	coeus:hasKey coeus:csv_UniProt_entry;
	coeus:isResourceOf coeus:concept_UniProt;
	coeus:loadsFrom coeus:csv_UniProt_entry,
		coeus:csv_UniProt_entryname,
		coeus:csv_UniProt_proteinname;
	coeus:method "cache"^^&lt;&xsd;string&gt;;
	coeus:order "0"^^&lt;&xsd;integer&gt;;
	dc:publisher "csv"^^&lt;&xsd;string&gt;;
	dc:title "UniProt"^^&lt;&xsd;string&gt;;
	a coeus:Resource,
		owl:NamedIndividual;
	rdfs:comment "UniProt data loader."^^&lt;&xsd;string&gt;;
	rdfs:label "resource_uniprot".

# Loading UniProt accession entries from CSV column 0
coeus:csv_UniProt_entry coeus:isKeyOf coeus:resource_UniProt;
	coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:identifier"^^&lt;&xsd;string&gt;;
	coeus:query "0"^^&lt;&xsd;string&gt;;
	dc:title "UniProt entry"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_entry"^^&lt;&xsd;string&gt;.

# Loading UniProt entry names from CSV column 1
coeus:csv_UniProt_entryname coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:title"^^&lt;&xsd;string&gt;;
	coeus:query "1"^^&lt;&xsd;string&gt;;
	dc:title "UniProt Entry Name"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_entryname"^^&lt;&xsd;string&gt;.

# Loading UniProt proteint names from CSV column 3
coeus:csv_UniProt_proteinname coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:description"^^&lt;&xsd;string&gt;;
	coeus:query "3"^^&lt;&xsd;string&gt;;
	dc:title "UniProt Protein Name"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_proteinname"^^&lt;&xsd;string&gt;.</pre>
            
            <h2>JSON</h2>

            <div class="bs-docs-example">
                This sample configuration details how to specify data imports from JSON files into COEUS' knowledge base. This example was taken from the Tester sample.                    
            </div>
            <pre class="prettyprint linenums">
# Mesh Json Resource configuration
coeus:resource_mesh_cache coeus:endpoint "http://bioinformatics.ua.pt/diseasecard/api/triple/diseasecard:uniprot_P51587/coeus:isAssociatedTo/obj"^^<&xsd;string>;
	coeus:extends coeus:concept_mesh;
	coeus:hasKey coeus:json_mesh_type;
	coeus:isResourceOf coeus:concept_mesh;
	coeus:loadsFrom coeus:json_mesh_type;
	coeus:method "cache"^^<&xsd;string>;
	coeus:order "5"^^<&xsd;string>;
	coeus:query "$.results.bindings[*]"^^<&xsd;string>;
	dc:publisher "json"^^<&xsd;string>;
	dc:title "Resource mesh cache"^^<&xsd;string>;
	a coeus:Resource,
		owl:NamedIndividual;
	rdfs:comment "resource for mesh terms cache"^^<&xsd;string>;
	rdfs:label "resource_mesh_cache"^^<&xsd;string>.
# Loading mesh id from Json 
coeus:json_mesh_id coeus:isKeyOf coeus:resource_mesh_cache_ext;
	coeus:loadsFor coeus:resource_mesh_cache_ext;
	coeus:property "dc:identifier"^^<&xsd;string>;
	coeus:query "$.obj.value"^^<&xsd;string>;
	coeus:regex "D[0-9]{6}"^^<&xsd;string>;
	dc:title "json mesh identifier"^^<&xsd;string>;
	a coeus:class_json,
		owl:NamedIndividual;
	rdfs:label "json_mesh_id"^^<&xsd;string>.
# Loading mesh type from Json 
coeus:json_mesh_type coeus:loadsFor coeus:resource_mesh_cache;
	coeus:property "rdfs:comment"^^<&xsd;string>;
	coeus:query "$.obj.type"^^<&xsd;string>;
	dc:title "json mesh type"^^<&xsd;string>;
	a coeus:class_json,
		owl:NamedIndividual;
	rdfs:label "json_mesh_type"^^<&xsd;string>.
# Loading mesh uri from Json 
coeus:json_mesh_uri coeus:loadsFor coeus:resource_mesh_complete;
	coeus:property "dc:description"^^<&xsd;string>;
	coeus:query "$.obj.value"^^<&xsd;string>;
	dc:title "json mesh uri"^^<&xsd;string>;
	a coeus:class_json,
		owl:NamedIndividual;
	rdfs:label "json_mesh_uri"^^<&xsd;string>.

            </pre>
            <h2>RDF</h2>

            <div class="bs-docs-example">
                This sample configuration details how to specify data imports and individuals association from RDF/XML files into COEUS' knowledge base. This example was taken from the Tester sample.                    
            </div>
            <pre class="prettyprint linenums">
# UniProt RDF Resource configuration
coeus:resource_uniprot_rdf_complete coeus:endpoint "http://www.uniprot.org/uniprot/#replace#.rdf"^^<&xsd;string>;
	coeus:extends coeus:concept_uniprot;
	coeus:extension "dc:identifier"^^<&xsd;string>;
	coeus:isResourceOf coeus:concept_uniprot;
	coeus:method "complete"^^<&xsd;string>;
	coeus:order "12";
	coeus:query "http://purl.uniprot.org/uniprot/"^^<&xsd;string>;
	dc:publisher "rdf"^^<&xsd;string>;
	dc:title "Resource Uniprot RDF complete"^^<&xsd;string>;
	a coeus:Resource,
		owl:NamedIndividual;
	rdfs:comment "resource uniprot for rdf data"^^<&xsd;string>;
	rdfs:label "resource_uniprot_rdf_complete"^^<&xsd;string>.

            </pre>
            
            <h2>LinkedData</h2>

            <div class="bs-docs-example">
                This sample configuration details how to link data into COEUS' knowledge base. This example was taken from the Tester sample.                    
            </div>
            <pre class="prettyprint linenums">
# UniProt LinkedData Resource configuration
coeus:resource_uniprot_ld_complete coeus:endpoint "http://purl.uniprot.org/uniprot/#replace#"^^<&xsd;string>;
	coeus:extends coeus:concept_uniprot;
	coeus:extension "dc:identifier"^^<&xsd;string>;
	coeus:hasKey coeus:ld_uniprot_complete;
	coeus:isResourceOf coeus:concept_uniprot;
	coeus:loadsFrom coeus:ld_uniprot_complete;
	coeus:method "complete"^^<&xsd;string>;
	coeus:order "14";
	dc:publisher "ld"^^<&xsd;string>;
	dc:title "Resource Uniprot Linked Data"^^<&xsd;string>;
	a coeus:Resource,
		owl:NamedIndividual;
	rdfs:comment "resource uniprot for linked data "^^<&xsd;string>;
	rdfs:label "resource_uniprot_ld_complete"^^<&xsd;string>.
# Make the association
coeus:ld_uniprot_complete coeus:isKeyOf coeus:resource_uniprot_ld_complete;
	coeus:loadsFor coeus:resource_uniprot_ld_complete;
	coeus:property "rdfs:seeAlso"^^<&xsd;string>;
	coeus:query ""^^<&xsd;string>;
	dc:title "linkeddata uniprot complete"^^<&xsd;string>;
	a coeus:LD,
		owl:NamedIndividual;
	rdfs:label "ld_uniprot_complete"^^<&xsd;string>.

            </pre>
            
        </section>
        <span class="pull-right"><a href="#" title="Back to top"><i class="icon-arrow-up"></i></a></span>
        <section id="datasources">
            <div class="page-header">
                <h1>Data Sources</h1>
            </div>
            <h2>UniProt entries</h2>
             <div class="bs-docs-example">
                The following RDF snippet details how to load miscellaneous metadata for protein entries from a CSV files (provided by UniProt's services). This example is used in the Proteinator tutorial.                    
            </div>
            <pre class="prettyprint linenums">
# UniProt Resource configuration
coeus:resource_UniProt coeus:endpoint "http://www.uniprot.org/uniprot/?query=breast+cancer+AND+taxonomy%3a%22Homo+sapiens+%5b9606%5d%22&force=yes&format=tab&columns=id,entry%20name,reviewed,protein%20names,genes,organism,length"^^&lt;&xsd;string&gt;;
	coeus:extends coeus:concept_UniProt;
	coeus:hasKey coeus:csv_UniProt_entry;
	coeus:isResourceOf coeus:concept_UniProt;
	coeus:loadsFrom coeus:csv_UniProt_entry,
		coeus:csv_UniProt_entryname,
		coeus:csv_UniProt_proteinname;
	coeus:method "cache"^^&lt;&xsd;string&gt;;
	coeus:order "0"^^&lt;&xsd;integer&gt;;
	dc:publisher "csv"^^&lt;&xsd;string&gt;;
	dc:title "UniProt"^^&lt;&xsd;string&gt;;
	a coeus:Resource,
		owl:NamedIndividual;
	rdfs:comment "UniProt data loader."^^&lt;&xsd;string&gt;;
	rdfs:label "resource_uniprot".

# Loading UniProt accession entries from CSV column 0
coeus:csv_UniProt_entry coeus:isKeyOf coeus:resource_UniProt;
	coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:identifier"^^&lt;&xsd;string&gt;;
	coeus:query "0"^^&lt;&xsd;string&gt;;
	dc:title "UniProt entry"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_entry"^^&lt;&xsd;string&gt;.

# Loading UniProt entry names from CSV column 1
coeus:csv_UniProt_entryname coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:title"^^&lt;&xsd;string&gt;;
	coeus:query "1"^^&lt;&xsd;string&gt;;
	dc:title "UniProt Entry Name"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_entryname"^^&lt;&xsd;string&gt;.

# Loading UniProt proteint names from CSV column 3
coeus:csv_UniProt_proteinname coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:description"^^&lt;&xsd;string&gt;;
	coeus:query "3"^^&lt;&xsd;string&gt;;
	dc:title "UniProt Protein Name"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_proteinname"^^&lt;&xsd;string&gt;.</pre>

            <h2>InterPro/PDB/PROSITE identifiers</h2>
             <div class="bs-docs-example">
                The following sample details how to load data for multiple protein identifiers from UniProt's knowledge base. This enables building a network of identifiers related with a list of UniProt entries. Please that the extension sort is specified in the resource configuration. This example is taken from the Proteinator tutorial.                    
            </div>
            <pre class="prettyprint linenums">
# PDB Resource configuration
coeus:resource_PDB coeus:endpoint "http://uniprot.org/uniprot/#replace#.xml"^^&lt;&xsd;string&gt;;
	coeus:extends coeus:concept_UniProt;
	coeus:hasKey coeus:xml_PDB_id;
	coeus:isResourceOf coeus:concept_PDB;
	coeus:loadsFrom coeus:xml_PDB_id;
	coeus:method "cache"^^&lt;&xsd;string&gt;;
	coeus:order "11"^^&lt;&xsd;integer&gt;;
	coeus:query "//entry"^^&lt;&xsd;string&gt;;
	dc:publisher "xml"^^&lt;&xsd;string&gt;;
	dc:title "PDB"^^&lt;&xsd;string&gt;;
	a coeus:Resource,
		owl:NamedIndividual;
	rdfs:comment "Resource connecting PDB information."^^&lt;&xsd;string&gt;;
	rdfs:label "resource_pdb"^^&lt;&xsd;string&gt;.

# Loading PDB identifiers from UniProt's XML (with XPath)
coeus:xml_PDB_id coeus:isKeyOf coeus:resource_PDB;
	coeus:loadsFor coeus:resource_PDB;
	coeus:property "dc:title|dc:identifier"^^&lt;&xsd;string&gt;;
	coeus:query "//dbReference[@type='PDB']/@id"^^&lt;&xsd;string&gt;;
	dc:publisher "xml"^^&lt;&xsd;string&gt;;
	dc:title "PDB id"^^&lt;&xsd;string&gt;;
	a coeus:XML,
		owl:NamedIndividual;
	rdfs:label "xml_pdb_id"^^&lt;&xsd;string&gt;.</pre>
        </section>

</div>
