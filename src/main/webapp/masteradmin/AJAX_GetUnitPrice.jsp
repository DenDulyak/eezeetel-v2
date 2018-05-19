<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSupplier = request.getParameter("supplier_id");
    String strProduct = request.getParameter("product_id");

    int nSupplierID = 0;
    if (strSupplier != null && !strSupplier.isEmpty())
        nSupplierID = Integer.parseInt(strSupplier);

    int nProductID = 0;
    if (strProduct != null && !strProduct.isEmpty())
        nProductID = Integer.parseInt(strProduct);

    if (nSupplierID <= 0 || nProductID <= 0) return;

    Session theSession = null;
    try {
        float fValue = 0.0f;
        float fSalePrice = 0.0f;
        float fFaceValue = 0.0f;
        float fCostPrice = 0.0f;
        boolean bSIMCardProduct = false;
        int nBatchID = 0;
        int nMaxTopups = -1;

        theSession = HibernateUtil.openSession();

        String strQuery = "from TMasterProductinfo where Supplier_ID = " + nSupplierID +
                " and Product_ID = " + nProductID +
                " and Product_Active_Status = 1";

        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        if (records.size() > 0) {
            TMasterProductinfo productInfo = (TMasterProductinfo) records.get(0);
            if (fValue <= 0)
                fValue = productInfo.getProductFaceValue();
            if (fSalePrice <= 0)
                fSalePrice = productInfo.getProductFaceValue();

            fFaceValue = productInfo.getProductFaceValue();

            if (productInfo.getProductType().getId() == 17)
                bSIMCardProduct = true;
        }

        strQuery = "from TBatchInformation where Supplier_ID = " + nSupplierID +
                " and Product_ID = " + nProductID +
                " and Batch_Activated_By_Supplier = 1 " +
                " and Batch_Ready_To_Sell = 1 and IsBatchActive = 1 " +
                " order by SequenceID desc";

        query = theSession.createQuery(strQuery);
        query.setMaxResults(1);
        records = query.list();

        if (records.size() > 0) {
            TBatchInformation batchInfo = (TBatchInformation) records.get(0);
            fValue = batchInfo.getUnitPurchasePrice();
            fSalePrice = batchInfo.getProbableSalePrice();
            fCostPrice = batchInfo.getBatchCost();
            if (fCostPrice <= 0)
                fCostPrice = fValue;

            nBatchID = batchInfo.getSequenceId();
        } else {
            strQuery = "select * from t_history_batch_information where Supplier_ID = " + nSupplierID +
                    " and Product_ID = " + nProductID +
                    " and Batch_Activated_By_Supplier = 1 " +
                    " and Batch_Ready_To_Sell = 1 and IsBatchActive = 1 " +
                    " order by SequenceID desc limit 1";

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TBatchInformation.class);
            records = sqlQuery.list();

            if (records.size() > 0) {
                TBatchInformation batchInfo = (TBatchInformation) records.get(0);
                fValue = batchInfo.getUnitPurchasePrice();
                fSalePrice = batchInfo.getProbableSalePrice();
                fCostPrice = batchInfo.getBatchCost();
                if (fCostPrice <= 0)
                    fCostPrice = fValue;

                nBatchID = batchInfo.getSequenceId();
            }
        }

        if (bSIMCardProduct) {
            nMaxTopups = 0;
            strQuery = "select * from t_sim_cards_info where Batch_Sequence_ID = " + nBatchID + " limit 1";

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TSimCardsInfo.class);
            records = sqlQuery.list();

            if (records.size() > 0) {
                TSimCardsInfo simCardInfo = (TSimCardsInfo) records.get(0);
                nMaxTopups = simCardInfo.getMaxTopups();
            }
        }

        String strResult = "<unit_purchase_value>";
        strResult += "<unit_price value=\"" + fValue + "\" probable_sale_price=\"" + fSalePrice + "\" face_value=\"" + fFaceValue + "\"";
        strResult += " cost_price=\"" + fCostPrice + "\" max_topups=\"" + nMaxTopups + "\"/>";
        strResult += "</unit_purchase_value>";

        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<unit_purchase_value></unit_purchase_value>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
