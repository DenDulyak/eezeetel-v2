<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String strCountryCode = application.getInitParameter("Country");
	int nCustomerId 			= Integer.parseInt(request.getParameter("customer_id"));
	int nProductId				= Integer.parseInt(request.getParameter("product_id"));
	short nCommissionType		= Short.parseShort(request.getParameter("commissiontype"));
	float fCommission			= Float.parseFloat(request.getParameter("commission"));
	String strNotes				= request.getParameter("notes");

	String strQuery = "update t_customer_commission set CommissionType = " + nCommissionType + ","
						+ "Commission = " + fCommission + ","
						+" Notes = '" + strNotes + "'," + "Last_Modified_Time = now()" 
						+ " where Customer_ID = " + nCustomerId
						+ " and Product_ID = " + nProductId;
	
	DatabaseHelper dbHelper = new DatabaseHelper();	
	dbHelper.setCountry(strCountryCode);
	if (dbHelper.executeQuery(strQuery))
		response.sendRedirect("ManageCustomerCommission.jsp");	
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Customer Commission</FONT></H4>" + 
		"<A HREF=\"ManageCustomerCommission.jsp\">Manage Customer Commission </A></BODY></HTML>";

		response.getWriter().println(strError);
	}
%>
