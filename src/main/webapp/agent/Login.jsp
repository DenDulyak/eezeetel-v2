<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String ksContext = application.getContextPath();
%>
<html>
<head>
<base target="_top">
<!-- <iframe src="http://localhost:8080/AgentApp/" height="300" width="300"></iframe> -->
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
<script language="javascript" src="<%=ksContext%>/js/validate.js"></script>
<script language="javascript">
function validate_and_submit()
{
	if (IsNULL(document.the_form.j_username.value))
	{
		alert("Please enter proper user id");
		document.the_form.j_username.focus();
		return;
	}

	if (!AlphaNumerals(document.the_form.j_username.value))
	{
		alert("User ID can only have alphabets and digits");
		document.the_form.j_username.focus();
		return;
	}		

	if (IsNULL(document.the_form.j_password.value))
	{
		alert("Please enter proper password");
		document.the_form.j_password.focus();
		return;
	}

	if (!AlphaNumerals(document.the_form.j_password.value))
	{
		alert("Password can only have alphabets and digits");
		document.the_form.j_password.focus();
		return;
	}
	
	document.the_form.action = "j_security_check";
	document.the_form.submit();	
}
</script>
</head>
<body>

<form name="the_form" method="post" action="">
	<table>
		<tr> <td align="right"> User ID : </td> <td> <input type="text" name="j_username" maxlength="12" size="12"> </td> </tr>
		<tr> <td align="right"> Password : </td> <td> <input type="password" name="j_password" maxlength="12" size="12"> </td> </tr>
		<tr> <td></td><td> <input type="button" value="Login" onClick="validate_and_submit()"> </td> </tr>
	</table>
</form>
</body>
</html>