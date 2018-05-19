<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function check_login_name() {
            if (IsNULL(document.the_form.login_id.value)) return;

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not check user existance");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var nl = httpObj.responseXML.getElementsByTagName('user');
                    if (nl.length == 0)
                        return;
                    else {
                        alert("Another user with same id already exists.  Please choose differ id.");
                        document.the_form.login_id.focus();
                    }
                    httpObj = null;
                }
            }

            var url = "/admin/Users/AJAX_CheckUserExist.jsp?name=" + document.the_form.login_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function Populate_Address() {
            if (document.the_form.company_name.value <= 0)
                return;
            if (document.the_form.user_type.value == 7 || document.the_form.user_type.value == 8) {
                var httpObj = getHttpObject();
                if (httpObj == null) {
                    alert("Can not get Address Details");
                    return;
                }

                httpObj.onreadystatechange = function () {
                    if (httpObj.readyState == 4) {
                        var nl = httpObj.responseXML.getElementsByTagName('customer');

                        var nli = nl.item(0);
                        var line1 = nli.getAttribute('add_line_1');
                        var line2 = nli.getAttribute('add_line_2');
                        var line3 = nli.getAttribute('add_line_3');
                        var city = nli.getAttribute('city');
                        var state = nli.getAttribute('state');
                        var postalcode = nli.getAttribute('Postal_code');
                        var country = nli.getAttribute('country');

                        document.the_form.address_line_1.value = line1;
                        document.the_form.address_line_2.value = line2;
                        document.the_form.address_line_3.value = line3;
                        document.the_form.city.value = city;
                        document.the_form.state.value = state;
                        document.the_form.postal_code.value = postalcode;
                        document.the_form.country.value = country;

                        httpObj = null;
                    }
                };

                var url = "/admin/Customers/AJAX_GetCustomerAddress.jsp?customer_id=" + document.the_form.company_name.value;
                httpObj.open("POST", url, true);
                httpObj.send(null);
            }
        }

        function update_customer_names() {
            var element = document.getElementById('company_name_id');
            for (var i = 0; i < element.length; i++)
                element.remove(i);
            element.innerHTML = "";

            if (document.the_form.user_type.value == 7 || document.the_form.user_type.value == 8) {
                var httpObj = getHttpObject();
                if (httpObj == null) {
                    alert("Can not get customer information");
                    return;
                }

                httpObj.onreadystatechange = function () {
                    if (httpObj.readyState == 4) {
                        var nl = httpObj.responseXML.getElementsByTagName('customer');

                        for (var i = 0; i < nl.length; i++) {
                            var nli = nl.item(i);
                            var id = nli.getAttribute('id');
                            var name = nli.getAttribute('name');

                            var elOption = document.createElement('option');
                            elOption.value = id;
                            elOption.innerHTML = name;
                            element.appendChild(elOption);
                        }

                        httpObj = null;
                    }
                };

                var url = "/admin/Users/AJAX_GetCustomerNames.jsp";
                httpObj.open("POST", url, true);
                httpObj.send(null);
            }
            else {
                var elOption = document.createElement('option');
                <%
                    DatabaseHelper dbHelper = new DatabaseHelper();
                    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
                    String strGroupName = dbHelper.GetCustomerGroupName(nCustomerGroupID);
                %>
                elOption.value = "<%=strGroupName%>";
                elOption.innerHTML = "<%=strGroupName%>";
                element.appendChild(elOption);
            }
        }

        function ValidateInput() {
            var errString = "";

            if (!CheckSpecialCharacters(document.the_form.login_id.value, "_@."))
                errString += "Login ID must have only characters, numbers and (_, @, .).  Please enter a proper value";

            if (!CheckCharacters(document.the_form.first_name.value, " "))
                errString += "First Name must have only characters.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.last_name.value, " "))
                errString += "\r\nLast Name must have only characters.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.middle_name.value, " "))
                errString += "\r\nMiddle Name must have only characters.  Please enter a proper value";

            if (IsNULL(document.the_form.company_name.value))
                errString += "\r\Company name can not be empty.  Please enter a proper value";

            if (IsNULL(document.the_form.address_line_1.value))
                errString += "\r\nAddress Line 1 can not be empty.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.city.value, " "))
                errString += "\r\nCity must have only characters.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.state.value, " "))
                errString += "\r\nState must have only characters.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.country.value, " "))
                errString += "\r\nCountry must have only characters.  Please enter a proper value";

            if (document.the_form.country.value == "United Kingdom") {
                if (!CheckSpecialCharacters(document.the_form.postal_code.value, " "))
                    errString += "\r\nPostal code must have only characters or numbers.  Please enter a proper value";
            }
            else {
                if (!CheckNumbers(document.the_form.postal_code.value, " "))
                    errString += "\r\nPostal code must have only numbers.  Please enter a proper value";
            }

            if (!CheckNumbers(document.the_form.primary_phone.value, "().- "))
                errString += "\r\Primary Phone must have only numbers.  Please enter a proper value";

            if (IsNULL(document.the_form.email_id.value))
                errString += "\r\EMail can not be empty.  Please enter a proper value";

            if (IsNULL(document.the_form.password_1.value))
                errString += "\r\Password can not be empty.  Please enter a proper value";

            if(document.the_form.password_1.value != document.the_form.password_2.value)
                errString += "\r\Password does not match the confirm password.";

            if (errString == null || errString.length <= 0) {
                for (i = 0; i < document.the_form.elements.length; i++)
                    if (document.the_form.elements[i].type == "text")
                        CheckDatabaseChars(document.the_form.elements[i]);

                document.the_form.action = "/admin/Users/AddUser.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }

    </script>
    <title>New User</title>
</head>
<body>
<form method="post" name="the_form" action="">
    <%
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
    %>
    <table width="100%">
        <tr>
            <td align="right">
                Login ID :
            </td>
            <td align="left">
                <input type="text" name="login_id" size="13" maxlength="12" onBlur="check_login_name()">
            </td>
        </tr>
        <tr>
            <td align="right">
                User Type :
            </td>
            <td align="left">
                <select name="user_type" onchange="update_customer_names()">
                    <%
                        String strQuery = "from TMasterUserTypeAndPrivilege where User_Type_And_Privilege_ID in (6, 7, 8, 9)";
                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();
                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            TMasterUserTypeAndPrivilege userType = (TMasterUserTypeAndPrivilege) records.get(nIndex);
                    %>
                    <option value="<%=userType.getId()%>"><%=userType.getName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Company Name :
            </td>
            <td align="left">
                <select name="company_name" id="company_name_id" onChange="Populate_Address()">
                    <option value="<%=strGroupName%>"><%=strGroupName%>
                    </option>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                First Name :
            </td>
            <td align="left">
                <input type="text" name="first_name" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Last Name :
            </td>
            <td align="left">
                <input type="text" name="last_name" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Middle Name :
            </td>
            <td align="left">
                <input type="text" name="middle_name" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 1 :
            </td>
            <td align="left">
                <input type="text" name="address_line_1" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 2 :
            </td>
            <td align="left">
                <input type="text" name="address_line_2" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 3 :
            </td>
            <td align="left">
                <input type="text" name="address_line_3" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                City :
            </td>
            <td align="left">
                <input type="text" name="city" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                State :
            </td>
            <td align="left">
                <input type="text" name="state" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Postal Code :
            </td>
            <td align="left">
                <input type="text" name="postal_code" size="20" maxlength="20">
            </td>
        </tr>
        <tr>
            <td align="right">
                Country :
            </td>
            <td align="left">
                <select name="country">
                    <%
                        strQuery = "from TMasterCountries";
                        query = theSession.createQuery(strQuery);
                        List countries = query.list();

                        for (int nIndex = 0; nIndex < countries.size(); nIndex++) {
                            TMasterCountries oneCountry = (TMasterCountries) countries.get(nIndex);
                    %>
                    <option value="<%=oneCountry.getCountryName()%>"><%=oneCountry.getCountryName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Primary Phone :
            </td>
            <td align="left">
                <input type="text" name="primary_phone" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Secondary Phone :
            </td>
            <td align="left">
                <input type="text" name="secondary_phone" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Mobile Phone :
            </td>
            <td align="left">
                <input type="text" name="mobile_phone" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                EMail ID :
            </td>
            <td align="left">
                <input type="text" name="email_id" size="50" maxlength="50">
            </td>
        </tr>
        <tr>
            <td align="right">
                Password :
            </td>
            <td align="left">
                <input type="password" name="password_1" size="13" maxlength="12">
            </td>
        </tr>
        <tr>
            <td align="right">
                Confirm Password :
            </td>
            <td align="left">
                <input type="password" name="password_2" size="13" maxlength="12">
            </td>
        </tr>
        <tr>
            <td align="right">
                Notes :
            </td>
            <td align="left">
                <%
                    String strCreatedBy = request.getRemoteUser();
                %>
                <input type="hidden" name="user_created_by" value="<%=strCreatedBy%>">
                <input type="text" name="notes" size="50" maxlength="100">
            </td>
        </tr>
        <tr>
            <td align="center">
                <a href="/admin">Admin Main</a>
            </td>

            <td align="center">
                <input type="button" name="add_button" value="Add" onClick="ValidateInput()">
            </td>

            <td align="center">
                <input type="reset" name="clear_button" value="Clear">
            </td>
        </tr>
    </table>
    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>
</form>

</body>
</html>