<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strCustomerGroupID = request.getParameter("customer_group_id");
    int nCustomerGroupID = 0;
    if (strCustomerGroupID != null && !strCustomerGroupID.isEmpty())
        nCustomerGroupID = Integer.parseInt(strCustomerGroupID);

    String strStatus = request.getParameter("credit_status");
    int nStatus = 0;
    if (strStatus != null && !strStatus.isEmpty())
        nStatus = Integer.parseInt(strStatus);

    String strQuery = "from TMasterCustomerGroupCredit where Entered_Time > '2011-01-01 00:00:00'";
    if (nCustomerGroupID > 0)
        strQuery += " and Customer_Group_ID = " + nCustomerGroupID;

    if (nStatus != -1) {
        if (nStatus == 0)
            strQuery += (" and Credit_or_Debit = 2 ");
        else
            strQuery += (" and Credit_ID_Status = " + nStatus);
    }

    strQuery += " order by Entered_Time desc";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<table class='table table-bordered'>" +
                "<tr bgcolor='#99CCFF'>" +
                "<th>Group Credit ID</th>" +
                "<th>Customer Group</th>" +
                "<th>Payment Type</th>" +
                "<th>Payment Details</th>" +
                "<th>Payment Amount</th>" +
                "<th>Payment Received Date</th>" +
                "<th>Collected By</th>" +
                "<th>Entered By</th>" +
                "<th>Topup Date</th>" +
                "<th>redit OR Debit</th>" +
                "<th>Notes</th>" +
                "</tr>";

        float fTotalAmountSoFar = 0.0f;
        boolean bDone = false;

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterCustomerGroupCredit custGroupCredit = (TMasterCustomerGroupCredit) records.get(nIndex);
            TMasterCustomerGroups groupInfo = custGroupCredit.getGroup();
            String userCollectedBy = custGroupCredit.getCollectedBy().getUserFirstName();
            String userEnteredBy = custGroupCredit.getEnteredBy().getUserFirstName();

            String strPaymentType = "Not Paid";
            switch (custGroupCredit.getPaymentType()) {
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

            String strCreditOrDebit = "DEBIT";
            String strBgColor = "danger";
            if (custGroupCredit.getCreditOrDebit() == 1) {
                strCreditOrDebit = "Credit";
                strBgColor = "";
            }

            strResult += ("<tr class='" + strBgColor + "'><td align=\"right\">" +
                    "<a href=\"/masteradmin/groupmanage/ModifyCustomerGroupCredit.jsp?credit_id=" + custGroupCredit.getId() + "\">" + custGroupCredit.getId() + "</a>" +
                    "</td><td align=\"left\">" + groupInfo.getName() + "</td>" +
                    "<td align=\"left\">" + strPaymentType + "</td>" +
                    "<td align=\"left\">" + custGroupCredit.getPaymentDetails() + "</td>" +
                    "<td align=\"left\">" + custGroupCredit.getPaymentAmount() + "</td>" +
                    "<td align=\"left\">" + custGroupCredit.getPaymentDate() + "</td>" +
                    "<td align=\"left\">" + userCollectedBy + "</td>" +
                    "<td align=\"left\">" + userEnteredBy + "</td>" +
                    "<td align=\"left\">" + custGroupCredit.getEnteredTime() + "</td>" +
                    "<td align=\"left\">" + strCreditOrDebit + "</td>" +
                    "<td align=\"left\">" + custGroupCredit.getNotes() + "</td>" + "</tr>");

            fTotalAmountSoFar += custGroupCredit.getPaymentAmount();
            if (fTotalAmountSoFar > groupInfo.getCustomerGroupBalance() && bDone == false && nCustomerGroupID > 0) {
                bDone = true;
            }
        }

        strResult += "</table>";
        response.setContentType("text/html");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        String strResult = "No records found";
        response.setContentType("text/plain");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
