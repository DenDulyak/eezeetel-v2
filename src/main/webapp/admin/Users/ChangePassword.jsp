<form method="post" action="" name="the_form">
    <table class="table-sm">
        <tr>
            <td align="right"> Password :</td>
            <td><input type="password" name="j_password" maxlength="12" size="13"></td>
        </tr>
        <tr>
            <td align="right"> New Password :</td>
            <td><input type="password" name="j_new_password" maxlength="12" size="13"></td>
        </tr>
        <tr>
            <td><input type="button" name="change_button" value="Change" onClick="validate_and_submit()"/></td>
        </tr>
    </table>
</form>
<script src="${pageContext.request.contextPath}/js/validate.js"></script>
<script>
    function validate_and_submit() {
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

        if (String(document.the_form.j_password.value.toLowerCase()) == (String(document.the_form.j_new_password.value)).toLowerCase()) {
            alert("New password is same as current password.  No update required");
            return;
        }
        document.the_form.action = "/admin/Users/UpdatePassword.jsp";
        document.the_form.submit();
        document.the_form.reset();
    }
</script>