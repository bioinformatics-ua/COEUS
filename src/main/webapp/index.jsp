<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {
                changeSidebar('#index');
                tooltip();
                var qTriples = "SELECT (COUNT(*) AS ?n) {?s ?p ?o }";
                queryToResult(qTriples, function(result) {
                    $('#triples').html(result[0].n.value);
                });
                var qSeeds = "SELECT (COUNT(*) AS ?n) {?s a coeus:Seed }";
                queryToResult(qSeeds, function(result) {
                    $('#seeds').html(result[0].n.value);
                });
                var qEntities = "SELECT (COUNT(*) AS ?n) {?s a coeus:Entity }";
                queryToResult(qEntities, function(result) {
                    $('#entities').html(result[0].n.value);
                });
                var qConcepts = "SELECT (COUNT(*) AS ?n) {?s a coeus:Concept}";
                queryToResult(qConcepts, function(result) {
                    $('#concepts').html(result[0].n.value);
                });
                var qResources = "SELECT (COUNT(*) AS ?n) {?resource a coeus:Resource . FILTER NOT EXISTS {?resource dc:coverage ?object}}";
                queryToResult(qResources, function(result) {
                    $('#resources').html(result[0].n.value);
                });
                var qIssues = "SELECT (COUNT(*) AS ?n) {?resource dc:coverage ?object . ?resource a coeus:Resource}";
                queryToResult(qIssues, function(result) {
                    $('#issues').html(result[0].n.value);
                });
                callURL("./config/getconfig/", function(result) {
                    if (result.config.built === false)
                        $('#info').append(generateHtmlMessage("Alert! ", 'The Knowledge Base is not built. You must complete it by running the <a class="alert-link tip" data-toggle="tooltip" title="Start with COEUS" href="./manager/seed/">COEUS Setup</a>!', "alert-warning"));
                    else
                        $('#info').append(generateHtmlMessage("Info: ", 'The Knowledge Base is ready to use. Try out the <a class="alert-link tip" data-toggle="tooltip" title="Go to SPARQL" href="./sparqler/">SPARQL Search Engine</a>. ', "alert-info"));
                    if (result.config.wizard === false)
                        $('#info').append(generateHtmlMessage("State: ", 'This Application was successfully downloaded and installed from the <a class="alert-link tip" data-toggle="tooltip" title="Go to COEUS Website" href="http://bioinformatics.ua.pt/coeus/">COEUS Website</a>! Feel free to use according to your needs! ', "alert-success"));

                });
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">

            <div class="row">
                <div class="col-lg-12">
                    <h1>Welcome to COEUS!<small> Overview</small></h1>
                    <ol class="breadcrumb">
                        <li id="breadHome"><span class="glyphicon glyphicon-home"></span> </li>
                        <li class="active">Overview</li>
                    </ol>
                    <div id="info"></div>
                </div>
            </div><!-- /.row -->

            <div class="row">
                <div class="col-lg-6">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-6">
                                    <i class="fa fa-circle-o fa-5x"></i>
                                </div>
                                <div class="col-xs-6 text-right">
                                    <p class="announcement-heading" id="seeds">0</p>
                                    <p class="announcement-text">Seeds</p>
                                </div>
                            </div>
                        </div>
                        <a href="<c:url value="/manager/seed/"/>">
                            <div class="panel-footer announcement-bottom">
                                <div class="row">
                                    <div class="col-xs-6">
                                        View all
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <i class="fa fa-arrow-circle-right"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>  
                <div class="col-lg-6">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-6">
                                    <i class="fa fa-code-fork fa-5x"></i>
                                </div>
                                <div class="col-xs-6 text-right">
                                    <p class="announcement-heading" id="triples">0</p>
                                    <p class="announcement-text">Triples</p>
                                </div>
                            </div>
                        </div>
                        <a href="<c:url value="/sparqler/"/>">
                            <div class="panel-footer announcement-bottom">
                                <div class="row">
                                    <div class="col-xs-6">
                                        Explore
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <i class="fa fa-arrow-circle-right"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>        

            </div><!-- /.row -->

            <div class="row">
                <div class="col-lg-3">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-6">
                                    <i class="fa fa-dot-circle-o fa-5x"></i>
                                </div>
                                <div class="col-xs-6 text-right">
                                    <p class="announcement-heading" id="entities">0</p>
                                    <p class="announcement-text">Entities</p>
                                </div>
                            </div>
                        </div>
                        <a href="<c:url value="/manager/seed/"/>">
                            <div class="panel-footer announcement-bottom">
                                <div class="row">
                                    <div class="col-xs-6">
                                        View all
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <i class="fa fa-arrow-circle-right"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-6">
                                    <i class="fa fa-bullseye fa-5x"></i>
                                </div>
                                <div class="col-xs-6 text-right">
                                    <p class="announcement-heading" id="concepts">0</p>
                                    <p class="announcement-text">Concepts</p>
                                </div>
                            </div>
                        </div>
                        <a href="<c:url value="/manager/seed/"/>">
                            <div class="panel-footer announcement-bottom">
                                <div class="row">
                                    <div class="col-xs-6">
                                        View all
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <i class="fa fa-arrow-circle-right"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="panel panel-danger">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-6">
                                    <i class="fa fa-exclamation-triangle fa-5x"></i>
                                </div>
                                <div class="col-xs-6 text-right">
                                    <p class="announcement-heading" id="issues">0</p>
                                    <p class="announcement-text">Resources</p>
                                </div>
                            </div>
                        </div>
                        <a href="<c:url value="/manager/seed/"/>">
                            <div class="panel-footer announcement-bottom">
                                <div class="row">
                                    <div class="col-xs-6">
                                        Fix Issues
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <i class="fa fa-arrow-circle-right"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-6">
                                    <i class="fa fa-check fa-5x"></i>
                                </div>
                                <div class="col-xs-6 text-right">
                                    <p class="announcement-heading" id="resources">0</p>
                                    <p class="announcement-text">Resources</p>
                                </div>
                            </div>
                        </div>
                        <a href="<c:url value="/manager/seed/"/>">
                            <div class="panel-footer announcement-bottom">
                                <div class="row">
                                    <div class="col-xs-6">
                                        View all
                                    </div>
                                    <div class="col-xs-6 text-right">
                                        <i class="fa fa-arrow-circle-right"></i>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div><!-- /.row -->

        </div>

    </s:layout-component>
</s:layout-render>