<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");
    String userAgent = request.getHeader("User-Agent");

    boolean bAutoPrint = true;
    if (userAgent.compareToIgnoreCase("CallingCardsApp") == 0)
        bAutoPrint = false;

    long nTransactionID = 0;
    Object objTransactionID = request.getSession().getAttribute("CurrentTransactionID");
    if (objTransactionID != null) {
        String strTransactionID = objTransactionID.toString();
        nTransactionID = Long.parseLong(strTransactionID);
    }

    if (nTransactionID <= 0) {
        String strTransactionID = request.getParameter("record_id");
        if (strTransactionID != null && !strTransactionID.isEmpty())
            nTransactionID = Long.parseLong(strTransactionID);

        if (nTransactionID <= 0) {
            strTransactionID = request.getParameter("print_transaction_id");
            if (strTransactionID != null && !strTransactionID.isEmpty())
                nTransactionID = Long.parseLong(strTransactionID);
        }

        if (nTransactionID <= 0) {
            response.sendRedirect("/customer/products");
        }
    }
    request.getSession().setAttribute("CurrentTransactionID", 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="stylesheet" href="/css/print.css" type="text/css" media="print"/>
    <STYLE TYPE='text/css'>
        P.pagebreakhere {
            page-break-before: always
        }

        td.font_style {
            font-family: "Verdana";
            font-weight: bolder;
            font-size: 14px;
        }
    </STYLE>
    <script language="javascript">
        function pausecomp(milsec) {
            milsec += new Date().getTime();
            while (new Date() < milsec) {
            }
            window.location.href = "/customer/products";
        }

        function PrintPage() {
            <%
                if (userAgent.contains("Chrome/"))
                {
            %>
            window.print();
            setTimeout("pausecomp(5000)", 5000);
            <%
                }
                else
                {
            %>
            window.location.href = "/customer/products";
            window.print();
            <%
                }
            %>
        }
        <%
        if (bAutoPrint)
        {
        %>
        window.onload = PrintPage;
        <%
        }
        %>
    </script>
    <title>Print Transaction</title>
</head>
<body>
<%
    String strQuery = "from TTransactions where Transaction_ID = " + nTransactionID + "  and Committed = 1 order by Sequence_ID";
    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();

        strQuery = "from TTransactions where Transaction_ID = " + nTransactionID + " and Committed = 1 order by Sequence_ID";
        Query query = theSession.createQuery(strQuery);
        List records = query.list();
        if (records.size() > 0) {
            TTransactions transactionRecord = (TTransactions) records.get(0);
            TMasterCustomerinfo custInfo = transactionRecord.getCustomer();
            List custUsers = custInfo.getCustomerUsers();

            boolean transactionBelongsToCustomer = false;
            Object users[] = custUsers.toArray();
            for (int k = 0; k < users.length; k++) {
                User theUser = ((TCustomerUsers) users[k]).getUser();
                if (theUser.getLogin().compareToIgnoreCase(request.getRemoteUser()) == 0)
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
                    if (!bAutoPrint)
                        strProductID = "<tr><td align=\"left\"><u><b>Product ID : " + prodInfo.getId() + "</b></u></td></tr>";

                    if (nIndex != 0)
                        response.getWriter().println("<P CLASS=\"pagebreakhere\"></P>");
                    String strPrintInfo = prodSaleInfo.getPrintInfo();
                    strPrintInfo = strPrintInfo.trim();

                    String strCardInfo = "<font size=\"3\" face=\"Verdana\">" + cardInfo.getCardId() + "</font>";
                    String strCardPin = "<font size=\"4\" face=\"Verdana\">" + cardInfo.getCardPin() + "</font>";
                    String strExpiryDate = "<font size=\"2\" face=\"Verdana\">" + batchInfo.getExpiryDate().toString() + "</font>";
                    String strProductAndValue = "<font size=\"4\" face=\"Verdana\"> " + prodInfo.getProductName() + "   " + prodInfo.getProductFaceValue() + "</font>";

                    strPrintInfo = strPrintInfo.replaceFirst("<<BATCH_OR_SERIAL_NUMBER>>", cardInfo.getCardId());
                    strPrintInfo = strPrintInfo.replaceFirst("<<BATCH_OR_SERIAL_NUMBER>", cardInfo.getCardId());
                    strPrintInfo = strPrintInfo.replaceFirst("<<CARD_PIN_NUMBER>>", strCardPin);
                    strPrintInfo = strPrintInfo.replaceFirst("<<EXPIRY_DATE>>", strExpiryDate);
                    strPrintInfo = strPrintInfo.trim();
%>
<table>
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
        <td class="font_style">
					<pre><font face="Verdana"><b>
                        <%=strPrintInfo%>
                    </b></font></pre>
        </td>
    </tr>
</table>
<%
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
<div id="nav">
    <%
        if (bAutoPrint) {
    %>
    <table width="100%">
        <tr>
            <td>
                <a href="/customer/products">Show Products</a>
            </td>
            <td>
                <input type="button" name="print_button" value="Print" onClick="javascript:PrintPage()"/>
            </td>
        </tr>
    </table>
    <%
        }
    %>
</div>
</body>
</html>