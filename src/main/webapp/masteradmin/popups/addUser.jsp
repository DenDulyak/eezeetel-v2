<div class="modal fade" id="userModal" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">New user</h4>
      </div>
      <form id="userForm" action="${pageContext.request.contextPath}/masteradmin/user/save" method="POST">
        <div class="modal-body">
          <div class="form-group">
            <label for="login">Login:</label>
            <input type="text" class="form-control" id="login" name="login"/>
          </div>
          <div class="form-group">
            <label for="type">Type:</label>
            <select class="form-control" id="type" name="type">
              <option value="2">Employee_Master_Admin</option>
              <option value="3">Employee_Manager</option>
              <option value="4">Group_Admin</option>
              <option value="5">Group_Manager</option>
              <option value="6">Agent_User</option>
              <option value="7">Customer_Supervisor</option>
              <option value="8">Customer_User</option>
              <option value="9">Mobile_Admin</option>
            </select>
          </div>
          <div class="form-group">
            <label for="group">Group:</label>
            <select class="form-control" id="group" name="group"></select>
          </div>
          <div class="form-group">
            <label for="company">Company name:</label>
            <select class="form-control" id="company" name="company"></select>
          </div>
          <div class="form-group">
            <label for="country">Country:</label>
            <select class="form-control" id="country" name="country"></select>
          </div>
          <div class="form-group">
            <label for="firstName">First name:</label>
            <input type="text" class="form-control" id="firstName" name="firstName"/>
          </div>
          <div class="form-group">
            <label for="lastName">Last name:</label>
            <input type="text" class="form-control" id="lastName" name="lastName"/>
          </div>
          <div class="form-group">
            <label for="middleName">Middle name:</label>
            <input type="text" class="form-control" id="middleName" name="middleName"/>
          </div>
          <div class="form-group">
            <label for="addressLine1">Address line 1:</label>
            <input type="text" class="form-control" id="addressLine1" name="addressLine1"/>
          </div>
          <div class="form-group">
            <label for="addressLine2">Address line 2:</label>
            <input type="text" class="form-control" id="addressLine2" name="addressLine2"/>
          </div>
          <div class="form-group">
            <label for="addressLine3">Address line 3:</label>
            <input type="text" class="form-control" id="addressLine3" name="addressLine3"/>
          </div>
          <div class="form-group">
            <label for="city">City:</label>
            <input type="text" class="form-control" id="city" name="city"/>
          </div>
          <div class="form-group">
            <label for="state">State:</label>
            <input type="text" class="form-control" id="state" name="state"/>
          </div>
          <div class="form-group">
            <label for="postalCode">Postal code:</label>
            <input type="text" class="form-control" id="postalCode" name="postalCode"/>
          </div>
          <div class="form-group">
            <label for="primaryPhone">Primary Phone:</label>
            <input type="text" class="form-control" id="primaryPhone" name="primaryPhone"/>
          </div>
          <div class="form-group">
            <label for="secondaryPhone">Secondary Phone:</label>
            <input type="text" class="form-control" id="secondaryPhone" name="secondaryPhone"/>
          </div>
          <div class="form-group">
            <label for="mobilePhone">Mobile Phone:</label>
            <input type="text" class="form-control" id="mobilePhone" name="mobilePhone"/>
          </div>
          <div class="form-group">
            <label for="email">Email:</label>
            <input type="text" class="form-control" id="email" name="email"/>
          </div>
          <div class="form-group">
            <label for="password1">Password:</label>
            <input type="password" class="form-control" id="password1" name="password1"/>
          </div>
          <div class="form-group">
            <label for="password2">Password 2:</label>
            <input type="password" class="form-control" id="password2" name="password2"/>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success">Save</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>
