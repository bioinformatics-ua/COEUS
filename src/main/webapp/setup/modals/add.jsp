<!-- Add Modal 
This modal is used to add Seeds, Entities and Concepts because all of them share the same properties. 
-->
<div id="addModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
        <button id="closeAddModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h3>Add <span id="addType">no type</span></h3>
    </div>
    <div class="modal-body">
        <div id="addResult"></div>
        <p class="help-block"><span id="helpAdd"></span> </p>
        <p class="lead" >URI - <span class="lead text-info" id="uri" data-toggle="tooltip" title="A URI is formed when you fill the title box." >coeus: </span></p>

        <div id="titleForm" >
            <label class="control-label" for="title">Title</label>
            <input id="title" type="text" placeholder="Ex: Uniprot" onkeyup="changeURI('uri',$('#addType').html(), this.value);" > <i class="icon-question-sign" data-toggle="tooltip" title="The title (dc:title) property." ></i>
        </div>
        <div id="labelForm">
            <label class="control-label" for="label">Label</label>
            <input id="label" type="text" placeholder="Ex: Uniprot"> <i class="icon-question-sign" data-toggle="tooltip" title="The label (rdfs:label) property." ></i>
        </div>
        <div id="commentForm">
            <label class="control-label" for="comment">Comment</label>
            <textarea rows="4" style="max-width: 500px;width: 400px;" id="comment" type="text" placeholder="Ex: Describes the Uniprot..."></textarea> <i class="icon-question-sign" data-toggle="tooltip" title="The comment (rdfs:comment) property." ></i>
        </div>
        <input type="hidden" id="linkedWith" value=""/>

    </div>

    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        <button id="add" class="btn btn-primary loading" onclick="add();">Save Changes</button>
    </div>
</div>