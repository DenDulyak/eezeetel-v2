<div class="modal fade" id="orderModal" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit order</h4>
      </div>
      <form id="orderForm" method="POST">
        <div class="modal-body panel panel-success">
          <input type="hidden" id="id" name="id" />
          <div class="form-group">
            <label>Mobile Unlocking</label>
            <p id="mobileUnlockingTitle" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>User</label>
            <p id="user" class="text-left"></p>
          </div>
          <div class="form-group">
            <label>IMEI</label>
            <input type="text" id="imei" name="imei" class="form-control" />
          </div>
          <div class="form-group">
            <label>Code</label>
            <input type="text" id="code" name="code" class="form-control" />
          </div>
          <div class="form-group">
            <label>Customer email</label>
            <input type="text" id="customerEmail" name="customerEmail" class="form-control" />
          </div>
          <div class="form-group">
            <label>Mobile number</label>
            <input type="text" id="mobileNumber" name="mobileNumber" class="form-control" />
          </div>
          <div class="form-group">
            <label>Status</label>
            <p id="status" class="text-left"></p>
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
            <label>Notes</label>
            <textarea id="notes" name="notes" class="form-control" rows="3"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success save">Save</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>
