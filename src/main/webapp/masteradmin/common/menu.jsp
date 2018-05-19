<aside>
  <div id="sidebar" class="nav-collapse no-print">
    <ul class="sidebar-menu">
      <li class="active">
        <a class="" href="${pageContext.request.contextPath}/masteradmin/MasterInformation.jsp">
          <span class="glyphicon glyphicon-home"></span>
          <span>Dashboard</span>
        </a>
      </li>
      <li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-user"></span>
          <span>Users</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <li><a href="${pageContext.request.contextPath}/masteradmin/user/type">User Type</a></li>
          <li><a href="${pageContext.request.contextPath}/masteradmin/ResetPassword.jsp">Reset Password</a></li>
        </ul>
      </li>
      <li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-globe"></span>
          <span>Suppliers</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/ManageSupplierType.jsp">Type</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/manage-supplier">Information</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/SupplierPayments.jsp">Payments</a></li>
        </ul>
      </li>
      <li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-list"></span>
          <span>Products</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/ManageProductType.jsp">Type</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/ManageProductInfo.jsp">Information</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/manage-product-sale-info">Sale Information</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/SIM/ManageSIMs.jsp">Manage SIMs</a></li>
        </ul>
      </li>
      <li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-folder-open"></span>
          <span>&nbspCustomers</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/ManageCustomerType.jsp">Type</a></li>
          <li><a style="height: 10vh" class="" href="${pageContext.request.contextPath}/masteradmin/groupmanage/MultipleCustomerGroupCommission.jsp">Profit Margin on Customer Group</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/groupmanage/ManageCustomerGroupCredit.jsp">GROUP CREDIT</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/customermessages/ManageCustomerMessage.jsp">Message To Customers</a></li>
          <%--<li><a class="" href="/masteradmin/feature">Features</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/customers/setup-features">Setup Features</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/groups">Groups</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/calling-card-price">Calling Card Prices</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/customers/pinless-group-commission">Pinless Commission</a></li>--%>
          <%--<li><a style="height: 10vh" class="" href="${pageContext.request.contextPath}/masteradmin/customers/world-topup-group-commission">World Mobile Topup Group Commission</a></li>--%>
        </ul>
      </li>
      <li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-file"></span>
          <span>Accounts</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/QuickCredit.jsp">Quick Credit Info</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/Purchase3RProducts.jsp">Purchase 3R Products</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/expenses/ManageExpenses.jsp">Manage Expenses</a></li>--%>
        </ul>
      </li>
      <li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-th"></span>
          <span>Transactions</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/ManageBatchInfo.jsp">Batch Information</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/RevokeTransactionManually.jsp">Revoke Transaction</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/correct-card-information">Correct Card Info</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/LookupBatchNumber.jsp">Lookup Batch Number</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/retune-cards-stock">Retune Cards Stock</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/sales-retune">Sales Retune</a></li>
        </ul>
      </li>
      <li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-list-alt"></span>
          <span>Reports</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/ReportStockInformation.jsp">Stock Information</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/ReportEmptyStockInformation.jsp">Empty Stock Info</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/MonthlyReportStockInformation.jsp">MONTHLY Stock Info</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/QuickProfitReport.jsp">Quick Profit</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/VATReport.jsp">VAT</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/vat-by-month">VAT By Month</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/vat-by-customer">VAT By Customer</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/revoked-transactions">Revoked Transaction</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/ReportTransferTo.jsp">TransferTo Transactions</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/ReportDing.jsp">Ding Transactions</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/ProductSaleReport.jsp">Product Sale</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/stock-reconciliation">Stock Reconciliation</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/product-cost-price">Products With Cost Price</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/sales-return">Sales Return</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/by-sequence">By Sequence ID</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/product-batches">Product Batches</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/sales-by-agent">Sales by Agent</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/detail-sales">Detail Sales</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/ding-transactions">Ding Transactions</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/mobitopup-transactions">Mobitopup Transactions</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/pinless-transactions">Pinless Transactions</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/daily-customers-transactions">Daily Transactions</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/new-profit">New Profit Report</a></li>--%>
          <%--<li><a class="" style="height: 10vh" href="${pageContext.request.contextPath}/masteradmin/report/world-mobile-topup-summary-report">World Mobile Topup Summary Report</a></li>--%>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/all-transactions">All Transactions</a></li>--%>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/customer-balance">Customer Balance</a></li>
          <%--<li><a class="" href="${pageContext.request.contextPath}/masteradmin/report/supplier-payment">Supplier Payment</a></li>--%>
        </ul>
      </li>
      <%--<li class="sub-menu">
        <a href="javascript:;" class="">
          <span class="glyphicon glyphicon-list-alt"></span>
          <span>Mobile Unlocking</span>
          <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
        </a>
        <ul class="sub">
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/mobile-unlocking">Mobile Unlocking</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/mobile-unlocking/commission">Profit Margin</a></li>
          <li><a class="" href="${pageContext.request.contextPath}/masteradmin/mobile-unlocking/orders">Orders</a></li>
        </ul>
      </li>--%>
      <li class="active">
        <a class="" href="${pageContext.request.contextPath}/masteradmin/setting">
          <span class="glyphicon glyphicon-cog"></span>
          <span>Setting</span>
        </a>
      </li>
    </ul>
  </div>
</aside>
