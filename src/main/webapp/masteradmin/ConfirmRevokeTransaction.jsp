<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Transaction items revoked</title>
</head>
<body>
<%
    String strTransactionItems = request.getParameter("sequence_ids");
    StringTokenizer st = new StringTokenizer(strTransactionItems, ",");

    final float fTHEVAT = 1.2f;

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        while (st.hasMoreTokens()) {
            String token = st.nextToken();
            if (token.length() > 0) {
                long nSequenceID = Long.parseLong(token);

                boolean bFromHistory = false;
                String strQuery = "from TTransactions where Committed = 1 and Sequence_ID = " + nSequenceID;
                Query query = theSession.createQuery(strQuery);
                List theTransactionList = query.list();
                if (theTransactionList.size() <= 0) {
                    bFromHistory = true;
                    strQuery = "select * from t_history_transactions where Committed = 1 and Sequence_ID = " + nSequenceID;
                    SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                    sqlQuery.addEntity(TTransactions.class);
                    theTransactionList = sqlQuery.list();
                }

                if (theTransactionList.size() > 0) {
                    TTransactions theTransaction = (TTransactions) theTransactionList.get(0);
                    TMasterCustomerinfo custInfo = theTransaction.getCustomer();

                    // update batch

                    TBatchInformation batchInfo = theTransaction.getBatch();

                    strQuery = "from TCardInfo where Transaction_ID = " + theTransaction.getTransactionId() +
                            " and Batch_Sequence_ID = " + batchInfo.getSequenceId() + " and IsSold = 1";
                    query = theSession.createQuery(strQuery);
                    List cardInfoList = query.list();

                    if (cardInfoList.size() > 0) {
                        batchInfo.setAvailableQuantity(batchInfo.getAvailableQuantity() + theTransaction.getQuantity());
                        theSession.save(batchInfo);

                        for (int k = 0; k < cardInfoList.size(); k++) {
                            TCardInfo cardInfo = (TCardInfo) cardInfoList.get(k);
                            cardInfo.setIsSold(false);
                            cardInfo.setTransactionId(null);
                            theSession.save(cardInfo);

                            strQuery = "insert into t_revoked_transactions (Original_Sequence_ID, Original_Transaction_ID, " +
                                    " Card_Sequence_ID, Revoked_Date, Sold_Again_Status) values (" +
                                    nSequenceID + ", " + theTransaction.getTransactionId() + ", " + cardInfo.getId() +
                                    " , now(), 0)";

                            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                            sqlQuery.executeUpdate();
                        }

                        if (bFromHistory) {
                            strQuery = "update t_history_transactions set Committed = 3, Post_Processing_Stage = 0 where Sequence_ID = " + nSequenceID;
                            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                            sqlQuery.executeUpdate();
                        } else {
                            theTransaction.setCommitted((byte) 3);
                            theTransaction.setPostProcessingStage(false);
                        }
                    }
                }
            }
        }

        theSession.getTransaction().commit();
        response.sendRedirect("RevokeTransactionManually.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        if (theSession != null) {
            theSession.getTransaction().rollback();
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to revoke transaction items.</FONT></H4>" +
                    "<A HREF=\"RevokeTransactionManually.jsp\">Revoke Transactions</A></BODY></HTML>";

            response.getWriter().println(strError);
        }
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</body>
<br>
<a href=MasterInformation.jsp> Go to Main </a>
</html>