<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <style>
        th, td {
            text-align: center;
        }

        th > span {
            font-size: x-large;
            color: brown;
        }
    </style>
    <meta charset="UTF-8">
    <title>Admin Application</title>
</head>
<body>
<%
    String ksContext = application.getContextPath();
    boolean bSuppressForGSM = false;
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strQuery = "from User where User_Login_ID = '" + request.getRemoteUser() + "' and Customer_Group_ID = " + nCustomerGroupID;

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();
        if (records.size() > 0) {
            User theUser = (User) records.get(0);
            TMasterCustomerGroups custGroup = theUser.getGroup();
%>
<div style="text-align: center;">
    <h2>Welcome <%=theUser.getUserFirstName()%> <%=theUser.getUserLastName()%> to <%=custGroup.getName()%>
        Administration</h2>
</div>
<%
    if (custGroup.getCheckAganinstGroupBalance()) {
        DecimalFormat df = new DecimalFormat("0.##");
%>
<div style="text-align: center;">
    <H3> Your Balance is : <%=df.format((double) custGroup.getCustomerGroupBalance())%>
    </H3>
</div>
<%
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
<HR>

<table width="100%">

    <tr>
        <th><span>Users</span></th>
        <th><span>Customers</span></th>
        <th><span>Accounts</span></th>
        <th><span>Reports</span></th>
    </tr>

    <tr></tr>
    <tr></tr>
    <tr></tr>
    <tr></tr>
    <tr></tr>
    <tr></tr>

    <tr>
        <td><a href="<%=ksContext%>/admin/Users/ManageUser.jsp"> Users </a></td>
        <td><a href="<%=ksContext%>/admin/customerinfo"> Customer Information </a></td>
        <td><a href="<%=ksContext%>/admin/Accounts/ManageCreditRequests.jsp"> Credit Requests </a></td>
        <td><a href="<%=ksContext%>/admin/Reports/ReportCustomerBalance.jsp"> Customer Balance Report</a></td>
    </tr>

    <tr>
        <td><a href="<%=ksContext%>/admin/Users/ResetPassword.jsp"> Reset Customer Password </a></td>
        <td><a href="<%=ksContext%>/admin/Customers/ManageNewContacts.jsp"> New Contacts </a></td>
        <td><a href="<%=ksContext%>/admin/Accounts/ManageCustomerCredit.jsp"> Customer Credit </a></td>
        <td><a href="<%=ksContext%>/admin/Reports/MonthlyReportCustomerCredit.jsp"> Monthly Customer Credit Report </a></td>
    </tr>

    <tr>
        <td><a href="<%=ksContext%>/admin/change-password">Change My Password</a></td>
        <td><a href="<%=ksContext%>/admin/Products/ManageSIMs.jsp"> Manage SIMs </a></td>
        <%--<td><a href="<%=ksContext%>/admin/Accounts/MultipleCustomerCommission.jsp"> Profit Margin </a></td>--%>
        <td><a href="<%=ksContext%>/admin/Reports/PaymentByCustomer.jsp"> Payment By Customer</a></td>
    </tr>

    <tr>
        <td><a href="${pageContext.request.contextPath}/logout"><font size="6">Logout</font></a></td>
        <td><a href="${pageContext.request.contextPath}/admin/Customers/customermessages/ManageCustomerMessage.jsp">
            Customer Messages</a>
        </td>
        <td><a href="${pageContext.request.contextPath}/admin/Accounts/CopyProfitMargins.jsp">Copy Profit Margins</a></td>
        <td><a href="${pageContext.request.contextPath}/admin/Reports/ReportDailyCustomer.jsp">Daily Customer
             Transaction</a>
        </td>
    </tr>

    <tr>
        <td></td>
        <td>
            <a href="${pageContext.request.contextPath}/admin/world-topup-customer-commission">World Topup
                Customer Commission</a>
        </td>
        <td><a href="<%=ksContext%>/admin/Accounts/GroupDeposits.jsp"> Credit Report </a></td>
        <%
            if (request.isUserInRole("Group_Admin")) {
        %>
        <td><a href="<%=ksContext%>/admin/Reports/ReportCustomerDaySummary.jsp"> Customer Day Summary
            Report </a></td>
        <%
        } else {
        %>
        <td></td>
        <%
            }
        %>
    </tr>

    <tr>
        <td></td>
        <td></td>
        <td><a href="${pageContext.request.contextPath}/admin/mobile-unlocking/commission">Mobile
            Unlocking Profit Margin</a></td>
        <%
            if (request.isUserInRole("Group_Admin")) {
        %>
        <td><a href="<%=ksContext%>/admin/Reports/MonthlyReportCustomerSalesSummary.jsp"> Customer Sales
            Summary Report</a></td>
        <%
            }
        %>
    </tr>

    <tr>
        <td></td>
        <td></td>
        <td><a href="${pageContext.request.contextPath}/admin/accounts/pinless-customer-commission">Pinless Profits</a></td>
        <%
            if (request.isUserInRole("Group_Admin")) {
        %>
        <td><a href="<%=ksContext%>/admin/Reports/MonthlyReportProductSalesSummary.jsp"> Product Sales
            Summary Report</a></td>
        <%
            }
        %>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="<%=ksContext%>/admin/Reports/SimcardsSalesReportSummary.jsp"> SimCards Sales
            Report</a></td>
    </tr>

    <tr>
        <td></td>
        <td></td>
        <td></td>
        <%
            if (nCustomerGroupID != null && nCustomerGroupID == 1) {
        %>
        <td>
            <a href="<%=ksContext%>/admin/Reports/SimInfoReport.jsp"> SimInfo Report</a><br/>
            <a href="<%=ksContext%>/admin/daily-customers-transactions">Daily Customer Transactions</a>
        </td>
        <%
        } else {
        %>
        <td>
            <a href="<%=ksContext%>/admin/daily-customers-transactions">Daily Customer Transactions</a>
        </td>
        <%
            }
        %>
    </tr>

    <%
        if (nCustomerGroupID != null && nCustomerGroupID == 1) {
    %>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td>
            <a href="<%=ksContext%>/admin/profit-report">New Profit Report</a>
        </td>
    </tr>

    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="<%=ksContext%>/admin/vat-report">Vat Report</a></td>
    </tr>

    <%
        }
    %>

    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="<%=ksContext%>/admin/report/customer-balance">New Customer Balance Report</a></td>
    </tr>

    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="<%=ksContext%>/admin/report/customer-commissions">Customer Commissions Report</a></td>
    </tr>

</table>
</body>
</html>