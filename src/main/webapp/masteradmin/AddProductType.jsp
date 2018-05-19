<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    String strProductType = request.getParameter("product_type");
    String strProductTypeDesc = request.getParameter("product_type_desc");
    String strNotes = request.getParameter("notes");

    String strQuery = "insert into t_master_producttype (Product_Type, Product_Type_Description, Product_Type_Active_Status, Notes)" +
            "values ('" + strProductType + "', '" + strProductTypeDesc + "', 1, '" + strNotes + "')";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("ManageProductType.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add Product Type.</FONT></H4>" +
                "<A HREF=\"ManageProductType.jsp\">Manage Product Type</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
