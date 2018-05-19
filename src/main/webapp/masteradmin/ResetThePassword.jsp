<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<%@ page import="org.apache.catalina.realm.JDBCRealm" %>
<%
	String userID = request.getParameter("user_to_clear");
	String strCountryCode = application.getInitParameter("Country");

	if (userID != null && userID.length() > 0)
	{
		String newPassword = userID + "123456";
		if (newPassword.length() > 12)
			newPassword = newPassword.substring(0, 12);
		String strEncryptedNewPassword = JDBCRealm.Digest(newPassword, "MD5", "utf8");

		String strQuery = "update t_master_users set Password = '" + strEncryptedNewPassword + "'"
							+ " where User_Login_ID = '" + userID + "'"
							+ " and User_Active_Status = 1";
	
		DatabaseHelper dbHelper = new DatabaseHelper();
		dbHelper.setCountry(strCountryCode);
		if (dbHelper.executeQuery(strQuery))
		{
			String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\"> " + userID + " password has been reset to " + newPassword + ".</FONT></H4>" + 
			"<br><br><A HREF=\"MasterInformation.jsp\">Go to Main</A></BODY></HTML>";
	
			response.getWriter().println(strError);
		}
		else
		{
			String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to reset the password.</FONT></H4>" + 
			"<A HREF=\"MasterInformation.jsp\">Go to Main</A></BODY></HTML>";
	
			response.getWriter().println(strError);
		}
	}
	else
		response.sendRedirect("MasterInformation.jsp");
%>