<!-- Edit Modal 
This modal is used to edit Seeds, Entities and Concepts because all of them share the same properties. 
-->
<div id="editModal" class="modal hide fade" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
        <button id="closeEditModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h3>Edit <span id="editType">no type</span></h3>
    </div>
    <div class="modal-body">
        <div id="editResult"></div>
         <p class="help-block"><span id="helpEdit"></span> </p>
         <p class="lead" >Entity URI - <span class="lead text-info" id="editURI" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>
        <div id="editTitleForm" >
            <label class="control-label" for="title">Title</label>
            <input id="editTitle" type="text" placeholder="Ex: Uniprot" autofocus> <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) property." ></i>
            <input type="hidden" id="oldTitle" value=""/>
        </div>
        <div id="editLabelForm">
            <label class="control-label" for="label">Label</label>
            <input id="editLabel" type="text" placeholder="Ex: Uniprot Entity"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) property." ></i>
            <input type="hidden" id="oldLabel" value=""/>
        </div>
        <div id="editCommentForm">
            <label class="control-label" for="comment">Comment</label>
            <textarea rows="4" style="max-width: 500px;width: 400px;" id="editComment" type="text" placeholder="Ex: Describes the Uniprot..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="A comment (rdfs:comment) property." ></i>
            <input type="hidden" id="oldComment" value=""/>
        </div>

    </div>

    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        <button id="edit" class="btn btn-primary loading" onclick="edit();">Save Changes</button>
    </div>
</div>