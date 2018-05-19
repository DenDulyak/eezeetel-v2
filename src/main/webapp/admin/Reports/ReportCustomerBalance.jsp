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
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    String strQuery = "from TMasterCustomerinfo where Active_Status = 1 and Customer_Group_ID = " + nCustomerGroupID +
            " order by Customer_Introduced_By, Customer_Balance, Customer_Company_Name";

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
        <td>Agent</td>
        <td>Customer</td>
        <td>Available Balance</td>
        <td><b>Debit History</b></td>
        <td>Customer ContactInfo</td>
    </tr>
    <%
        float fTotalBalance = 0.0f;
        float fTotalDebit = 0.0f;
        float fTotalAgentBalance = 0.0f;
        float fTotalAgentDebit = 0.0f;

        String strPreviousAgent = "";
        for (int i = 0; i < report.size(); i++) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) report.get(i);

            String strCustomer = custInfo.getCompanyName();
            Float fBalance = custInfo.getCustomerBalance();
            fTotal += fBalance;
            String color = "green";
            if (fBalance <= 0.0)
                color = "red";
            else if (fBalance <= 100.00)
                color = "blue";

            fTotalBalance += fBalance;
            fTotalAgentBalance += fBalance;

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
                fTotalAgentDebit += custCredit.getPaymentAmount();
            }

            String strAgentName = custInfo.getIntroducedBy().getUserFirstName();
            if (strPreviousAgent.isEmpty())
                strPreviousAgent = strAgentName;

            if (strAgentName.compareToIgnoreCase(strPreviousAgent) != 0)    // agent changed
            {
    %>
    <tr bgcolor="yellow">
        <td></td>
        <td>Agent Balance</td>
        <td><font color="<%=color%>"><%=new DecimalFormat("0.00").format((double) fTotalAgentBalance)%>
        </font></td>
        <td><b><%=fTotalAgentDebit%>
        </b></td>
        <td></td>
    </tr>
    <%
            fTotalAgentBalance = 0;
            fTotalAgentDebit = 0;
        }

        strPreviousAgent = strAgentName;

    %>
    <tr>
        <td><%=strAgentName%>
        </td>
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
    <tr bgcolor="yellow">
        <td></td>
        <td>Agent Balance</td>
        <td><font color="green"><%=new DecimalFormat("0.00").format((double) fTotalAgentBalance)%>
        </font></td>
        <td><b><%=fTotalAgentDebit%>
        </b></td>
        <td></td>
    </tr>
    <tr>
        <td><h3><font color="red">Balance</font></h3></td>
        <td><h3><font color="red"><%=new DecimalFormat("0.00").format((double) fTotalBalance)%>
        </font></h3></td>
        <td><b><%=fTotalDebit%>
        </b></td>
    </tr>

</table>
<BR><BR>
<a href="/admin"> Admin Main </a>
</body>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</html>