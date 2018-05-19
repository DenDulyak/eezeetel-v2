<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strResponse = "Card Not Found.";
    response.setContentType("text/html");

    String strSupplierID = request.getParameter("supplier_id");
    String strProductID = request.getParameter("product_name");
    String strBatchNumber = request.getParameter("batch_number");

    int nSupplierID = 0, nProductID = 0;

    try {
        if (strSupplierID != null && !strSupplierID.isEmpty())
            nSupplierID = Integer.parseInt(strSupplierID);

        if (strProductID != null && !strProductID.isEmpty())
            nProductID = Integer.parseInt(strProductID);
    } catch (NumberFormatException nfe) {
        nSupplierID = 0;
        nProductID = 0;
    }

    if (nSupplierID <= 0 || nProductID <= 0) return;
    if (strBatchNumber == null || strBatchNumber.isEmpty()) return;

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        TCardInfo theCardInfo = null;

        String strQuery = "from TCardInfo where Product_ID = " + nProductID +
                " and card_id = '" + strBatchNumber + "'";
        Query query = theSession.createQuery(strQuery);
        List list = query.list();
        if (list.size() <= 0) {
            strQuery = "select * from t_history_card_info where Product_ID = " + nProductID +
                    " and card_id = '" + strBatchNumber + "'";

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TCardInfo.class);
            list = sqlQuery.list();
            if (list.size() > 0)
                theCardInfo = (TCardInfo) list.get(0);
        } else
            theCardInfo = (TCardInfo) list.get(0);

        if (theCardInfo == null) {
            response.getWriter().println(strResponse);
            return;
        }

        TBatchInformation batchInfo = theCardInfo.getBatch();

        strQuery = "from TBatchInformation where SequenceID = " + batchInfo.getSequenceId();
        query = theSession.createQuery(strQuery);
        list = query.list();
        if (list.size() <= 0) {
            strQuery = "select * from t_history_batch_information where SequenceID = " + batchInfo.getSequenceId();

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TBatchInformation.class);
            list = sqlQuery.list();
            if (list.size() > 0)
                batchInfo = (TBatchInformation) list.get(0);
        } else
            batchInfo = (TBatchInformation) list.get(0);

        TMasterSupplierinfo supInfo = batchInfo.getSupplier();
        TMasterProductinfo prodInfo = batchInfo.getProduct();
        User userInfo = batchInfo.getUser();

        String strFirstCard = "", strLastCard = "";

        strQuery = "from TCardInfo where Product_ID = " + nProductID +
                " and Batch_Sequence_ID = " + batchInfo.getSequenceId() +
                " order by card_id";

        query = theSession.createQuery(strQuery);
        list = query.list();

        if (list.size() > 0) {
            TCardInfo firstCard = (TCardInfo) list.get(0);
            strFirstCard = firstCard.getCardId();
            TCardInfo lastCard = (TCardInfo) list.get(list.size() - 1);
            strLastCard = lastCard.getCardId();
        }

        strQuery = "select * from t_history_card_info where Product_ID = " + nProductID +
                " and Batch_Sequence_ID = " + batchInfo.getSequenceId() +
                " order by card_id";

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addEntity(TCardInfo.class);
        list = sqlQuery.list();

        if (list.size() > 0) {
            TCardInfo firstCard = (TCardInfo) list.get(0);
            if (!firstCard.getCardId().isEmpty())
                strFirstCard = firstCard.getCardId();
            TCardInfo lastCard = (TCardInfo) list.get(list.size() - 1);
            if (strLastCard.isEmpty())
                strLastCard = lastCard.getCardId();
        }

        strResponse = "<table class='table table-bordered'>";
        strResponse += "<tr><td align=right>Sequence ID :</td><td align=left>" + batchInfo.getSequenceId() + "</td></tr>";
        strResponse += "<tr><td align=right>Batch ID :</td><td align=left>" + batchInfo.getBatchId() + "</td></tr>";
        strResponse += "<tr><td align=right>Supplier :</td><td align=left>" + supInfo.getSupplierName() + "</td></tr>";
        strResponse += "<tr><td align=right>Product :</td><td align=left>" + prodInfo.getProductName() + "</td></tr>";
        strResponse += "<tr><td align=right>Quantity :</td><td align=left>" + batchInfo.getQuantity() + "</td></tr>";
        strResponse += "<tr><td align=right>Available Quantity :</td><td align=left>" + batchInfo.getAvailableQuantity() + "</td></tr>";
        strResponse += "<tr><td align=right>Unit Purchase Price :</td><td align=left>" + batchInfo.getUnitPurchasePrice() + "</td></tr>";
        strResponse += "<tr><td align=right>Arrival Date :</td><td align=left>" + batchInfo.getArrivalDate() + "</td></tr>";
        strResponse += "<tr><td align=right>Expiry Date :</td><td align=left>" + batchInfo.getExpiryDate() + "</td></tr>";
        strResponse += "<tr><td align=right>Entered Date :</td><td align=left>" + batchInfo.getEntryTime() + "</td></tr>";
        strResponse += "<tr><td align=right>Created By :</td><td align=left>" + userInfo.getUserFirstName() + "</td></tr>";
        strResponse += "<tr><td align=right>Activated By Supplier :</td><td align=left>" + batchInfo.getBatchActivatedBySupplier() + "</td></tr>";
        strResponse += "<tr><td align=right>Ready To Sell :</td><td align=left>" + batchInfo.getBatchReadyToSell() + "</td></tr>";
        strResponse += "<tr><td align=right>Batch Active :</td><td align=left>" + batchInfo.getActive() + "</td></tr>";
        strResponse += "<tr><td align=right>Addtional Info :</td><td align=left>" + batchInfo.getAdditionalInfo() + "</td></tr>";
        strResponse += "<tr><td align=right>Notes :</td><td align=left>" + batchInfo.getNotes() + "</td></tr>";
        strResponse += "<tr><td align=right>Upload Status :</td><td align=left>" + batchInfo.getBatchUploadStatus() + "</td></tr>";
        strResponse += "<tr><td align=right>Batch Start Number :</td><td align=left>" + strFirstCard + "</td></tr>";
        strResponse += "<tr><td align=right>Batch End Number :</td><td align=left>" + strLastCard + "</td></tr>";
        strResponse += "</table>";

        response.getWriter().println(strResponse);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
