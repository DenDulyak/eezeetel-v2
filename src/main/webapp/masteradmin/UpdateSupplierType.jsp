<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strUserType = request.getParameter("supplier_type");
    String strUserDesc = request.getParameter("supplier_type_desc");
    String strNotes = request.getParameter("notes");

    String strQuery = "update t_master_suppliertype set Supplier_Type = '" + strUserType + "',"
            + "Supplier_Type_Description = '" + strUserDesc + "',"
            + "Notes = '" + strNotes + "' "
            + " where Supplier_Type_ID = " + record_id;

    DatabaseHelper dbHelper = new DatabaseHelper();
    dbHelper.setCountry(strCountryCode);
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("ManageSupplierType.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Supplier Type</FONT></H4>" +
                "<A HREF=\"ManageSupplierType.jsp\">Manage Supplier Type</A></BODY></HTML>";
        response.getWriter().println(strError);
    }
%>
