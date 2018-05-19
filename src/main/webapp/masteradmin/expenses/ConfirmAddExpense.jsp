<%@page import="com.utilities.ExpenseUpload"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String expenseFoloder = application.getInitParameter("EXPENSES_FOLDER");

	ExpenseUpload expenseUpload = new ExpenseUpload();
	expenseUpload.m_strExpenseFoloder = expenseFoloder;
	if (expenseUpload.processData(request))
		response.sendRedirect("ManageExpenses.jsp");
	else
	{
		String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to add new expense.</FONT></H4>" + 
		"<A HREF=\"ManageExpenses.jsp\">Manage Expenses</A></BODY></HTML>";
		response.getWriter().println(strError);
	}
%>