<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Stock Information Report</title>
</head>
<%
    String strQuery = "from TMasterCustomerinfo where Active_Status = 1 order by Customer_Balance, Customer_ID";

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();

        Query sqlQuery = theSession.createQuery(strQuery);
        List report = sqlQuery.list();
        float fTotal = 0;
%>
<body>
<table border="1">
    <tr>
        <td><h3>EezeeTel Customers</h3></td>
    </tr>
    <tr>
        <td>Customer</td>
        <td>Available Balance</td>
        <td><b>Debit History</b></td>
        <td>Customer ContactInfo</td>
    </tr>
    <%
        float fTotalBalance = 0.0f;
        float fTotalDebit = 0.0f;
        for (int i = 0; i < report.size(); i++) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) report.get(i);
            if (custInfo.getGroup().getId() != 1) continue;

            String strCustomer = custInfo.getCompanyName();
            Float fBalance = custInfo.getCustomerBalance();
            fTotal += fBalance;
            String color = "green";
            if (fBalance <= 0.0)
                color = "red";
            else if (fBalance <= 100.00)
                color = "blue";

            fTotalBalance += fBalance;

            String strContactInfo = "Mobile : " + custInfo.getMobilePhone() + ", " +
                    "Primary : " + custInfo.getPrimaryPhone() + ", " +
                    "Secondary : " + custInfo.getSecondaryPhone();

            strQuery = "from TMasterCustomerCredit where Customer_ID = " + custInfo.getId() +
                    "and Credit_or_Debit = 2 and Entered_Time > '2010-12-31 23:59:59' " +
                    "order by Entered_Time desc";

            Query sqlQuery1 = theSession.createQuery(strQuery);
            List list1 = sqlQuery1.list();

            String debitHistory = "";
            for (int j = 0; j < list1.size(); j++) {
                if (j != 0)
                    debitHistory += ", ";

                TMasterCustomerCredit custCredit = (TMasterCustomerCredit) list1.get(j);
                debitHistory += "(" + custCredit.getPaymentAmount() + " on " + custCredit.getEnteredTime() + ")";
                fTotalDebit += custCredit.getPaymentAmount();
            }

    %>
    <tr>
        <td><%=strCustomer%>
        </td>
        <td><font color="<%=color%>"><%=new DecimalFormat("0.00").format((double) fBalance)%>
        </font></td>
        <td><b><%=debitHistory%>
        </b></td>
        <td><%=strContactInfo%>
        </td>
    </tr>
    <%
        }
    %>

    <tr>
        <td><h3><font color="gray">Eezeetel Balance</font></h3></td>
        <td><h3><font color="gray"><%=new DecimalFormat("0.00").format((double) fTotalBalance)%>
        </font></h3></td>
        <td><b><%=fTotalDebit%>
        </b></td>
    </tr>

    <tr>
        <td><h3>GSM Customers</h3></td>
    </tr>
    <%
        fTotalBalance = 0.0f;
        fTotalDebit = 0.0f;
        for (int i = 0; i < report.size(); i++) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) report.get(i);
            if (custInfo.getGroup().getId() != 2) continue;

            String strCustomer = custInfo.getCompanyName();
            Float fBalance = custInfo.getCustomerBalance();
            fTotal += fBalance;
            String color = "green";
            if (fBalance <= 0.0)
                color = "red";
            else if (fBalance <= 100.00)
                color = "blue";

            fTotalBalance += fBalance;

            String strContactInfo = "Mobile : " + custInfo.getMobilePhone() + ", " +
                    "Primary : " + custInfo.getPrimaryPhone() + ", " +
                    "Secondary : " + custInfo.getSecondaryPhone();

            strQuery = "from TMasterCustomerCredit where Customer_ID = " + custInfo.getId() +
                    "and Credit_or_Debit = 2 and Entered_Time > '2010-12-31 23:59:59' " +
                    "order by Entered_Time desc";

            Query sqlQuery1 = theSession.createQuery(strQuery);
            List list1 = sqlQuery1.list();

            String debitHistory = "";
            for (int j = 0; j < list1.size(); j++) {
                if (j != 0)
                    debitHistory += ", ";

                TMasterCustomerCredit custCredit = (TMasterCustomerCredit) list1.get(j);
                debitHistory += "(" + custCredit.getPaymentAmount() + " on " + custCredit.getEnteredTime() + ")";
                fTotalDebit += custCredit.getPaymentAmount();
            }
    %>
    <tr>
        <td><%=strCustomer%>
        </td>
        <td><font color="<%=color%>"><%=new DecimalFormat("0.00").format((double) fBalance)%>
        </font></td>
        <td><b><%=debitHistory%>
        </b></td>
        <td><%=strContactInfo%>
        </td>
    </tr>
    <%
        }
    %>

    <tr>
        <td><h3><font color="gray">GSM Balance</font></h3></td>
        <td><h3><font color="gray"><%=new DecimalFormat("0.00").format((double) fTotalBalance)%>
        </font></h3></td>
        <td><b><%=fTotalDebit%>
        </b></td>
    </tr>

    <tr>
        <td align="right"><b><font color="red">Total Balance</font></b></td>
        <td align="left"><b><font color="red"><%=new DecimalFormat("0.00").format((double) fTotal)%>
        </font></b></td>
    </tr>
</table>
<BR><BR>
<a href="MasterInformation.jsp"> Go to Main </a>
</body>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</html>