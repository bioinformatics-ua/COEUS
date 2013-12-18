<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">Error 404</s:layout-component>
    <s:layout-component name="body">

        <div style="height: 100px;"></div>
        <style>
            .center {
                text-align: center;
                margin-left: auto;
                margin-right: auto;
                margin-bottom: auto;
                margin-top: auto;
            }
        </style>

            <div class="center">
                <h1>Page Not Found <small>Error 404</small></h1>
                <br />
                <p>The page you requested could not be found, either contact your webmaster
                    or try again.</p>
                <p>Use your browser <b>Back</b> button to navigate to the page you have prevously
                    come from</p>
                <p><b>Or you could just press this button:</b>
                </p> <a href="/coeus/" class="btn btn-primary btn-lg"><i class="glyphicon glyphicon-home"></i> Take Me Home</a>
            </div>
            <br />



    </s:layout-component>
</s:layout-render>
