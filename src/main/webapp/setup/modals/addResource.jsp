<%-- 
    Document   : addResource
    Created on : Oct 14, 2013, 3:41:38 PM
    Author     : sernadela
--%>

<!-- add Resource Modal -->
<div id="addResourceModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button id="closeAddResourceModal" type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">x</button>
                <h3 class="modal-title">Add Resource</h3>
            </div>
            <div class="modal-body">
                <div id="addResourceResult"></div>
                <p class="help-block">Resource individuals are used to store external resource integration properties.
                    The configuration is further specialised with CSV, XML, JSON, RDF, TTL,
                    SQL and SPARQL classes, mapping precise dataset results to the application
                    model, through direct concept relationships.</p>
                <p class="lead">Resource URI - <span class="lead text-info" id="resourceURI" data-toggle="tooltip"
                                                     title="A URI is formed when you fill the title box.">coeus: </span>
                </p>
                <div class="row">
                    <div id="resourceTitleForm" class="col-md-6 form-group">
                        <label for="title">Title</label>
                        <input class="form-control tip" data-toggle="tooltip" title="The title (dc:title) property." id="titleResource" type="text" placeholder="Ex: Journal"
                               maxlength="50" onkeyup="changeURI('resourceURI', 'Resource', this.value);" autofocus/> 
                    </div>
                    <div id="orderForm" class="col-md-6 form-group">
                        <label for="label label-default">Order</label>
                        <input class="form-control tip" data-toggle="tooltip" title="Integration order"  id="order" min="0" type="number" placeholder="Ex: 1" /> 
                    </div>
                    <input type="hidden" id="resourceLink" value="" />
                </div>
                <div id="resourceLabelForm" class="form-group">
                    <label for="label label-default">Label</label>
                    <input id="labelResource" maxlength="50" type="text" placeholder="Ex: Journal Resource" class="form-control tip" data-toggle="tooltip" title="The label (rdfs:label) of the Resource." />
                </div>
                <div id="resourceCommentForm" class="form-group">
                    <label for="comment">Description</label>
                    <textarea rows="4" style="max-width: 500px; width: 450px;" class="form-control tip" data-toggle="tooltip" title="A description/comment (rdfs:comment) field for the Resource." 
                              id="commentResource" maxlength="100" type="text" placeholder="Ex: Journal Publications Resource"></textarea>
                </div>
                <div class="row">
                    <div id="extendsForm" class="col-md-6 form-group">
                        <label>Extends</label>
                        <select id="extends" class="form-control tip" data-toggle="tooltip" title="A Resource extends a Concept. This means that the subject resource will select data for processing from the concept Item individuals."></select> 
                    </div>
                    <div id="methodForm" class="col-md-6 form-group">
                        <label for="label label-default">Method</label>
                        <select id="method" class="form-control tip" data-toggle="tooltip" title="Integration method: Cache (replicate resources), Map (new mappings amongst existing resources), Complete (complete existing resources)">
                            <option>cache</option>
                            <option>complete</option>
                            <option>map</option>
                        </select> 
                    </div>
                </div>
                <div class="row">
                    <div id="extensionForm" class="col-md-6 form-group">
                        <label>Property Extension (Optional)</label>
                        <input type="text" id="extension" class="form-control tip" title="The property (e.g. dc:identifier, dc:source, etc.) that will be choosed for the extension query." data-toggle="tooltip">
                    </div>
                    
                </div>
                <div class="row">
                    <div id="publisherForm" class="col-md-6 form-group">
                        <label for="label label-default">Publisher</label>
                        <select id="publisher" class="form-control tip" data-toggle="tooltip" title="Connector type: the selectors configuration will be loaded according to this value." onchange="publisherChange();">
                            <option>xml</option>
                            <option>csv</option>
                            <option>json</option>
                            <option>sql</option>
                            <option>sparql</option>
                            <option>rdf</option>
                            <option>linkeddata</option>
                        </select> 
                    </div>
                    <div id="endpointForm" class="col-md-6 form-group">
                        <label for="label label-default">Endpoint</label>
                        <input id="endpoint" type="text" placeholder="Ex: http://someurl.com" class="form-control tip" data-toggle="tooltip" title="Data location URI. When the resource extends another concept, use the #replace# keyword to compose the URL with the values from the extended Concept items."/> 
                    </div>
                </div>
                <div id="sqlEndpointForm" class="hide form-group">
                    <label>Endpoint (DB Connection)</label>
                    <div class="form-inline ">
                        <div class="form-group">jdbc:</div>
                        <div class="form-group">
                            <select id="driverEndpoint" type="text" placeholder="Ex: mysql" class="form-control input-sm tip" onchange="refreshEnpoint();" data-toggle="tooltip" title="Driver">
                                <option>mysql</option>
                                <option>sqlserver</option>
                            </select>
                        </div>
                        <div class="form-group">://</div>
                        <div class="form-group">
                            <input id="hostEndpoint" type="text" placeholder="Ex: someurl.com" class="form-control input-medium tip" onkeyup="refreshEnpoint();" data-toggle="tooltip" title="URL"/>
                        </div>
                        <div class="form-group">:</div>
                        <div class="form-group">
                            <input id="portEndpoint" type="number" placeholder="3306" class="form-control input-port tip" onchange="refreshEnpoint();" data-toggle="tooltip" title="Port"/>
                        </div>
                        <div class="form-group">/</div>
                        <div class="form-group">
                            <input id="dbEndpoint" type="text" placeholder="Ex: coeus" class="form-control input-mini tip" data-toggle="tooltip" title="Database"
                                   onkeyup="refreshEnpoint();" />
                        </div>

                    </div>
                    <label>Login:</label>
                    <div class="form-inline ">
                        <div class="form-group">
                            <input id="userEndpoint" type="text" placeholder="Ex: user" class="form-control input-medium tip" onkeyup="refreshEnpoint();" data-toggle="tooltip" title="User"/>
                        </div>
                        <div class="form-group">
                            <input id="passwordEndpoint" type="password" placeholder="Ex: password"
                                   class="form-control input-medium tip" onkeyup="refreshEnpoint();" data-toggle="tooltip" title="Password"/>
                        </div>
                    </div>
                </div>
                <div id="csvQueryForm" class="hide row ">
                    <div class="col-md-6 form-group">
                        <label >Csv Quotes</label>
                        <select class="input-mini form-control tip" data-toggle="tooltip" title="Quotes delimiter" id="csvQueryDelimiter" onchange="refreshQuery();"
                                type="text" maxlength="1" placeholder="Ex:  '">
                            <option>"</option>
                            <option>'</option>
                        </select> 
                    </div>
                    <div class="col-md-6 form-group">
                        <label for="label label-default">Csv Starting line</label>
                        <input class="input-mini form-control tip" data-toggle="tooltip" title="Headers skip number " id="csvQueryHeaderSkip"
                               onchange="refreshQuery();" type="number" min="0" placeholder="Ex:  1" /> 
                    </div>
                </div>
                <div id="queryForm" class="form-group">
                    <label for="label label-default">Query</label>
                    <textarea id="query" type="text" placeholder="Ex: //item" class="form-control tip" data-toggle="tooltip" title="Query depends on publisher type. If XML use XPath query, if SQL/SPARQL use SELECT query, etc. For more, see documentation."></textarea> 
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button id="addResource" class="btn btn-primary loading"
                        onclick="addResource();">Save Changes</button>
            </div>
        </div>
    </div>
</div>