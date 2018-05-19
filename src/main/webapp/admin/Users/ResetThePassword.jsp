<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ page import="org.apache.catalina.realm.JDBCRealm" %>

<%
    String userID = request.getParameter("user_to_clear");

    if (userID != null && userID.length() > 0) {
        String newPassword = userID + "123456";
        if (newPassword.length() > 12)
            newPassword = newPassword.substring(0, 12);
        String strEncryptedNewPassword = JDBCRealm.Digest(newPassword, "MD5", "utf8");

        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

        String strQuery = "update t_master_users set Password = '" + strEncryptedNewPassword + "'"
                + " where User_Login_ID = '" + userID + "'"
                + " and User_Active_Status = 1 and Customer_Group_ID = " + nCustomerGroupID;

        DatabaseHelper dbHelper = new DatabaseHelper();
        if (dbHelper.executeQuery(strQuery)) {
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\"> " + userID + " password has been reset to " + newPassword + ".</FONT></H4>" +
                    "<br><br><A HREF='/admin'>Admin Main</A></BODY></HTML>";
            response.getWriter().println(strError);
        } else {
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to reset the password.</FONT></H4>" +
                    "<A HREF='/admin'>Admin Main</A></BODY></HTML>";
            response.getWriter().println(strError);
        }
    } else
        response.sendRedirect("/admin");
%>