<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function ValidateInput() {
            if (!CheckSpecialCharacters(document.the_form.product_type.value, "#. ")) {
                alert("Product Type must have only characters and numbers.  Please enter a proper value");
                return;
            }

            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text")
                    CheckDatabaseChars(document.the_form.elements[i]);

            document.the_form.action = "AddProductType.jsp";
            document.the_form.submit();
        }
    </script>
    <title>New Product Type Definition</title>
</head>
<body>
<form method="post" name="the_form" action="">

    <table width="100%">
        <tr>
            <td align="right">
                Product Type :
            </td>

            <td align="left">
                <input type="text" name="product_type" size="50" maxlength="50">
            </td>

        <tr>
            <td align="right">
                Product Type Description :
            </td>

            <td align="left">
                <input type="text" name="product_type_desc" size="50" maxlength="100">
            </td>
        </tr>

        <tr>
            <td align="right">
                Notes :
            </td>

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