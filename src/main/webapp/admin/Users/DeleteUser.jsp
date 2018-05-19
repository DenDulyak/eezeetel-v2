<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String ksContext = application.getContextPath();
	String strCountry = application.getInitParameter("Country");
	String record_id = request.getParameter("record_id");

	Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

	String strQuery = "update t_master_users set User_Active_Status = 0"
						+ ", User_Modified_Time = now()" //, User_Type_And_Privilege = 1"
						+ " where User_Login_ID = '" + record_id + "'" 
						+ " and User_Active_Status = 1"
						+ " and Customer_Group_ID = " + nCustomerGroupID;

	DatabaseHelper dbHelper = new DatabaseHelper();	
	dbHelper.setCountry(strCountry);
	if (dbHelper.executeQuery(strQuery))
		response.sendRedirect(ksContext + "/admin/Users/ManageUser.jsp");
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Delete User</FONT></H4>" + 
				"<A HREF=\"" + ksContext + "/admin/Users/ManageUser.jsp\">Manage User Information</A></BODY></HTML>";

		response.getWriter().println(strError);
	}
%>
