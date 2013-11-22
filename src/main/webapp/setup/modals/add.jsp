<!-- Add Modal 
This modal is used to add Seeds, Entities and Concepts because all of them share the same properties. 
-->
<div id="addModal" class="modal fade"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button id="closeAddModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3 class="modal-title">Add <span id="addType">no type</span></h3>
            </div>
            <div class="modal-body">
                <div id="addResult"></div>
                <p class="help-block"><span id="helpAdd"></span> </p>
                <p class="lead" >URI - <span class="lead text-info" id="uri" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

                    <div id="titleForm" class="form-group">
                        <label class="control-label" for="title">Title</label>
                        <input maxlength="50" class="form-control tip" data-toggle="tooltip" title="The title (dc:title) property." id="title" type="text" placeholder="Ex: Publication" onkeyup="changeURI('uri', $('#addType').html(), this.value);" autofocus> 
                    </div>
                    <div id="labelForm" class="form-group">
                        <label class="control-label" for="label">Label</label>
                        <input maxlength="50" class="form-control tip" data-toggle="tooltip" title="The label (rdfs:label) property." id="label" type="text" placeholder="Ex: Publication Label"> 
                    </div>
                    <div id="commentForm" class="form-group">
                        <label class="control-label" for="comment">Description</label>
                        <textarea maxlength="100" class="form-control tip" data-toggle="tooltip" title="The description (rdfs:comment) property." rows="4" id="comment" type="text" placeholder="Ex: Semantic Publication"></textarea> 
                    </div>
                    <input type="hidden" id="linkedWith" value=""/>
            </div>

            <div class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button id="add" class="btn btn-primary loading" onclick="add();">Save Changes</button>
            </div>
        </div>
    </div>
</div>