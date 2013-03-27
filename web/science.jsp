<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">Science - COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {

            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <div class="container">
            <!-- Sidebar -->

            <div class="row-fluid">
                <div class="span3 bs-docs-sidebar space">
                    <ul class="nav nav-list bs-docs-sidenav affix-top" data-spy="affix">
                        <li><a href="#jbs">J Biomedical Semantics</a></li>
                        <li><a href="#white">White Paper</a></li>
                        <li><a href="#swat4ls">SWAT4LS</a></li>
                        <li><a href="#mixhs">MIX-HS</a></li>
                        <li><a href="#isemantics">I-SEMANTICS'11</a></li>
                    </ul>
                </div>

                <div class="span9">
                    <section id="jbs">
                        <div class="page-header">
                            <h1>Journal of Biomedical Semantics</h1>
                        </div>

                        <p><strong>COEUS: "Semantic Web in a box" for biomedical applications</strong><br>
                            <em>Pedro Lopes &amp; José Luís Oliveira</em><br>
                            DOI: <a href="http://dx.doi.org/10.1186/2041-1480-3-11" target="_blank">10.1186/2041-1480-3-11</a>
                            <br />
                            <small><span class="label label-info">Notice:</span> Please use this reference when citing COEUS in your work.</small>
                        </p>
                    </section>


                    <section id="white">
                        <div class="page-header">
                            <h1>COEUS White Paper</h1>
                        </div>

                        <p><a class="btn btn-small btn-inverse" href="<c:url value="/assets/files/coeus_whitepaper.pdf" />">Get Whitepaper <i class="icon-file icon-white"></i></a><br></p>
                    </section>

                    <section id="swat4ls">
                        <div class="page-header">
                            <h1>SWAT4LS 2011</h1>
                        </div>
                        <p><a href="http://www.swat4ls.org/workshops/london2011/" target="_blank">Visit website</a><br>
                            <strong>December 9th, 2011</strong> London, United Kingdom</p>

                        <p><strong>COEUS: A Semantic Web Application Framework</strong><br>
                            <em>Pedro Lopes &amp; José Luís Oliveira</em><br>
                            DOI: <a href="http://dx.doi.org/10.1145/2166896.2166915" target="_blank">10.1145/2166896.2166915</a></p>

                        <div data-configid="1292978/1825031" style="width: 650px; height: 488px;" class="issuuembed"></div><script type="text/javascript" src="//e.issuu.com/embed.js" async="true"></script>
                    </section>

                    <section id="mixhs">
                        <div class="page-header">
                            <h1>MIX-HS'11</h1>
                        </div>
                        <p><a href="http://informatics.mayo.edu/CNTRO/index.php/Events/MIXHS11/" target="_blank">Visit website</a><br>
                            <strong>October 28th, 2011</strong> Glasgow, Scotland</p>

                        <p><strong>A semantic web application framework for health systems interoperability</strong><br>
                            <em>Pedro Lopes &amp; José Luís Oliveira</em><br>
                            DOI: <a href="http://dx.doi.org/10.1145/2064747.2064768" target="_blank">10.1145/2064747.2064768</a></p>

                        <div data-configid="1292978/1825055" style="width: 650px; height: 488px;" class="issuuembed"></div><script type="text/javascript" src="//e.issuu.com/embed.js" async="true"></script>
                    </section>

                    <section id="isemantics">
                        <div class="page-header">
                            <h1>I-SEMANTICS 2011</h1>
                        </div>
                        <p><a href="http://i-semantics.tugraz.at/" target="_blank">Visit website</a><br>
                            <strong>September 7 - 9, 2011</strong> Graz, Austria</p>

                        <p><strong>Towards knowledge federation in biomedical applications</strong><br>
                            <em>Pedro Lopes &amp; José Luís Oliveira</em><br>
                            DOI: <a href="http://dx.doi.org/10.1145/2063518.2063530" target="_blank">10.1145/2063518.2063530</a></p>

                        <div data-configid="1292978/1825069" style="width: 650px; height: 488px;" class="issuuembed"></div><script type="text/javascript" src="//e.issuu.com/embed.js" async="true"></script>
                    </section>
                </div>
            </div>
        </div><!-- /container -->

    </s:layout-component>
</s:layout-render>