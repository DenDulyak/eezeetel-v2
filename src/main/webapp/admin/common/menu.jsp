<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside>
    <div id="sidebar" class="nav-collapse no-print">
        <ul class="sidebar-menu">
            <li class="active">
                <a class="" href="${pageContext.request.contextPath}/admin/AdminMain.jsp">
                    <span class="glyphicon glyphicon-home"></span>
                    <span class="p-l-5">Dashboard</span>
                </a>
            </li>
            <li class="sub-menu">
                <a href="javascript:;" class="">
                    <span class="glyphicon glyphicon-user"></span>
                    <span class="p-l-5">Users</span>
                    <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
                </a>
                <ul class="sub">
                    <li><a href="${pageContext.request.contextPath}/admin/Users/ManageUser.jsp">Users</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/change-password">Change Password</a></li>
                    <li><a style="height: 10vh" href="${pageContext.request.contextPath}/admin/Users/ResetPassword.jsp">Reset Customer Password</a></li>
                </ul>
            </li>
            <li class="sub-menu">
                <a href="javascript:;" class="">
                    <span class="glyphicon glyphicon-globe"></span>
                    <span class="p-l-5">Customers</span>
                    <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
                </a>
                <ul class="sub">
                    <li><a class="" href="${pageContext.request.contextPath}/admin/customerinfo">Customer Information</a></li>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/Customers/ManageNewContacts.jsp">New Contacts</a></li>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/Products/ManageSIMs.jsp">Manage SIMs</a></li>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/Customers/customermessages/ManageCustomerMessage.jsp">Customer Messages</a></li>
                    <li><a style="height: 10vh" class="" href="${pageContext.request.contextPath}/admin/world-topup-customer-commission">World Topup Customer Commission</a></li>
                </ul>
            </li>
            <li class="sub-menu">
                <a href="javascript:;" class="">
                    <span class="glyphicon glyphicon-list"></span>
                    <span class="p-l-5">Accounts</span>
                    <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
                </a>
                <ul class="sub">
                    <c:if test="${groupId != 2}">
                        <li><a class="" href="${pageContext.request.contextPath}/admin/Accounts/ManageCreditRequests.jsp">Credit Requests</a></li>
                        <li><a class="" href="${pageContext.request.contextPath}/admin/Accounts/ManageCustomerCredit.jsp">Customer Credit</a></li>
                    </c:if>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/Accounts/MultipleCustomerCommission.jsp">Profit Margin</a></li>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/Accounts/CopyProfitMargins.jsp">Copy Profit Margins</a></li>
                    <li><a style="height: 10vh" href="${pageContext.request.contextPath}/admin/mobile-unlocking/commission">Mobile Unlocking Profit Margins</a></li>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/accounts/pinless-customer-commission">Pinless Profits</a></li>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/Accounts/GroupDeposits.jsp">Credit Report</a></li>
                </ul>
            </li>
            <li class="sub-menu">
                <a href="javascript:;" class="">
                    <span class="glyphicon glyphicon-folder-open"></span><span class="p-l-5">Reports</span>
                    <span class="menu-arrow glyphicon glyphicon-menu-right"></span>
                </a>
                <ul class="sub">
                    <li><a class="" href="${pageContext.request.contextPath}/admin/Reports/ReportCustomerBalance.jsp">Customer Balance</a></li>
                    <li><a style="height: 10vh" class="" href="${pageContext.request.contextPath}/admin/Reports/MonthlyReportCustomerCredit.jsp">Monthly
                        Customer Credit Report</a></li>
                    <c:if test="${groupId != 2}">
                        <li><a class="" href="${pageContext.request.contextPath}/admin/Reports/PaymentByCustomer.jsp">Payment By Customer</a></li>
                    </c:if>
                    <li>
                        <a style="height: 10vh" class="" href="${pageContext.request.contextPath}/admin/Reports/ReportDailyCustomer.jsp">Daily Customer Transaction</a>
                    </li>
                    <c:if test="${isGroupAdmin}">
                        <li>
                            <a class="" href="${pageContext.request.contextPath}/admin/Reports/ReportCustomerDaySummary.jsp">Customer Day Summary</a>
                        </li>
                        <li>
                            <a style="height: 10vh" class=""
                               href="${pageContext.request.contextPath}/admin/Reports/MonthlyReportCustomerSalesSummary.jsp">Customer Sales Summary</a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/Reports/MonthlyReportProductSalesSummary.jsp">Product Sales Summary</a>
                        </li>
                    </c:if>
                    <li>
                        <a class="" href="${pageContext.request.contextPath}/admin/Reports/SimcardsSalesReportSummary.jsp">SimCards Sales</a>
                    </li>
                    <c:if test="${groupId == 1}">
                        <li><a class="" href="${pageContext.request.contextPath}/admin/Reports/SimInfoReport.jsp">SimInfo Report</a></li>
                    </c:if>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/report/customer-balance">Customer Balance Report</a></li>
                    <li><a class="" href="${pageContext.request.contextPath}/admin/report/customer-commissions">Customer Commissions</a></li>
                </ul>
            </li>
        </ul>
    </div>
</aside>
