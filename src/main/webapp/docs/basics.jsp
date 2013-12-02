<%@include file="/layout/taglib.jsp" %>                  
<div class="container">

    <!-- Basics/GOALS -->
    <section id="goals">
        <div class="page-header">
            <h1>Goals</h1>
        </div>
        <p>COEUS is focused on <strong>integration</strong> and <strong>interoperability</strong>.
            These are the key goals that defined COEUS' development and its internal
            organization.
            <br />For a simpler interpretation of COEUS internal structure, we thought about
            organizing it according to a gardening metaphor.</p>
        <p>The first thing to consider are single COEUS instances. These standalone
            applications are built according to a configuration file, in Javascript,
            and a setup file, in RDF, adopting COEUS Ontology.</p>
        <p>Each COEUS instance integrates data in a mini-warehouse (or a large warehouse,
            depending on the number of resources you are collecting!) and is called
            a <em><strong>Seed</strong></em>.
            <br />Building a new seed involves three key steps:
        <ol>
            <li>Configure the resource integration settings. In this step we define what
                data we want to import, where the data comes from, how the data sources
                are connected, how they will be integrated, and, at last, to what ontologies/models
                will the newly imported data be matched.</li>
            <li>Build the knowledge base. This step loads the configuration files and
                imports data using flexible <strong>connectors</strong> (for CSV, XML, SQL,
                SPARQL, RDF, ...) resources, abstracting it to a semantic environment,
                using advanced data/ontology <strong>selectors</strong>.</li>
            <li>Access the collected data. The final step involves the creation of custom
                client applications that access all the integrated data available in the
                knowledge base through any of the available APIs. This simplifies the creation
                of new applications for web, desktop or mobile platforms.</li>
        </ol>
        </p>
        <p>Since all seeds publish acquired data by default, we can deploy multiple
            seeds and connect them easily, creating a knowledge federation layer: the <em><strong>Garden</strong></em>.</p>
    </section>

    <!-- Basics/ARCHITECTURE -->
    <section id="architecture">
        <div class="page-header">
            <h1>Architecture</h1>
        </div>

        <h2>Seeds</h2>

        <p>A single COEUS instance is a seed. This represents a standalone application, built from integrated resources, with a public API.</p>

        <div class="thumbnail">
            <img src="<c:url value="/assets/img/seed.png" />" alt="COEUS Seed">
        </div>

        <p></p>

        <h2>Garden</h2>

        <p>And you get multiple seeds working together... they bloom, creating a <strong>garden</strong>: a truly federated semantic knowledge network.</p>

        <div class="thumbnail">
            <img src="<c:url value="/assets/img/garden.png" />" alt="COEUS Garden">
        </div>

    </section>

</div>