<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">SPARQL - COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {
                changeSidebar('#sparql');
                $('#pro_item_info').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\nPREFIX dc: <http://purl.org/dc/elements/1.1/>\n\nSELECT * { \n?uniprot coeus:hasConcept coeus:concept_UniProt . \n?uniprot dc:identifier ?id .\n?uniprot dc:title ?name \n}');
                });

                $('#pro_all_concept').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\n\nSELECT ?item {\n?item coeus:hasConcept coeus:concept_UniProt \n}');
                });

                $('#pro_count_items').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\n\nSELECT COUNT(DISTINCT ?tag) {\n?tag coeus:hasConcept coeus:concept_UniProt\n}');
                });

                $('#news_item_info').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\nPREFIX dc: <http://purl.org/dc/elements/1.1/>\n\nSELECT * { \n?bbc coeus:hasConcept coeus:concept_BBC .\n?bbc dc:identifier ?from .\n?bbc dc:title ?title \n}');
                });

                $('#news_all_concept').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\nSELECT ?item {?item coeus:hasConcept coeus:concept_BBC }');
                });

                $('#news_count_items').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\n\nSELECT COUNT(DISTINCT ?tag) {?tag coeus:hasConcept coeus:concept_BBC}');
                });

                $('#list_nanopubs').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\nPREFIX np: <http://www.nanopub.org/nschema#>\n\nSELECT ?np { GRAPH ?g { ?np a np:Nanopublication } }');
                });
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <div class="container space">
            <div class="row">

                <div class="col-md-9">
                    <section id="sparql">
                        <div class="page-header">
                            <h1>SPARQL</h1>
                        </div>
                        <ol class="breadcrumb">
                            <li id="breadHome"><span class="glyphicon glyphicon-home"></span> </li>
                            <li class="active">SPARQL</li>
                        </ol>
                        <p>You can test (or write) your SPARQL queries in the <span class="label label-info">query</span> box
                            or use one of the samples below.</p>
                        <div class="row">
                            <div class="col-md-4">
                                <p><strong>Proteinator</strong>
                                </p>
                                <ul>
                                    <li><a id="pro_item_info" href="#">Get Uniprot individuals info</a>
                                    </li>
                                    <li><a id="pro_all_concept" href="#">Get all Concept individuals</a>
                                    </li>
                                    <li><a id="pro_count_items" href="#">Get Item count for Concept</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <p><strong>NewsAggregator</strong>
                                </p>
                                <ul>
                                    <li><a id="news_item_info" href="#">Get BBC individuals info</a>
                                    </li>
                                    <li><a id="news_all_concept" href="#">Get all Concept individuals</a>
                                    </li>
                                    <li><a id="news_count_items" href="#">Get Item count for Concept</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <p><strong>Nanopublications</strong>
                                </p>
                                <ul>
                                    <li><a id="list_nanopubs" href="#">List all nanopubs</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <form action="../sparql" method="get" target="_blank">
                            <div class="clearfix">
                                <label label-default="label-default" for="query"><strong>Query</strong>
                                </label>
                                <div class="input">
                                    <textarea class="form-control" id="query" name="query" rows="16"></textarea> <span class="help-block">Please write your SPARQL query and select the output data format:</span>
                                </div>
                            </div>
                            <div class="clearfix">
                                <div class="input">
                                    <ul class="list-unstyled">
                                        <li>
                                            <label>
                                                <input type="radio" name="output" value="xml" checked="true" /> <span>HTML</span>
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" name="output" value="json" /> <span>JSON</span>
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" name="output" value="tsv" /> <span>TSV</span>
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" name="output" value="csv" /> <span>CSV</span>
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" name="output" value="text" /> <span>Text</span>
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input style="visibility: none;" type="checkbox" name="force-accept" value="text/plain"
                                                       /> <span>Force the accept header to <tt>text/plain</tt> regardless</span>
                                            </label>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="clearfix">
                                <div class="input">
                                    <input type="submit" class="btn btn-primary" value="Get Data" />
                                </div>
                            </div>
                            <input hidden="" style="display: none; visibility: hidden;" name="stylesheet"
                                   size="25" value="<c:url value="/translate"/>" />
                        </form>
                        <h2>Endpoint</h2>
                        <p>You can integrate COEUS data directly by using the SPARQL endpoint.
                            <br
                                />This endpoint replies to any SPARQL queries, including output format specifications
                            and distributed service connections.</p>
                        <p><a class="btn btn-default right disabled" target="_top" href="#">Endpoint at <em>/sparql</em></a>
                        </p>
                    </section>
                    <!--<section id="linkeddata">
                        <div class="page-header">
                            <h1>Linked Data</h1>
                        </div>
                        <p>You can also browse COEUS content through LinkedData methods.</p>
                        <div
                            class="row">
                            <div class="col-md-4">
                                <p><strong>Proteinator</strong>
                                </p>
                                <ul>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/uniprot_O15350" target="_top">Browse <em>UniProt P78312</em> data </a>
                                    </li>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/resource_UniProt"
                                           target="_top">Browse <em>UniProt Resource</em> </a>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <p><strong>NewsAggregator</strong>
                                </p>
                                <ul>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/concept_BBC" target="_top">Browse <em>BBC Concept</em> </a>
                                    </li>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/resource_BBC" target="_top">Browse <em>BBC Resource</em> </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </section>-->
                </div>
            </div>
        </div>
    </s:layout-component>
</s:layout-render>