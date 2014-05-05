<%-- 
    Document   : addResource
    Created on : Oct 14, 2013, 3:41:38 PM
    Author     : sernadela
--%>
<!-- edit Resource Modal -->
<div id="editResourceModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button id="closeEditResourceModal" type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">x</button>
                <h3 class="modal-title">Edit Resource</h3>
            </div>
            <div class="modal-body">
                <div id="editResourceResult"></div>
                <p class="help-block">Resource individuals are used to store external resource integration properties.
                    The configuration is further specialised with CSV, XML, JSON, RDF, TTL,
                    SQL and SPARQL classes, mapping precise dataset results to the application
                    model, through direct concept relationships.</p>
                <p class="lead">Resource URI - <span class="lead text-info" id="editResourceURI" data-toggle="tooltip"
                                                     title="A URI is formed when you fill the title box.">coeus: </span>
                </p>
                <div class="row">
                    <div id="editResourceTitleForm" class="col-md-6 form-group">
                        <label  for="title">Title</label>
                        <input maxlength="50" id="editResourceTitle" type="text" placeholder="Ex: HGNC" class="form-control tip" data-toggle="tooltip" title="The title (dc:title) property." autofocus="autofocus" />
                        <input type="hidden" id="oldResourceTitle" value="" />
                    </div>
                    <div id="builtForm" class="col-md-6 ">
                        <label for="built">Built State</label>
                        <div class="checkbox form-inline">
                        <label>
                            <input type="checkbox" id="built" class=""/><span class="label label-success tip" data-toggle="tooltip" title="Show if the resource has been builded.">Built</span>
                        </label>
                        </div>
                        <input type="hidden" id="oldBuilt" value="" />
                    </div>
                </div>
                <div class="row">
                    <div id="editResourceLabelForm" class="col-md-6 form-group">
                        <label for="label label-default">Label</label>
                        <input maxlength="50" id="editResourceLabel" type="text" placeholder="Ex: HGNC Resource" class="form-control tip" data-toggle="tooltip" title="The label (rdfs:label) property."/>
                        <input
                            type="hidden" id="oldResourceLabel" value="" />
                    </div>
                    <div id="editOrderForm" class="col-md-6 form-group">
                        <label for="label label-default">Order</label>
                        <input class="input-mini form-control tip" id="editOrder" type="number" min="0" placeholder="Ex: 1" data-toggle="tooltip" title="Integration order"/>  
                        <input type="hidden" id="oldOrder" value="" />
                    </div>
                </div>
                <div id="editResourceCommentForm" class=" form-group">
                    <label for="comment">Comment</label>
                    <textarea rows="4" id="editResourceComment" type="text" placeholder="Ex: Describes the HGNC Resource..." data-toggle="tooltip"
                              maxlength="100" title="A description/comment (rdfs:comment) field for the Resource." class="tip form-control"></textarea>
                    <input
                        type="hidden" id="oldResourceComment" value="" />
                </div>
                <div class="row">
                    <div id="editExtendsForm" class="col-md-6 form-group">
                        <label for="editExtends">Extends</label>
                        <select id="editExtends" class="col-md-10 form-control tip" data-toggle="tooltip" title="A Resource extends a Concept. This means that the subject resource will select data for processing from the concept Item individuals."></select>
                        <input type="hidden" id="oldExtends" value="" />
                    </div>
                    <div id="editMethodForm" class="col-md-6 form-group">
                        <label for="editMethod">Method</label>
                        <select id="editMethod" class="col-md-10 form-control tip" data-toggle="tooltip" title="Integration method: Cache (replicate resources), Map (new mappings amongst existing resources), Complete (complete existing resources)">
                            <option>cache</option>
                            <option>complete</option>
                            <option>map</option>
                        </select> 
                        <input
                            type="hidden" id="oldMethod" value="" />
                    </div>
                </div>
                <div class="row">
                    <div id="editExtensionForm" class="col-md-6 form-group">
                        <label>Property Extension (Optional)</label>
                        <input type="text" id="editExtension" class="form-control tip" title="The property (e.g. dc:identifier, dc:source, etc.) that will be choosed for the extension query." data-toggle="tooltip">
                        <input type="hidden" id="oldExtension" value="" />
                    </div>
                </div>
                <div class="row">
                    <div id="editPublisherForm" class="col-md-6 form-group">
                        <label for="label label-default">Publisher</label>
                        <select id="editPublisher" class="col-md-10 form-control tip" onchange="publisherChange('edit');" data-toggle="tooltip" title="Connector type: the selectors configuration will be loaded according to this value.">
                            <option>xml</option>
                            <option>csv</option>
                            <option>json</option>
                            <option>sql</option>
                            <option>sparql</option>
                            <option>rdf</option>
                            <option>linkeddata</option>
                        </select> 
                        <input
                            type="hidden" id="oldPublisher" value="" />
                    </div>
                    <div id="editConceptForm" class="col-md-6 form-group">
                        <label for="label label-default">Concept</label>
                        <select id="editConcept" class="col-md-10 form-control tip" data-toggle="tooltip" title="Change the concept of this Resource."></select> 
                        <input type="hidden" id="oldConcept" value="" />
                    </div>
                </div>
                <div class="row">
                   
                    <div id="editEndpointForm" class="col-md-6 form-group">
                        <label for="label label-default">Endpoint</label>
                        <input id="editEndpoint" type="text" placeholder="Ex: http://someurl.com" class="form-control tip" data-toggle="tooltip" title="Data location URI. When the resource extends another concept, use the #replace# keyword to compose the URL with the values from the extended Concept items."/>
                        <input type="hidden" id="oldEndpoint" value="" />
                    </div>
                </div>

                <div id="editSqlEndpointForm" class="hide form-group">
                    <label>Endpoint (DB Connection)</label>
                    <div class="form-inline ">
                        <div class="form-group">jdbc:</div>
                        <div class="form-group">
                            <select id="editDriverEndpoint" type="text" placeholder="Ex: mysql" class="input-sm form-control tip" onchange="refreshEnpoint('edit');" data-toggle="tooltip" title="Driver" >
                                <option>mysql</option>
                                <option>sqlserver</option>
                            </select>
                        </div>
                        <div class="form-group">://</div>
                        <div class="form-group">
                            <input id="editHostEndpoint" type="text" placeholder="Ex: someurl.com" class="input-medium form-control tip" onkeyup="refreshEnpoint('edit');" data-toggle="tooltip" title="URL" />
                        </div>
                        <div class="form-group">:</div>
                        <div class="form-group">
                            <input id="editPortEndpoint" type="number" placeholder="3306" class="input-port form-control tip" onchange="refreshEnpoint('edit');" data-toggle="tooltip" title="Port" />
                        </div>
                        <div class="form-group">/</div>
                        <div class="form-group">
                            <input id="editDbEndpoint" type="text" placeholder="Ex: coeus" class="input-mini form-control tip" onkeyup="refreshEnpoint('edit');" data-toggle="tooltip" title="Database" />
                        </div>

                    </div>
                    <label>Login:</label>
                    <div class="form-inline ">
                        <div class="form-group">
                            <input id="editUserEndpoint" type="text" placeholder="Ex: user" class="input-medium form-control tip" onkeyup="refreshEnpoint('edit');" data-toggle="tooltip" title="User" />
                        </div>
                        <div class="form-group">
                            <input id="editPasswordEndpoint" type="password" placeholder="Ex: password" class="input-medium form-control tip" onkeyup="refreshEnpoint('edit');" data-toggle="tooltip" title="Password" />
                        </div>
                    </div>
                </div>
                <div id="editCsvQueryForm" class="hide row form-group">
                    <div class="col-md-6">
                        <label for="label label-default">Csv Quotes</label>
                        <select class="input-mini form-control tip" data-toggle="tooltip" title="Quotes delimiter" id="editCsvQueryDelimiter" onchange="refreshQuery('edit');" type="text" maxlength="1" placeholder="Ex:  '">
                            <option>"</option>
                            <option>'</option>
                        </select> 
                    </div>
                    <div class="col-md-6 form-group">
                        <label for="label label-default">Csv Starting line</label>
                        <input class="input-mini form-control tip" id="editCsvQueryHeaderSkip" data-toggle="tooltip" title="Headers skip number" onchange="refreshQuery('edit');" type="number" placeholder="Ex:  1" /> 
                    </div>
                </div>
                <div id="editQueryForm" class="form-group">
                    <label for="label label-default">Query</label>
                    <textarea id="editQuery" type="text" placeholder="Ex: //item" class="form-control tip" data-toggle="tooltip" title="Query depends on publisher type. If XML use XPath query, if SQL/SPARQL use SELECT query, etc. For more, see documentation."></textarea> 
                    <input type="hidden" id="oldQuery" value="" />
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button id="editResource" class="btn btn-primary loading"
                        onclick="editResource();">Save Changes</button>
            </div>
        </div>
    </div>
</div>