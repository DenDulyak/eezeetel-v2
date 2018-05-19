<%@page import="com.utilities.ImageUpload" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strImageFolder = application.getInitParameter("IMAGES_FOLDER");

    ImageUpload imgUpload = new ImageUpload();
    if (strImageFolder != null && !strImageFolder.isEmpty())
        ImageUpload.m_strImageFolder = strImageFolder;

    if (imgUpload.uploadSupplierImage(request, false))
        response.sendRedirect("manage-supplier");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Supplier Information</FONT></H4>" +
                "<A HREF='manage-supplier'>Manage Supplier Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
