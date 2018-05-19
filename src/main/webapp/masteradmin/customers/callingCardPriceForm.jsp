<div class="modal fade" id="callingCardPriceModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Calling Card Price</h4>
            </div>
            <div class="modal-body">
                <form id="callingCardPriceForm">
                    <input type="hidden" name="id"/>

                    <div class="form-group">
                        <label for="country">Country:</label>
                        <input type="text" class="form-control" id="country" name="country"/>
                    </div>
                    <div class="form-group">
                        <label for="landlinePrice">Landline P/Min:</label>
                        <input type="text" class="form-control" id="landlinePrice" name="landlinePrice"/>
                    </div>
                    <div class="form-group">
                        <label for="mobilePrice">Mobile P/Min:</label>
                        <input type="text" class="form-control" id="mobilePrice" name="mobilePrice"/>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success save">Save</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>
