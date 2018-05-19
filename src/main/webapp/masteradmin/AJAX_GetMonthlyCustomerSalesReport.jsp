<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    int nStartYear = Integer.parseInt(request.getParameter("start_year_number"));
    int nStartMonth = Integer.parseInt(request.getParameter("start_month_number"));
    int nEndYear = Integer.parseInt(request.getParameter("end_year_number"));
    int nEndMonth = Integer.parseInt(request.getParameter("end_month_number"));

    Calendar cal = Calendar.getInstance();
    cal.set(nEndYear, nEndMonth - 1, 1);
    int nMaxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    response.setContentType("text/xml");
    String xmlData = "<report>";

    String durationBegin = "'" + nStartYear + "-" + nStartMonth + "-01 00:00:00'";
    String durationEnd = "'" + nEndYear + "-" + nEndMonth + "-" + nMaxDay + " 23:59:59'";

    Session theSession = null;

    try {
        String strQuery = "select Customer_ID, Batch_Sequence_ID, sum(Total_Transaction_Amount) as Total_Amount, " +
                " sum(Secondary_Transaction_Amount) as Total_Second_Amount, " +
                " sum(Number_of_transactions) as Total_Transactions, " +
                " sum(Number_of_cards) as Total_Cards from " +
                "((select Customer_ID, Batch_Sequence_ID, " +
                " sum(Unit_Purchase_Price) as Total_Transaction_Amount, " +
                " sum(Secondary_Transaction_Price) as Secondary_Transaction_Amount, " +
                " count(Transaction_ID) as Number_of_transactions, " +
                " SUM(quantity) as Number_of_cards " +
                " from t_transactions " +
                " where Committed = 1 and Transaction_Time >= " + durationBegin + " and Transaction_Time <= " + durationEnd +
                " and Customer_ID != 28 and Product_ID != 146 " +
                " group by Customer_ID, Batch_Sequence_ID order by Customer_ID) " +
                " union " +
                " (select Customer_ID, Batch_Sequence_ID, " +
                " sum(Unit_Purchase_Price) as Total_Transaction_Amount, " +
                " sum(Secondary_Transaction_Price) as Secondary_Transaction_Amount, " +
                " count(Transaction_ID) as Number_of_transactions, " +
                " SUM(quantity) as Number_of_cards " +
                " from t_history_transactions " +
                " where Committed = 1 and Transaction_Time >= " + durationBegin + " and Transaction_Time <= " + durationEnd +
                " and Customer_ID != 28 and Product_ID != 146 " +
                " group by Customer_ID, Batch_Sequence_ID order by Customer_ID)) as pp " +
                " group by Customer_ID, Batch_Sequence_ID order by Customer_ID";

        DecimalFormat ff = new DecimalFormat("0.00");
        theSession = HibernateUtil.openSession();

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);

        sqlQuery.addScalar("Customer_ID", new IntegerType());
        sqlQuery.addScalar("Batch_Sequence_ID", new IntegerType());
        sqlQuery.addScalar("Total_Transactions", new IntegerType());
        sqlQuery.addScalar("Total_Cards", new IntegerType());
        sqlQuery.addScalar("Total_Amount", new FloatType());
        sqlQuery.addScalar("Total_Second_Amount", new FloatType());

        List report = sqlQuery.list();

        for (int i = 0; i < report.size(); i++) {
            Object[] oneRecord = (Object[]) report.get(i);
            if (oneRecord.length > 0) {
                Integer nCustomerID = (Integer) oneRecord[0];
                Integer nBatchID = (Integer) oneRecord[1];
                Integer nTransactions = (Integer) oneRecord[2];
                Integer nCards = (Integer) oneRecord[3];
                Float fTotalAmount = (Float) oneRecord[4];
                Float fSecondaryTotalAmount = (Float) oneRecord[5];

                String strGroup = "eezeetel";
                int nCustomerGroupID = 1;
                String strSupplierName = "";
                String strCustomerName = "";
                String strProductName = "";
                Float fBalance = 0f;

                Float fUnitPrice = 1f;

                // customer information

                strQuery = "from TMasterCustomerinfo where Customer_ID = " + nCustomerID;
                Query query = theSession.createQuery(strQuery);
                List custList = query.list();
                if (custList.size() > 0) {
                    TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
                    strCustomerName = custInfo.getCompanyName();
                    fBalance = custInfo.getCustomerBalance();

                    TMasterCustomerGroups custGroup = custInfo.getGroup();
                    nCustomerGroupID = custGroup.getId();
                    strGroup = custGroup.getName();
                }

                if (nCustomerGroupID == 2)
                    fTotalAmount = fSecondaryTotalAmount;

                // batch information

                strQuery = "from TBatchInformation where SequenceID = " + nBatchID;
                query = theSession.createQuery(strQuery);
                List theBatchList = query.list();
                if (theBatchList.size() <= 0) {
                    strQuery = "select * from t_history_batch_information where SequenceID = " + nBatchID;
                    sqlQuery = theSession.createSQLQuery(strQuery);
                    sqlQuery.addEntity(TBatchInformation.class);
                    theBatchList = sqlQuery.list();
                }

                if (theBatchList.size() > 0) {
                    TBatchInformation theBatch = (TBatchInformation) theBatchList.get(0);
                    TMasterSupplierinfo suppInfo = theBatch.getSupplier();
                    TMasterProductinfo prodInfo = theBatch.getProduct();

                    strSupplierName = suppInfo.getSupplierName();
                    strProductName = prodInfo.getProductName();
                    fUnitPrice = theBatch.getUnitPurchasePrice();
                }

                if (i == 0)
                    xmlData = "<report>";
                else
                    xmlData = "";

                xmlData += "<record ";
                xmlData += (" supplier_name = \"" + strSupplierName + "\" ");
                xmlData += (" customer_group = \"" + strGroup + "\" ");
                xmlData += (" customer_name = \"" + strCustomerName + "\" ");
                xmlData += (" product_name = \"" + strProductName + "\" ");
                xmlData += (" transactions = \"" + nTransactions + "\" ");
                xmlData += (" cards = \"" + nCards + "\" ");
                xmlData += (" total_amount = \"" + fTotalAmount + "\" ");
                xmlData += (" unit_price = \"" + fUnitPrice + "\" ");
                xmlData += (" balance = \"" + fBalance + "\" ");
                xmlData += "/>";

                if (i + 1 == report.size())
                    xmlData += "</report>";

                response.getWriter().println(xmlData);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }

    //xmlData += "</report>";
    //System.out.println(xmlData);
    //response.getWriter().println(xmlData);
%>