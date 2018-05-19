<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <form ENCTYPE="multipart/form-data" method="post" name="the_form" action="">
        <%
            Session theSession = null;
            try {
                theSession = HibernateUtil.openSession();
        %>

        <table width="100%">
            <tr>
                <td align="right">
                    Supplier Name :
                </td>
                <td align="left">
                    <input type="text" name="supplier_name" size="50" maxlength="50">
                </td>
            </tr>
            <tr>
                <td align="right">
                    Supplier Type :
                </td>
                <td align="left">
                    <select name="supplier_type_id">
                        <%
                            String strQuery = "from TMasterSuppliertype where Supplier_Type_Active_Status = 1";
                            Query query = theSession.createQuery(strQuery);
                            List records = query.list();

                            for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                TMasterSuppliertype supType = (TMasterSuppliertype) records.get(nIndex);
                        %>
                        <option value="<%=supType.getId()%>"><%=supType.getSupplierType()%>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right">
                    Contact Person :
                </td>
                <td align="left">
                    <input type="text" name="supplier_contact" size="50" maxlength="100">
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
                    Website Address :
                </td>
                <td align="left">
                    <input type="text" name="website_address" size="50" maxlength="100">
                </td>
            </tr>
            <tr>
                <td align="right">
                    E-Mail :
                </td>
                <td align="left">
                    <input type="text" name="email_id" size="50" maxlength="100">
                </td>
            </tr>
            <tr>
                <td align="right">
                    Supplier Introduced By :
                </td>
                <td align="left">
                    <input type="hidden" name="supplier_created_by"
                           value="<%=request.getRemoteUser()%>">
                    <input type="text" name="supplier_introduced_by" size="50" maxlength="50">
                </td>
            </tr>
            <tr>
                <td align="right">
                    Additional Notes :
                </td>
                <td align="left">
                    <input type="text" name="additional_notes" size="50" maxlength="100">
                </td>
            </tr>
            <tr>
                <td align="right">
                    Second-hand Supplier :
                </td>
                <td align="left">
                    <input type="checkbox" name="second_hand_supplier">
                </td>
            </tr>
            <tr>
                <td align="center">

                </td>
                <td align="center">
                    <input type="button" name="add_button" value="Add" onClick="ValidateInput()">
                </td>
                <td align="center">
                    <input type="reset" name="clear_button" value="Clear">
                </td>
            </tr>
            <tr>
                <td align="right">
                    Image File to Upload
                </td>
                <td align="left">
                    <input type="file" name="file_to_upload">
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
</div>

<script src="${pageContext.request.contextPath}/js/validate.js"></script>
<script>
    function ValidateInput() {
        var errString = "";

        if (!CheckSpecialCharacters(document.the_form.supplier_name.value, " "))
            errString += "Supplier Name must have only characters.  Please enter a proper value";

        if (!CheckCharacters(document.the_form.supplier_contact.value, " "))
            errString += "\r\nContact Person Name must have only characters.  Please enter a proper value";

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
            if (!CheckNumbers(document.the_form.postal_code.value, ""))
                errString += "\r\nPostal code must have only numbers.  Please enter a proper value";
        }

        if (!CheckNumbers(document.the_form.primary_phone.value, "().- "))
            errString += "\r\Primary Phone must have only numbers.  Please enter a proper value";

        if (errString == null || errString.length <= 0) {
            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text")
                    CheckDatabaseChars(document.the_form.elements[i]);

            document.the_form.action = "AddSupplierInfo.jsp";
            document.the_form.submit();
        }
        else
            alert(errString);
    }
</script>