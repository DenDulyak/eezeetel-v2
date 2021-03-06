<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strQuery1 = "update t_master_customerinfo set Active_Status = 0"
            + ", Last_Modified_Time = now()"
            + " where Customer_ID = " + record_id
            + " and Active_Status = 1 and Customer_Group_ID = " + nCustomerGroupID;

    String strQuery2 = "update t_master_users set User_Active_Status = 0"
            + ", User_Modified_Time = now()"
            + " where Customer_Group_ID = " + nCustomerGroupID +
            " and User_Login_ID in (select User_Login_ID from t_customer_users where Customer_ID = " + record_id + ")";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeMultipleQuery(strQuery1, strQuery2)) {
        response.sendRedirect("/admin/Customers/ManageCustomerInfo.jsp");
    }
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Delete Customer Information.</FONT></H4>" +
                "<A HREF='/admin/Customers/ManageCustomerInfo.jsp'>Manage Customer Information</A></BODY></HTML>";
        response.getWriter().println(strError);
    }
%>
