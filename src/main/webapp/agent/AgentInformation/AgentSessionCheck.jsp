<%@ include file="/common/imports.jsp"%>

<%
String ksContext = application.getContextPath(); // returns /CustomerApp, /GSMApp
if (!session.isNew()) {
	response.addHeader("Pragma", "no-cache");
	response.addHeader("Expires", "-1");
	
	DatabaseHelper dbHelper = new DatabaseHelper();
	String currentSessionId = request.getSession().getId();
	String strUserID = (String) session.getAttribute("USER_ID");
	
	if (strUserID == null || strUserID.length() < 0) {
		strUserID = request.getRemoteUser();
		session.setAttribute("USER_ID", strUserID);
		
		String strQuery = "insert into t_user_log (User_Login_ID, Login_Time, Login_Status, SessionID) values ( '" +
			strUserID + "', now(), 1, '" + currentSessionId + "')";

		if (!dbHelper.executeQuery(strQuery)) {
			System.out.println("Failed to add to user log (LOGIN) User " + strUserID);
			session.invalidate();
		}

		response.sendRedirect(ksContext + "/AgentInformation/AgentInformation.jsp");
		return;
	} else {
		String previousSessionID = dbHelper.checkForLatestSession(strUserID, currentSessionId);
		if (previousSessionID != null && !previousSessionID.isEmpty()) {
			session.invalidate();
			response.sendRedirect(ksContext + "/AgentInformation/AgentInformation.jsp");
		}
	}
}
%>