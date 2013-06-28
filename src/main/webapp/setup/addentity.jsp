<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/setup/html.jsp">
    <s:layout-component name="title">COEUS Setup</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script src="<c:url value="/assets/js/jquery.js" />"></script>
        <script src="<c:url value="/assets/js/coeus.sparql.js" />"></script>
        <script src="<c:url value="/assets/js/coeus.api.js" />"></script>
        <script src="<c:url value="/assets/js/bootstrap-tooltip.js" />"></script>
        <script type="text/javascript">

            $(document).ready(function() {

                //header name
                var path=lastPath();
                $('#header').append('<h1>' + path + '<small> env.. </small></h1>');
                
                //activate tooltip (bootstrap-tooltip.js is need)
                $('.icon-question-sign').tooltip();
            });

            $('#submit').click(function() {
                submit();
                //if one fail the others fails too
                if (document.getElementById('result').className === 'alert alert-error') {
                    $('#callModal').click();
                }
                if (document.getElementById('result').className === 'alert alert-success') {
                    window.location = "../entity/";
                }
            });

            function submit() {

                var type = 'Entity';
                var individual = $('#uri').html();
                var title = $('#title').val();
                var label = $('#label').val();
                var seed = $('#seed').val();
                var comment = $('#comment').val();

                var predType = "rdf:type";
                var predTitle = "dc:title";
                var predLabel = "rdfs:label";
                var predSeed = "coeus:isIncludedIn";
                var predComment = "rdfs:comment";

                var urlWrite = "../../../api/" + getApiKey() + "/write/";

                // verify all fields:
                var empty = false;
                if (title === '') {
                    $('#titleForm').addClass('controls control-group error');
                    empty = true;
                }
                if (label === '') {
                    $('#labelForm').addClass('controls control-group error');
                    empty = true;
                }
                if (comment === '') {
                    $('#commentForm').addClass('controls control-group error');
                    empty = true;
                }
                if (!empty) {

                    callAPI(urlWrite + individual + "/" + predType + "/owl:NamedIndividual", '#result');
                    callAPI(urlWrite + individual + "/" + predType + "/coeus:" + type, '#result');
                    callAPI(urlWrite + individual + "/" + predTitle + "/xsd:string:" + title, '#result');
                    callAPI(urlWrite + individual + "/" + predLabel + "/xsd:string:" + label, '#result');
                    callAPI(urlWrite + individual + "/" + predSeed + "/" + lastPath(), '#result');
                    callAPI(urlWrite + individual + "/" + predComment + "/xsd:string:" + comment, '#result');

                    // /api/coeus/write/coeus:uniprot_Q13428/dc:title/Q13428
                    //window.location = "../entity/";
                }


            }
            
            function changeURI(value) {
                //var specialChars = "!@#$^&%*()+=-[]\/{}|:<>?,. ";
                document.getElementById('uri').innerHTML = 'coeus:entity_' + value.split(' ').join('_');
            }
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>
            <p class="lead" >Entity URI - <a class="lead" id="uri">coeus: </a></p>

            <div class="row-fluid">
                <h4>New Entity: </h4>
                <div class="span4" >


                    <div id="titleForm" >
                        <label class="control-label" for="title">Title</label>
                        <input id="title" type="text" placeholder="Ex: Uniprot" onkeyup="changeURI(this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the dc:title property" ></i>
                    </div>
                    <div id="labelForm"> 
                        <label class="control-label" for="label">Label</label>
                        <input id="label" type="text" placeholder="Ex: Uniprot Entity"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the rdfs:label property" ></i>
                    </div>
                   
                    <br/>
                    <div class="span4">
                        <button  type="button" id="submit" class="btn btn-success">Add <i class="icon-plus icon-white"></i> </button>
                    </div>
                    <div class="span4">
                        <button type="button" id="done" class="btn btn-danger" onclick="window.location = '../entity/';">Cancel</button>
                    </div>
                </div>
                <div class="span8"></div>
                <div id="commentForm">
                    <label class="control-label" for="comment">Comment</label> 
                    <textarea rows="4" style="max-width: 500px;width: 400px;" id="comment" type="text" placeholder="Ex: Describes the Uniprot Entity"></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the rdfs:comment property" ></i>
                </div>

            </div>

            <!-- Aux button to call modal -->
            <button class="hide" type="button"  id="callModal" href="#errorModal" role="button" data-toggle="modal">modal</button>

        </div>



        <!-- Modal -->
        <div id="errorModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                <h3 id="myModalLabel">Output</h3>
            </div>
            <div class="modal-body">
                <div id="result">

                </div>
               <!-- <div id="titleResult">

                </div>
                <div id="labelResult">

                </div>
                <div id="commentResult">

                </div>
                <div id="seedResult">

                </div>
                <div id="typeResult">

                </div>-->
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                <button class="btn btn-primary" onclick="submit();">Retry</button>
            </div>
        </div>


    </s:layout-component>
</s:layout-render>
