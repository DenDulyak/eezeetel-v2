<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <c:import url="../common/libs.jsp"/>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Master Information</title>
</head>
<body>
<table class="table table-striped">
    <tr>
        <th>Users</th>
        <th>Suppliers</th>
        <th>Products</th>
        <th>Customers</th>
        <th>Accounts</th>
        <th>Transactions</th>
        <th>Reports</th>
    </tr>

    <tr>
        <td><a href=/masteradmin/user/type> User Type </a></td>
        <td><a href=/masteradmin/ManageSupplierType.jsp> Supplier Type </a></td>
        <td><a href=/masteradmin/ManageProductType.jsp> Product Type </a></td>
        <td><a href=/masteradmin/ManageCustomerType.jsp> Customer Type </a></td>
        <td><a href=/masteradmin/QuickCredit.jsp> Quick Credit Info </a></td>
        <td><a href=/masteradmin/ManageBatchInfo.jsp> Batch Information </a></td>
        <td><a href=/masteradmin/ReportStockInformation.jsp> Stock Information Report </a></td>
    </tr>

    <tr>
        <td><a href=/masteradmin/ChangePassword.jsp> Change My Password </a></td>
        <td><a href=/masteradmin/ManageSupplierInfo.jsp> Supplier Information </a></td>
        <td><a href=/masteradmin/ManageProductInfo.jsp> Product Information </a></td>
        <td><a href=/masteradmin/groupmanage/MultipleCustomerGroupCommission.jsp> Profit Margin on Customer Group </a></td>
        <td></td>
        <td><a href=/masteradmin/RevokeTransactionManually.jsp> Revoke Transaction</a></td>
        <td><a href=/masteradmin/ReportEmptyStockInformation.jsp> Empty Stock Information Report </a>
        </td>
    </tr>

    <tr>
        <td><a href=/masteradmin/ResetPassword.jsp> Reset Password </a></td>
        <td><a href=/masteradmin/SupplierPayments.jsp> Supplier Payments </a></td>
        <td><a href=/masteradmin/ManageProductSaleInfo.jsp> Product Sale Information </a></td>
        <td><a href=/masteradmin/groupmanage/ManageCustomerGroupCredit.jsp> CUSTOMER GROUP CREDIT </a>
        </td>
        <td><a href=/masteradmin/Purchase3RProducts.jsp>Purchase 3R Products</a></td>
        <td><a href=/masteradmin/CorrectCardInfo.jsp> Correct Card Information </a></td>
        <td><a href=/masteradmin/MonthlyReportStockInformation.jsp> MONTHLY Stock Information Report </a>
        </td>
    </tr>

    <tr>
        <td><a href="/logout">Logout</a></td>
        <td></td>
        <!-- <td></td> -->
        <td><a href="/masteradmin/SIM/ManageSIMs.jsp"> Manage SIMs </a></td>
        <td><a href="/masteradmin/customermessages/ManageCustomerMessage.jsp">Message To Customers</a>
        </td>
        <td><a href="/masteradmin/expenses/ManageExpenses.jsp">Manage Expenses</a></td>
        <td><a href="/masteradmin/LookupBatchNumber.jsp"> Lookup Batch Number </a></td>
        <%
            if (request.isUserInRole("Employee_Master_Admin")) {
        %>
        <td><a href=/masteradmin/QuickProfitReport.jsp> Quick Profit Report </a></td>
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
        <td></td>
        <td><a href="/masteradmin/customers/SetupFeatures.jsp">Customer Features</a></td>
        <td></td>
        <td></td>
        <td><a href=/masteradmin/VATReport.jsp> VAT Report </a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="/masteradmin/group">Customer groups</a></td>
        <td></td>
        <td></td>
        <td><a href=/masteradmin/VAT_Report_By_Customer.jsp> VAT Report By Customer</a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><a href=/masteradmin/ReportRevokedTransactions.jsp> Revoked Transaction Report </a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><a href=/masteradmin/ReportTransferTo.jsp> TransferTo Transactions </a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><a href=/masteradmin/ReportDing.jsp> Ding Transactions </a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><a href=/masteradmin/ProductSaleReport.jsp> Product Sale Report </a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="/masteradmin/report/stock-reconciliation">Stock Reconciliation Report</a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="/masteradmin/report/by-sequence">Report by sequence ID</a></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><a href="/masteradmin/report/sales-by-agent">Sales Report by Agent</a></td>
    </tr>
</table>

<%
    String strQuery = "from TTransfertoTransactions order by Transaction_Time desc";
    float fBalance = 0.0f;
    float fDingBalance = 0.0f;
    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        Query query = theSession.createQuery(strQuery);
        query.setMaxResults(1);
        List records = query.list();
        if (records.size() > 0) {
            TTransfertoTransactions theTransaction = (TTransfertoTransactions) records.get(0);
            fBalance = theTransaction.getEezeeTelBalance();
        }

//        DingMain dingser = new DingMain(1, null);
//        fDingBalance = dingser.GetBalance();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
<br><br>
<H2>EezeeTel Balance with Transfer-To is : <%=fBalance%></H2>
<br>
<H2>EezeeTel Balance with Ding is : <%=fDingBalance%></H2>
</body>
</html>