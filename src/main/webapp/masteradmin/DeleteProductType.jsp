<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strQuery = "update t_master_producttype set Product_Type_Active_Status = 0 "
            + " where Product_Type_ID = " + record_id
            + " and Product_Type_Active_Status = 1";

    DatabaseHelper dbHelper = new DatabaseHelper();
    dbHelper.setCountry(strCountryCode);
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("/masteradmin/ManageProductType.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Delete Product Type.</FONT></H4>" +
                "<A HREF='manage-product-sale-info'>Manage Product Type</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
