<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strProductId = request.getParameter("product_id");
    String strIsNewBatch = request.getParameter("new_batch");
    int isNewBatch = 0;
    int nPreviousBatchSaleInfoID = 0;
    if (strIsNewBatch != null && !strIsNewBatch.isEmpty())
        isNewBatch = Integer.parseInt(strIsNewBatch);

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        String strQuery = "";
        if (strProductId != null && !strProductId.isEmpty()) {
            strQuery = "SELECT Sale_Info_ID FROM t_batch_information where Product_ID = " +
                    Integer.parseInt(strProductId) + " order by Batch_Entry_Time desc limit 1";
            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Sale_Info_ID", new IntegerType());
            List oneRecord = sqlQuery.list();
            if (oneRecord.size() > 0)
                nPreviousBatchSaleInfoID = (Integer) oneRecord.get(0);
        }

        strQuery = "from TMasterProductsaleinfo where IsActive = 1";
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<product_sale_information>";

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterProductsaleinfo prodSaleInfo = (TMasterProductsaleinfo) records.get(nIndex);
            TMasterProductinfo prodInfo = (TMasterProductinfo) prodSaleInfo.getProduct();

            String strSelected = "0";
            if (isNewBatch == 1) {
                if (nPreviousBatchSaleInfoID != 0 && nPreviousBatchSaleInfoID == prodSaleInfo.getId())
                    strSelected = "1";
            } else {
                if (strProductId != null && !strProductId.isEmpty())
                    if (prodInfo.getId() == Integer.parseInt(strProductId))
                        strSelected = "1";
            }

            strResult += "<product_sale_info id=\"" + prodSaleInfo.getId() + "\"" +
                    " product_id=\"" + prodInfo.getId() + "\"" +
                    " selected=\"" + strSelected + "\"" + "/>";
        }

        strResult += "</product_sale_information>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<product_sale_information></product_sale_information>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>