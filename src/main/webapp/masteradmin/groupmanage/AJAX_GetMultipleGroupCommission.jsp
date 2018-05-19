<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSupplier = request.getParameter("supplier_id");
    String strCustomerGroup = request.getParameter("customer_group_id");

    String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
    if (strSupplier != null && !strSupplier.isEmpty())
        strQuery += (" AND Supplier_ID = " + Integer.parseInt(strSupplier));
    strQuery += " order by Product_Name";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<product_names>";

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);

            String strQuery_new = "from TCustomerGroupCommissions where Product_ID = " + prodInfo.getId();
            strQuery_new += (" AND Customer_Group_ID = " + Integer.parseInt(strCustomerGroup));

            Query query_new = theSession.createQuery(strQuery_new);
            List records_new = query_new.list();

            String strBatchQuery = "from TBatchInformation where Product_ID = " + prodInfo.getId() +
                    //" and Supplier_ID = " + strSupplier +
                    " and Batch_Activated_By_Supplier = 1 " +
                    " and Batch_Ready_To_Sell = 1 and IsBatchActive = 1 " +
                    " order by SequenceID desc";

            Query query1 = theSession.createQuery(strBatchQuery);
            query1.setMaxResults(1);
            List batchList = query1.list();
            if (batchList.size() <= 0) {
                strBatchQuery = "select * from t_history_batch_information where Product_ID = " + prodInfo.getId() +
                        " and Supplier_ID = " + strSupplier +
                        " and Batch_Activated_By_Supplier = 1 " +
                        " and Batch_Ready_To_Sell = 1 and IsBatchActive = 1 " +
                        " order by SequenceID desc limit 1";

                SQLQuery sqlQuery = theSession.createSQLQuery(strBatchQuery);
                sqlQuery.addEntity(TBatchInformation.class);
                batchList = sqlQuery.list();
            }

            float fUnitPrice = 0.0f;
            if (batchList.size() > 0) {
                TBatchInformation batchInfo = (TBatchInformation) batchList.get(0);
                fUnitPrice = batchInfo.getUnitPurchasePrice();
            }


            if (records_new.size() == 1) {
                TCustomerGroupCommissions custgroupcomm = (TCustomerGroupCommissions) records_new.get(0);
                String strNotes = custgroupcomm.getNotes();
                if (strNotes == null || strNotes.isEmpty() || strNotes.compareToIgnoreCase("null") == 0)
                    strNotes = "";

                strResult += "<product id=\"" + prodInfo.getId() +
                        "\" name=\"" + prodInfo.getProductName() +
                        "\" face_value=\"" + prodInfo.getProductFaceValue() +
                        "\" eezeetel_commission=\"" + custgroupcomm.getCommission() +
							/*"\" agent_commission=\"" + custcomm.getAgentCommission() +*/
                        "\" notes=\"" + strNotes +
                        "\" active=\"" + custgroupcomm.getActiveStatus() +
                        "\" unit_price=\"" + fUnitPrice + "\"/>";
            } else {
                strResult += "<product id=\"" + prodInfo.getId() +
                        "\" name=\"" + prodInfo.getProductName() +
                        "\" face_value=\"" + prodInfo.getProductFaceValue() +
                        "\" eezeetel_commission=\"" + 0 +
				/*"\" agent_commission=\"" + 0 +*/
                        "\" notes=\"" + "" +
                        "\" active=\"" + 0 +
                        "\" unit_price=\"" + fUnitPrice + "\"/>";
            }
        }

        strResult += "</product_names>";

        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<product_names></product_names>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
