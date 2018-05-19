<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strMessage = request.getParameter("the_message");
    String strQuery2 = "";

    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strQuery1 = "delete from t_messages where Target_Group = " + nCustomerGroupID;

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (nCustomerGroupID > 0 && dbHelper.executeQuery(strQuery1)) {
        if (strMessage != null && !strMessage.isEmpty()) {
            strQuery2 = "insert into t_messages values (0, now(), '" + strMessage + "'," + nCustomerGroupID + ", '', DATE_ADD(now(), INTERVAL '5' DAY), 1)";
            if (dbHelper.executeQuery(strQuery2))
                response.sendRedirect("/admin");
        }
    }

    String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Setup New Message.</FONT></H4>" +
            "<A HREF=\"/admin\"Admin Main</A></BODY></HTML>";
    response.getWriter().println(strError);
%>    
