<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html_site.jsp">
    <s:layout-component name="title">COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {

            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">


        <div class="header-image">

            <div class="headline">
                <div class="container">
                    <h1>COEUS</h1>
                    <h2>Streamlined back-end framework for rapid semantic web application development.</h2>
                </div>
            </div>

        </div><!-- /header-image -->

        <div class="jumbotron masthead">
            <div class="container">
                <h1>COEUS</h1>
                <p>Streamlined back-end framework for rapid semantic web application development.</p>
                <p> <a href="https://github.com/bioinformatics-ua/COEUS/archive/master.zip"
                       class="btn btn-inverse btn-lg">Get COEUS</a>
                </p>
                <ul class="masthead-links">
                    <li><a href="https://github.com/bioinformatics-ua/COEUS" target="_blank">GitHub project</a>
                    </li>
                    <li>Version 1.3</li>
                </ul>
            </div>
        </div>
        <div class="text-center hero-unit">
            <p><h1>SWAT4LS Workshop <sup><span class="label label-warning">New!! <i class="icon-star icon-white"></i></span></sup></h1></p>
        <p class="lead">A COEUS Workshop/Tutorial will be presented in the next edition of <a href="http://www.swat4ls.org/workshops/edinburgh2013/">SWAT4LS</a>.</p>
        <p class="lead">This workshop will be helded in Edinburgh, UK, December 9-12, 2013. </p>
        <p><a href="./science/#tutorial2013" class="btn btn-primary btn-large">View more »</a></p> 
    </div>
    <div class="container">
        <div class="marketing">
            <h1>Hello, Semantic Web!</h1>

            <p class="marketing-byline"><em>Ipsa scientia potestas est.</em> Knowledge itself is power.</p>

            <div class="row-fluid">
                <div class="span4">
                    <img src="assets/img/integrate.png" width="150" height="150" alt="Integration">

                    <h2>Integration</h2>

                    <p><strong>Create custom warehouses</strong>, collecting distributed and heterogeneous data.<br>
                        Integrate CSV, SQL, XML or SPARQL resources with advanced Extract-Transform-Load warehousing features.</p>
                </div>

                <div class="span4">
                    <img src="assets/img/cloud.png" width="150" height="150" alt="Cloud-based">

                    <h2>Cloud-based</h2>

                    <p><strong>Deploy your knowledgebase in the cloud</strong>, using any available host.<br>
                        Your content - available any time, any where. And with full create, read, update, and delete support.</p>
                </div>

                <div class="span4">
                    <img src="assets/img/semantic.png" width="150" height="150" alt="Semantic Web">

                    <h2>Semantics</h2>

                    <p><strong>Use Semantic Web &amp; LinkedData technologies in all application layers.</strong><br>
                        Enable reasoning and inference over connected knowledge. Access data through LinkedData interfaces and enable a custom SPARQL endpoint.</p>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    <img src="assets/img/rapid.png" width="150" height="150" alt="RAD">

                    <h2>Rapid Dev Time</h2>

                    <p><strong>Reduce development time.</strong> Get new applications up and running much faster using the latest rapid application development strategies.<br>
                        COEUS is the back-end framework, the client-side is language-agnostic: PHP, Ruby, JavaScript, C#... COEUS' APIs work everywhere.</p>
                </div>

                <div class="span4">
                    <img src="assets/img/network.png" width="150" height="150" alt="Interoperability">

                    <h2>Interoperability</h2>

                    <p><strong>Use COEUS advanced API to connect multiple nodes together and with any other software.</strong><br>
                        Create your own knowledge network using SPARQL Federation enabling data-sharing amongst a scalable number of peers</p>
                </div>

                <div class="span4">
                    <img src="assets/img/distribute.png" width="150" height="150" alt="Ecosystem">

                    <h2>Ecosystem</h2>

                    <p><strong>Launch your custom application ecosystem.</strong> Distribute your data to any platform or device.<br>
                        Reach more users and create new semantic cloud-based software platforms.</p>
                </div>
            </div>
            <hr class="soften">

            <h1>Build the future with COEUS</h1>

            <p class="marketing-byline">Semantic Web + Rapid Application Development = Next-Generation Applications.</p>

            <div class="row-fluid">
                <div class="span4">
                    <h2>Support</h2>

                    <p>COEUS is an ongoing open-source project at the <a href="http://www.ua.pt" target="_blank">University of Aveiro</a>'s <a href="http://bioinformatics.ua.pt" target="_blank">bioinformatics group</a>.<br>
                        If you are looking for support to launch your own system, please <a href="mailto:pedrolopes@ua.pt">contact us</a>. Private/commercial collaborations are also possible through <a href="http://bmd-software.com" target="_blank" title="View BMD Software">BMD Software</a>.</p>
                </div>

                <div class="span4">
                    <h2>Cite</h2>

                    <p>Multiple <a href="<c:url value="/science/" />" title="View COEUS publications">scientific publications</a> support COEUS architecture and development strategies. However, if you wish to cite COEUS in your work please use the following citation.</p>

                    <dl>
                        <dt>COEUS: "Semantic Web in a box" for biomedical applications</dt>

                        <dd>Pedro Lopes and Jose Luis Oliveira</dd>

                        <dd><em>Journal of Biomedical Semantics</em> 2012, 3:11</dd>

                        <dd>DOI:<a href="http://dx.doi.org/10.1186/2041-1480-3-11" target="_blank" title="View COEUS publication">10.1186/2041-1480-3-11</a></dd>
                    </dl>
                </div>

                <div class="span4">
                    <h2>Featured</h2><a title="Go to Diseasecard" target="_blank" href="http://bioinformatics.ua.pt/diseasecard/"><img src="<c:url value="/assets/img/dc4.png" />" width="200" height="29" alt="Diseasecard"></a>
                    <br/><br />
                    A new semantic rare diseases research portal. COEUS is the foundation of the internal application engine, enabling the delivery of advanced UI features and the exploration of collected knowledge programmatically.<br>
                    <br />
                    <p><a title="Go to Diseasecard" target="_blank"  class="btn btn-primary btn-info" href="http://bioinformatics.ua.pt/diseasecard/">Go to Diseasecard</a></p>
                </div>
            </div>
        </div>
    </div>  
</s:layout-component>
</s:layout-render>