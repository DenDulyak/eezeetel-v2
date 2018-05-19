<div class="modal fade" id="assignModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Assign the order</h4>
            </div>
            <form id="assignForm" method="POST">
                <input type="hidden" id="orderId" name="orderId" />
                <div class="modal-body">
                    <div class="form-group">
                        <label for="login">Mobile Admin:</label>
                        <select class="form-control" id="login" name="login"></select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success assignSave">Save</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

