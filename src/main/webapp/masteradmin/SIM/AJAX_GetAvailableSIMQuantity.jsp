<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strProductID = request.getParameter("product_id");
    if (strProductID == null || strProductID.isEmpty()) {
        response.setContentType("text/plain");
        response.getWriter().println("0");
        return;
    }

    Session theSession = null;

    try {
        Integer nProductID = Integer.parseInt(strProductID);

        theSession = HibernateUtil.openSession();

        // fetch batch information for the given product to know the available quantity in each batch.

        String strQuery = "from TBatchInformation qc where Available_Quantity > 0 and Product_ID = " + nProductID +
                " and Batch_Activated_By_Supplier = 1 and Batch_Ready_To_Sell = 1" +
                " and IsBatchActive = 1 and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
                " order by Batch_Arrival_Date, Available_Quantity ";

        Query query = theSession.createQuery(strQuery);
        List batches = query.list();
        Integer availableQuantity = 0;

        for (int nBatch = 0; nBatch < batches.size(); nBatch++) {
            TBatchInformation batchInfo = (TBatchInformation) batches.get(nBatch);
            availableQuantity += batchInfo.getAvailableQuantity();
        }

        response.setContentType("text/plain");
        response.getWriter().println(availableQuantity.intValue());
    } catch (Exception e) {
        response.setContentType("text/plain");
        response.getWriter().println("0");
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
