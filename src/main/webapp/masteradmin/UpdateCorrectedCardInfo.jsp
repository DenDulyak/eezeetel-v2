<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String strCountryCode = application.getInitParameter("Country");
	Enumeration paramNames = request.getParameterNames();
	
	while(paramNames.hasMoreElements())
	{
		String filedName = paramNames.nextElement().toString();
		if (filedName.compareToIgnoreCase("transaction_id") == 0)
			continue;
		long nSequenceID = Long.parseLong(filedName);
		if (nSequenceID > 0)
		{
			String strValue = request.getParameter(filedName);
			if (strValue != null && !strValue.isEmpty())
			{
				String strQuery = "update T_Card_Info set card_pin = '" + strValue + "' " +
									" where SequenceID = " + nSequenceID;
				
				DatabaseHelper dbHelper = new DatabaseHelper();
				dbHelper.setCountry(strCountryCode);
				dbHelper.executeQuery(strQuery);
				
				strQuery = "update t_history_card_info set card_pin = '" + strValue + "' " +
								" where SequenceID = " + nSequenceID;
				dbHelper.executeQuery(strQuery);

				if (!dbHelper.executeQuery(strQuery))
				{
					if (!dbHelper.executeQuery(strQuery))
					{
						String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to correct card information</FONT></H4>" + 
						"<A HREF=\"MasterInformation.jsp\">Master Information </A></BODY></HTML>";
						response.getWriter().println(strError);
					}
				}				
			}
		}
	}
	
	String strDone = "<HTML><BODY><H4><FONT COLOR=\"RED\">Updated Card Information</FONT></H4>" + 
						"<A HREF=\"MasterInformation.jsp\">Master Information </A></BODY></HTML>";
	response.getWriter().println(strDone);
%>
