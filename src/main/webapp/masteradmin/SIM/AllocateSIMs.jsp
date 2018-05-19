<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Session theSession = null;
    try {
        String strCustomerGroupID = request.getParameter("customer_group_id");
        String strProductID = request.getParameter("product_id");
        String strRequiredQuantity = request.getParameter("required_quantity");

        int nCustomerGroupID = 0;
        int nProductID = 0;
        int nRequiredQuantity = 0;

        if (strCustomerGroupID != null && !strCustomerGroupID.isEmpty())
            nCustomerGroupID = Integer.parseInt(strCustomerGroupID);

        if (strProductID != null && !strProductID.isEmpty())
            nProductID = Integer.parseInt(strProductID);

        if (strRequiredQuantity != null && !strRequiredQuantity.isEmpty())
            nRequiredQuantity = Integer.parseInt(strRequiredQuantity);

        if (nCustomerGroupID <= 0 || nProductID <= 0 || nRequiredQuantity <= 0) {
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Please select Customer, Product and Required Quantity to allocate SIMS.</FONT></H4>" +
                    "<A HREF=\"/masteradmin/SIM/AssignSIMs.jsp\">Assign SIMs To Customer Groups</A></BODY></HTML>";
            response.getWriter().println(strError);
            return;
        }

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        // fetch batch information for the given product to know the available quantity in each batch.

        String strQuery = "from TBatchInformation qc where Available_Quantity > 0 and Product_ID = " + nProductID +
                " and Batch_Activated_By_Supplier = 1 and Batch_Ready_To_Sell = 1" +
                " and IsBatchActive = 1 and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
                " order by Batch_Arrival_Date, Available_Quantity ";

        Query query = theSession.createQuery(strQuery);
        query.setLockMode("qc", LockMode.UPGRADE);
        List batches = query.list();

        int nRequiredQuantityNow = nRequiredQuantity;

        for (int nBatch = 0; nBatch < batches.size(); nBatch++) {
            TBatchInformation batchInfo = (TBatchInformation) batches.get(nBatch);

            int nAvailableInThisBatch = 0;
            if (batchInfo.getAvailableQuantity() >= nRequiredQuantityNow)
                nAvailableInThisBatch = nRequiredQuantityNow;
            else
                nAvailableInThisBatch = batchInfo.getAvailableQuantity();

            nRequiredQuantityNow -= nAvailableInThisBatch;

            strQuery = "from TSimCardsInfo qc1 where Product_ID = " + nProductID + " and Batch_Sequence_ID = " +
                    batchInfo.getSequenceId() + " and Is_Sold = 0 and Customer_Group_ID = 0 and Customer_ID = 0 " +
                    " order by SequenceID";

            query = theSession.createQuery(strQuery);
            query.setLockMode("qc1", LockMode.UPGRADE);
            List simCards = query.list();

            for (int i = 0; i < simCards.size() && i < nAvailableInThisBatch; i++) {
                TSimCardsInfo simCardInfo = (TSimCardsInfo) simCards.get(i);
                simCardInfo.setCustomerGroupId(nCustomerGroupID);
                theSession.save(simCardInfo);
            }

            // update batch information
            batchInfo.setAvailableQuantity(batchInfo.getAvailableQuantity() - nAvailableInThisBatch);
            batchInfo.setLastTouchTime(Calendar.getInstance().getTime());
            theSession.save(batchInfo);


            if (nRequiredQuantityNow <= 0) break;
        }

        theSession.getTransaction().commit();

        response.sendRedirect("/masteradmin/SIM/AssignSIMs.jsp");
    } catch (Exception e) {
        if (theSession != null)
            theSession.getTransaction().rollback();

        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">FAILED to allocate SIMS.  Please try again.</FONT></H4>" +
                "<A HREF=\"/masteradmin/SIM/AssignSIMs.jsp\">Assign SIMs To Customer Groups</A></BODY></HTML>";
        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>