<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ include file="/common/SessionCheck.jsp" %>

<%
    String changeText = "Failed to change the password.  Please try again later";
    String strUserID = request.getRemoteUser();
    String strPassword = request.getParameter("j_password");
    String strNewPassword = request.getParameter("j_new_password");
    if (strUserID != null && !strUserID.isEmpty()) {
        DatabaseHelper dbHelper = new DatabaseHelper();
        dbHelper.setCountry(strCountryCode);
        if (dbHelper.updateUserPassword(strUserID, strPassword, strNewPassword))
            changeText = "Password changed successfully.";
    }
%>

<html>
<head>
</head>
<body>

<%=changeText%>
<br>
<br>
<a href="/customer/products">Show Products</a>

</body>
</html>