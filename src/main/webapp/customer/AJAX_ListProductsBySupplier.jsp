<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Session theSession = null;
    try {
        String userAgent = request.getHeader("User-Agent");
        String strButtonStyle = "product_type";
        if (userAgent.compareToIgnoreCase("CallingCardsApp") == 0)
            strButtonStyle = "product_type_till";

        String strSupplierID = request.getParameter("supplier_id");

        String strQuery = "select T1.Product_ID, T1.Product_Name, T1.Product_Face_Value, sum(T2.Available_Quantity) as Available_Quantity " +
                " from t_master_productinfo T1, t_batch_information T2 " +
                " where T1.Product_ID = T2.Product_ID" + " and T1.Supplier_ID = " + strSupplierID +
                " and Product_Active_Status = 1 and Product_Type_ID != 17 " +
                " and IsBatchActive = 1 and Batch_Activated_By_Supplier = 1 and Batch_Ready_To_Sell = 1 " +
                " and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB'" +
                " group by T2.Product_ID order by T1.Product_Face_Value, T1.Product_Name";

        theSession = HibernateUtil.openSession();

        SQLQuery query = theSession.createSQLQuery(strQuery);
        query.addScalar("Product_ID", new IntegerType());
        query.addScalar("Product_Name", new StringType());
        query.addScalar("Product_Face_Value", new FloatType());
        query.addScalar("Available_Quantity", new IntegerType());

        List records = query.list();

        String strResult = "<table width=\"100%\">";

        boolean addTR = false;
        for (int i = 0, nDisplayedCards = 0; i < records.size(); i++) {
            Object[] oneRecord = (Object[]) records.get(i);
            int nProductID = (Integer) oneRecord[0];
            String strProductName = (String) oneRecord[1];
            Float strFaceValue = (Float) oneRecord[2];
            int nAvailableQuantity = (Integer) oneRecord[3];
            if (nAvailableQuantity <= 0) continue;

            strQuery = "select Product_Image_File from t_master_productsaleinfo where IsActive = 1 and Sale_Info_ID = " +
                    "(select Sale_Info_ID from t_batch_information where Product_ID = " + nProductID +
                    " order by Available_Quantity limit 1)";

            SQLQuery imageFileQuery = theSession.createSQLQuery(strQuery);
            imageFileQuery.addScalar("Product_Image_File", new StringType());
            List imageFileRecord = imageFileQuery.list();
            String imgFile = "";
            if (imageFileRecord.size() > 0)
                imgFile = imageFileRecord.get(0).toString();

            if (imgFile == null || imgFile.isEmpty() || imgFile.compareToIgnoreCase("null") == 0)
                imgFile = "";

            if ((nDisplayedCards % 4) == 0) {
                if (nDisplayedCards != 0)
                    strResult += "</tr>";
                strResult += "<tr>";
            }
            strResult += "<td>";

            String oneEntry = "<table cellpadding=\"10\"><tr>";
            oneEntry += "<td valign=\"bottom\" align=\"center\" nowrap onmouseover=\"this.className='highlight'\"" + " onmouseout=\"this.className='product_normal'\">";
            oneEntry += "<input class=\"" + strButtonStyle + "\" type=\"image\" src=\"" + imgFile + "\"" +
                    " onClick=\"do_transaction(" + nProductID + ")\"" +
                    " alt=\"" + strProductName + " - " + strFaceValue + "\"" + "/></td></tr>";

            strQuery = "from TMasterSupplierinfo where Supplier_ID = " + strSupplierID;
            Query thequery = theSession.createQuery(strQuery);
            List supplierList = thequery.list();
            boolean bShowMultipleQuantity = true;
            if (supplierList != null && supplierList.size() > 0) {
                TMasterSupplierinfo supInfo = (TMasterSupplierinfo) supplierList.get(0);
                if (supInfo.getSupplierType().getId() == 16)
                    bShowMultipleQuantity = false;
            }

            if (bShowMultipleQuantity) {
                oneEntry += "<tr><td valign=\"top\" align=\"left\">Quantity: <select name=\"" + nProductID + "\" onChange=\"add_required_products(" + nProductID + ")\">";
                for (int n = 0; n <= nAvailableQuantity; n++) {
                    oneEntry += ("<option value=" + n + ">" + n + "</option>");
                    if (n == 5) break;
                }
                oneEntry += "</select></td></tr>";
            }

            oneEntry += "</table>";

            strResult += oneEntry;

            strResult += "</td>";
            if ((nDisplayedCards + 1 == records.size()))
                strResult += "</tr>";
            nDisplayedCards++;
        }

        strResult += "</table>";

        response.setContentType("text/plain");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/plain");
        response.getWriter().println("");
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>

