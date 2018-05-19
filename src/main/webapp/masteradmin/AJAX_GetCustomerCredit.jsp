<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strCustomerID = request.getParameter("customer_id");
    int nCustomerID = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerID = Integer.parseInt(strCustomerID);

    String strStatus = request.getParameter("credit_status");
    int nStatus = 0;
    if (strStatus != null && !strStatus.isEmpty())
        nStatus = Integer.parseInt(strStatus);

    String strQuery = "from TMasterCustomerCredit where Entered_Time > '2011-01-01 00:00:00'";
    if (nCustomerID > 0)
        strQuery += " and Customer_ID = " + nCustomerID;

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

        String strResult = "<table border=\"1\" width=\"100%\"> <tr bgcolor=\"#99CCFF\">" +
                "<td>  </td> <td> <h5>Customer</h5> </td> <td> <h5>Payment Type</h5> </td>" +
                "<td> <h5>Payment Details</h5> </td><td> <h5>Payment Amount</h5> </td>" +
                "<td> <h5>Payment Received Date</h5> </td> 	<td> <h5>Collected By</h5> </td>" +
                "<td> <h5>Entered By</h5> </td> <td> <h5>Topup Date</h5> </td>" +
                "<td> <h5>Credit OR Debit</h5> </td>" +
                "<td> <h5>Notes</h5> </td></tr>";

        float fTotalAmountSoFar = 0.0f;
        boolean bDone = false;

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterCustomerCredit custCredit = (TMasterCustomerCredit) records.get(nIndex);
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custCredit.getCustomer();
            User userCollectedBy = custCredit.getCollectedBy();
            User userEnteredBy = custCredit.getEnteredBy();

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

            String strCreditOrDebit = "DEBIT";
            String strBgColor = "Red";
            if (custCredit.getCreditOrDebit() == 1) {
                strCreditOrDebit = "Credit";
                strBgColor = "";
            }

            strResult += ("<tr bgcolor=\"" + strBgColor + "\"><td bgcolor=\"yellow\" align=\"right\">" +
                    "<a href=\"/masteradmin/ModifyCustomerCredit.jsp?credit_id=" + custCredit.getId() + "\">" + custCredit.getId() + "</a>" +
						/*"<input type=\"radio\" name=\"record_id\" value=\"" + custCredit.getId() + "\">" +*/
                    "</td>	<td align=\"left\">" + custInfo.getCompanyName() + "</td>" +
                    "<td align=\"left\">" + strPaymentType + "</td>" +
                    "<td align=\"left\">" + custCredit.getPaymentDetails() + "</td>" +
                    "<td align=\"left\">" + custCredit.getPaymentAmount() + "</td>" +
                    "<td align=\"left\">" + custCredit.getPaymentDate() + "</td>" +
                    "<td align=\"left\">" + userCollectedBy.getUserFirstName() + "</td>" +
                    "<td align=\"left\">" + userEnteredBy.getUserFirstName() + "</td>" +
                    "<td align=\"left\">" + custCredit.getEnteredTime() + "</td>" +
                    "<td align=\"left\">" + strCreditOrDebit + "</td>" +
                    "<td align=\"left\">" + custCredit.getNotes() + "</td>" + "</tr>");

            fTotalAmountSoFar += custCredit.getPaymentAmount();
            if (fTotalAmountSoFar > custInfo.getCustomerBalance() && bDone == false && nCustomerID > 0) {
                //strResult += "<tr bgcolor=blue><td>Below transactions are clear</td></tr>";
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
