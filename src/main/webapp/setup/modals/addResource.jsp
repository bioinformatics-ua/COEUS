<%-- 
    Document   : addResource
    Created on : Oct 14, 2013, 3:41:38 PM
    Author     : sernadela
--%>

<!-- add Resource Modal -->
<div id="addResourceModal" class="modal hide fade" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" >
    <div class="modal-header">
        <button id="closeAddResourceModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h3>Add Resource</h3>
    </div>
    <div class="modal-body">
        <div id="addResourceResult"></div>
        <p class="help-block">Resource individuals are used to store external resource integration properties. The configuration is further specialised with CSV, XML, JSON, RDF, TTL, SQL and SPARQL classes, mapping precise dataset results to the application model, through direct concept relationships. </p>
        <p class="lead" >Resource URI - <span class="lead text-info" id="resourceURI" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>
        <div class="row-fluid">
            <div id="resourceTitleForm" class="span6">
                <label class="control-label" for="title">Title</label>
                <input id="titleResource" type="text" placeholder="Ex: HGNC" onkeyup="changeURI('resourceURI', 'Resource', this.value);" autofocus> <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Resource." ></i>
            </div>
            <div id="orderForm" class="span6"> 
                <label class="control-label" for="label">Order</label>
                <input class="input-mini" id="order" type="number" placeholder="Ex: 1"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:order property" ></i>
            </div>
            <input type="hidden" id="resourceLink" value=""/>
        </div>
        <div id="resourceLabelForm" >
            <label class="control-label" for="label">Label</label>
            <input id="labelResource" type="text" placeholder="Ex: HGNC Resource"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Resource." ></i>
        </div>
        <div id="resourceCommentForm">
            <label class="control-label" for="comment">Comment</label>
            <textarea rows="4" style="max-width: 500px;width: 450px;" id="commentResource" type="text" placeholder="Ex: Describes the HGNC Resource..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Resource." ></i>
        </div>
        <div class="row-fluid">
            <div id="extendsForm" class="span6"> 
                <label class="control-label" for="label">Extends</label>
                <select id="extends" class="span10">

                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Select the concept to extends" ></i>
            </div>
            <div id="methodForm" class="span6"> 
                <label class="control-label" for="label">Method</label>
                <select id="method" class="span10">
                    <option>cache</option>
                    <option>complete</option>
                    <option>map</option>
                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:method property" ></i>
            </div>
        </div>
        <div class="row-fluid">
            <div id="publisherForm" class="span6"> 
                <label class="control-label" for="label">Publisher</label>
                <select id="publisher" class="span10" onchange="publisherChange();">
                    <option>xml</option>
                    <option>csv</option>
                    <option>json</option>
                    <option>sql</option>
                    <option>sparql</option>
                    <option>rdf</option>
                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:publisher property" ></i>
            </div>
            <div id="endpointForm" class="span6"> 
                <label class="control-label" for="label">Endpoint</label> 
                <input id="endpoint" type="text" placeholder="Ex: http://someurl.com"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:endpoint property" ></i>
            </div>
        </div>
        <div id="sqlEndpointForm" class="hide"> 
            <label class="control-label" >Endpoint (DB Connection)</label> 

            jdbc: 
            <select id="driverEndpoint" type="text" placeholder="Ex: mysql" class="input-small" onchange="refreshEnpoint();">
                <option>mysql</option>
                <option>sqlserver</option>
            </select>
            ://
            <input id="hostEndpoint" type="text" placeholder="Ex: someurl.com" class="input-medium" onkeyup="refreshEnpoint();">
            :
            <input id="portEndpoint" type="number" placeholder="3306" class="input-mini" onchange="refreshEnpoint();"> 
            /
            <input id="dbEndpoint" type="text" placeholder="Ex: coeus" class="input-mini" onkeyup="refreshEnpoint();"> 

            <br/>
            Login:
            <input id="userEndpoint" type="text" placeholder="Ex: user" class="input-medium" onkeyup="refreshEnpoint();">   
            <input id="passwordEndpoint" type="password" placeholder="Ex: password" class="input-medium" onkeyup="refreshEnpoint();"> 

        </div>
        <div id="csvQueryForm" class="hide row-fluid"> 
            <div class="span6">
                <label class="control-label" for="label">Csv Quotes</label>
                <select class="input-mini" id="csvQueryDelimiter" onchange="refreshQuery();" type="text" maxlength="1" placeholder="Ex:  '">
                    <option>"</option>
                    <option>'</option>
                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Quotes delimiter" ></i>
            </div>
            <div class="span6">
                <label class="control-label" for="label">Csv Starting line</label>
                <input class="input-mini" id="csvQueryHeaderSkip" onchange="refreshQuery();" type="number" placeholder="Ex:  1"> <i class="icon-question-sign" data-toggle="tooltip" title="Headers skip number "></i>
            </div>
        </div>
        <div id="queryForm"> 
            <label class="control-label" for="label">Query</label>
            <textarea id="query" type="text" placeholder="Ex: //item"></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:query property" ></i>
        </div>
    </div>

    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        <button id="addResource" class="btn btn-primary loading" onclick="addResource();">Save Changes</button>
    </div>
</div>