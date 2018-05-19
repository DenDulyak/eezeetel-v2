<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    StringBuffer baseContext = request.getRequestURL();
    int nIndex = baseContext.lastIndexOf("/");
    String baseContextPath = baseContext.substring(0, nIndex + 1);
    String strFailed = request.getParameter("failed");
    if (strFailed != null && !strFailed.isEmpty())
        strFailed = "Failed to Login.  Please try again.";
    else
        strFailed = "";
%>
<html>
<head>
    <base target="_top">
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login</title>
    <script type="text/javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function validate_and_submit() {
            if (IsNULL(document.the_form.j_username.value)) {
                alert("Please enter proper user id");
                document.the_form.j_username.focus();
                return;
            }

            if (!AlphaNumerals(document.the_form.j_username.value)) {
                alert("User ID can only have alphabets and digits");
                document.the_form.j_username.focus();
                return;
            }

            if (IsNULL(document.the_form.j_password.value)) {
                alert("Please enter proper password");
                document.the_form.j_password.focus();
                return;
            }

            if (!AlphaNumerals(document.the_form.j_password.value)) {
                alert("Password can only have alphabets and digits");
                document.the_form.j_password.focus();
                return;
            }

            document.the_form.action = "/login";
            document.the_form.submit();
        }
    </script>
</head>
<body>

<form name="the_form" method="post" action="">
    <H1>Welcome Mobitopup Customer</H1>
    <br><br>
    <%=strFailed%>
    <table>
        <tr>
            <td align="right"> User ID :</td>
            <td><input type="text" id="j_username" name="j_username" maxlength="12" size="12"></td>
        </tr>
        <tr>
            <td align="right"> Password :</td>
            <td><input type="password" id="j_password" name="j_password" maxlength="12" size="12"></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="button" id="butn_5" value="Login" onClick="validate_and_submit()"></td>
        </tr>
    </table>
</form>
</body>
</html>
