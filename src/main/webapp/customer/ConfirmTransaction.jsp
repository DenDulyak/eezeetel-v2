<%@ page import="com.eezeetel.customerapp.ProcessTransaction" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    long nTransactionID = 0;
    Object objTransactionID = request.getSession().getAttribute(
            "CurrentTransactionID");
    if (objTransactionID != null) {
        String strTransactionID = objTransactionID.toString();
        if (strTransactionID != null && strTransactionID.length() > 0)
            nTransactionID = (Long.parseLong(strTransactionID));
    }

    request.getSession().setAttribute("CurrentTransactionID", 0);

    if (nTransactionID > 0) {
        ProcessTransaction processTransaction = new ProcessTransaction();
        boolean bProcessed = false;
        processTransaction.confirm(nTransactionID);
        if (!bProcessed) {
            response.getWriter()
                    .printf("<font size=\"4\" color=red>Could not complete transaction</font>");
            return;
        }
    } else {
        response.getWriter()
                .printf("<font size=\"4\" color=red>No pending transactions to confirm.</font>");
        return;
    }
%>

<%
    String strQuery = "from TTransactions where Transaction_ID = "
            + nTransactionID
            + "  and Committed = 1 order by Sequence_ID";
    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();

        strQuery = "from TTransactions where Transaction_ID = "
                + nTransactionID
                + " and Committed = 1 order by Sequence_ID";
        Query query = theSession.createQuery(strQuery);
        List records = query.list();
        if (records.size() > 0) {
            TTransactions transactionRecord = (TTransactions) records.get(0);
            TMasterCustomerinfo custInfo = transactionRecord.getCustomer();
            List custUsers = custInfo.getCustomerUsers();
            boolean transactionBelongsToCustomer = false;
            Object users[] = custUsers.toArray();
            for (int k = 0; k < users.length; k++) {
                User theUser = ((TCustomerUsers) users[k])
                        .getUser();
                if (theUser.getLogin().compareToIgnoreCase(
                        request.getRemoteUser()) == 0)
                    transactionBelongsToCustomer = true;
            }

            if (transactionBelongsToCustomer) {
                strQuery = "from TCardInfo where IsSold = 1 and Transaction_ID = " + nTransactionID;
                query = theSession.createQuery(strQuery);
                List cards = query.list();

                for (int nIndex = 0; nIndex < cards.size(); nIndex++) {
                    TCardInfo cardInfo = (TCardInfo) cards.get(nIndex);
                    TBatchInformation batchInfo = cardInfo.getBatch();
                    TMasterProductsaleinfo prodSaleInfo = batchInfo.getProductsaleinfo();
                    TMasterProductinfo prodInfo = batchInfo.getProduct();
                    String strProductID = "";
                    boolean bAutoPrint = true;
                    if (!bAutoPrint)
                        strProductID = "<tr><td align=\"left\"><u><b>Product ID : "
                                + prodInfo.getId()
                                + "</b></u></td></tr>";

                    if (nIndex != 0)
                        response.getWriter().println(
                                "<P CLASS=\"pagebreakhere\"></P>");
                    String strPrintInfo = prodSaleInfo.getPrintInfo();
                    strPrintInfo = strPrintInfo.trim();

                    String strCardInfo = "<font size=\"3\" face=\"Verdana\">"
                            + cardInfo.getCardId() + "</font>";
                    String strCardPin = "<font size=\"4\" face=\"Verdana\">"
                            + cardInfo.getCardPin() + "</font>";
                    String strExpiryDate = "<font size=\"2\" face=\"Verdana\">"
                            + batchInfo.getExpiryDate().toString()
                            + "</font>";
                    String strProductAndValue = "<font size=\"4\" face=\"Verdana\"> "
                            + prodInfo.getProductName()
                            + "   "
                            + prodInfo.getProductFaceValue()
                            + "</font>";

                    strPrintInfo = strPrintInfo.replaceFirst(
                            "<<BATCH_OR_SERIAL_NUMBER>>",
                            cardInfo.getCardId());
                    strPrintInfo = strPrintInfo.replaceFirst(
                            "<<BATCH_OR_SERIAL_NUMBER>",
                            cardInfo.getCardId());
                    strPrintInfo = strPrintInfo.replaceFirst(
                            "<<CARD_PIN_NUMBER>>", strCardPin);
                    strPrintInfo = strPrintInfo.replaceFirst(
                            "<<EXPIRY_DATE>>", strExpiryDate);
                    strPrintInfo = strPrintInfo.trim();
%>
<a name="Print" class="productsButton" href="PrintTransaction.jsp?record_id=<%=nTransactionID%>">Print</a>
<table frame="box" style="border:solid 1px #000000">
    <tr>
        <td align="left"><b><%=custInfo.getCompanyName()%>
        </b></td>
    </tr>

    <tr>
        <td align="left"><b>Transaction Number : <%=nTransactionID%>
        </b></td>
    </tr>
    <tr>
        <td align="left"><b><%=transactionRecord.getTransactionTime()%>
        </b></td>
    </tr>
    <tr>
        <td align="left"><u><b><%=strProductAndValue%>
        </b></u></td>
    </tr>
    <%=strProductID%>
    <tr>
        <td class="print_style"><pre>
				<font face="Verdana"><b>
                    <%=strPrintInfo%>
                </b></font>
			</pre>
        </td>
    </tr>
</table>
<%
    }
%>
<%
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>


