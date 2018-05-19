<%@ page import="com.eezeetel.service.CardService" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strResponse = "Card Not Found.";
    response.setContentType("text/html");

    String strSupplierID = request.getParameter("supplier_id");
    String strProductID = request.getParameter("product_name");
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

    Calendar now = Calendar.getInstance();
    now.add(Calendar.MONTH, -6);
    SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
    String strEnteredTime = sf.format(now.getTime());

    Session theSession = null;

    try {
        WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
        CardService cardService = context.getBean(CardService.class);

        theSession = HibernateUtil.openSession();

        String strQuery = "select * from t_batch_information where Product_ID = " + nProductID +
                //" and Batch_Entry_Time >= '" + strEnteredTime + "'" +
                " and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB'" +
                " order by Batch_Entry_Time desc";

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addEntity(TBatchInformation.class);
        List newBatches = sqlQuery.list();

        strQuery = "select * from t_history_batch_information where Product_ID = " + nProductID +
                //" and Batch_Entry_Time >= '" + strEnteredTime + "' " +
                " and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB'" +
                " and SequenceID not in(select SequenceID from t_batch_information) " +
                " order by Batch_Entry_Time desc";

        sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addEntity(TBatchInformation.class);
        List oldBatches = sqlQuery.list();

        strResponse = "<table class='table table-bordered'>" +
                "<tr>" +
                "<th>Batch Number</th>" +
                "<th>Batch ID</th>" +
                "<th>Supplier</th>" +
                "<th>Product</th>" +
                "<th>Quantity</th>" +
                "<th>Available Quantity</th>" +
                "<th>Unit Purchase Price</th>" +
                "<th>Arrival Date</th>" +
                "<th>Expiry Date</th>" +
                "<th>Entered Date</th>" +
                "<th>Created By</th>" +
                "<th>Activated By Supplier</th>" +
                "<th>Ready To Sell</th>" +
                "<th>Batch Active</th>" +
                "<th>Upload Status</th>" +
                "<th>Batch Start Number</th>" +
                "<th>Batch End Number</th>" +
                "</tr>";

        for (int i = 0; i < newBatches.size(); i++) {
            TBatchInformation batchInfo = (TBatchInformation) newBatches.get(i);
            TMasterSupplierinfo supInfo = batchInfo.getSupplier();
            TMasterProductinfo prodInfo = batchInfo.getProduct();
            User userInfo = batchInfo.getUser();

            // get the card information

            String strFirstCard = "", strLastCard = "";

            strFirstCard = cardService.findFirstCardIdByBatch(batchInfo.getSequenceId());
            strLastCard = cardService.findLastCardIdByBatch(batchInfo.getSequenceId());

            strResponse += "<tr>";
            strResponse += "<td>" + batchInfo.getSequenceId() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchId() + "</td>";
            strResponse += "<td>" + supInfo.getSupplierName() + "</td>";
            strResponse += "<td>" + prodInfo.getProductName() + "</td>";
            strResponse += "<td>" + batchInfo.getQuantity() + "</td>";
            strResponse += "<td>" + batchInfo.getAvailableQuantity() + "</td>";
            strResponse += "<td>" + batchInfo.getUnitPurchasePrice() + "</td>";
            strResponse += "<td>" + batchInfo.getArrivalDate() + "</td>";
            strResponse += "<td>" + batchInfo.getExpiryDate() + "</td>";
            strResponse += "<td>" + batchInfo.getEntryTime() + "</td>";
            strResponse += "<td>" + userInfo.getUserFirstName() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchActivatedBySupplier() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchReadyToSell() + "</td>";
            strResponse += "<td>" + batchInfo.getActive() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchUploadStatus() + "</td>";
            strResponse += "<td>" + strFirstCard + "</td>";
            strResponse += "<td>" + strLastCard + "</td>";
            strResponse += "</tr>";
        }

        for (int i = 0; i < oldBatches.size(); i++) {
            TBatchInformation batchInfo = (TBatchInformation) oldBatches.get(i);
            TMasterSupplierinfo supInfo = batchInfo.getSupplier();
            TMasterProductinfo prodInfo = batchInfo.getProduct();
            User userInfo = batchInfo.getUser();

            // get the card information

            String strFirstCard = "", strLastCard = "";

            strFirstCard = cardService.findFirstCardIdByBatch(batchInfo.getSequenceId()) + "";
            strLastCard = cardService.findLastCardIdByBatch(batchInfo.getSequenceId()) + "";

            strResponse += "<tr>";
            strResponse += "<td>" + batchInfo.getSequenceId() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchId() + "</td>";
            strResponse += "<td>" + supInfo.getSupplierName() + "</td>";
            strResponse += "<td>" + prodInfo.getProductName() + "</td>";
            strResponse += "<td>" + batchInfo.getQuantity() + "</td>";
            strResponse += "<td>" + batchInfo.getAvailableQuantity() + "</td>";
            strResponse += "<td>" + batchInfo.getUnitPurchasePrice() + "</td>";
            strResponse += "<td>" + batchInfo.getArrivalDate() + "</td>";
            strResponse += "<td>" + batchInfo.getExpiryDate() + "</td>";
            strResponse += "<td>" + batchInfo.getEntryTime() + "</td>";
            strResponse += "<td>" + userInfo.getUserFirstName() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchActivatedBySupplier() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchReadyToSell() + "</td>";
            strResponse += "<td>" + batchInfo.getActive() + "</td>";
            strResponse += "<td>" + batchInfo.getBatchUploadStatus() + "</td>";
            strResponse += "<td>" + strFirstCard + "</td>";
            strResponse += "<td>" + strLastCard + "</td>";
            strResponse += "</tr>";
        }

        strResponse += "</table>";

        response.getWriter().println(strResponse);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
