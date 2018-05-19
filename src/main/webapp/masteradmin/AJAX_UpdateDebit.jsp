<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>


<%
    String strCutoffDate = "'2011-03-31 23:59:59'";

    String strCustomerID = request.getParameter("customer_id");
    int nCustomerID = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerID = Integer.parseInt(strCustomerID);
    if (nCustomerID == 0 || nCustomerID == 28) return;

    Session theSession = null;
    DecimalFormat df = new DecimalFormat("0.##");
    Object objValue;
    try {
        theSession = HibernateUtil.openSession();

        String strQuery = "from TMasterCustomerCredit where Customer_ID = " + nCustomerID;
        strQuery += "and Credit_or_Debit = 2 and Payment_Date > " + strCutoffDate + "order by Payment_Date";
        Query query = theSession.createQuery(strQuery);
        List updateCreditList = query.list();
        for (int i = 0; i < updateCreditList.size(); i++) {
            TMasterCustomerCredit custCredit = (TMasterCustomerCredit) updateCreditList.get(i);
            // work from here
        }

        strQuery = "from TMasterCustomerinfo where Active_Status = 1 and Customer_ID = " + nCustomerID;
        query = theSession.createQuery(strQuery);
        List list = query.list();
        if (list.size() > 0) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) list.get(0);
            strQuery = "select sum(Payment_Amount) as Payment_Amount from t_master_customer_credit where Customer_ID = " +
                    custInfo.getId() + " and Credit_or_Debit = 1 and Payment_Date > " + strCutoffDate;
            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Payment_Amount", new FloatType());
            List paymentList = sqlQuery.list();
            float fTotalCredit = 0.0f;
            if (paymentList.size() > 0) {
                objValue = paymentList.get(0);
                if (objValue != null)
                    fTotalCredit = Float.parseFloat(objValue.toString());
            }

            strQuery = "select sum(Payment_Amount) as Payment_Amount from t_master_customer_credit where Customer_ID = " +
                    custInfo.getId() + " and Credit_or_Debit = 2 and Payment_Date > " + strCutoffDate;
            sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Payment_Amount", new FloatType());
            paymentList = sqlQuery.list();

            float fTotalDebit = 0.0f;
            if (paymentList.size() > 0) {
                objValue = paymentList.get(0);
                if (objValue != null)
                    fTotalDebit = Float.parseFloat(objValue.toString());
            }
            float fTotalPayment = fTotalCredit + fTotalDebit;

            strQuery = "select sum(tot_amount) as total_spent from (" +
                    "select sum(Unit_Purchase_Price) as tot_amount from t_transactions where Customer_ID = " + custInfo.getId() +
                    "  and Committed = 1 and Transaction_Time > " + strCutoffDate + " and Product_ID != 146" +
                    " union " +
                    "select sum(Unit_Purchase_Price)  as tot_amount from t_history_transactions where Customer_ID = " + custInfo.getId() +
                    " and Committed = 1 and Transaction_Time > " + strCutoffDate + " and Product_ID != 146" +
                    ") as pp";

            sqlQuery = theSession.createSQLQuery(strQuery);

            sqlQuery.addScalar("total_spent", new FloatType());
            List spentList = sqlQuery.list();
            float fTotalSepnt = 0.0f;
            if (spentList.size() > 0) {
                objValue = spentList.get(0);
                if (objValue != null)
                    fTotalSepnt = Float.parseFloat(objValue.toString());
            }

            strQuery = "select Balance_After_Transaction from t_history_transaction_balance where Transaction_ID = " +
                    "(select Transaction_ID from t_history_transactions where Customer_ID = " +
                    custInfo.getId() + " and Transaction_Time < " + strCutoffDate +
                    " and Committed = 1 order by Transaction_Time desc limit 1)";
            sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Balance_After_Transaction", new FloatType());
            List balanceList = sqlQuery.list();
            float fBeginningBalance = 0.0f;
            if (balanceList.size() > 0) {
                objValue = balanceList.get(0);
                if (objValue != null)
                    fBeginningBalance = Float.parseFloat(objValue.toString());
            }

            String strBalanceShouldHaveBeen = df.format(fTotalPayment - fTotalSepnt + fBeginningBalance);
            String strBalanceIs = df.format(custInfo.getCustomerBalance());

            int nBalanceShouldBe = (int) (fTotalPayment - fTotalSepnt + fBeginningBalance);
            int nBalanceIs = (int) (custInfo.getCustomerBalance());

            String strTallied = "YES";
            if (nBalanceShouldBe != nBalanceIs)
                strTallied = "NO";

            strQuery = "from TMasterCustomerCredit where Customer_ID = " +
                    custInfo.getId() + " order by Payment_Date desc";
            query = theSession.createQuery(strQuery);
            List latestTransactions = query.list();

            String strResult = "<table border=\"1\">";
            strResult += "<tr> <td> Customer ID </td>";
            strResult += "<td>" + custInfo.getId() + "</td></tr>";

            strResult += "<tr> <td> Customer </td>";
            strResult += "<td>" + custInfo.getCompanyName() + "</td></tr>";

            strResult += "<tr> <td> Customer Address </td>";
            strResult += "<td>" + custInfo.getAddressLine1() + ", " + custInfo.getAddressLine2();
            strResult += ", " + custInfo.getCity() + "</td></tr>";

            strResult += "<tr> <td> Total Credits </td>";
            strResult += "<td>" + df.format(fTotalCredit) + "</td></tr>";

            strResult += "<tr> <td> Total Debits </td>";
            strResult += "<td>" + df.format(fTotalDebit) + "</td></tr>";

            strResult += "<tr> <td> Total Payment </td>";
            strResult += "<td>" + df.format(fTotalPayment) + "</td></tr>";

            strResult += "<tr> <td> Total Spending </td>";
            strResult += "<td>" + df.format(fTotalSepnt) + "</td></tr>";

            strResult += "<tr> <td> Beginning Balance (" + strCutoffDate + ")</td>";
            strResult += "<td>" + df.format(fBeginningBalance) + "</td></tr>";

            strResult += "<tr> <td> Balance Should Be </td>";
            strResult += "<td>" + strBalanceShouldHaveBeen + "</td></tr>";

            strResult += "<tr> <td> Balance Is </td>";
            strResult += "<td>" + strBalanceIs + "</td></tr>";

            strResult += "<tr> <td> Tallied </td>";
            strResult += "<td>" + strTallied + "</td></tr>";

            strResult += "<tr> <td> <font color=\"red\">Recent Debits </font></td>";
            for (int i = 0; i < latestTransactions.size(); i++) {
                TMasterCustomerCredit custCredit = (TMasterCustomerCredit) latestTransactions.get(i);
                if (custCredit.getCreditOrDebit() == 1)
                    break;

                strResult += "<tr><td>" + custCredit.getPaymentDate() + "</td>";
                strResult += "<td>" + custCredit.getPaymentAmount() + "</td></tr>";
            }
            strResult += "</tr>";
            strResult += "</table>";

            response.setContentType("text/html");
            response.getWriter().println(strResult);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
