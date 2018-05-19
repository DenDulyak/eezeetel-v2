<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function ValidateInput() {
            if (!CheckSpecialCharacters(document.the_form.customer_type.value, " ")) {
                alert("Customer Type must have only characters and numbers.  Please enter a proper value");
                return;
            }
            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text")
                    CheckDatabaseChars(document.the_form.elements[i]);

            document.the_form.action = "AddCustomerType.jsp";
            document.the_form.submit();
        }
    </script>
    <title>New Customer Type</title>
</head>
<body>
<form method="post" name="the_form" action="">
    <table width="100%">
        <tr>
            <td align="right">Customer Type :</td>
            <td align="left">
                <input type="text" name="customer_type" size="50" maxlength="50">
            </td>
        <tr>
            <td align="right">Customer Type Description :</td>
            <td align="left">
                <input type="text" name="customer_type_desc" size="50" maxlength="100">
            </td>
        </tr>
        <tr>
            <td align="right">Notes :</td>
            <td align="left">
                <input type="text" name="notes" size="50" maxlength="100">
            </td>
        </tr>
        <tr>
            <td align="center">
                <a href=MasterInformation.jsp> Go to Main </a>
            </td>
            <td align="center">
                <input type="button" name="add_button" value="Add" onClick="ValidateInput()">
            </td>
            <td align="center">
                <input type="reset" name="clear_button" value="Clear">
            </td>
        </tr>
    </table>
</form>
</body>
</html>