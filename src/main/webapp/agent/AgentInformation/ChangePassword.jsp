<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<%@ include file="AgentSessionCheck.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script language="javascript" src="<%=ksContext%>/js/validate.js" type="text/javascript"></script>
<script language="javascript">
function validate_and_submit()
{
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

	if (IsNULL(document.the_form.j_new_password.value))
	{
		alert("Please enter proper new password");
		document.the_form.j_new_password.focus();
		return;
	}

	if (!AlphaNumerals(document.the_form.j_new_password.value))
	{
		alert("New Password can only have alphabets and digits");
		document.the_form.j_new_password.focus();
		return;
	}

	if (new String(document.the_form.j_password.value.toLowerCase())==(new
			String(document.the_form.j_new_password.value)).toLowerCase())
	{		
		alert("New password is same as current password.  No update required");
		return;
	}	
	document.the_form.action = "<%=ksContext%>/AgentInformation/UpdatePassword.jsp";	
	document.the_form.submit();
	document.the_form.reset();
}

</script>
<title>Change Password</title>
</head>
<body>
<form method="post" action="" name="the_form">
<table>
	<tr> <td align="right"> Password : </td> <td> <input type="password" name="j_password" maxlength="12" size="13"> </td> </tr>
	<tr> <td align="right"> New Password : </td> <td> <input type="password" name="j_new_password" maxlength="12" size="13"> </td> </tr>
	<tr> 
		<td><a href="<%=ksContext%>/AgentInformation/AgentInformation.jsp"> Go to Main </a></td>
		<td><input type="button" name="change_button" value="Change" onClick="validate_and_submit()"/></td>
	</tr>
</table>
</form>
</body>
</html>