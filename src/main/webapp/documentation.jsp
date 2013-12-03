<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">Documentation - COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {
                // set bootstrap tab handlers
                $('#tabs a').click(function(e) {
                    e.preventDefault();
                    window.location.hash = e.target.hash;
                    $(this).tab('show');
                });

                // customize tab behaviour for inner sections (hashed)
                if (window.location.hash === '#basics' || window.location.hash === '#downloads' || window.location.hash === '#ontology' || window.location.hash.toString() === '#tutorials' || window.location.hash === '#registry' || window.location.hash === '#api' || window.location.hash === '#science' || window.location.hash === '#support' || window.location.hash === '#licensing') {
                    $('a[href=' + window.location.hash + ']').tab('show');
                } else {
                    var id = $(window.location.hash).parents('.tab-pane').attr('id');
                    $('a[href=#' + id + ']').tab('show');
                }

                window.prettyPrint && prettyPrint();
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <div class="container">
            <ul id="tabs" class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#basics">Basics</a></li>
                <li><a href="#downloads" data-toggle="tab">Downloads</a></li>
                <li><a href="#ontology" data-toggle="tab">Ontology</a></li>
                <li><a href="#tutorials" data-toggle="tab">Tutorials</a></li>
                <li><a href="#registry" data-toggle="tab">Registry</a></li>
                <li><a href="#api" data-toggle="tab">API</a></li>
                <li><a href="#science" data-toggle="tab">Science</a></li>
                <li><a href="#support" data-toggle="tab">Support</a></li>
                <li><a href="#licensing" data-toggle="tab">Licensing</a></li>
            </ul>

            <!-- BASICS -->
            <div class="tab-content">
                <div class="tab-pane fade in active" id="basics">
                    <c:import url="/docs/basics.jsp" />
                </div>

                <!-- REGISTRY -->
                <div class="tab-pane fade" id="registry">
                    <c:import url="/docs/registry.jsp" />
                </div>

                <!-- ONTOLOGY -->
                <div class="tab-pane fade" id="ontology">
                    <c:import url="/docs/ontology.jsp" />
                </div>

                <!-- API -->
                <div class="tab-pane fade" id="api">                    
                    <c:import url="/docs/api.jsp" />
                </div>

                <!-- TUTORIALS -->
                <div class="tab-pane fade" id="tutorials">                    
                    <c:import url="/docs/tutorials.jsp" />                    
                </div>

                <!-- DOWNLOADS -->
                <div class="tab-pane fade" id="downloads">
                    <c:import url="/docs/downloads.jsp" />
                </div>

                <!-- SUPPORT -->
                <div class="tab-pane fade" id="support">
                    <c:import url="/docs/support.jsp" />
                </div>
                
                <!-- Science -->
                <div class="tab-pane fade" id="science">
                    <c:import url="/docs/science.jsp" />
                </div>

                <!-- LICENSING -->
                <div class="tab-pane fade" id="licensing">
                    <c:import url="/docs/licensing.jsp" />
                </div>
            </div>
        </div>
    </s:layout-component>
</s:layout-render>