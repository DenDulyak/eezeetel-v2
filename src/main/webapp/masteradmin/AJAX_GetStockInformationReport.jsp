<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    response.setContentType("text/xml");
    String xmlData = "<report>";
    String strQuery = "select t1.Product_ID, t2.Product_Name, t3.Supplier_Name, t2.Product_Face_Value, sum(t1.Quantity) as Quantity, " +
            "sum(t1.Available_Quantity) as Available_Quantity, t1.Unit_Purchase_Price " +
            " from t_batch_information t1, t_master_productinfo t2, t_master_supplierinfo t3 where t1.Product_ID = t2.Product_ID " +
            " and t1.Supplier_ID = t3.Supplier_ID and Batch_Activated_By_Supplier = 1 and Batch_Ready_To_Sell = 1 and IsBatchActive = 1 " +
            " and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
            " group by t1.Supplier_ID, t1.Product_ID order by Supplier_Name, Product_Name";

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("Product_ID", new IntegerType());
        sqlQuery.addScalar("Product_Name", new StringType());
        sqlQuery.addScalar("Supplier_Name", new StringType());
        sqlQuery.addScalar("Product_Face_Value", new FloatType());
        sqlQuery.addScalar("Quantity", new IntegerType());
        sqlQuery.addScalar("Available_Quantity", new IntegerType());
        sqlQuery.addScalar("Unit_Purchase_Price", new FloatType());
        List report = sqlQuery.list();

        for (int i = 0; i < report.size(); i++) {
            Object[] oneRecord = (Object[]) report.get(i);
            if (oneRecord.length > 0) {
                Integer nProductID = (Integer) oneRecord[0];
                String strProductName = (String) oneRecord[1];
                String strSupplierName = (String) oneRecord[2];
                Float fFaceValue = (Float) oneRecord[3];
                Integer quantity = (Integer) oneRecord[4];
                Integer availQuantity = (Integer) oneRecord[5];
                Float fUnitPrice = (Float) oneRecord[6];
                if (availQuantity == 0) continue;

                xmlData += "<record ";
                xmlData += (" product_id = \"" + nProductID + "\" ");
                xmlData += (" product_name = \"" + strProductName + "\" ");
                xmlData += (" supplier_name = \"" + strSupplierName + "\" ");
                xmlData += ("face_value = \"" + fFaceValue + "\" ");
                xmlData += ("quantity = \"" + quantity + "\" ");
                xmlData += ("available_quantity = \"" + availQuantity + "\" ");
                xmlData += ("unit_price = \"" + fUnitPrice + "\" ");
                xmlData += "/>";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
    xmlData += "</report>";
    response.getWriter().println(xmlData);
%>