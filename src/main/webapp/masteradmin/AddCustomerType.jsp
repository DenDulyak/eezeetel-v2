<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCustomerType = request.getParameter("customer_type");
    String strCustomerTypeDesc = request.getParameter("customer_type_desc");
    String strNotes = request.getParameter("notes");

    String strQuery = "insert into t_master_customertype (Customer_Type, Customer_Type_Description, " +
            "Customer_Type_Active_Status, Notes) values('" + strCustomerType + "', '" +
            strCustomerTypeDesc + "', 1, '" + strNotes + "')";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("ManageCustomerType.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add Customer Type.</FONT></H4>" +
                "<A HREF=\"ManageCustomerType.jsp\">Manage Customer Type</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
