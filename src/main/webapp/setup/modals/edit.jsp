<!-- Edit Modal 
This modal is used to edit Seeds, Entities and Concepts because all of them share the same properties. 
-->
<div id="editModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button id="closeEditModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3 class="modal-title">Edit <span id="editType">no type</span></h3>
            </div>
            <div class="modal-body">
                <div id="editResult"></div>
                <p class="help-block"><span id="helpEdit"></span> </p>
                <p class="lead" >Entity URI - <span class="lead text-info" id="editURI" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>
                <div id="editTitleForm" class="form-group">
                    <label class="control-label" for="title">Title</label>
                    <input maxlength="50" id="editTitle" class="form-control tip" data-toggle="tooltip" title="The title (dc:title) property." type="text" placeholder="Ex: Uniprot" autofocus> 
                    <input type="hidden" id="oldTitle" value=""/>
                </div>
                <div id="editLabelForm" class="form-group">
                    <label class="control-label" for="label">Label</label>
                    <input maxlength="50" id="editLabel" class="form-control tip" data-toggle="tooltip" title="The label (rdfs:label) property." type="text" placeholder="Ex: Uniprot Entity"> 
                    <input type="hidden" id="oldLabel" value=""/>
                </div>
                <div id="editCommentForm" class="form-group">
                    <label class="control-label" for="comment">Comment</label>
                    <textarea maxlength="100" rows="4" class="form-control tip" data-toggle="tooltip" title="A comment (rdfs:comment) property." id="editComment" type="text" placeholder="Ex: Describes the Uniprot..."></textarea> 
                    <input type="hidden" id="oldComment" value=""/>
                </div>

            </div>

            <div class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancel</button>
                <button id="edit" class="btn btn-primary loading" onclick="edit();">Save Changes</button>
            </div>
        </div>
    </div>
</div>