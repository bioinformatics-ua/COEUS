<%-- 
    Document   : addResource
    Created on : Oct 14, 2013, 3:41:38 PM
    Author     : sernadela
--%>
<!-- edit Resource Modal -->
<div id="editResourceModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
        <button id="closeEditResourceModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h3>Edit Resource</h3>
    </div>
    <div class="modal-body">
        <div id="editResourceResult"></div>
        <p class="help-block">Resource individuals are used to store external resource integration properties. The configuration is further specialised with CSV, XML, JSON, RDF, TTL, SQL and SPARQL classes, mapping precise dataset results to the application model, through direct concept relationships. </p>
        <p class="lead" >Resource URI - <span class="lead text-info" id="editResourceURI" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>
        <div class="row-fluid">
            <div id="editResourceTitleForm" class="span6">
                <label class="control-label" for="title">Title</label>
                <input id="editResourceTitle" type="text" placeholder="Ex: HGNC" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) of the Resource." ></i>
                <input type="hidden" id="oldResourceTitle" value=""/>
            </div>

            <div id="builtForm" class="span6"> 
                <label class="control-label" for="built">Built</label>
                <label class="checkbox" >
                    <input type="checkbox" id="built"><span class="label label-success">Built</span>
                </label>
                <input type="hidden" id="oldBuilt" value=""/>
            </div>

        </div>
        <div class="row-fluid">
            <div id="editResourceLabelForm"  class="span6">
                <label class="control-label" for="label">Label</label>
                <input id="editResourceLabel" type="text" placeholder="Ex: HGNC Resource"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) of the Resource." ></i>
                <input type="hidden" id="oldResourceLabel" value=""/>
            </div>
            <div id="editOrderForm" class="span6"> 
                <label class="control-label" for="label">Order</label>
                <input class="input-mini" id="editOrder" type="number" placeholder="Ex: 1"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:order property" ></i>
                <input type="hidden" id="oldOrder" value=""/>
            </div>
        </div>
        <div id="editResourceCommentForm">
            <label class="control-label" for="comment">Comment</label>
            <textarea rows="4" style="max-width: 500px;width: 450px;" id="editResourceComment" type="text" placeholder="Ex: Describes the HGNC Resource..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Resource." ></i>
            <input type="hidden" id="oldResourceComment" value=""/>
        </div>
        <div class="row-fluid">
            <div id="editExtendsForm" class="span6"> 
                <label class="control-label" for="label">Extends</label>
                <select id="editExtends" class="span10">
                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Select the concept to extends" ></i>
                <input type="hidden" id="oldExtends" value=""/>
            </div>
            <div id="editMethodForm" class="span6"> 
                <label class="control-label" for="label">Method</label>
                <select id="editMethod" class="span10">
                    <option>cache</option>
                    <option>complete</option>
                    <option>map</option>
                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:method property" ></i>
                <input type="hidden" id="oldMethod" value=""/>
            </div>
        </div>
        <div class="row-fluid">
            <div id="editPublisherForm" class="span6"> 
                <label class="control-label" for="label">Publisher</label>
                <select id="editPublisher" class="span10" onchange="publisherChange('edit');">
                    <option>xml</option>
                    <option>csv</option>
                    <option>json</option>
                    <option>sql</option>
                    <option>sparql</option>
                    <option>rdf</option>
                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:publisher property" ></i>
                <input type="hidden" id="oldPublisher" value=""/>
            </div>
            <div id="editEndpointForm" class="span6"> 
                <label class="control-label" for="label">Endpoint</label> 
                <input id="editEndpoint" type="text" placeholder="Ex: http://someurl.com"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:endpoint property" ></i>
                <input type="hidden" id="oldEndpoint" value=""/>
            </div>
        </div>
        <div id="editSqlEndpointForm" class="hide"> 
            <label class="control-label" >Endpoint (DB Connection)</label> 

            jdbc: 
            <select id="editDriverEndpoint" type="text" placeholder="Ex: mysql" class="input-small" onchange="refreshEnpoint('edit');">
                <option>mysql</option>
                <option>sqlserver</option>
            </select>
            ://
            <input id="editHostEndpoint" type="text" placeholder="Ex: someurl.com" class="input-medium" onkeyup="refreshEnpoint('edit');">
            :
            <input id="editPortEndpoint" type="number" placeholder="3306" class="input-mini" onchange="refreshEnpoint('edit');"> 
            /
            <input id="editDbEndpoint" type="text" placeholder="Ex: coeus" class="input-mini" onkeyup="refreshEnpoint('edit');"> 

            <br/>
            Login:
            <input id="editUserEndpoint" type="text" placeholder="Ex: user" class="input-medium" onkeyup="refreshEnpoint('edit');">   
            <input id="editPasswordEndpoint" type="password" placeholder="Ex: password" class="input-medium" onkeyup="refreshEnpoint('edit');"> 

        </div>
        <div id="editCsvQueryForm" class="hide row-fluid"> 
            <div class="span6">
                <label class="control-label" for="label">Csv Quotes</label>
                <select class="input-mini" id="editCsvQueryDelimiter" onchange="refreshQuery('edit');" type="text" maxlength="1" placeholder="Ex:  '">
                    <option>"</option>
                    <option>'</option>
                </select> <i class="icon-question-sign" data-toggle="tooltip" title="Quotes delimiter" ></i>
            </div>
            <div class="span6">
                <label class="control-label" for="label">Csv Starting line</label>
                <input class="input-mini" id="editCsvQueryHeaderSkip" onchange="refreshQuery('edit');" type="number" placeholder="Ex:  1"> <i class="icon-question-sign" data-toggle="tooltip" title="Headers skip number "></i>
            </div>
        </div>
        <div id="editQueryForm"> 
            <label class="control-label" for="label">Query</label>
            <input id="editQuery" type="text" placeholder="Ex: //item"> <i class="icon-question-sign" data-toggle="tooltip" title="Add a triple with the coeus:query property" ></i>
            <input type="hidden" id="oldQuery" value=""/>
        </div>

    </div>

    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        <button id="editResource" class="btn btn-primary loading" onclick="editResource();">Save Changes</button>
    </div>
</div>