<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    if (!request.isUserInRole("Employee_Master_Admin")) {
        response.getWriter().println("Permission Denied");
        return;
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Customer Day Summary Report</title>
    <script language="javascript">
        function generate_report() {
            document.the_form.action = "ReportCustomerDaySummary.jsp?days=" + document.the_form.number_of_days.value;
            document.the_form.submit();
        }
    </script>
</head>
<%
    String strCountryCode = application.getInitParameter("Country");
    String strDays = request.getParameter("days");
    int nDays = 0;
    if (strDays != null && !strDays.isEmpty())
        nDays = Integer.parseInt(strDays);

    String strQueryPart = "t1.Transaction_Time < now() and t1.Transaction_Time > CAST((concat(CURDATE(), ' 00:00:00')) as DATETIME) ";
    if (nDays > 0) {
        strQueryPart = "t1.Transaction_Time < now() and t1.Transaction_Time > CAST((concat(DATE_ADD(CURDATE(), INTERVAL - "
                + nDays + " DAY), ' 00:00:00')) as DATETIME) ";
    }

    String strQuery = "SELECT t2.Customer_Company_Name as Customer, t4.Product_Name as Product, count(Transaction_ID) as Number_of_transactions, " +
            "SUM(t1.quantity) as Number_of_cards, SUM(t1.Unit_Purchase_Price) as Total_Transaction_Amount, " +
            "SUM(t1.Secondary_Transaction_Price) as Total_Second_Amount, (t3.Unit_Purchase_Price) as Unit_Purchase_Price, " +
            "t2.Customer_Balance as Available_Balance FROM t_transactions t1, t_master_customerinfo t2, " +
            "t_batch_information t3, t_master_productinfo t4 where t1.Customer_ID = t2.Customer_ID and " +
            " t1.Product_ID = t4.Product_ID and t1.Batch_Sequence_ID = t3.SequenceID  and t1.Committed = 1 and " +
            strQueryPart +
            " group by t1.Customer_ID, t1.Product_ID";

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("Customer", new StringType());
        sqlQuery.addScalar("Product", new StringType());
        sqlQuery.addScalar("Number_of_transactions", new IntegerType());
        sqlQuery.addScalar("Number_of_cards", new IntegerType());
        sqlQuery.addScalar("Total_Transaction_Amount", new FloatType());
        sqlQuery.addScalar("Total_Second_Amount", new FloatType());
        sqlQuery.addScalar("Unit_Purchase_Price", new FloatType());
        sqlQuery.addScalar("Available_Balance", new FloatType());
        List report = sqlQuery.list();
%>
<body>
<form name="the_form" method="post">
    <table width="100%" border="1">
        <tr>
            <td>Days :</td>
            <td>
                <select name="number_of_days">
                    <%
                        for (int n = 1; n <= 7; n++) {
                            String strSelected = "";
                            if (n == nDays)
                                strSelected = "selected";
                    %>
                    <option value="<%=n%>" <%=strSelected%>><%=n%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td>
                <input type="button" name="generate_button" value="Generate" onClick="generate_report()">
            </td>
        </tr>
        <tr>
            <td>Customer</td>
            <td>Product</td>
            <td>Purchase Price</td>
            <td>Total Transactions</td>
            <td>Total Cards</td>
            <td>Total Transaction Sale Price</td>
            <td>Total Transaction Sale Price To Agent</td>
            <td>Total Transaction Purchase Price</td>
            <td>Total Profit</td>
            <td>Available Balance</td>
        </tr>
        <%
            int nTotalCardsInADay = 0;
            float fTotalPurchaseAmountInADay = 0;
            float fTotalSaleAmountInADay = 0;
            float fTotalProfitAmountInADay = 0;
            float fTotalAgentSalePrice = 0;

            for (int i = 0; i < report.size(); i++) {
                Object[] oneRecord = (Object[]) report.get(i);
                if (oneRecord.length > 0) {
                    String strCustomer = (String) oneRecord[0];
                    String strProduct = (String) oneRecord[1];
                    Integer nTransactions = (Integer) oneRecord[2];
                    Integer nCards = (Integer) oneRecord[3];
                    Float fSalePrice = (Float) oneRecord[4];
                    Float fSalePriceToAgent = (Float) oneRecord[5];
                    Float fUnitPurchasePrice = (Float) oneRecord[6];
                    Float fPurchasePrice = fUnitPurchasePrice * nCards;
                    Float fBalance = (Float) oneRecord[7];
                    Float fProfit = fSalePriceToAgent - fPurchasePrice;

                    nTotalCardsInADay += nCards;
                    fTotalPurchaseAmountInADay += fPurchasePrice;
                    fTotalSaleAmountInADay += fSalePrice;
                    fTotalAgentSalePrice += fSalePriceToAgent;
                    fTotalProfitAmountInADay += fProfit;
        %>
        <tr>
            <td><%=strCustomer%>
            </td>
            <td><%=strProduct%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fUnitPurchasePrice)%>
            </td>
            <td><%=nTransactions%>
            </td>
            <td><%=nCards%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fSalePrice)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fSalePriceToAgent)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fPurchasePrice)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fProfit)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fBalance)%>
            </td>
        </tr>
        <%
                }
            }
        %>
        <tr bgcolor="gray">
            <td></td>
            <td></td>
            <td></td>
            <td>Total</td>
            <td><%=nTotalCardsInADay%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalSaleAmountInADay)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalAgentSalePrice)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalPurchaseAmountInADay)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalProfitAmountInADay)%>
            </td>
            <td></td>
        </tr>
    </table>
    <BR><BR>

    <H2>Mobile Topups</H2>
    <table border="1">
        <tr>
            <td>Customer</td>
            <td>Total Transactions</td>
            <td>Total Transaction Sale Price</td>
            <td>Total Transaction Sale Price To Agent</td>
            <td>Total Transaction Purchase Price</td>
            <td>Total Profit</td>
        </tr>
        <%
            strQuery = "SELECT Customer_Company_Name as Customer, count(Transaction_ID) as Number_of_transactions, " +
                    " sum(Cost_To_EezeeTel) as Cost_To_EezeeTel, sum(Cost_To_Customer) as Cost_To_Customer, sum(Cost_To_Agent) as Cost_To_Agent " +
                    " FROM t_transferto_transactions t1, t_master_customerinfo t2 " +
                    " where t1.Customer_ID = t2.Customer_ID and " + strQueryPart + " group by t1.Customer_ID";

            sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Customer", new StringType());
            sqlQuery.addScalar("Number_of_transactions", new IntegerType());
            sqlQuery.addScalar("Cost_To_EezeeTel", new FloatType());
            sqlQuery.addScalar("Cost_To_Customer", new FloatType());
            sqlQuery.addScalar("Cost_To_Agent", new FloatType());
            report = sqlQuery.list();

            int nTotalTransactions = 0;
            float fotalPurchaseAmountMobileTopup = 0;
            float fTotalSaleAmountMobileTopup = 0;
            float fTotalProfitAmountMobileTopup = 0;
            float fTotalAgentSalePriceMobileTopup = 0;

            for (int i = 0; i < report.size(); i++) {
                Object[] oneRecord = (Object[]) report.get(i);
                if (oneRecord.length > 0) {
                    String strCustomer = (String) oneRecord[0];
                    Integer nTransactions = (Integer) oneRecord[1];
                    Float fPurchasePrice = (Float) oneRecord[2];
                    Float fSalePrice = (Float) oneRecord[3];
                    Float fSalePriceToAgent = (Float) oneRecord[4];
                    Float fProfit = fSalePriceToAgent - fPurchasePrice;

                    nTotalTransactions += nTransactions;
                    fTotalSaleAmountMobileTopup += fSalePrice;
                    fotalPurchaseAmountMobileTopup += fPurchasePrice;
                    fTotalProfitAmountMobileTopup += fProfit;
                    fTotalAgentSalePriceMobileTopup += fSalePriceToAgent;
        %>
        <tr>
            <td><%=strCustomer%>
            </td>
            <td><%=nTransactions%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fSalePrice)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fSalePriceToAgent)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fPurchasePrice)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fProfit)%>
            </td>
        </tr>
        <%
                }
            }
        %>

        <tr bgcolor="yellow">
            <td>Total</td>
            <td><%=nTotalTransactions%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalSaleAmountMobileTopup)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalAgentSalePriceMobileTopup)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fotalPurchaseAmountMobileTopup)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalProfitAmountMobileTopup)%>
            </td>
        </tr>

        <%
            nTotalTransactions += nTotalCardsInADay;
            fTotalSaleAmountMobileTopup += fTotalSaleAmountInADay;
            fTotalAgentSalePriceMobileTopup += fTotalAgentSalePrice;
            fotalPurchaseAmountMobileTopup += fTotalPurchaseAmountInADay;
            fTotalProfitAmountMobileTopup += fTotalProfitAmountInADay;
        %>


        <tr bgcolor="green">
            <td><H1>Day(s) Summary</H1></td>
            <td><%=nTotalTransactions%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalSaleAmountMobileTopup)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalAgentSalePriceMobileTopup)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fotalPurchaseAmountMobileTopup)%>
            </td>
            <td><%=new DecimalFormat("0.00").format((double) fTotalProfitAmountMobileTopup)%>
            </td>
        </tr>

    </table>
    <BR><BR>
    <a href="MasterInformation.jsp"> Go to Main </a>
</form>
</body>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</html>