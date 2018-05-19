'
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.utilities.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strImageFolder = application.getInitParameter("IMAGES_FOLDER");
    if (strImageFolder != null && !strImageFolder.isEmpty()) {
        //ImageUpload.m_strImageFolder = strImageFolder;
    }
    UpdateSaleInfo updateSale = new UpdateSaleInfo();
    if (updateSale.processData(request))
        response.sendRedirect("manage-product-sale-info");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to update product sale information.</FONT></H4>" +
                "<A HREF=\"manage-product-sale-info\">Manage Product Sale Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
