<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<% 
	String strCountryCode = application.getInitParameter("Country");
	String strSupplierType = request.getParameter("supplier_type");
	String strSupplierTypeDesc = request.getParameter("supplier_type_desc");
	String strNotes = request.getParameter("notes");
	
	String strQuery = "insert into t_master_suppliertype (Supplier_Type, Supplier_Type_Description, " +
						"Supplier_Type_Active_Status, Notes) values ('" + strSupplierType +"', '" + strSupplierTypeDesc +
							"', 1, '" + strNotes + "')";

	DatabaseHelper dbHelper = new DatabaseHelper();
	dbHelper.setCountry(strCountryCode);
	if (dbHelper.executeQuery(strQuery))
		response.sendRedirect("ManageSupplierType.jsp");
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add Supplier Type.</FONT></H4>" + 
		"<A HREF=\"ManageSupplierType.jsp\">Manage Supplier Type</A></BODY></HTML>";

		response.getWriter().println(strError);
	}
%>
