<div class="modal fade" id="printOrderModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Print Order</h4>
            </div>
            <div class="modal-body modalContainerBody">
                <div class="container">
                    <form>
                        <div class="form-group">
                            <label>Mobile Unlocking</label>

                            <p id="mobileUnlockingTitle" class="text-left"></p>
                        </div>
                        <%--<div class="form-group">
                            <label>Customer</label>

                            <p id="shopKeeperName" class="text-left"></p>
                        </div>--%>
                        <div class="form-group">
                            <label>User</label>

                            <p id="user" class="text-left"></p>
                        </div>
                        <div class="form-group">
                            <label>IMEI</label>

                            <p type="text" id="imei"></p>
                        </div>
                        <div class="form-group">
                            <label>Code</label>

                            <p type="text" id="code"></p>
                        </div>
                        <div class="form-group">
                            <label>Customer email</label>

                            <p type="text" id="customerEmail"></p>
                        </div>
                        <div class="form-group">
                            <label>Mobile number</label>

                            <p type="text" id="mobileNumber"></p>
                        </div>
<%--                        <div class="form-group">
                            <label>Status</label>

                            <p id="status" class="text-left"></p>
                        </div>--%>
                        <div class="form-group">
                            <label>Order Time</label>

                            <p id="createdDate" class="text-left"></p>
                        </div>
                        <div class="form-group">
                            <label>Notes</label>

                            <p id="notes"></p>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary printButton">Print</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
