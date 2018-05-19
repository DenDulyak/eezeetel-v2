<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Customer Credit Summary</title>
</head>
<body>
<%
    String strCutoffDate = "2012-04-01 00:00:00";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Calendar cal = Calendar.getInstance();
    cal.setTime(sdf.parse(strCutoffDate));
    cal.add(Calendar.SECOND, -1);
    String strPreviousYear = sdf.format(cal.getTime());

    strCutoffDate = "'" + strCutoffDate + "'";
%>
<form name="the_form" method="post" action="">
    <table>
        <tr>
            <td align="right"> Customer :</td>
            <td>
                <genericappdb:CustomerList name="customer_id" active_records_only="1" initial_option="All" onChange=""/>
            </td>
        </tr>
    </table>
    <table width="100%" border="1">
        <tr>
            <td> Customer ID</td>
            <td> Customer</td>
            <td> Credit</td>
            <td> Debit</td>
            <td> Total Payment</td>
            <td> Total Spending</td>
            <td> Beginning Balance (<%=strCutoffDate%>)</td>
            <td> Balance Should Be</td>
            <td> Balance Is</td>
            <td> Tallied</td>
        </tr>
        <%
            Session theSession = null;
            DecimalFormat df = new DecimalFormat("0.##");
            Object objValue;
            try {
                theSession = HibernateUtil.openSession();

                Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

                String strQuery = "from TMasterCustomerinfo where Active_Status = 1 and Customer_Group_ID = " + nCustomerGroupID +
                        " order by Customer_ID";
                Query query = theSession.createQuery(strQuery);
                List list = query.list();
                for (int i = 0; i < list.size(); i++) {
                    TMasterCustomerinfo custInfo = (TMasterCustomerinfo) list.get(i);
                    if (custInfo.getId() == 28) continue;
                    strQuery = "select sum(Payment_Amount) as Payment_Amount from t_master_customer_credit where Customer_ID = " +
                            custInfo.getId() + " and Credit_or_Debit = 1 and Payment_Date >= " + strCutoffDate;
                    System.out.println(strQuery);
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
                            custInfo.getId() + " and Credit_or_Debit = 2 and Entered_Time >= " + strCutoffDate;
                    System.out.println(strQuery);
                    sqlQuery = theSession.createSQLQuery(strQuery);
                    sqlQuery.addScalar("Payment_Amount", new FloatType());
                    paymentList = sqlQuery.list();

                    float fTotalDebit = 0.0f;
                    if (paymentList.size() > 0) {
                        objValue = paymentList.get(0);
                        if (objValue != null)
                            fTotalDebit = Float.parseFloat(objValue.toString());
                    }

                    strQuery = "select sum(Cost_To_Customer) as total_spent from t_report_customer_profit where Customer_ID = " + custInfo.getId() + " and Customer_Group_ID = " + nCustomerGroupID +
                            " and Begin_Date >= " + strCutoffDate;
                    System.out.println(strQuery);
                    sqlQuery = theSession.createSQLQuery(strQuery);

                    sqlQuery.addScalar("total_spent", new FloatType());
                    List spentList = sqlQuery.list();
                    float fTotalSepnt = 0.0f;
                    if (spentList.size() > 0) {
                        objValue = spentList.get(0);
                        if (objValue != null)
                            fTotalSepnt = Float.parseFloat(objValue.toString());
                    }

                    strQuery = "from TReportCustomerCredit where Customer_ID = " + custInfo.getId() +
                            " and Customer_Group_ID = " + nCustomerGroupID + " order by Begin_Date desc limit 1";
                    System.out.println(strQuery);
                    query = theSession.createQuery(strQuery);
                    List balanceList = query.list();
                    float fBeginningBalance = 0.0f;
                    float fBeginningDebt = 0.0f;
                    TReportCustomerCredit reportCredit = null;
                    if (balanceList.size() > 0) {
                        reportCredit = (TReportCustomerCredit) balanceList.get(0);
                        if (reportCredit != null) {
                            fBeginningBalance = reportCredit.getBalanceOnEndDate();
                            fBeginningDebt = reportCredit.getTotalDebitOnEndDate();
                        }
                    }

                    float fTotalPayment = fTotalCredit + fTotalDebit - fBeginningDebt;

                    String strBalanceShouldHaveBeen = df.format(fTotalPayment - fTotalSepnt + fBeginningBalance);
                    String strBalanceIs = df.format(custInfo.getCustomerBalance());

                    int nBalanceShouldBe = (int) (fTotalPayment - fTotalSepnt + fBeginningBalance);
                    int nBalanceIs = (int) (custInfo.getCustomerBalance());

                    String strTallied = "YES";
                    if (nBalanceShouldBe != nBalanceIs)
                        strTallied = "NO";
        %>
        <tr>
            <td><%=custInfo.getId()%>
            </td>
            <td><%=custInfo.getCompanyName()%>
            </td>
            <td><%=df.format(fTotalCredit)%>
            </td>
            <td><%=df.format(fTotalDebit)%>
            </td>
            <td><%=df.format(fTotalPayment)%>
            </td>
            <td><%=df.format(fTotalSepnt)%>
            </td>
            <td><%=df.format(fBeginningBalance)%>
            </td>
            <td><%=strBalanceShouldHaveBeen%>
            </td>
            <td><%=strBalanceIs%>
            </td>
            <td><%=strTallied%>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession(theSession);
            }
        %>

        <tr>

            <td align="center">
                <a href="/admin"> Admin Main </a>
            </td>
        </tr>

    </table>
</form>
</body>
</html>