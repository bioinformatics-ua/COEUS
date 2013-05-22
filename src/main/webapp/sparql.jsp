<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">SPARQL - COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {
                $('#pro_item_info').on('click', function() {
                    $('#query').val('SELECT ?predicate ?object {<http://bioinformatics.ua.pt/coeus/resource/uniprot_P51587> ?predicate ?object}');
                });

                $('#pro_all_concept').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\nSELECT ?item {?item coeus:hasConcept coeus:concept_UniProt }');
                });

                $('#pro_count_items').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\n\nSELECT COUNT(DISTINCT ?tag) {?tag coeus:hasConcept coeus:concept_UniProt}');
                });

                $('#news_item_info').on('click', function() {
                    $('#query').val('SELECT ?predicate ?object {<http://bioinformatics.ua.pt/coeus/resource/bbc_21774292> ?predicate ?object}');
                });

                $('#news_all_concept').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\nSELECT ?item {?item coeus:hasConcept coeus:concept_BBC }');
                });

                $('#news_count_items').on('click', function() {
                    $('#query').val('PREFIX coeus: <http://bioinformatics.ua.pt/coeus/resource/>\n\nSELECT COUNT(DISTINCT ?tag) {?tag coeus:hasConcept coeus:concept_BBC}');
                });
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <div class="container space">
            <div class="row-fluid">
                <div class="span3 bs-docs-sidebar">
                    <ul class="nav nav-list bs-docs-sidenav affix-top" data-spy="affix">
                        <li><a href="#sparql">SPARQL</a></li>
                        <li><a href="#linkeddata">LinkedData</a></li>
                    </ul>
                </div>
                <div class="span9">
                    <section id="sparql">
                        <div class="page-header">
                            <h1>SPARQL</h1>
                        </div>


                        <h2>Test your query</h2>

                        <p>You can test (or write) your SPARQL queries in the <span class="label label-info">query</span> box or use one of the samples below.</p>

                        <div class="row-fluid">
                            <div class="span4">
                                <p><strong>Proteinator</strong></p>
                                <ul>
                                    <li><a id="pro_item_info" href="#">Get individual Item info</a></li>

                                    <li><a id="pro_all_concept" href="#">Get all Concept individuals</a></li>

                                    <li><a id="pro_count_items" href="#">Get Item count for Concept</a></li>
                                </ul>
                            </div>
                            <div class="span4">
                                <p><strong>NewsAggregator</strong></p>

                                <ul>
                                    <li><a id="news_item_info" href="#">Get individual Item info</a></li>

                                    <li><a id="news_all_concept" href="#">Get all Concept individuals</a></li>

                                    <li><a id="news_count_items" href="#">Get Item count for Concept</a></li>
                                </ul>
                            </div>
                        </div>



                        <form action="../sparql" method="get">
                            <div class="clearfix">
                                <label for="query"><strong>Query</strong></label>
                                <div class="input">
                                    <textarea class="input-xxlarge" id="query" name="query" rows="16">
                                    </textarea> <span class="help-block">Please write your SPARQL query and select the output data format:</span>
                                </div>
                            </div>

                            <div class="clearfix">
                                <div class="input">


                                    <ul class="inputs-list unstyled">
                                        <li><label><input type="radio" name="output" value="xml" checked="true"> <span>HTML</span></label></li>

                                        <li><label><input type="radio" name="output" value="json"> <span>JSON</span></label></li>

                                        <li><label><input type="radio" name="output" value="tsv"> <span>TSV</span></label></li>

                                        <li><label><input type="radio" name="output" value="csv"> <span>CSV</span></label></li>

                                        <li><label><input type="radio" name="output" value="text"> <span>Text</span></label></li>

                                        <li><label><input style="visibility: none;" type="checkbox" name="force-accept" value="text/plain"> <span>Force the accept header to <tt>text/plain</tt> regardless</span></label></li>
                                    </ul>
                                </div>
                            </div>

                            <div class="clearfix">
                                <div class="input">
                                    <input type="submit" class="btn btn-primary" value="Get Data">
                                </div>
                            </div><input hidden="" style="display: none; visibility: hidden;" name="stylesheet" size="25" value="<c:url value="/translate" />">
                        </form>

                        <h2>Endpoint</h2>

                        <p>You can integrate COEUS data directly by using the SPARQL endpoint.<br>
                            This endpoint replies to any SPARQL queries, including output format specifications and distributed service connections.</p>

                        <p><a class="btn right disabled" target="_top" href="#">Endpoint at <em>/sparql</em></a></p>
                    </section>
                    <section id="linkeddata">
                        <div class="page-header">
                            <h1>Linked Data</h1>
                        </div>
                        <p>You can also browse COEUS content through LinkedData methods.</p>
                        <div class="row-fluid">
                            <div class="span4">
                                <p><strong>Proteinator</strong></p>
                                <ul>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/uniprot_P51587" target="_top">Browse <em>UniProt P51587</em> data</a></li>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/pdb_1N0W" target="_top">Browse <em>PDB 1N0W</em> data</a></li>
                                </ul>
                            </div>
                            <div class="span4">
                                <p><strong>NewsAggregator</strong></p>

                                <ul>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/bbc_21774292" target="_top">Browse <em>BBC 21774292</em> data</a></li>
                                    <li><a href="http://bioinformatics.ua.pt/coeus/resource/reuters_20130319" target="_top">Browse <em>Reuters 20130319</em> data</a></li>
                                </ul>
                            </div>
                        </div>

                    </section>
                </div>
            </div>
        </div>
    </s:layout-component>
</s:layout-render>