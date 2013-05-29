<%-- 
    Document   : management
    Created on : May 28, 2013, 1:55:42 PM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/setup/html.jsp">
    <s:layout-component name="title">COEUS Setup</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {
                $('#clean').tooltip();
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <div class="container">
            <br><br>
            <div class="page-header">
                <h1>Management</h1>
            </div>

            <h4>Knowledge Base</h4>
            <div class="row-fluid">
                <div class="span3">
                    <p>Triples </p>
                </div>
                <div class="span3">
                    <span class="label">0</span>
                </div>
                <div class="span3">
                    <p>Environment </p>
                </div>
                <div class="span3">
                    <div class="btn-group">
                        <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                            Production
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Production</a></li>
                            <li><a href="#">Testing</a></li>
                        </ul>
                    </div>
                </div>

            </div>

            <h4>Actions</h4>
            <div class="row-fluid">
                <div class="span3">
                    <div class="btn-group">
                        <a id="clean" href="#" class="btn btn-danger" data-placement="bottom" data-toggle="tooltip" title="Clean up knowledgebase" ><i class="icon-trash"></i> Cleanup</a>
                    </div>
                </div>
                <div class="span3">
                    <button class="btn btn-success" type="button">Rebuild</button>
                </div>
                <div class="span3">
                    <div class="btn-group">
                        <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                            Export
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="#">CSV</a></li>
                            <li><a href="#">XML</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            
            
        </div>
    </s:layout-component>
</s:layout-render>
