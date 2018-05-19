<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<html>
<body>
<a href="/admin"> Admin Main </a>
<br><br>


<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();

        String strQuery = "from TMasterCustomerGroupCredit where Customer_Group_ID = " + nCustomerGroupID
                + " order by Group_Credit_ID desc";
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<table border=\"1\" width=\"100%\"> <tr bgcolor=\"#99CCFF\">" +
                "<td> <h5>Credit ID</h5> </td> <td> <h5>Payment Type</h5> </td>" +
                "<td> <h5>Payment Details</h5> </td><td> <h5>Payment Amount</h5> </td>" +
                "<td> <h5>Payment Received Date</h5> </td>" +
                "<td> <h5>Topup Date</h5> </td>" +
                "<td> <h5>Credit OR Debit</h5> </td></tr>";

        float fOutstandingBalance = 0.0f;
        boolean bDone = false;

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterCustomerGroupCredit custCredit = (TMasterCustomerGroupCredit) records.get(nIndex);

            String strPaymentType = "Not Paid";
            switch (custCredit.getPaymentType()) {
                case 1:
                    strPaymentType = "Cash";
                    break;
                case 2:
                    strPaymentType = "Cheque";
                    break;
                case 3:
                    strPaymentType = "Bank Deposit";
                    break;
                case 4:
                    strPaymentType = "Funds Transfer";
                    break;
                case 5:
                    strPaymentType = "Debit/Credit Card";
                    break;
            }

            String strPaymentDate = "Not Paid/Credited Yet";

            Date dtPayment = custCredit.getPaymentDate();
            if (dtPayment != null)
                strPaymentDate = dtPayment.toString();

            String strCreditOrDebit = "DEBIT";
            String strBgColor = "Red";
            if (custCredit.getCreditOrDebit() == 1) {
                strCreditOrDebit = "Credit";
                strBgColor = "";
                fOutstandingBalance += custCredit.getPaymentAmount();
            } else
                fOutstandingBalance -= custCredit.getPaymentAmount();

            String strPaymentDetails = custCredit.getPaymentDetails();
            if (strPaymentDetails == null || strPaymentDetails.isEmpty())
                strPaymentDetails = "";

            strResult += ("<tr bgcolor=\"" + strBgColor + "\">" +
                    "<td align=\"left\">" + custCredit.getId() + "</td>" +
                    "<td align=\"left\">" + strPaymentType + "</td>" +
                    "<td align=\"left\">" + strPaymentDetails + "</td>" +
                    "<td align=\"left\">" + custCredit.getPaymentAmount() + "</td>" +
                    "<td align=\"left\">" + strPaymentDate + "</td>" +
                    "<td align=\"left\">" + custCredit.getEnteredTime() + "</td>" +
                    "<td align=\"left\">" + strCreditOrDebit + "</td>" + "</tr>");
        }

        DecimalFormat df = new DecimalFormat("0.00");

        strResult += "</table>";
%>
<%=strResult%>
<%
} catch (Exception e) {
    e.printStackTrace();
    String strResult = "No records found";
%>
<%=strResult%>
<%
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
<br>
<a href="/admin"> Admin Main </a>
</body>
</html>
