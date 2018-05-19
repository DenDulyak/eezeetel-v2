<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    int nCustomerId = Integer.parseInt(request.getParameter("customer_id"));
    int nProductId = Integer.parseInt(request.getParameter("product_id"));
    short nCommissionType = Short.parseShort(request.getParameter("commissiontype"));
    float fCommission = Float.parseFloat(request.getParameter("commission"));
    String strCreatedBy = request.getParameter("created_by");
    String strNotes = request.getParameter("notes");

    String strQuery = "insert into t_customer_commission(Customer_ID, Product_ID, CommissionType, Commission,Active_Status, " +
            " Created_By,Creation_Time,Last_Modified_Time,Notes) values(" + nCustomerId + "," + nProductId + "," +
            nCommissionType + "," + fCommission + ", 1, '" + strCreatedBy + "', now(), now(),'" + strNotes + "')";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("ManageCustomerCommission.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add Customer Commission.</FONT></H4>" +
                "<A HREF=\"ManageCustomerCommission.jsp\">Manage Customer Commission</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
