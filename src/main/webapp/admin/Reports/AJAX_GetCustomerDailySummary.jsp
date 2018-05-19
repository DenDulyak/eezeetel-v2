<%@ page import="com.eezeetel.service.MobileUnlockingOrderService" %>
<%@ page import="com.eezeetel.service.MobitopupTransactionService" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eezeetel.service.PinlessTransactionService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%

    String strContent = "";
    String strCustomerID = request.getParameter("customer_id");
    int nCustomerID = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerID = Integer.parseInt(strCustomerID);

    String theYear = request.getParameter("year");
    String theMonth = request.getParameter("month");
    String theDay = request.getParameter("day");

    int nYear = Integer.parseInt(theYear);
    int nMonth = Integer.parseInt(theMonth);
    int nDay = Integer.parseInt(theDay);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Calendar cal = Calendar.getInstance();
    cal.set(nYear, nMonth, nDay);

    String durationBegin = sdf.format(cal.getTime());
    String durationEnd = durationBegin;

    durationBegin += " 00:00:00";
    durationEnd += " 23:59:59";

    response.setContentType("text/plain");
    if (nCustomerID <= 0) {
        response.getWriter().println("");
        return;
    }

    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.GetCustomerGroupID(nCustomerID) != nCustomerGroupID) {
        response.getWriter().println("");
        return;
    }

    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    MobileUnlockingOrderService orderService = context.getBean(MobileUnlockingOrderService.class);
    MobitopupTransactionService mobitopupTransactionService = context.getBean(MobitopupTransactionService.class);
    PinlessTransactionService pinlessTransactionService = context.getBean(PinlessTransactionService.class);


    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        Float fCustomerBalance = 0.0f;
        Map<Long, String> result = new TreeMap<Long, String>();

        String strQuery = "from TMasterCustomerinfo where Customer_ID = " + nCustomerID +
                " and Customer_Group_ID = " + nCustomerGroupID;
        Query query = theSession.createQuery(strQuery);
        List custList = query.list();
        TMasterCustomerinfo customer = null;

        if (custList.size() > 0) {
            customer = (TMasterCustomerinfo) custList.get(0);
            fCustomerBalance = customer.getCustomerBalance();
        }

        strQuery = "call SP_Customer_Daily_Summary(" + nCustomerID +
                ", '" + durationBegin + "', '" + durationEnd + "', '')";

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

        SimpleDateFormat dtf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // summary variables

        int nTotalCommittedTransactions = 0;
        int nTotalCards = 0;
        Float fTotalTransactionAmount = 0.0f;
        Float fTotalTotalCostPrice = 0.0f;
        Float fTotalAgentProfit = 0.0f;
        Float fTotalProfit = 0.0f;
        Float fTotalCustomerProfit = 0.0f;
        int nTotalRevokedTransactions = 0;

        DecimalFormat twoPointsAfterDecimal = new DecimalFormat("0.00");

        String strResponse = "<table border=1 width='100%'>";
        strResponse += "<tr>" +
                "<td>Transaction</td>" +
                "<td>Transaction Time</td>" +
                "<td>Balance Before Transaction</td>" +
                "<td>Balance After Transaction</td>" +
                "<td>Product Name</td>" +
                "<td>Quantity</td>" +
                "<td>Retail Price</td>" +
                "<td>Transaction Price</td>" +
                "<td>Customer Profit</td>" +
                "<td>Agent Profit</td>" +
                "<td>Group Profit</td>" +
                "<td>Commit Status</td>" +
                "</tr>";

        Long nPrevTransactionID = 0L;
        for (int i = 0; i < custTransactions.size(); i++) {
            Object[] theRecord = (Object[]) custTransactions.get(i);
            Integer nIsHistory = (Integer) theRecord[0];
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
            Float fGroupAmount = (Float) theRecord[14];
            String strCommitStatus = "Committed";

            Float fAgentProfit = fTransactionPrice - fSecondTransactionAmount;
            Float fProfit = fSecondTransactionAmount - fGroupAmount;
            Float fCustomerProfit = (fProbableSalePrice * nQuantity) - fTransactionPrice;

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
                    fTotalTotalCostPrice += fGroupAmount;
                    fTotalAgentProfit += fAgentProfit;
                    fTotalProfit += fProfit;
                    fTotalCustomerProfit += fCustomerProfit;
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
            }

            row += "<td>" + nTransactionID + "</td>";
            row += "<td>" + dtf.format(dtTransaction) + "</td>";
            row += "<td>" + fBalanceBefore + "</td>";
            row += "<td>" + fBalanceAfter + "</td>";
            row += "<td>" + strProductName + "-" + twoPointsAfterDecimal.format((double) fFaceValue) + "</td>";
            row += "<td>" + nQuantity + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fProbableSalePrice) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fTransactionPrice) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fCustomerProfit) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fAgentProfit) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fProfit) + "</td>";
            row += "<td>" + strCommitStatus + "</td>";
            row += "</tr>";

            if (result.containsKey(nTransactionID)) {
                row += result.get(nTransactionID);
            }

            result.put(nTransactionID, row);
        }

        // Mobile topup transctions

        int nTotalMobileTopups = 0;
        int nMobleToupTotalRevokedTransactions = 0;

        strQuery = "call SP_Customer_Daily_AIT_Summary(" + nCustomerID +
                //", CAST((concat(CURDATE(), ' 00:00:00')) as DATETIME), now(), '')";
                ", '" + durationBegin + "', '" + durationEnd + "', '')";

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
            Float fAgentAmount = (Float) theRecord[8];
            Float fGroupAmount = (Float) theRecord[9];
            String strCommitStatus = "Committed";

            Float fAgentProfit = fTransactionPrice - fAgentAmount;
            Float fProfit = fAgentAmount - fGroupAmount;
            Float fCustomerProfit = fProbableSalePrice - fTransactionPrice;

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
                    fTotalTotalCostPrice += fGroupAmount;
                    fTotalAgentProfit += fAgentProfit;
                    fTotalProfit += fProfit;
                    fTotalCustomerProfit += fCustomerProfit;
                    break;
                }
                case 3: {
                    strCommitStatus = "Revoked";
                    nMobleToupTotalRevokedTransactions++;
                    break;
                }
            }

            String row = "<tr bgcolor='yellow'>";
            if (nPrevTransactionID.longValue() != nTransactionID.longValue()) {
                if (nCommited == 1)
                    nTotalCommittedTransactions++;

                nPrevTransactionID = nTransactionID;
                row += "<td>" + nTransactionID + "</td>";
                row += "<td>" + dtf.format(dtTransaction) + "</td>";
                row += "<td>" + fBalanceBefore + "</td>";
                row += "<td>" + fBalanceAfter + "</td>";
            } else
                row += "<td colspan=4></td>";

            row += "<td>" + strProductName + "</td>";
            row += "<td>" + nQuantity + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fProbableSalePrice) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fTransactionPrice) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fCustomerProfit) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fAgentProfit) + "</td>";
            row += "<td>" + twoPointsAfterDecimal.format((double) fProfit) + "</td>";
            row += "<td>" + strCommitStatus + "</td>";
            row += "</tr>";
            result.put(nTransactionID, row);
        }

        // mobitopup transactions
        List<MobitopupTransaction> mobitopupTransactions = mobitopupTransactionService.findByCustomerAndTransactionTime(customer, dtf.parse(durationBegin), dtf.parse(durationEnd));
        for (MobitopupTransaction transaction : mobitopupTransactions) {

            String row = "<tr bgcolor='yellow'>";
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
            row += "<td>" + transaction.getAgentCommission() + "</td>";
            row += "<td>" + transaction.getGroupCommission() + "</td>";
            row += "<td>Committed</td>";
            row += "</tr>";

            nTotalMobileTopups += 1;
            fTotalTransactionAmount += transaction.getRetailPrice().subtract(transaction.getCustomerCommission()).floatValue();
            fTotalTotalCostPrice += transaction.getRetailPrice()
                    .subtract(transaction.getCustomerCommission())
                    .subtract(transaction.getAgentCommission())
                    .subtract(transaction.getGroupCommission())
                    .floatValue();
            fTotalAgentProfit += transaction.getAgentCommission().floatValue();
            fTotalProfit += transaction.getGroupCommission().floatValue();
            fTotalCustomerProfit += transaction.getCustomerCommission().floatValue();
            nTotalCommittedTransactions++;

            result.put(transaction.getTransactionId(), row);
        }

        // pinless transactions
        List<PinlessTransaction> pinlessTransactions = pinlessTransactionService.findByCustomerAndTransactionTime(customer, dtf.parse(durationBegin), dtf.parse(durationEnd));
        for (PinlessTransaction transaction : pinlessTransactions) {

            String row = "<tr bgcolor='yellow'>";
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
            row += "<td>" + transaction.getAgentCommission() + "</td>";
            row += "<td>" + transaction.getGroupCommission() + "</td>";
            row += "<td>Committed</td>";
            row += "</tr>";

            fTotalTransactionAmount += transaction.getRetailPrice().subtract(transaction.getCustomerCommission()).floatValue();
            fTotalTotalCostPrice += transaction.getRetailPrice()
                    .subtract(transaction.getCustomerCommission())
                    .subtract(transaction.getAgentCommission())
                    .subtract(transaction.getGroupCommission())
                    .floatValue();
            fTotalAgentProfit += transaction.getAgentCommission().floatValue();
            fTotalProfit += transaction.getGroupCommission().floatValue();
            fTotalCustomerProfit += transaction.getCustomerCommission().floatValue();
            nTotalCommittedTransactions++;

            result.put(transaction.getTransactionId(), row);
        }

        // mobile unlocking orders
        List<MobileUnlockingOrder> orders = orderService.findByCustomerAndCreatedDateBetween(customer, dtf.parse(durationBegin), dtf.parse(durationEnd));
        if (!orders.isEmpty()) {
            Map<Long, Integer> quantities = new TreeMap<Long, Integer>();

            for (MobileUnlockingOrder order : orders) {
                if (quantities.containsKey(order.getTransactionId())) {
                    quantities.put(order.getTransactionId(), quantities.get(order.getTransactionId()) + 1);
                } else {
                    quantities.put(order.getTransactionId(), 1);
                }
            }

            for (MobileUnlockingOrder order : orders) {
                if (result.containsKey(order.getTransactionId())) {
                    continue;
                }

                BigDecimal quantity = new BigDecimal(quantities.get(order.getTransactionId()) + "");

                String row = "<tr bgcolor='lime'>";
                row += "<td>" + order.getTransactionId() + "</td>";
                row += "<td>" + dtf.format(order.getCreatedDate()) + "</td>";
                row += "<td>" + order.getTransactionBalance().getBalanceBeforeTransaction() + "</td>";
                row += "<td>" + order.getTransactionBalance().getBalanceAfterTransaction() + "</td>";
                row += "<td>" + order.getMobileUnlocking().getTitle() + "</td>";
                row += "<td>" + quantity + "</td>";
                row += "<td>" + order.getSellingPrice().multiply(quantity) + "</td>";
                row += "<td>" + order.getSellingPrice().multiply(quantity) + "</td>";
                row += "<td>0.00</td>";
                row += "<td>" + order.getAgentCommission().multiply(quantity) + "</td>";
                row += "<td>" + order.getGroupCommission().multiply(quantity) + "</td>";
                row += "<td>Committed</td>";
                row += "</tr>";

                fTotalTransactionAmount += order.getSellingPrice().floatValue();
                fTotalTotalCostPrice += order.getSellingPrice().floatValue();
                fTotalAgentProfit += order.getAgentCommission().multiply(quantity).floatValue();
                fTotalProfit += order.getGroupCommission().multiply(quantity).floatValue();
                //fTotalCustomerProfit += order.getCustomerCommission().multiply(quantity).floatValue();
                nTotalCommittedTransactions++;

                result.put(order.getTransactionId(), row);
            }
        }

        for (String row : result.values()) {
            strResponse += row;
        }

        strResponse += "<tr>" +
                "<td><a href='/admin'>Admin Main</a></td></td></tr>";
        strResponse += "</table>";

        String strFirstPortion = "<table border=1 width='100%'>";
        strFirstPortion += "<tr>";
        strFirstPortion += "<td><font color='red'>Customer Balance</font></td>";
        strFirstPortion += "<td><font color='green'>Total Committed Transactions</font></td>";
        strFirstPortion += "<td><font color='green'>Total Cards</font></td>";
        strFirstPortion += "<td><font color='blue'>Total Transaction Amount</font></td>";
        strFirstPortion += "<td><font color='blue'>Total Transaction Cost Amount</font></td>";
        strFirstPortion += "<td><font color='blue'>Total Agent Profit</font></td>";
        strFirstPortion += "<td><font color='blue'><b>Total Group Profit</b></font></td>";
        strFirstPortion += "<td><font color='red'>Total Revoked Sub Transactions</font></td>";
        strFirstPortion += "</tr>";

        strFirstPortion += "<tr>";
        strFirstPortion += "<td><font color='red'>" + fCustomerBalance + "</font></td>";
        strFirstPortion += "<td><font color='green'>" + nTotalCommittedTransactions + "</font></td>";
        strFirstPortion += "<td><font color='green'>" + nTotalCards + "</font></td>";
        strFirstPortion += "<td><font color='blue'>" + twoPointsAfterDecimal.format((double) fTotalTransactionAmount) + "</font></td>";
        strFirstPortion += "<td><font color='blue'>" + twoPointsAfterDecimal.format((double) fTotalTotalCostPrice) + "</font></td>";
        strFirstPortion += "<td><font color='blue'>" + twoPointsAfterDecimal.format((double) fTotalAgentProfit) + "</font></td>";
        strFirstPortion += "<td><font color='blue'><b>" + twoPointsAfterDecimal.format((double) fTotalProfit) + "</b></font></td>";
        strFirstPortion += "<td><font color='red'>" + nTotalRevokedTransactions + "</font></td>";
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