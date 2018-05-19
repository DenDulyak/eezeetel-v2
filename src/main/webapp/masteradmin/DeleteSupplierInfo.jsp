<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html>

<%
    String strCountryCode = application.getInitParameter("Country");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strQuery = "update t_master_supplierinfo set Supplier_Active_Status = 0"
            + " where Supplier_ID = " + record_id
            + " and Supplier_Active_Status = 1";

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
