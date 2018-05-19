<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strProductName = request.getParameter("product_name");
    int nProductTypeID = Integer.parseInt(request.getParameter("product_type_id"));
    float fFaceValue = Float.parseFloat(request.getParameter("face_value"));
    String strProductDesc = request.getParameter("product_desc");
    String strNotes = request.getParameter("notes");
    int nSupplierId = Integer.parseInt(request.getParameter("supplier_id"));
    String strCalcVAT = request.getParameter("caliculate_vat");
    String costPrice = request.getParameter("cost_price");
    if (costPrice == null || costPrice.isEmpty()) {
        costPrice = "0.00";
    }

    short nCalcVAT = 0;
    if (strCalcVAT != null && strCalcVAT.compareToIgnoreCase("on") == 0)
        nCalcVAT = 1;

    String strQuery = "update t_master_productinfo set Product_Name = '" + strProductName + "',"
            + "Product_Type_ID = " + nProductTypeID + ","
            + "Product_Face_Value = " + fFaceValue + ","
            + "Supplier_ID = " + nSupplierId + ","
            + "Product_Description = '" + strProductDesc + "',"
            + "Notes = '" + strNotes + "',"
            + "COST_PRICE = '" + costPrice + "',"
            + "Caliculate_VAT = " + nCalcVAT
            + " where Product_ID = " + record_id;

    DatabaseHelper dbHelper = new DatabaseHelper();
    dbHelper.setCountry(strCountryCode);
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("ManageProductInfo.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Product Information</FONT></H4>" +
                "<A HREF=\"ManageProductInfo.jsp\">Manage Product Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
