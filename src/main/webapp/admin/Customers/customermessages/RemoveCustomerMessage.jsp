<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strQuery1 = "delete from t_messages where Target_Group = " + nCustomerGroupID;

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery1))
        response.sendRedirect("/admin");

    String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Remove Existing Message</FONT></H4>" +
            "<A HREF=\"/admin\"Admin Main</A></BODY></HTML>";
    response.getWriter().println(strError);
%>    
