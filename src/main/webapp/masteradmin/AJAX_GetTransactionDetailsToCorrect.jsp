<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strTransactionID = request.getParameter("transaction_id");
    long nTransactionID = 0;
    if (strTransactionID != null && !strTransactionID.isEmpty())
        nTransactionID = Integer.parseInt(strTransactionID);

    response.setContentType("text/plain");
    if (nTransactionID <= 0) {
        response.getWriter().println("");
        return;
    }

    String strQuery = "from TCardInfo where Transaction_ID = " + nTransactionID + " and IsSold = 1";
    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List custTransactions = query.list();
        if (custTransactions.size() <= 0) {
            strQuery = "select * from t_history_card_info where Transaction_ID = " + nTransactionID + " and IsSold = 1";
            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TCardInfo.class);
            custTransactions = sqlQuery.list();

            if (custTransactions.size() <= 0) {
                response.getWriter().println("");
                return;
            }
        }

        String strResponse = "<table class='table table-bordered'>";
        strResponse += "<tr>" +
                "<td>Transaction Date</td>" +
                "<td>Transaction</td>" +
                "<td>Customer</td>" +
                "<td>Product</td>" +
                "<td>Face Value</td>" +
                "<td>Batch Number</td>" +
                "<td>Pin Number</td>" +
                "</tr>";

        for (int i = 0; i < custTransactions.size(); i++) {
            TCardInfo oneCard = (TCardInfo) custTransactions.get(i);
            TMasterProductinfo prodInfo = oneCard.getProduct();

            strQuery = "select * from t_transactions where Transaction_ID = " + nTransactionID;
            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TTransactions.class);
            List transList = sqlQuery.list();

            if (transList.size() <= 0) {
                strQuery = "select * from t_history_transactions where Transaction_ID = " + nTransactionID;
                sqlQuery = theSession.createSQLQuery(strQuery);
                sqlQuery.addEntity(TTransactions.class);
                transList = sqlQuery.list();
            }

            String strProductName = "";
            String strTransactionDate = "";
            String customer = "";
            Float fFaceValue = 0.0f;

            if (transList.size() > 0) {
                TTransactions theTrans = (TTransactions) transList.get(0);

                strProductName = prodInfo.getProductName();
                fFaceValue = prodInfo.getProductFaceValue();
                strTransactionDate = theTrans.getTransactionTime().toString();
                customer = theTrans.getCustomer().getCompanyName();
            }


            strResponse += "<tr>";
            strResponse += "<td>" + strTransactionDate + "</td>";
            strResponse += "<td>" + oneCard.getTransactionId() + "</td>";
            strResponse += "<td>" + customer + "</td>";
            strResponse += "<td>" + strProductName + "</td>";
            strResponse += "<td>" + fFaceValue + "</td>";
            strResponse += "<td>" + oneCard.getCardId() + "</td>";
            strResponse += "<td><input type='text' name='" + oneCard.getId() + "' value='" + oneCard.getCardPin() + "'></td>";
            strResponse += "</tr>";
        }

        strResponse += "<tr><td><input type='button' name='correct_button' class='btn' value='Correct' onClick='Correct()'></td></tr>";

        response.getWriter().println(strResponse);
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("");
    } finally {
        HibernateUtil.closeSession(theSession);
    }

%>