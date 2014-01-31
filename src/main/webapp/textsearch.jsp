<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/layout/html.jsp">
    <s:layout-component name="title">Text Search - COEUS</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script type="text/javascript">
            $(document).ready(function() {
                changeSidebar('#textsearch');

                //Associate Enter key:
                document.onkeypress = function(event) {
                    //Enter key pressed
                    if (event.charCode === 13) {
                        getSearchResult();
                    }
                };

            });

            function fillTable(result) {
                console.log(result);
                var head = '<thead><tr>';
                for (var v in result.head.vars) {
                    head = head + '<th>' + result.head.vars[v] + '</th>';
                }
                head = head + '</tr></thead>';
                
                var body = '<tbody>';
                for (var b in result.results.bindings) {
                    body = body + '<tr>';
                    for(var i in result.head.vars){
                        var headerValue=result.head.vars[i];
                        var value=result.results.bindings[b][headerValue].value;
                        if(contains(value,"http")) value='<a href="'+value+'">'+value+'</a>';
                        body = body + '<th>' + value + '</th>';
                    }
                    body = body + '</tr>';
                    console.log(result.results.bindings[b]);
                }
                body = body + '</tr></tbody>';
                console.log(body);
                
                $("#results").html(head+body);
                

            }
            function getSearchResult(){
                var input=$("#input").val();
                callURL("../textsearch/query="+input, fillTable);
                document.getElementById("exportJSON").href="../textsearch/query="+input;
            }
        </script>
    </s:layout-component>
    <s:layout-component name="body">
        <div class="container space">
            <div class="row">


                <section id="textsearch">
                    <div class="page-header">
                        <h1>Text Search</h1>
                    </div>
                    <ol class="breadcrumb">
                        <li id="breadHome"><span class="glyphicon glyphicon-home"></span> </li>
                        <li class="active">Text Search</li>
                    </ol>
                    <p>Write your text queries in the <span class="label label-info">query</span> box below.</p>
                    
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="input-group custom-search-form">
                                <input type="text" class="form-control" id="input">
                                <span class="input-group-btn">
                                    <button class="btn btn-default" type="button" onclick="getSearchResult();">
                                        <span class="glyphicon glyphicon-search"></span>
                                    </button>
                                </span>
                            </div><!-- /input-group -->
                        </div>
                    </div>
                    <p></p>
                    <p>Results:</p>
                    <div class="table-responsive ">
                        <table class="table table-hover" id="results">
                            <thead><tr><th>Text_Match</th><th>Subject_Associated</th><th>Predicate_Associated</th><th>Score</th></tr></thead>
                            <tbody>
                                <tr>
                                    <td>-</td>
                                    <td >-</td>
                                    <td >-</td>
                                    <td>-</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <a href="../textsearch/query=" id="exportJSON" target="_blank">As JSON</a>
                </section>


            </div>
        </div>
    </s:layout-component>
</s:layout-render>