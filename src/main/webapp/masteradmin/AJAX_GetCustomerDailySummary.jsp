<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    if (!request.isUserInRole("Employee_Master_Admin")) {
        response.getWriter().println("Permission Denied");
        return;
    }

    String strCustomerID = request.getParameter("customer_id");
    int nCustomerID = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerID = Integer.parseInt(strCustomerID);

    response.setContentType("text/plain");
    if (nCustomerID <= 0) {
        response.getWriter().println("");
        return;
    }

    String strQuery = "SELECT t2.Transaction_ID as Transaction_ID,  Transaction_Time, Balance_Before_Transaction, " +
            "Balance_After_Transaction, t1.Customer_Balance " +
            " FROM t_master_customerinfo t1, t_transactions t2, t_transaction_balance t3 " +
            " where t1.Customer_ID = t2.Customer_ID and t2.Customer_ID = " + nCustomerID +
            " and t2.Transaction_ID = t3.Transaction_ID and (t2.Committed = 1 OR t2.Committed = 3) " +
            " and t2.Transaction_Time < now() and t2.Transaction_Time > CAST((concat(CURDATE(), ' 00:00:00')) as DATETIME) " +
            "group by Transaction_ID";

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        SQLQuery query = theSession.createSQLQuery(strQuery);
        query.addScalar("Transaction_ID", new LongType());
        query.addScalar("Transaction_Time", new TimeType());
        query.addScalar("Balance_Before_Transaction", new FloatType());
        query.addScalar("Balance_After_Transaction", new FloatType());
        query.addScalar("Customer_Balance", new FloatType());

        List custTransactions = query.list();
        if (custTransactions.size() <= 0) {
            response.getWriter().println("");
            return;
        }
        String strTransactionIDs = "";
        Float fCustomerBalance = 0.0f;
        for (int i = 0; i < custTransactions.size(); i++) {
            if (i != 0)
                strTransactionIDs += ", ";
            Object[] oneRecord = (Object[]) custTransactions.get(i);
            String transactionID = (String) oneRecord[0].toString();
            fCustomerBalance = (Float) oneRecord[4];
            strTransactionIDs += transactionID;
        }

        String strQuery1 = "SELECT t1.Product_Name, t2.Transaction_ID,  t2.Unit_Purchase_Price as Transaction_Price, " +
                " t2.Committed, t3.Unit_Purchase_Price, t2.Quantity, t2.Secondary_Transaction_Price from t_master_productinfo t1, t_transactions t2, " +
                "t_batch_information t3 where t1.Product_ID = t2.Product_ID and t2.Batch_Sequence_ID = t3.SequenceID " +
                " and t2.Transaction_ID in (" + strTransactionIDs + ")";

        query = theSession.createSQLQuery(strQuery1);
        query.addScalar("Product_Name", new StringType());
        query.addScalar("Transaction_ID", new LongType());
        query.addScalar("Transaction_Price", new FloatType());
        query.addScalar("Committed", new ShortType());
        query.addScalar("Unit_Purchase_Price", new FloatType());
        query.addScalar("Quantity", new IntegerType());
        query.addScalar("Secondary_Transaction_Price", new FloatType());

        List prodTransactions = query.list();
        if (prodTransactions.size() <= 0) {
            response.getWriter().println("");
            return;
        }


        // summary variables

        int nTotalCommittedTransactions = 0;
        int nTotalCards = 0;
        Float fTotalTransactionAmount = 0.0f;
        Float fTotalTotalCostPrice = 0.0f;
        Float fTotalAgentProfit = 0.0f;
        Float fTotalProfit = 0.0f;
        int nTotalRevokedTransactions = 0;

        DecimalFormat twoPointsAfterDecimal = new DecimalFormat("0.00");

        String strResponse = "<table border=1 width=\"100%\">";
        strResponse += "<tr><td>Transaction</td><td>Transaction Time</td><td>Balance Before Transaction</td>";
        strResponse += "<td>Balance After Transaction</td><td>Product Name</td><td>Quantity</td>";
        strResponse += "<td>Transaction Price</td><td>Agent Profit</td><td>Profit</td><td>Commit Status</td></tr>";

        for (int i = 0; i < custTransactions.size(); i++) {
            Object[] oneRecord = (Object[]) custTransactions.get(i);
            Long transactionID = (Long) oneRecord[0];
            Date dtTransaction = (Date) oneRecord[1];
            Float fBalanceBefore = (Float) oneRecord[2];
            Float fBalanceAfter = (Float) oneRecord[3];

            strResponse += "<tr>";
            strResponse += "<td>" + transactionID + "</td>";
            strResponse += "<td>" + dtTransaction + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fBalanceBefore) + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fBalanceAfter) + "</td>";

            boolean bFirstRecord = true;
            for (int j = 0; j < prodTransactions.size(); j++) {
                Object[] oneProductRecord = (Object[]) prodTransactions.get(j);

                String strProductName = (String) oneProductRecord[0];
                Long nTransactionID = (Long) oneProductRecord[1];
                Float fTransactionPrice = (Float) oneProductRecord[2];
                Short nCommitted = (Short) oneProductRecord[3];
                Float fUnitPurchasePrice = (Float) oneProductRecord[4];
                int nQuantity = (Integer) oneProductRecord[5];
                fUnitPurchasePrice *= nQuantity;
                Float fSecondaryPurchasePrice = (Float) oneProductRecord[6];

                Float fAgentProfit = fTransactionPrice - fSecondaryPurchasePrice;
                Float fProfit = fSecondaryPurchasePrice - fUnitPurchasePrice;

                String strAgentProfit = twoPointsAfterDecimal.format((double) (fAgentProfit));
                String strProfit = twoPointsAfterDecimal.format((double) (fProfit));

                if (nTransactionID.longValue() == transactionID.longValue()) {
                    String strCommitStatus = "Committed";
                    if (nCommitted == 0)
                        strCommitStatus = "Cancelled/Revoked";
                    if (nCommitted == 2)
                        strCommitStatus = "Pending";
                    if (nCommitted == 3) {
                        strCommitStatus = "Manually Revoked";
                        nTotalRevokedTransactions++;
                    }

                    if (nCommitted == 1) {
                        nTotalCards += nQuantity;
                        fTotalTransactionAmount += fTransactionPrice;
                        fTotalTotalCostPrice += fUnitPurchasePrice;
                        fTotalAgentProfit += fAgentProfit;
                        fTotalProfit += fProfit;
                    }

                    if (!bFirstRecord)
                        strResponse += "<tr><td> </td><td> </td><td> </td><td> </td>";
                    else if (nCommitted == 1)
                        nTotalCommittedTransactions++;

                    bFirstRecord = false;
                    strResponse += "<td>" + strProductName + "</td>";
                    strResponse += "<td>" + nQuantity + "</td>";
                    strResponse += "<td>" + twoPointsAfterDecimal.format((double) fTransactionPrice) + "</td>";
                    strResponse += "<td>" + strAgentProfit + "</td>";
                    strResponse += "<td>" + strProfit + "</td>";
                    strResponse += "<td>" + strCommitStatus + "</td>";
                    strResponse += "</tr>";
                }
            }
        }

        // Mobile topup transctions

        int nTotalMobileTopups = 0;
        int nMobleToupTotalRevokedTransactions = 0;

        strQuery = "select t1.Transaction_ID, t1.Transaction_Time, t1.Retail_Price, t1.Cost_To_Customer, t1.Cost_To_Agent, " +
                " t1.Cost_To_EezeeTel, t1.Transaction_Status, t2.Balance_Before_Transaction, " +
                " t2.Balance_After_Transaction" +
                " FROM t_transferto_transactions t1 left outer join t_transaction_balance t2 " +
                " on (t1.Transaction_ID = t2.Transaction_ID) where t1.Customer_ID = " + nCustomerID +
                " and t1.Transaction_Time < now() and t1.Transaction_Time > CAST((concat(CURDATE(), ' 00:00:00')) as DATETIME) " +
                " and (t1.Transaction_Status = 1) ";

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("Transaction_ID", new LongType());
        sqlQuery.addScalar("Transaction_Time", new TimestampType());
        sqlQuery.addScalar("Retail_Price", new FloatType());
        sqlQuery.addScalar("Cost_To_Customer", new FloatType());
        sqlQuery.addScalar("Cost_To_Agent", new FloatType());
        sqlQuery.addScalar("Cost_To_EezeeTel", new FloatType());
        sqlQuery.addScalar("Transaction_Status", new IntegerType());
        sqlQuery.addScalar("Balance_Before_Transaction", new FloatType());
        sqlQuery.addScalar("Balance_After_Transaction", new FloatType());

        custTransactions = sqlQuery.list();

        Long nPrevTransactionID = 0L;
        Float fMobileTotalAmount = 0.0f;
        Float fMobileTotalAgentProfit = 0.0f;
        Float fMobileTotalEezeeTelProfit = 0.0f;

        for (int i = 0; i < custTransactions.size(); i++) {
            Object[] theRecord = (Object[]) custTransactions.get(i);
            if (theRecord.length <= 0) continue;

            String strProductName = "Mobile Topup";
            Integer nQuantity = 1;

            Long nTransactionID = (Long) theRecord[0];
            Date dtTransaction = (Date) theRecord[1];
            Float fProbableSalePrice = (Float) theRecord[2];
            Float fTransactionPrice = (Float) theRecord[3];
            Float fAgentPrice = (Float) theRecord[4];
            Float fEezeeTelPrice = (Float) theRecord[5];
            Integer nCommited = (Integer) theRecord[6];
            String strCommitStatus = "Committed";
            Float fBalanceBefore = (Float) theRecord[7];
            Float fBalanceAfter = (Float) theRecord[8];

            Float fAgentProfit = fTransactionPrice - fAgentPrice;
            Float fProfit = fAgentPrice - fEezeeTelPrice;

            String strAgentProfit = twoPointsAfterDecimal.format((double) (fAgentProfit));
            String strProfit = twoPointsAfterDecimal.format((double) (fProfit));

            strProductName = "Mobile Topup";
            nQuantity = 1;

            switch (nCommited) {
                case 0:
                    strCommitStatus = "Cancelled";
                    break;
                case 2:
                    strCommitStatus = "Pending";
                    break;
                case 1: {
                    strCommitStatus = "Committed";
                    nTotalMobileTopups += nQuantity;
                    fMobileTotalAmount += fTransactionPrice;
                    fMobileTotalAgentProfit += fAgentProfit;
                    fMobileTotalEezeeTelProfit += fProfit;
                    break;
                }
                case 3: {
                    strCommitStatus = "Revoked";
                    nMobleToupTotalRevokedTransactions++;
                    break;
                }
            }

            strResponse += "<tr bgcolor=\"yellow\">";
            if (nPrevTransactionID.longValue() != nTransactionID.longValue()) {
                if (nCommited == 1)
                    nTotalCommittedTransactions++;

                nPrevTransactionID = nTransactionID;
                strResponse += "<td>" + nTransactionID + "</td>";
                strResponse += "<td>" + dtTransaction + "</td>";
                strResponse += "<td>" + twoPointsAfterDecimal.format((double) fBalanceBefore) + "</td>";
                strResponse += "<td>" + twoPointsAfterDecimal.format((double) fBalanceAfter) + "</td>";
            } else
                strResponse += "<td colspan=4> </td>";

            strResponse += "<td>" + strProductName + "</td>";
            strResponse += "<td>" + nQuantity + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fTransactionPrice) + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fAgentProfit) + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fProfit) + "</td>";
            strResponse += "<td>" + strCommitStatus + "</td>";
            strResponse += "</tr>";
        }

        strResponse += "<tr><td><a href=MasterInformation.jsp> Go to Main </a></td></tr>";
        strResponse += "</table>";

        String strFirstPortion = "<table border=1 width=\"100%\">";
        strFirstPortion += "<tr>";
        strFirstPortion += "<td><font color=\"red\">Customer Balance</font></td>";
        strFirstPortion += "<td><font color=\"green\">Total Committed Transactions</font></td>";
        strFirstPortion += "<td><font color=\"green\">Total Cards</font></td>";
        strFirstPortion += "<td><font color=\"blue\">Total Transaction Amount</font></td>";
        strFirstPortion += "<td><font color=\"blue\">Total Transaction Cost Amount</font></td>";
        strFirstPortion += "<td><font color=\"blue\">Total Agent Profit</font></td>";
        strFirstPortion += "<td><font color=\"blue\"><b>Total Transaction Profit</b></font></td>";
        strFirstPortion += "<td><font color=\"red\">Total Revoked Sub Transactions</font></td>";
        strFirstPortion += "</tr>";

        strFirstPortion += "<tr>";
        strFirstPortion += "<td><font color=red>" + fCustomerBalance + "</font></td>";
        strFirstPortion += "<td><font color=\"green\">" + nTotalCommittedTransactions + "</font></td>";
        strFirstPortion += "<td><font color=\"green\">" + nTotalCards + "</font></td>";
        strFirstPortion += "<td><font color=\"blue\">" + twoPointsAfterDecimal.format((double) fTotalTransactionAmount) + "</font></td>";
        strFirstPortion += "<td><font color=\"blue\">" + twoPointsAfterDecimal.format((double) fTotalTotalCostPrice) + "</font></td>";
        strFirstPortion += "<td><font color=\"blue\">" + twoPointsAfterDecimal.format((double) fTotalAgentProfit) + "</font></td>";
        strFirstPortion += "<td><font color=\"blue\"><b>" + twoPointsAfterDecimal.format((double) fTotalProfit) + "</b></font></td>";
        strFirstPortion += "<td><font color=\"red\">" + nTotalRevokedTransactions + "</font></td>";
        strFirstPortion += "</tr>";
        strFirstPortion += "</table><br><br>";

        strFirstPortion += strResponse;

        response.getWriter().println(strFirstPortion);
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("");
    } finally {
        HibernateUtil.closeSession(theSession);
    }

%>