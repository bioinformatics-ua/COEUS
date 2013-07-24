<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/setup/html.jsp">
    <s:layout-component name="title">COEUS Setup</s:layout-component>
    <s:layout-component name="body">

        <div style="height: 100px;"></div>
        <style>
            .center {text-align: center; margin-left: auto; margin-right: auto; margin-bottom: auto; margin-top: auto;}
        </style>
        <title>Error 404</title>
        <body>
            <div class="hero-unit center">
                <h1>Page Not Found <small><font face="Tahoma" color="red">Error 404</font></small></h1>
                <br />
                <p>The page you requested could not be found, either contact your webmaster or try again. </p>
                <p>Use your browsers <b>Back</b> button to navigate to the page you have prevously come from</p>
                <p><b>Or you could just press this button:</b></p>
                <a href="/coeus/manager/seed/" class="btn btn-large btn-info"><i class="icon-home icon-white"></i> Take Me Home</a>
            </div>
            <br />


        </s:layout-component>
    </s:layout-render>
