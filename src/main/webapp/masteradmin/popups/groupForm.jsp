<div class="modal fade" id="groupModal" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Group</h4>
      </div>
      <form action="${pageContext.request.contextPath}/masteradmin/group/save" method="POST" role="form">
        <div class="modal-body">
          <input type="hidden" id="groupId" name="id"/>

          <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" class="form-control" id="name" name="name"/>
          </div>
          <div class="form-group">
            <label for="customerSince">Customer since:</label>
            <input type="date" class="form-control" id="customerSince" name="customerSince" disabled/>
          </div>
          <div class="form-group">
            <label for="createBy">Create By:</label>
            <input type="text" class="form-control" id="createBy" name="createBy" readonly/>
          </div>
          <div class="form-group">
            <label for="notes">Notes:</label>
            <input type="text" class="form-control" id="notes" name="notes"/>
          </div>
          <div class="form-group">
            <label for="balance">Balance:</label>
            <input type="number" class="form-control" id="balance" name="balance"/>
          </div>
          <div class="form-group">
            <label for="defaultCustomerInfo">Default customer info:</label>
            <select class="form-control" id="defaultCustomerInfo" name="defaultCustomerInfo"></select>
          </div>
          <div class="form-group">
            <label for="address">Address:</label>
            <input type="text" class="form-control" id="address" name="address"/>
          </div>
          <div class="form-group">
            <label for="city">City:</label>
            <input type="text" class="form-control" id="city" name="city"/>
          </div>
          <div class="form-group">
            <label for="pinCode">Pin code:</label>
            <input type="text" class="form-control" id="pinCode" name="pinCode"/>
          </div>
          <div class="form-group">
            <label for="phone">Phone:</label>
            <input type="text" class="form-control" id="phone" name="phone"/>
          </div>
          <div class="form-group">
            <label for="mobile">Mobile:</label>
            <input type="text" class="form-control" id="mobile" name="mobile"/>
          </div>
          <div class="form-group">
            <label for="email">Email:</label>
            <input type="text" class="form-control" id="email" name="email"/>
          </div>
          <div class="form-group">
            <label for="companyRegNo">Company Reg No:</label>
            <input type="text" class="form-control" id="companyRegNo" name="companyRegNo"/>
          </div>
          <div class="form-group">
            <label for="vatRegNo">Vat Reg No:</label>
            <input type="text" class="form-control" id="vatRegNo" name="vatRegNo"/>
          </div>
          <div class="form-group">
            <label for="style">Style:</label>
            <select class="form-control" id="style" name="style">
              <option value="DEFAULT">DEFAULT</option>
              <option value="GSM">GSM</option>
              <option value="KAS">KAS</option>
              <option value="YMT">YMT</option>
            </select>
          </div>
          <div class="checkbox">
            <label><input type="checkbox" id="active" name="active"/>Active</label>
          </div>
          <div class="checkbox">
            <label><input type="checkbox" id="checkAganinstGroupBalance" name="checkAganinstGroupBalance"/>Check aganinst group balance</label>
          </div>
          <div class="checkbox">
            <label><input type="checkbox" id="applyDefaultCustomerPercentages"
                          name="applyDefaultCustomerPercentages"/>Apply default customer percentages</label>
          </div>
          <div class="checkbox">
            <label><input type="checkbox" id="sellAtFaceValue" name="sellAtFaceValue"/>Sell at face
              value</label>
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
