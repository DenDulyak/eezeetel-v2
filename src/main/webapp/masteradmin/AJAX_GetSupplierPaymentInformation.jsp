<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    int nSupplierID = 0;
    String strSupplierID = request.getParameter("supplier_id");
    if (strSupplierID != null && !strSupplierID.isEmpty())
        nSupplierID = Integer.parseInt(strSupplierID);

    String strPaidClause = " and Paid_To_Supplier = 0 ";
    boolean bPaidAlread = false;
    String strWantPaidOnes = request.getParameter("already_paid");

    if (strWantPaidOnes != null && strWantPaidOnes.equalsIgnoreCase("true")) {
        strPaidClause = " and Paid_To_Supplier = 1";
        bPaidAlread = true;
    }

    String strWhere = "";
    if (nSupplierID > 0)
        strWhere = " and Supplier_ID = " + nSupplierID + " ";

    Float fTotalPendingPayments = 0.0f;
    Float fTotalPayments = 0.0f;
    int nTotalCards = 0;
    int nTotalAvailableCards = 0;

    response.setContentType("text/html");
    String htmlData = "<table class='table table-bordered'>";
    htmlData += "<tr>";
    htmlData += ("<th>Batch ID</th>");
    htmlData += ("<th>Supplier Name</th>");
    htmlData += ("<th>Product Name</th>");
    htmlData += ("<th>Face Value</th>");
    htmlData += ("<th>Purchase Price</th>");
    htmlData += ("<th>Ready To Sell</th>");
    htmlData += ("<th>Is Active</th>");
    htmlData += ("<th>Entered Time</th>");
    htmlData += ("<th>Quantity</th>");
    htmlData += ("<th>Available Quantity</th>");
    htmlData += ("<th class='info'>Batch Upload Status</th>");
    htmlData += ("<th class='info'>Activated By Supplier</th>");
    htmlData += ("<th class='info'>Cost Price</th>");
    htmlData += ("<th class='info'>Total Cost Price</th>");
    htmlData += ("<th class='info'>Payment Date</th>");
    htmlData += ("<th class='info'>Paid To supplier</th>");
    htmlData += ("</tr>");
    String strQuery = "from TBatchInformation where Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
            " and Batch_Activated_By_Supplier = 1 " + strWhere +
            strPaidClause + " order by IsBatchActive desc, Batch_Entry_Time desc, Paid_To_Supplier";

    Session theSession = null;

    try {
        DecimalFormat ff = new DecimalFormat("0.00");
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List report = query.list();

        strQuery = "select * from t_history_batch_information where Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB'" +
                " and Batch_Activated_By_Supplier = 1 " + strWhere + strPaidClause +
                " order by IsBatchActive desc, Batch_Entry_Time desc, Paid_To_Supplier";

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addEntity(TBatchInformation.class);
        List reportHist = sqlQuery.list();

        // batch

        for (int i = 0; i < report.size(); i++) {
            TBatchInformation batchInfo = (TBatchInformation) report.get(i);
            TMasterProductinfo prodInfo =  batchInfo.getProduct();
            TMasterSupplierinfo supInfo = batchInfo.getSupplier();

            String strProductName = prodInfo.getProductName();
            String strSupplierName = supInfo.getSupplierName();
            Float fFaceValue = prodInfo.getProductFaceValue();
            Integer quantity = batchInfo.getQuantity();
            Integer availQuantity = batchInfo.getAvailableQuantity();
            Float fUnitPrice = batchInfo.getUnitPurchasePrice();
            Float fCostPrice = batchInfo.getBatchCost();
            Float fTotalCostPrice = quantity * fCostPrice;
            Date dt = batchInfo.getPaymentDateToSupplier();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MMM-dd");
            String strPyamentDate = "";
            if (dt != null)
                strPyamentDate = df.format(dt);
            String strBatchActivated = (batchInfo.getBatchActivatedBySupplier()) ? "Yes" : "No";
            String strReadyToSell = (batchInfo.getBatchReadyToSell()) ? "Yes" : "No";
            String strIsActive = (batchInfo.getActive()) ? "Yes" : "No";
            String strBgColor = (batchInfo.getActive()) ? "" : "danger";
            String strBatchUploadStatus = batchInfo.getBatchUploadStatus();

            String strPaid = "No";
            if (batchInfo.getActive()) {
                nTotalCards += quantity;
                nTotalAvailableCards += availQuantity;

                if (batchInfo.getPaidToSupplier()) {
                    strPaid = "Yes";
                    fTotalPayments += fTotalCostPrice;
                } else
                    fTotalPendingPayments += fTotalCostPrice;
            }

            htmlData += ("<tr>");
            htmlData += ("<td><a href=\"/masteradmin/ModifyBatchInfo.jsp?record_id=" + batchInfo.getSequenceId() + "\">" + batchInfo.getSequenceId() + "</a></td>");
            htmlData += ("<td>" + strSupplierName + "</td>");
            htmlData += ("<td>" + strProductName + "</td>");
            htmlData += ("<td>" + fFaceValue + "</td>");
            htmlData += ("<td>" + fUnitPrice + "</td>");
            htmlData += ("<td>" + strReadyToSell + "</td>");
            htmlData += ("<td class='" + strBgColor + "'>" + strIsActive + "</td>");
            htmlData += ("<td>" + batchInfo.getEntryTime() + "</td>");
            htmlData += ("<td>" + quantity + "</td>");
            htmlData += ("<td>" + availQuantity + "</td>");
            htmlData += ("<td class='info'>" + strBatchUploadStatus + "</td>");
            htmlData += ("<td class='info'>" + strBatchActivated + "</td>");
            htmlData += ("<td class='info'>" + fCostPrice + "</td>");
            htmlData += ("<td class='info'>" + ff.format(fTotalCostPrice) + "</td>");
            htmlData += ("<td class='info'>" + strPyamentDate + "</td>");
            htmlData += ("<td class='info'>" + strPaid + "</td>");
            htmlData += ("</tr>");
        }

        // history batch

        for (int i = 0; i < reportHist.size(); i++) {
            TBatchInformation batchInfo = (TBatchInformation) reportHist.get(i);
            TMasterProductinfo prodInfo = batchInfo.getProduct();
            TMasterSupplierinfo supInfo = batchInfo.getSupplier();

            String strProductName = prodInfo.getProductName();
            String strSupplierName = supInfo.getSupplierName();
            Float fFaceValue = prodInfo.getProductFaceValue();
            Integer quantity = batchInfo.getQuantity();
            Integer availQuantity = batchInfo.getAvailableQuantity();
            Float fUnitPrice = batchInfo.getUnitPurchasePrice();
            Float fCostPrice = batchInfo.getBatchCost();
            Date dt = batchInfo.getPaymentDateToSupplier();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MMM-dd");
            Float fTotalCostPrice = quantity * fCostPrice;
            String strPyamentDate = "";
            if (dt != null)
                strPyamentDate = df.format(dt);
            String strBatchActivated = (batchInfo.getBatchActivatedBySupplier()) ? "Yes" : "No";
            String strReadyToSell = (batchInfo.getBatchReadyToSell()) ? "Yes" : "No";
            String strIsActive = (batchInfo.getActive()) ? "Yes" : "No";
            String strBgColor = (batchInfo.getActive()) ? "#FFFFFF" : "#808080";
            String strBatchUploadStatus = batchInfo.getBatchUploadStatus();

            String strPaid = "No";
            if (batchInfo.getActive()) {
                nTotalCards += quantity;
                nTotalAvailableCards += availQuantity;

                if (batchInfo.getPaidToSupplier()) {
                    strPaid = "Yes";
                    fTotalPayments += fTotalCostPrice;
                } else
                    fTotalPendingPayments += fTotalCostPrice;
            }

            htmlData += ("<tr>");
            htmlData += ("<td><a href=\"/masteradmin/ModifyBatchInfo.jsp?record_id=" + batchInfo.getSequenceId() + "\">" + batchInfo.getSequenceId() + "</a></td>");
            htmlData += ("<td>" + strSupplierName + "</td>");
            htmlData += ("<td>" + strProductName + "</td>");
            htmlData += ("<td>" + fFaceValue + "</td>");
            htmlData += ("<td>" + fUnitPrice + "</td>");
            htmlData += ("<td>" + strReadyToSell + "</td>");
            htmlData += ("<td bgcolor=" + strBgColor + ">" + strIsActive + "</td>");
            htmlData += ("<td>" + batchInfo.getEntryTime() + "</td>");
            htmlData += ("<td>" + quantity + "</td>");
            htmlData += ("<td>" + availQuantity + "</td>");
            htmlData += ("<td bgcolor=yellow>" + strBatchUploadStatus + "</td>");
            htmlData += ("<td bgcolor=yellow>" + strBatchActivated + "</td>");
            htmlData += ("<td bgcolor=yellow>" + fCostPrice + "</td>");
            htmlData += ("<td bgcolor=yellow>" + ff.format(fTotalCostPrice) + "</td>");
            htmlData += ("<td bgcolor=yellow>" + strPyamentDate + "</td>");
            htmlData += ("<td bgcolor=yellow>" + strPaid + "</td>");
            htmlData += ("</tr>");
        }

        htmlData += ("<tr>");
        htmlData += "<td> </td><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td>";
        if (bPaidAlread) {
            htmlData += ("<td bgcolor=green> Total Paid");
            htmlData += ("<td bgcolor=green>" + nTotalCards + "</td>");
            htmlData += ("<td bgcolor=green>" + nTotalAvailableCards + "</td>");
            htmlData += ("<td> </td><td> </td><td> </td>");
            htmlData += ("<td bgcolor=green>" + ff.format(fTotalPayments) + "</td>");
        } else {
            htmlData += ("<td class='danger'> Total Pending");
            htmlData += ("<td class='danger'>" + nTotalCards + "</td>");
            htmlData += ("<td class='danger'>" + nTotalAvailableCards + "</td>");
            htmlData += ("<td></td><td></td><td></td>");
            htmlData += ("<td class='danger'>" + ff.format(fTotalPendingPayments) + "</td>");
            htmlData += ("<td></td><td></td>");
        }
        htmlData += ("</tr>");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
    htmlData += "</table>";
    response.getWriter().println(htmlData);
%>