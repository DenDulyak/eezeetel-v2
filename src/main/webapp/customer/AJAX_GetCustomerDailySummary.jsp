<%@ page import="com.eezeetel.enums.OrderStatus" %>
<%@ page import="com.eezeetel.service.MobileUnlockingOrderService" %>
<%@ page import="com.eezeetel.service.MobitopupTransactionService" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eezeetel.service.PinlessTransactionService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/imports.jsp" %>

<%
    String strUserID = request.getParameter("the_user_id");
    if (strUserID == null || strUserID.isEmpty()) {
        response.setContentType("text/plain");
        response.getWriter().println("");
        return;
    }

    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    MobitopupTransactionService mobitopupTransactionService = context.getBean(MobitopupTransactionService.class);
    MobileUnlockingOrderService orderService = context.getBean(MobileUnlockingOrderService.class);
    PinlessTransactionService pinlessTransactionService = context.getBean(PinlessTransactionService.class);

    String from = request.getParameter("from") + " 00:00:00";
    String to = request.getParameter("to") + " 23:59:59";
    SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
    SimpleDateFormat dtf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    int nCustomer_ID = 0;
    float fCustomerBalance = 0f;
    Session theSession = null;

    try {
        Date dateFrom = format.parse(from);
        Date dateTo = format.parse(to);
        String durationBegin = dtf.format(dateFrom);
        String durationEnd = dtf.format(dateTo);

        theSession = HibernateUtil.openSession();
        String strQuery2 = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";
        Query query2 = theSession.createQuery(strQuery2);
        List customer = query2.list();
        if (customer.size() > 0) {
            TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
            TMasterCustomerinfo theCustomer = custUsers.getCustomer();
            User theUser = custUsers.getUser();
            if (theCustomer.getActive() && theUser.getUserActiveStatus()) {
                nCustomer_ID = theCustomer.getId();
                fCustomerBalance = theCustomer.getCustomerBalance();
            }
        }

        if (nCustomer_ID == 0) {
            response.setContentType("text/plain");
            response.getWriter().println("");
            return;
        }

        List<Map.Entry<Date,String>> result = new ArrayList<Map.Entry<Date,String>>();

        boolean bFromHistory = false;
        String specificUser = "''";
        if (strUserID.compareToIgnoreCase("All") != 0)
            specificUser = "'" + strUserID + "'";

        String strQuery = "call SP_Customer_Daily_Summary(" + nCustomer_ID +
                ", '" + durationBegin + "', '" + durationEnd + "', " +
                specificUser + ")";

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("IsHistory", new IntegerType());
        sqlQuery.addScalar("Transaction_ID", new LongType());
        sqlQuery.addScalar("Transaction_Time", new TimestampType());
        sqlQuery.addScalar("Balance_Before", new FloatType());
        sqlQuery.addScalar("Balance_After", new FloatType());
        sqlQuery.addScalar("Product_ID", new IntegerType());
        sqlQuery.addScalar("Product_Name", new StringType());
        sqlQuery.addScalar("Quantity", new IntegerType());
        sqlQuery.addScalar("Batch_ID", new IntegerType());
        sqlQuery.addScalar("Probable_Sale_Price", new FloatType());
        sqlQuery.addScalar("Transaction_Amount", new FloatType());
        sqlQuery.addScalar("Second_Amount", new FloatType());
        sqlQuery.addScalar("commit_status", new IntegerType());
        sqlQuery.addScalar("face_value", new FloatType());
        sqlQuery.addScalar("Group_Amount", new FloatType());

        List custTransactions = sqlQuery.list();

        // summary variables

        int nTotalCommittedTransactions = 0;
        int nTotalCards = 0;
        Float fTotalRetailPriceValue = 0.0f;
        Float fTotalTransactionAmount = 0.0f;
        Float fTotalCommissionAmount = 0.0f;
        int nTotalRevokedTransactions = 0;

        DecimalFormat twoPointsAfterDecimal = new DecimalFormat("0.00");

        String strResponse = "<table class='table-sm table-striped table-bordered'>";
        strResponse += "<thead>" +
                "<tr>" +
                "<th>Transaction Number</th>" +
                "<th>Transaction Time</th>" +
                "<th>Balance Before</th>" +
                "<th>Balance After</th>" +
                "<th>Product Name</th>" +
                "<th>Quantity</th>" +
                "<th>Retail Price</th>" +
                "<th>Transaction Price</th>" +
                "<th>Commission</th>" +
                "<th>Transaction Status</th>" +
                "</tr>" +
                "</thead>";

        Long nPrevTransactionID = 0L;

        try {
            for (int i = 0; i < custTransactions.size(); i++) {
                Object[] theRecord = (Object[]) custTransactions.get(i);
                if (theRecord.length <= 0) continue;

                Long nTransactionID = (Long) theRecord[1];
                Date dtTransaction = (Date) theRecord[2];
                Float fBalanceBefore = (Float) theRecord[3];
                Float fBalanceAfter = (Float) theRecord[4];
                Integer nProductID = (Integer) theRecord[5];
                String strProductName = (String) theRecord[6];
                Integer nQuantity = (Integer) theRecord[7];
                Integer nBatchID = (Integer) theRecord[8];
                Float fProbableSalePrice = (Float) theRecord[9];
                Float fTransactionPrice = (Float) theRecord[10];
                Float fSecondTransactionAmount = (Float) theRecord[11];
                Integer nCommited = (Integer) theRecord[12];
                Float fFaceValue = (Float) theRecord[13];
                String strCommitStatus = "Committed";

                fProbableSalePrice = fProbableSalePrice * nQuantity;
                Float fCommission = fProbableSalePrice - fTransactionPrice;

                switch (nCommited) {
                    case 0:
                        strCommitStatus = "Cancelled";
                        break;
                    case 2:
                        strCommitStatus = "Pending";
                        break;
                    case 1: {
                        strCommitStatus = "Committed";
                        nTotalCards += nQuantity;
                        fTotalTransactionAmount += fTransactionPrice;
                        fTotalRetailPriceValue += fProbableSalePrice;
                        fTotalCommissionAmount += fCommission;
                        break;
                    }
                    case 3: {
                        strCommitStatus = "Revoked";
                        nTotalRevokedTransactions++;
                        break;
                    }
                }

                String row = "<tr>";
                if (nPrevTransactionID.longValue() != nTransactionID.longValue()) {
                    if (nCommited == 1)
                        nTotalCommittedTransactions++;

                    nPrevTransactionID = nTransactionID;
                    row += "<td>" + nTransactionID + "</td>";
                    row += "<td>" + dtf.format(dtTransaction) + "</td>";
                    row += "<td>" + twoPointsAfterDecimal.format((double) fBalanceBefore) + "</td>";
                    row += "<td>" + twoPointsAfterDecimal.format((double) fBalanceAfter) + "</td>";
                } else
                    row += "<td colspan=4> </td>";

                row += "<td>" + strProductName + "-" + twoPointsAfterDecimal.format((double) fFaceValue) + "</td>";
                row += "<td>" + nQuantity + "</td>";
                row += "<td>" + twoPointsAfterDecimal.format((double) fProbableSalePrice) + "</td>";
                row += "<td>" + twoPointsAfterDecimal.format((double) fTransactionPrice) + "</td>";
                row += "<td>" + twoPointsAfterDecimal.format((double) fCommission) + "</td>";
                row += "<td>" + strCommitStatus + "</td>";
                row += "</tr>";

                result.add(new AbstractMap.SimpleEntry<Date, String>(dtTransaction, row));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Mobile topup transctions

        int nTotalMobileTopups = 0;
        int nMobleToupTotalRevokedTransactions = 0;

        strQuery = "call SP_Customer_Daily_AIT_Summary(" + nCustomer_ID +
                ", '" + durationBegin + "', '" + durationEnd + "', " +
                specificUser + ")";

        sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("IsHistory", new IntegerType());
        sqlQuery.addScalar("Transaction_ID", new LongType());
        sqlQuery.addScalar("Transaction_Time", new TimestampType());
        sqlQuery.addScalar("Balance_Before", new FloatType());
        sqlQuery.addScalar("Balance_After", new FloatType());
        sqlQuery.addScalar("Probable_Sale_Price", new FloatType());
        sqlQuery.addScalar("Transaction_Amount", new FloatType());
        sqlQuery.addScalar("commit_status", new IntegerType());
        sqlQuery.addScalar("Agent_Amount", new FloatType());
        sqlQuery.addScalar("Group_Amount", new FloatType());

        custTransactions = sqlQuery.list();

        nPrevTransactionID = 0L;
        for (int i = 0; i < custTransactions.size(); i++) {
            Object[] theRecord = (Object[]) custTransactions.get(i);
            if (theRecord.length <= 0) continue;

            String strProductName = "Mobile Topup";
            Integer nQuantity = 1;

            Long nTransactionID = (Long) theRecord[1];
            Date dtTransaction = (Date) theRecord[2];
            Float fBalanceBefore = (Float) theRecord[3];
            Float fBalanceAfter = (Float) theRecord[4];

            Float fProbableSalePrice = (Float) theRecord[5];
            Float fTransactionPrice = (Float) theRecord[6];
            Integer nCommited = (Integer) theRecord[7];
            String strCommitStatus = "Committed";

            Float fCommission = fProbableSalePrice - fTransactionPrice;

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
                    fTotalTransactionAmount += fTransactionPrice;
                    fTotalRetailPriceValue += fProbableSalePrice;
                    fTotalCommissionAmount += fCommission;
                    break;
                }
                case 3: {
                    strCommitStatus = "Revoked";
                    nMobleToupTotalRevokedTransactions++;
                    break;
                }
            }

            String row = "<tr class='info'>";
            if (nPrevTransactionID.longValue() != nTransactionID.longValue()) {
                if (nCommited == 1)
                    nTotalCommittedTransactions++;

                nPrevTransactionID = nTransactionID;
                strResponse += "<td>" + nTransactionID + "</td>";
                strResponse += "<td>" + dtf.format(dtTransaction) + "</td>";
                strResponse += "<td>" + twoPointsAfterDecimal.format((double) fBalanceBefore) + "</td>";
                strResponse += "<td>" + twoPointsAfterDecimal.format((double) fBalanceAfter) + "</td>";
            } else
                strResponse += "<td colspan=4> </td>";

            strResponse += "<td>" + strProductName + "</td>";
            strResponse += "<td>" + nQuantity + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fProbableSalePrice) + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fTransactionPrice) + "</td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fCommission) + "</td>";
            strResponse += "<td>" + strCommitStatus + "</td>";
            strResponse += "</tr>";

            result.add(new AbstractMap.SimpleEntry<Date, String>(dtTransaction, row));
        }

        // mobitopup transactions
        List<MobitopupTransaction> mobitopupTransactions = mobitopupTransactionService.findByUserAndTransactionTimeBetween(new User(strUserID), dateFrom, dateTo);
        for (MobitopupTransaction transaction : mobitopupTransactions) {
            String row = "<tr class='info'>";
            row += "<td>" + transaction.getTransactionId() + "</td>";
            row += "<td>" + dtf.format(transaction.getTransactionTime()) + "</td>";
            if (transaction.getTransactionBalance() != null) {
                row += "<td>" + transaction.getTransactionBalance().getBalanceBeforeTransaction() + "</td>";
                row += "<td>" + transaction.getTransactionBalance().getBalanceAfterTransaction() + "</td>";
            } else {
                row += "<td></td>";
                row += "<td></td>";
            }
            row += "<td>Mobile Topup</td>";
            row += "<td>1</td>";
            row += "<td>" + transaction.getRetailPrice() + "</td>";
            row += "<td>" + transaction.getRetailPrice().subtract(transaction.getCustomerCommission()) + "</td>";
            row += "<td>" + transaction.getCustomerCommission() + "</td>";
            row += "<td>Committed</td>";
            row += "</tr>";

            result.add(new AbstractMap.SimpleEntry<Date, String>(transaction.getTransactionTime(), row));

            nTotalMobileTopups++;
            nTotalCommittedTransactions++;
            fTotalRetailPriceValue += transaction.getRetailPrice().floatValue();
            fTotalTransactionAmount += transaction.getRetailPrice().subtract(transaction.getCustomerCommission()).floatValue();
            fTotalCommissionAmount += transaction.getCustomerCommission().floatValue();
        }

        // pinless transactions
        Integer totalPinless = 0;
        Integer revokedPinless = 0;
        List<PinlessTransaction> pinlessTransactions = pinlessTransactionService.findByUserAndTransactionTimeBetween(new User(strUserID), dateFrom, dateTo);
        for (PinlessTransaction transaction : pinlessTransactions) {
            String row = "<tr class='info'>";
            row += "<td>" + transaction.getTransactionId() + "</td>";
            row += "<td>" + dtf.format(transaction.getTransactionTime()) + "</td>";
            if (transaction.getTransactionBalance() != null) {
                row += "<td>" + transaction.getTransactionBalance().getBalanceBeforeTransaction() + "</td>";
                row += "<td>" + transaction.getTransactionBalance().getBalanceAfterTransaction() + "</td>";
            } else {
                row += "<td></td>";
                row += "<td></td>";
            }
            row += "<td>Pinless</td>";
            row += "<td>1</td>";
            row += "<td>" + transaction.getRetailPrice() + "</td>";
            row += "<td>" + transaction.getRetailPrice().subtract(transaction.getCustomerCommission()) + "</td>";
            row += "<td>" + transaction.getCustomerCommission() + "</td>";
            row += "<td>Committed</td>";
            row += "</tr>";

            result.add(new AbstractMap.SimpleEntry<Date, String>(transaction.getTransactionTime(), row));

            totalPinless++;
            nTotalCommittedTransactions++;
            fTotalRetailPriceValue += transaction.getRetailPrice().floatValue();
            fTotalTransactionAmount += transaction.getRetailPrice().subtract(transaction.getCustomerCommission()).floatValue();
            fTotalCommissionAmount += transaction.getCustomerCommission().floatValue();
        }

        // SIM transctions

        int nTotalSIMTransactions = 0;

        strQuery = "call SP_Customer_Daily_SIM_Summary(" + nCustomer_ID +
                ", '" + durationBegin + "', '" + durationEnd + "', " +
                specificUser + ")";

        sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("IsHistory", new IntegerType());
        sqlQuery.addScalar("Transaction_ID", new LongType());
        sqlQuery.addScalar("Transaction_Time", new TimestampType());
        sqlQuery.addScalar("total_topups", new IntegerType());
        sqlQuery.addScalar("Customer_Commission", new FloatType());
        sqlQuery.addScalar("Agent_Commission", new FloatType());
        sqlQuery.addScalar("Group_Commission", new FloatType());
        sqlQuery.addScalar("Sim_Sequence_ID", new IntegerType());
        sqlQuery.addScalar("Product_Name", new StringType());

        custTransactions = sqlQuery.list();
        int nTotalSimTrans = custTransactions.size();

        for (int i = 0; i < nTotalSimTrans; i++) {
            Object[] theRecord = (Object[]) custTransactions.get(i);
            if (theRecord.length <= 0) continue;

            String strProductName = "SIM Transaction";
            Integer nQuantity = 1;

            Long nTransactionID = (Long) theRecord[1];
            Date dtTransaction = (Date) theRecord[2];
            Integer nTopups = (Integer) theRecord[3];
            Float fCommission = theRecord[4] == null ? 0f : (Float) theRecord[4];
            strProductName = (String) theRecord[8];

            strResponse += "<tr bgcolor='#C0C0C0'>";
            nTotalCommittedTransactions++;
            fTotalCommissionAmount += fCommission;

            strResponse += "<td>" + nTransactionID + "</td>";
            strResponse += "<td>" + dtf.format(dtTransaction) + "</td>";
            strResponse += "<td> </td><td> </td>";
            strResponse += "<td>" + strProductName + "</td>";
            strResponse += "<td>" + nQuantity + "</td>";
            strResponse += "<td> </td><td> </td>";
            strResponse += "<td>" + twoPointsAfterDecimal.format((double) fCommission) + "</td>";
            strResponse += "<td>" + nTopups + " Topups </td>";
            strResponse += "</tr>";
        }

/*        if (nTotalSimTrans > 0) {
            strResponse += "</table>";
        }*/

        // mobile unlocking orders
        Integer totalOrders = 0;
        Integer revokedOrders = 0;
        Map<Long, List<MobileUnlockingOrder>> orders = orderService.findByUserAndCreatedDateBetweenGroupByTransactionId(new User(strUserID), dateFrom, dateTo);
        for (Map.Entry<Long, List<MobileUnlockingOrder>> entry : orders.entrySet()) {
            totalOrders += entry.getValue().size();
            BigDecimal size = new BigDecimal(entry.getValue().size());
            MobileUnlockingOrder order = entry.getValue().get(0);
            String row = "<tr class='success'>";
            row += "<td>" + order.getTransactionId() + "</td>";
            row += "<td>" + dtf.format(order.getCreatedDate()) + "</td>";
            if (order.getTransactionBalance() != null) {
                row += "<td>" + order.getTransactionBalance().getBalanceBeforeTransaction() + "</td>";
                row += "<td>" + order.getTransactionBalance().getBalanceAfterTransaction() + "</td>";
            } else {
                row += "<td></td>";
                row += "<td></td>";
            }
            row += "<td>" + order.getMobileUnlocking().getTitle() + "</td>";
            row += "<td>" + size + "</td>";
            row += "<td>" + order.getSellingPrice().multiply(size) + "</td>";
            row += "<td>" + order.getSellingPrice().multiply(size) + "</td>";
            row += "<td>0.00</td>";
            row += "<td>" + (order.getStatus().equals(OrderStatus.REJECTED) ? order.getStatus().getDescription() : "Committed") + "</td>";
            row += "</tr>";
            fTotalRetailPriceValue += order.getSellingPrice().multiply(size).floatValue();
            fTotalTransactionAmount += order.getSellingPrice().multiply(size).floatValue();
            //fTotalCommissionAmount += order.getAgentCommission().add(order.getEezeetelCommission()).floatValue();
            if (order.getStatus().equals(OrderStatus.REJECTED)) {
                revokedOrders++;
            } else {
                nTotalCommittedTransactions++;
            }

            result.add(new AbstractMap.SimpleEntry<Date, String>(order.getCreatedDate(), row));
        }

        Collections.sort(result, new Comparator<Map.Entry<Date, String>>() {
            @Override
            public int compare(Map.Entry<Date, String> o1, Map.Entry<Date, String> o2) {
                return o1.getKey().compareTo(o2.getKey());
            }
        });
        for(Map.Entry entry: result) {
            strResponse += entry.getValue();
        }

        strResponse += "</table>";

        String strFirstPortion = "<table class='table-sm table-striped table-bordered'>";
        strFirstPortion += "<tr>";
        strFirstPortion += "<th><font color=\"red\">Customer Balance</font></th>";
        strFirstPortion += "<th><font color=\"green\">Total Committed Transactions</font></th>";
        strFirstPortion += "<th><font color=\"green\">Total Quantity</font></th>";
        strFirstPortion += "<th><font color=\"green\">Total Retail Value</font></th>";
        strFirstPortion += "<th><font color=\"green\">Total Transaction Amount</font></th>";
        strFirstPortion += "<th><font color=\"blue\">Total Commission</font></th>";
        strFirstPortion += "<th><font color=\"red\">Total Revoked Sub Transactions</font></th>";
        strFirstPortion += "</tr>";

        int nTotalQuantity = nTotalCards + nTotalMobileTopups + nTotalSimTrans + totalOrders + totalPinless;
        int nTotalRevoked = nTotalRevokedTransactions + nMobleToupTotalRevokedTransactions + revokedOrders + revokedPinless;

        strFirstPortion += "<tr>";
        strFirstPortion += "<td><font color=red>" + twoPointsAfterDecimal.format((double) fCustomerBalance) + "</font></td>";
        strFirstPortion += "<td><font color=\"green\">" + nTotalCommittedTransactions + "</font></td>";
        strFirstPortion += "<td><font color=\"green\">" + nTotalCards + " + " + nTotalMobileTopups + " + " + totalOrders + " + " + totalPinless;
        if (nTotalSimTrans > 0)
            strFirstPortion += " + " + nTotalSimTrans + " = " + nTotalQuantity + "</font></td>";
        else
            strFirstPortion += " = " + nTotalQuantity + "</font></td>";

        strFirstPortion += "<td><font color=\"green\">" + twoPointsAfterDecimal.format((double) fTotalRetailPriceValue) + "</font></td>";
        strFirstPortion += "<td><font color=\"green\">" + twoPointsAfterDecimal.format((double) fTotalTransactionAmount) + "</font></td>";
        strFirstPortion += "<td><font color=\"blue\"><b>" + twoPointsAfterDecimal.format((double) fTotalCommissionAmount) + "</b></font></td>";
        strFirstPortion += "<td><font color=\"red\">" + nTotalRevokedTransactions + " + " + nMobleToupTotalRevokedTransactions + " + " + revokedOrders + " + " + revokedPinless + " = " + nTotalRevoked + "</font></td>";
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