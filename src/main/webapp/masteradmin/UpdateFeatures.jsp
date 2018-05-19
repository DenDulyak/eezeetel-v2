<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String strCountryCode = application.getInitParameter("Country");
	int featureID = Integer.parseInt(request.getParameter("Customer_Features_ID"));

	String strQuery = "update t_master_customerinfo set Customer_Feature_ID = " + featureID + " where Customer_ID != 743";

	DatabaseHelper dbHelper = new DatabaseHelper();	
	dbHelper.setCountry(strCountryCode);
	if (dbHelper.executeQuery(strQuery))
		response.sendRedirect("MasterInformation.jsp");	
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Customer Features</FONT></H4>" + 
		"<A HREF=\"MasterInformation.jsp\">Go to Main</A></BODY></HTML>";

		response.getWriter().println(strError);
	}
%>