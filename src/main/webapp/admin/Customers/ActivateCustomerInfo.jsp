<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<%@ include file="/common/SessionCheck.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String strCountry = application.getInitParameter("Country");
	Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
	int record_id = Integer.parseInt(request.getParameter("record_id"));
	String strQuery = "update t_master_customerinfo set Active_Status = 1"
						+ ", Last_Modified_Time = now()"
						+ " where Customer_ID = " + record_id 
						+ " and Active_Status = 0 and Customer_Group_ID = " + nCustomerGroupID;

	DatabaseHelper dbHelper = new DatabaseHelper();
	dbHelper.setCountry(strCountry);
	if (dbHelper.executeQuery(strQuery))
		response.sendRedirect (ksContext + "/admin/Customers/ManageCustomerInfo.jsp");
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Activate Customer Information.</FONT></H4>" + 
		"<A HREF=\"" + ksContext + "/admin/Customers/ManageCustomerInfo.jsp\">Manage Customer Information</A></BODY></HTML>";

		response.getWriter().println(strError);
	}
%>
