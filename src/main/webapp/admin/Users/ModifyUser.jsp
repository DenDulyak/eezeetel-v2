<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
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
                }

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

            if (errString == null || errString.length <= 0) {
                for (i = 0; i < document.the_form.elements.length; i++)
                    if (document.the_form.elements[i].type == "text")
                        CheckDatabaseChars(document.the_form.elements[i]);

                document.the_form.action = "/admin/Users/UpdateUser.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }
    </script>
    <title>Modify User</title>
</head>
<body>
<%
    String strUserLoginID = request.getParameter("record_id");
    String strQuery = "from User where User_Login_ID = '" + strUserLoginID + "' and Customer_Group_ID = " + nCustomerGroupID;

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        if (records.size() > 0) {
            User userInfo = (User) records.get(0);
            TMasterUserTypeAndPrivilege userPrivilege = userInfo.getUserType();
%>

<form method="post" name="the_form" action="">
    <input type="hidden" name="record_id" value="<%=userInfo.getLogin()%>">
    <table width="100%">
        <tr>
            <td align="right">
                Login ID :
            </td>
            <td align="left">
                <input type="text" name="login_id" size="12" maxlength="12" value="<%=userInfo.getLogin()%>"
                       readonly>
            </td>
        </tr>
        <tr>
            <td align="right">
                User Type :
            </td>
            <td align="left">
                <input type="hidden" name="user_type" value="<%=userPrivilege.getId()%>">
                <input type="text" name="user_type_name" value="<%=userPrivilege.getName()%>"
                       readonly>
            </td>
        </tr>
        <tr>
            <td align="right">
                Company Name :
            </td>
            <td align="left">
                <input type="text" name="company_name" value="<%=userInfo.getUserCompanyName()%>" readonly>
            </td>
        </tr>
        <tr>
            <td align="right">
                First Name :
            </td>
            <td align="left">
                <input type="text" name="first_name" size="50" maxlength="50" value="<%=userInfo.getUserFirstName()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Last Name :
            </td>
            <td align="left">
                <input type="text" name="last_name" size="50" maxlength="50" value="<%=userInfo.getUserLastName()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Middle Name :
            </td>
            <td align="left">
                <input type="text" name="middle_name" size="50" maxlength="50"
                       value="<%=userInfo.getUserMiddleName()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 1 :
            </td>
            <td align="left">
                <input type="text" name="address_line_1" size="50" maxlength="50"
                       value="<%=userInfo.getAddressLine1()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 2 :
            </td>
            <td align="left">
                <input type="text" name="address_line_2" size="50" maxlength="50"
                       value="<%=userInfo.getAddressLine2()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 3 :
            </td>
            <td align="left">
                <input type="text" name="address_line_3" size="50" maxlength="50"
                       value="<%=userInfo.getAddressLine3()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                City :
            </td>
            <td align="left">
                <input type="text" name="city" size="50" maxlength="50" value="<%=userInfo.getCity()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                State :
            </td>
            <td align="left">
                <input type="text" name="state" size="50" maxlength="50" value="<%=userInfo.getState()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Postal Code :
            </td>
            <td align="left">
                <input type="text" name="postal_code" size="20" maxlength="20" value="<%=userInfo.getPostalCode()%>">
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

                            String strSelect = "";
                            if (oneCountry.getCountryName().equalsIgnoreCase(userInfo.getCountry()))
                                strSelect = "Selected";
                    %>
                    <option value="<%=oneCountry.getCountryName()%>" <%=strSelect%>><%=oneCountry.getCountryName()%>
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
                <input type="text" name="primary_phone" size="50" maxlength="50"
                       value="<%=userInfo.getPrimaryPhone()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Secondary Phone :
            </td>
            <td align="left">
                <input type="text" name="secondary_phone" size="50" maxlength="50"
                       value="<%=userInfo.getSecondaryPhone()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Mobile Phone :
            </td>
            <td align="left">
                <input type="text" name="mobile_phone" size="50" maxlength="50" value="<%=userInfo.getMobilePhone()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                EMail ID :
            </td>
            <td align="left">
                <input type="text" name="email_id" size="50" maxlength="50" value="<%=userInfo.getEmailId()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Notes :
            </td>
            <td align="left">
                <input type="text" name="notes" size="50" maxlength="100" value="<%=userInfo.getNotes()%>">
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession(theSession);
            }
        %>
        <tr>
            <td align="center">
                <a href="/admin"> Admin Main </a>
            </td>

            <td align="center">
                <input type="button" name="update_button" value="Update" onClick="ValidateInput()">
            </td>

            <td align="center">
                <input type="reset" name="clear_button" value="Clear">
            </td>
        </tr>
    </table>
</form>

</body>
</html>