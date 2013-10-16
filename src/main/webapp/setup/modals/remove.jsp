<!-- Remove Modal 
This modal is used to remove Seeds, Entities and Concepts because all of them share the same properties. 
-->
<div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h3 >Remove <span id="removeType">no type</span></h3>
    </div>
    <div class="modal-body">
        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong>?</p>
        <p class="text-warning">Warning: All dependents triples are removed too.</p>

        <div id="removeResult"></div>

    </div>

    <div class="modal-footer">
        <button id="btnCloseModal" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        <button id="remove" class="btn btn-danger loading" onclick="remove();">Remove <i class="icon-trash icon-white"></i></button>
    </div>
</div>