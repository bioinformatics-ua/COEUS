<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/setup/html.jsp">
    <s:layout-component name="title">COEUS Setup</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {

            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div class="page-header">
                <h1>${actionBean.name} <small>Production</small></h1>
                <a href="../seed/">refresh</a>
            </div>

            <div class="row-fluid">
                <div class="span6">
                    <h4>Knowledge Base</h4>
                    <p class="text-info">Disease</p>
                    <ul>
                        <li>OMIM <span class="badge">1123</span></li>
                        <li>Orphanet <span class="badge">133</span></li>
                    </ul>
                    <p class="text-info">Drug</p>
                    <ul>
                        <li>PharmGKB <span class="badge">22331</span></li>
                    </ul>
                </div>
                <div class="span6">
                    <h4>Actions</h4>
                    <div class="row-fluid">
                        <div class="span4">
                            Environments
                        </div>
                        <div class="span4">
                            <select class="span10">
                                <option>Production</option>
                                <option>Testing</option>
                                <option>Development</option>
                            </select>
                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a href="#" class="btn btn-danger">Change environment</a>
                            </div>
                        </div>
                    </div>

                    <div class="row-fluid">
                        <div class="span4">
                            Entities
                        </div>
                        <div class="span4">
                            <select class="span10">
                                <option>Production</option>
                                <option>Testing</option>
                                <option>Development</option>
                            </select>
                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a href="#" class="btn btn-info">Add new Entity</a>
                            </div>
                        </div>
                    </div>

                    <div class="row-fluid">
                        <div class="span4">
                            Concepts
                        </div>
                        <div class="span4">
                            <select class="span10">
                                <option>Production</option>
                                <option>Testing</option>
                                <option>Development</option>
                            </select>
                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a href="#" class="btn btn-info">Add new Concept</a>
                            </div>
                        </div>
                    </div>

                    <div class="row-fluid">
                        <div class="span4">
                            Resources
                        </div>
                        <div class="span4">
                            <select class="span10">
                                <option>Production</option>
                                <option>Testing</option>
                                <option>Development</option>
                            </select>
                        </div>
                        <div class="span4">
                            <div class="btn-group">
                                <a href="#" class="btn btn-info">Add new Resource</a>
                            </div>

                        </div>
                    </div>
                </div>
            </div>



        </div>

    </s:layout-component>
</s:layout-render>
