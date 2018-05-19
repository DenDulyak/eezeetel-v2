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

    String strQuery = "from TTransactions where Transaction_ID = " + nTransactionID + " and Committed = 1";

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List custTransactions = query.list();

        if (custTransactions.size() <= 0) {
            strQuery = "select * from t_history_transactions where Transaction_ID = " + nTransactionID +
                    " and Committed = 1";

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TTransactions.class);
            custTransactions = sqlQuery.list();
        }

        if (custTransactions.size() <= 0) {
            response.getWriter().println("");
            return;
        }

        String strResponse = "<table border=1>";
        strResponse += "<tr><td>Customer</td><td>Transaction</td><td>Transaction Time</td>";
        strResponse += "<td>Product Name</td><td>Customer Price</td><td>Agent Price</td><td>Revoke?</td></tr>";

        for (int i = 0; i < custTransactions.size(); i++) {
            TTransactions oneTransaction = (TTransactions) custTransactions.get(i);
            TMasterProductinfo oneProdroduct = oneTransaction.getProduct();
            TMasterCustomerinfo oneCustomer = oneTransaction.getCustomer();

            String strTransactionName = "sequenceid_" + oneTransaction.getId();

            strResponse += "<tr>";
            strResponse += "<td>" + oneCustomer.getCompanyName() + "</td>";
            strResponse += "<td>" + nTransactionID + "</td>";
            strResponse += "<td>" + oneTransaction.getTransactionTime() + "</td>";
            strResponse += "<td>" + oneProdroduct.getProductName() + "</td>";
            strResponse += "<td>" + oneTransaction.getUnitPurchasePrice() + "</td>";
            strResponse += "<td>" + oneTransaction.getSecondaryTransactionPrice() + "</td>";
            strResponse += "<td><input type=\"checkbox\" name=\"" + strTransactionName + "\" value=\"" + oneTransaction.getId() + "\"></td>";
            strResponse += "</tr>";
        }

        strResponse += "<tr><td><input type=\"button\" name=\"revoke_button\" value=\"Revoke\" onClick=\"Revoke()\"></td></tr>";

        response.getWriter().println(strResponse);
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("");
    } finally {
        HibernateUtil.closeSession(theSession);
    }

%>