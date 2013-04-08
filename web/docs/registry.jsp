<%@include file="/layout/taglib.jsp" %>
<div class="row">
    <div class="span2 bs-docs-sidebar pull-left">
        <ul class="nav nav-list bs-docs-sidenav affix">
            <li><a href="#formats">Formats</a></li>

            <li><a href="#datasources">Data Sources</a></li>
        </ul>
    </div>

    <div class="span9 pull-right">
        <section id="formats">
            <div class="page-header">
                <h1>Formats</h1>
            </div>

            <p>The following code snippets highlight how to configure data loading from the various supported formats. The examples include one resource connector and one or more selectors.</p>

            <h2>XML (RSS)</h2>

            <div class="bs-docs-example">
                This configuration specifies how to extract data from an RSS/XML feed. This example was taken from the News Aggregator tutorial.
            </div>
            <pre class="prettyprint lang-xml linenums">
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

coeus:xml_BBC_id coeus:isKeyOf coeus:resource_BBC;
    coeus:loadsFor coeus:resource_BBC;
    coeus:property "dc:identifier"^^&lt;&xsd;string&gt;;
    coeus:query "guid"^^&lt;&xsd;string&gt;;
    coeus:regex "[0-9]{5,}"^^&lt;&xsd;string&gt;;
    dc:title "BBC identifier"^^&lt;&xsd;string&gt;;
    a coeus:XML,
        owl:NamedIndividual;
    rdfs:label "xml_bbc_id"^^&lt;&xsd;string&gt;.

coeus:xml_BBC_title coeus:loadsFor coeus:resource_BBC;
    coeus:property "dc:title"^^&lt;&xsd;string&gt;;
    coeus:query "title"^^&lt;&xsd;string&gt;;
    dc:title "BBC entry title"^^&lt;&xsd;string&gt;;
    a coeus:XML,
        owl:NamedIndividual;
    rdfs:label "xml_bbc_title"^^&lt;&xsd;string&gt;.

coeus:xml_description coeus:loadsFor coeus:resource_BBC;
    coeus:property "dc:description"^^&lt;&xsd;string&gt;;
    coeus:query "description"^^&lt;&xsd;string&gt;;
    dc:title "entry description"^^&lt;&xsd;string&gt;;
    a coeus:XML,
        owl:NamedIndividual;
    rdfs:label "xml_description"^^&lt;&xsd;string&gt;.

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
            <pre class="prettyprint lang-xml linenums">
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
            <pre class="prettyprint lang-xml linenums">
coeus:csv_UniProt_entry coeus:isKeyOf coeus:resource_UniProt;
	coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:identifier"^^&lt;&xsd;string&gt;;
	coeus:query "0"^^&lt;&xsd;string&gt;;
	dc:title "UniProt entry"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_entry"^^&lt;&xsd;string&gt;.

coeus:csv_UniProt_entryname coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:title"^^&lt;&xsd;string&gt;;
	coeus:query "1"^^&lt;&xsd;string&gt;;
	dc:title "UniProt Entry Name"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_entryname"^^&lt;&xsd;string&gt;.

coeus:csv_UniProt_proteinname coeus:loadsFor coeus:resource_UniProt;
	coeus:property "dc:description"^^&lt;&xsd;string&gt;;
	coeus:query "3"^^&lt;&xsd;string&gt;;
	dc:title "UniProt Protein Name"^^&lt;&xsd;string&gt;;
	a coeus:CSV,
		owl:NamedIndividual;
	rdfs:label "csv_uniprot_proteinname"^^&lt;&xsd;string&gt;.
	
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
	rdfs:label "resource_uniprot".</pre>
        </section>

        <section id="datasources">
            <div class="page-header">
                <h1>Data Sources</h1>
            </div>
            <p>
                Coming soon!
            </p>
        </section>
    </div>
</div>
