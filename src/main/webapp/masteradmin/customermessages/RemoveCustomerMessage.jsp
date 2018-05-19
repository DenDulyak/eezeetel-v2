<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>    
<%
	String strMessage = request.getParameter("the_message");
	
	int nCustomerGroupID = 0;
	String strGroupID = request.getParameter("customer_group_id");
	if (strGroupID == null && !strGroupID.isEmpty())
		nCustomerGroupID = Integer.parseInt(strGroupID);
	
	String strQuery1 = "delete from t_messages where Target_Group = " + nCustomerGroupID;	

	DatabaseHelper dbHelper = new DatabaseHelper();
	if (dbHelper.executeQuery(strQuery1))
			response.sendRedirect("/masteradmin/MasterInformation.jsp");
	
	String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Remove Existing.</FONT></H4>" + 
	"<A HREF=\"/masteradmin/MasterInformation.jsp\"Go To Main</A></BODY></HTML>";
	response.getWriter().println(strError);
%>    
