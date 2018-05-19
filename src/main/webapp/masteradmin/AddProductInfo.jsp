<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<%@ include file="/common/imports.jsp" %>
<%@ page import="com.utilities.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    String strProductName = request.getParameter("product_name");
    int nProductTypeID = Integer.parseInt(request.getParameter("product_type_id"));
    float fFaceValue = Float.parseFloat(request.getParameter("face_value"));
    String strProductDesc = request.getParameter("product_desc");
    String strNotes = request.getParameter("notes");
    String strProductCreatedBy = request.getParameter("product_created_by");
    int nSupplierId = Integer.parseInt(request.getParameter("supplier_id"));
    String strUserName = request.getRemoteUser();
    String strCalcVAT = request.getParameter("caliculate_vat");
    short nCalcVAT = 0;
    if (strCalcVAT != null && strCalcVAT.compareToIgnoreCase("on") == 0)
        nCalcVAT = 1;

    String strQuery = "insert into t_master_productinfo (Supplier_ID, Product_Name, Product_Type_ID, " +
            "Product_Face_Value, Product_Description, Product_Active_Status, Product_Created_By, " +
            "Product_Creation_Time, Notes, Caliculate_VAT) values (" + nSupplierId + ",'" + strProductName + "'," + nProductTypeID +
            "," + fFaceValue + ", '" + strProductDesc + "', 1, '" + strProductCreatedBy + "', now(), '" + strNotes + "'," + nCalcVAT + ")";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery)) {
        response.sendRedirect("ManageProductInfo.jsp");
    } else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add Product Information.</FONT></H4>" +
                "<A HREF=\"ManageProductInfo.jsp\">Manage Product Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
