<%@ page import="java.text.DecimalFormatSymbols" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strSupplier = request.getParameter("supplier_id");
    String strCustomer = request.getParameter("customer_id");

    DecimalFormat ff = new DecimalFormat("0.00", DecimalFormatSymbols.getInstance(Locale.ENGLISH));

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

            String strQuery_new = "from TCustomerCommission where Product_ID = " + prodInfo.getId();
            strQuery_new += (" AND Customer_ID = " + Integer.parseInt(strCustomer));

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
            float fGroupBasePrice = 0.0f;
            if (batchList.size() > 0) {
                TBatchInformation batchInfo = (TBatchInformation) batchList.get(0);
                fUnitPrice = batchInfo.getUnitPurchasePrice();
                fGroupBasePrice = fUnitPrice;
            }

            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

            String strBasePriceQuery = "from TCustomerGroupCommissions where Product_ID = " + prodInfo.getId() +
                    " and Customer_Group_ID = " + nCustomerGroupID;

            Query queryGrpComm = theSession.createQuery(strBasePriceQuery);
            List groupCommList = queryGrpComm.list();
            if (groupCommList.size() > 0) {
                TCustomerGroupCommissions groupCommission = (TCustomerGroupCommissions) groupCommList.get(0);
                fGroupBasePrice = fUnitPrice + groupCommission.getCommission();
            }

            if (records_new.size() == 1) {
                TCustomerCommission custcomm = (TCustomerCommission) records_new.get(0);
                if (custcomm.getCustomer().getGroup().getId().intValue() == nCustomerGroupID) {
                    String strNotes = custcomm.getNotes();
                    if (strNotes == null || strNotes.isEmpty() || strNotes.compareToIgnoreCase("null") == 0)
                        strNotes = "";
                    strResult += "<product id=\"" + prodInfo.getId() +
                            "\" name=\"" + prodInfo.getProductName() +
                            "\" face_value=\"" + ff.format(prodInfo.getProductFaceValue()) +
                            "\" unit_price=\"" + ff.format(fGroupBasePrice) +
                            "\" group_commission=\"" + ff.format(custcomm.getCommission()) +
                            "\" agent_commission=\"" + ff.format(custcomm.getAgentCommission()) +
                            "\" notes=\"" + strNotes +
                            "\" active=\"" + custcomm.getActiveStatus() + "\"/>";
                }
            } else {
                strResult += "<product id=\"" + prodInfo.getId() +
                        "\" name=\"" + prodInfo.getProductName() +
                        "\" face_value=\"" + ff.format(prodInfo.getProductFaceValue()) +
                        "\" unit_price=\"" + ff.format(fGroupBasePrice) +
                        "\" group_commission=\"" + 0 +
                        "\" agent_commission=\"" + 0 +
                        "\" notes=\"" + "" +
                        "\" active=\"" + 0 + "\"/>";
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
