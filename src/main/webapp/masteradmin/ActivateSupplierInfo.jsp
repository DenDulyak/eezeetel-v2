<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strQuery = "update t_master_supplierinfo set Supplier_Active_Status = 1"
            + " where Supplier_ID = " + record_id
            + " and Supplier_Active_Status = 0";

    DatabaseHelper dbHelper = new DatabaseHelper();
    dbHelper.setCountry(strCountryCode);
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("/masteradmin/manage-supplier");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Delete Suppplier.</FONT></H4>" +
                "<a href='/masteradmin/manage-supplier'>Manage Suppplier Information</a</BODY></HTML>";
        response.getWriter().println(strError);
    }
%>
