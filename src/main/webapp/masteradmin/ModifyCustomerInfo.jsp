<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <script language="javascript">
        function ValidateInput() {
            var errString = "";

            if (!CheckSpecialCharacters(document.the_form.customer_company_name.value, " "))
                errString += "Customer Compnay Name must have only characters.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.first_name.value, " "))
                errString += "\r\nFirst Name must have only characters.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.last_name.value, " "))
                errString += "\r\nLast Name must have only characters.  Please enter a proper value";

            if (!CheckCharacters(document.the_form.middle_name.value, " "))
                errString += "\r\nMiddle Name must have only characters.  Please enter a proper value";

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

                document.the_form.action = "UpdateCustomerInfo.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }
    </script>
    <title>Modify Customer Information</title>
</head>
<body>
<%
    int record_id = 0;
    String strRecordID = request.getParameter("record_id");
    if (strRecordID != null && !strRecordID.isEmpty())
        record_id = Integer.parseInt(strRecordID);
    String strQuery = "from TMasterCustomerinfo where Customer_ID = " + record_id;

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        if (records.size() > 0) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(0);
            TMasterCustomertype custType = custInfo.getCustomerType();
            User userInfo = custInfo.getIntroducedBy();
            TMasterCustomerGroups custGroup = custInfo.getGroup();
%>
<form method="post" name="the_form" action="">

    <table width="100%">

        <tr>
            <td align="right">
                Customer Company Name :
            </td>
            <td align="left">
                <input type="hidden" name="record_id" value="<%=custInfo.getId()%>">
                <input type="text" name="customer_company_name" size="50" maxlength="50"
                       value="<%=custInfo.getCompanyName()%>">
            </td>
        </tr>

        <tr>
            <td align="right">
                Customer Type :
            </td>
            <td align="left">
                <select name="customer_type_id">
                    <%
                        strQuery = "from TMasterCustomertype where Customer_Type_Active_Status = 1";

                        query = theSession.createQuery(strQuery);
                        List customer_types = query.list();

                        for (int nIndex = 0; nIndex < customer_types.size(); nIndex++) {
                            TMasterCustomertype oneCustType = (TMasterCustomertype) customer_types.get(nIndex);

                            String strSelect = "";
                            if (oneCustType.getId() == custType.getId())
                                strSelect = "Selected";
                    %>
                    <option value="<%=oneCustType.getId()%>" <%=strSelect%>><%=oneCustType.getCustomerType()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>

        <tr>
            <td align="right">
                First Name :
            </td>
            <td align="left">
                <input type="text" name="first_name" size="50" maxlength="50" value="<%=custInfo.getFirstName()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Last Name :
            </td>
            <td align="left">
                <input type="text" name="last_name" size="50" maxlength="50" value="<%=custInfo.getLastName()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Middle Name :
            </td>
            <td align="left">
                <input type="text" name="middle_name" size="50" maxlength="50" value="<%=custInfo.getMiddleName()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 1 :
            </td>
            <td align="left">
                <input type="text" name="address_line_1" size="50" maxlength="50"
                       value="<%=custInfo.getAddressLine1()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 2 :
            </td>
            <td align="left">
                <input type="text" name="address_line_2" size="50" maxlength="50"
                       value="<%=custInfo.getAddressLine2()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Address Line 3 :
            </td>
            <td align="left">
                <input type="text" name="address_line_3" size="50" maxlength="50"
                       value="<%=custInfo.getAddressLine3()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                City :
            </td>
            <td align="left">
                <input type="text" name="city" size="50" maxlength="50" value="<%=custInfo.getCity()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                State :
            </td>
            <td align="left">
                <input type="text" name="state" size="50" maxlength="50" value="<%=custInfo.getState()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Postal Code :
            </td>
            <td align="left">
                <input type="text" name="postal_code" size="20" maxlength="20" value="<%=custInfo.getPostalCode()%>">
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
                            if (oneCountry.getCountryName().equalsIgnoreCase(custInfo.getCountry()))
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
                       value="<%=custInfo.getPrimaryPhone()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Secondary Phone :
            </td>
            <td align="left">
                <input type="text" name="secondary_phone" size="50" maxlength="50"
                       value="<%=custInfo.getSecondaryPhone()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Mobile Phone :
            </td>
            <td align="left">
                <input type="text" name="mobile_phone" size="50" maxlength="50" value="<%=custInfo.getMobilePhone()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Website Address :
            </td>
            <td align="left">
                <input type="text" name="website_address" size="50" maxlength="100"
                       value="<%=custInfo.getWebsiteAddress()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                E-Mail :
            </td>
            <td align="left">
                <input type="text" name="email_id" size="50" maxlength="100" value="<%=custInfo.getEmailId()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Customer Introduced By :
            </td>
            <td align="left">
                <select name="customer_introduced_by">
                    <%
                        strQuery = "from User where User_Login_ID = '" + request.getRemoteUser() + "'" + " OR User_Login_ID = '" + userInfo.getLogin() + "'" +
                                " OR (User_Type_And_Privilege = 6 and User_Login_ID != 'Pending' and User_Active_Status = 1" +
                                "  )  order by User_First_Name";

                        query = theSession.createQuery(strQuery);
                        List users = query.list();

                        for (int nIndex = 0; nIndex < users.size(); nIndex++) {
                            User oneUserInfo = (User) users.get(nIndex);
                            String strSelect = "";
                            if (oneUserInfo.getLogin().equals(userInfo.getLogin()))
                                strSelect = "Selected";
                    %>
                    <option value="<%=oneUserInfo.getLogin()%>" <%=strSelect%>><%=oneUserInfo.getUserFirstName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Additional Notes :
            </td>
            <td align="left">
                <input type="text" name="additional_notes" size="50" maxlength="100" value="<%=custInfo.getNotes()%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Customer Group :
            </td>
            <td align="left">
                <select name="Customer_Group_ID">
                    <%
                        strQuery = "from TMasterCustomerGroups where active = 1";
                        query = theSession.createQuery(strQuery);
                        List groups = query.list();

                        for (int nIndex = 0; nIndex < groups.size(); nIndex++) {
                            TMasterCustomerGroups oneGroupInfo = (TMasterCustomerGroups) groups.get(nIndex);
                            String strSelected = "";
                            if (oneGroupInfo.getId() == custGroup.getId())
                                strSelected = "Selected";
                    %>
                    <option value="<%=oneGroupInfo.getId()%>" <%=strSelected%>><%=oneGroupInfo.getName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Customer Features :
            </td>

            <td align="left">
                <select name="Customer_Features_ID">
                    <%
                        String strSelected = "";
                        if (custInfo != null)
                            strSelected = "selected";
                    %>
                    <option value="0" selected>Calling Cards, Mobile Vouchers & Transfer-To</option>
                    <%
                        strSelected = "";
                        if (custInfo.getCustomerFeatureId() == 1)
                            strSelected = "selected";
                    %>
                    <option value="1">Calling Cards, Mobile Vouchers & Ding</option>
                    <%
                        strSelected = "";
                        if (custInfo.getCustomerFeatureId() == 2)
                            strSelected = "selected";
                    %>
                    <option value="2">Calling Cards, Mobile Vouchers, Transfer-To, Ding</option>
                    <%
                        strSelected = "";
                        if (custInfo.getCustomerFeatureId() == 3)
                            strSelected = "selected";
                    %>
                    <option value="3">SIMS, Calling Cards, Mobile Vouchers, Ding, Bulkupload</option>
                </select>
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
        <tr></tr>
        <tr>
            <td align="center">
                <a href=MasterInformation.jsp> Go to Main </a>
            </td>

            <td align="left">
                <input type="button" name="update_button" value="Update" onClick="ValidateInput()">
            </td>

            <td align="left">
                <input type="reset" name="clear_button" value="Clear">
            </td>
        </tr>

    </table>

</form>

</body>
</html>