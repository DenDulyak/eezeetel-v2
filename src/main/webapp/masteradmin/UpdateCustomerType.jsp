<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String strCountryCode = application.getInitParameter("Country");
	int record_id = Integer.parseInt(request.getParameter("record_id"));
	String strCustomerType = request.getParameter("customer_type");
	String strCustomerTypeDesc  = request.getParameter("customer_type_desc");
	String strNotes = request.getParameter("notes");

	String strQuery = "update t_master_customertype set Customer_Type = '" + strCustomerType + "',"
						+ "Customer_Type_Description = '" + strCustomerTypeDesc + "',"
						+" Notes = '" + strNotes + "'"
						+ " where Customer_Type_ID = " + record_id;
	
	DatabaseHelper dbHelper = new DatabaseHelper();	
	dbHelper.setCountry(strCountryCode);
	if (dbHelper.executeQuery(strQuery))
		response.sendRedirect("ManageCustomerType.jsp");	
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Customer Type</FONT></H4>" + 
		"<A HREF=\"ManageCustomerType.jsp\">Manage Customer Type </A></BODY></HTML>";

		response.getWriter().println(strError);
	}
%>
