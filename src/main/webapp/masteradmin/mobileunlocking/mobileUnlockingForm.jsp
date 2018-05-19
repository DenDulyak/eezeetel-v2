<div class="modal fade" id="mobileUnlockingModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Mobile Unlocking</h4>
            </div>
            <form id="mobileUnlockingForm" action="${pageContext.request.contextPath}/masteradmin/mobile-unlocking/save" method="POST" role="form">
                <input type="hidden" id="id" name="id"/>

                <div class="modal-body">
                    <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text" class="form-control" id="title" name="title"/>
                    </div>
                    <div class="form-group">
                        <label for="supplierId">Supplier:</label>
                        <select class="form-control" id="supplierId" name="supplierId"></select>
                    </div>
                    <label>Duration time:</label>

                    <div class="form-group">
                        <input type="text" class="form-control" id="deliveryTime" name="deliveryTime"
                               placeholder="Delivery Time"/>
                    </div>
                    <div class="form-group">
                        <label for="purchasePrice">Purchase Price:</label>
                        <input type="number" class="form-control" id="purchasePrice" name="purchasePrice"/>
                    </div>
                    <div class="form-group">
                        <label>Transaction Condition</label>
                        <textarea id="transactionCondition" name="transactionCondition" class="form-control" rows="15">
                        </textarea>
                    </div>
                    <div class="form-group">
                        <label>Notes</label>
                        <textarea id="notes" name="notes" class="form-control" rows="5"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success save">Save</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

