<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../common/libs.jsp"/>
    <meta charset="UTF-8">
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function validate_and_submit_local() {
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

            if (IsNULL(document.the_form.j_new_password.value)) {
                alert("Please enter proper new password");
                document.the_form.j_new_password.focus();
                return;
            }

            if (!AlphaNumerals(document.the_form.j_new_password.value)) {
                alert("New Password can only have alphabets and digits");
                document.the_form.j_new_password.focus();
                return;
            }

            if (new String(document.the_form.j_password.value.toLowerCase()) == (new String(document.the_form.j_new_password.value)).toLowerCase()) {
                alert("New password is same as current password.  No update required");
                return;
            }
            document.the_form.action = "/customer/UpdatePassword.jsp";
            document.the_form.submit();
            document.the_form.reset();
        }

    </script>
    <title>Change Password</title>
</head>
<body>
<c:import url="headerNavbar.jsp"/>

<div class="container">
    <form method="post" action="" name="the_form">
        <table class="table-condensed">
            <tr>
                <td align="right"> Password :</td>
                <td><input type="password" name="j_password" maxlength="12" size="13"></td>
            </tr>
            <tr>
                <td align="right"> New Password :</td>
                <td><input type="password" name="j_new_password" maxlength="12" size="13"></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="button" name="change_button" class="btn" value="Change" onClick="validate_and_submit_local()"/></td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>