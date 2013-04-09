<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">Tester - COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script src="<c:url value="/assets/js/coeus.write.js" />" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                // Write API example
                var map = {};
                map['dc:description'] = 'javas4!';
                map['rdfs:comment'] = 'javascript4234!';
                writeToSeed('coeus:uniprot_P11310', map, 'uavr');
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <div class="container">
            <div class="row span12">
                <div id="results">

                </div>
            </div>

        </div><!-- /container -->
    </s:layout-component>
</s:layout-render>