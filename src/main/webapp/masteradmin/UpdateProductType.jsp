<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String strCountryCode = application.getInitParameter("Country");
	int record_id = Integer.parseInt(request.getParameter("record_id"));
	String strProductType = request.getParameter("product_type");
	String strProductTypeDesc  = request.getParameter("product_type_desc");
	String strNotes = request.getParameter("notes");	
	
	String strQuery = "update t_master_producttype set Product_Type = '" + strProductType + "',"
						+ "Product_Type_Description = '" + strProductTypeDesc + "',"
						+ "Notes = '" + strNotes +"'"
						+ " where Product_Type_ID = " + record_id;

	DatabaseHelper dbHelper = new DatabaseHelper();	
	dbHelper.setCountry(strCountryCode);
	if (dbHelper.executeQuery(strQuery))
		response.sendRedirect("ManageProductType.jsp");	
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Product Type</FONT></H4>" + 
		"<A HREF=\"ManageProductType.jsp\">Manage Product Type</A></BODY></HTML>";

		response.getWriter().println(strError);
	}
%>
