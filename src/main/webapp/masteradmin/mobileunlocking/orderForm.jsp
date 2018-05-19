<div class="modal fade" id="orderModal" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Order info</h4>
      </div>
      <form id="orderForm" method="POST">
        <div class="modal-body panel panel-success">
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
            <p id="imei" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Code</label>
            <p id="code" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Price</label>
            <p id="price" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Balance Before</label>
            <p id="balanceBefore" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Balance After</label>
            <p id="balanceAfter" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Customer email</label>
            <p id="customerEmail" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Mobile number</label>
            <p id="mobileNumber" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Status</label>
            <p id="status" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Assigned to</label>
            <p id="assigned" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Created date</label>
            <p id="createdDate" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Updated date</label>
            <p id="updatedDate" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Transaction Condition</label>
            <p id="transactionCondition" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>Notes</label>
            <p id="notes" class="text-left"></p>
          </div>
        </div>
        <div class="modal-footer">
          <%--<button type="button" class="btn btn-success assignSave">Save</button>--%>
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>