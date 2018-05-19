<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strQuery = "from TMasterProductsaleinfo where Sale_Info_ID = " + record_id;

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        if (records.size() > 0) {
            TMasterProductsaleinfo prodSaleInfo = (TMasterProductsaleinfo) records.get(0);
            TMasterProductinfo prodInfo = prodSaleInfo.getProduct();
%>

<form ENCTYPE="multipart/form-data" name="the_form" method="post" action="">
    <input type="hidden" name="record_id" value="<%=prodSaleInfo.getId()%>">
    <table>
        <tr>
            <td align="right">
                Product :
            </td>
            <td align="left">
                <select name="product_id">
                    <%
                        strQuery = "from TMasterProductinfo where Product_Active_Status = 1 order by Product_Name";
                        query = theSession.createQuery(strQuery);
                        List products = query.list();

                        for (int nIndex = 0; nIndex < products.size(); nIndex++) {
                            TMasterProductinfo oneProduct = (TMasterProductinfo) products.get(nIndex);
                            String strSelect = "";
                            if (oneProduct.getId() == prodInfo.getId())
                                strSelect = "Selected";
                    %>
                    <option value="<%=oneProduct.getId()%>" <%=strSelect%>><%=oneProduct.getProductName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <!--
	<tr>
		<td>Toll Free Number 1</td>
		<td><input type="text" name="toll_free_number_1" value="<%=prodSaleInfo.getTollFreeNumber1()%>" ></td>
	</tr>
	<tr>
		<td>Toll Free Number 2</td>
		<td><input type="text" name="toll_free_number_2" value="<%=prodSaleInfo.getTollFreeNumber2()%>" ></td>
	</tr>
	<tr>
		<td>Local Access Number 1</td>
		<td><input type="text" name="local_access_number_1" value="<%=prodSaleInfo.getLocalAcessNumber1()%>"></td>
	</tr>
	<tr>
		<td>Local Access Number 2</td>
		<td><input type="text" name="local_access_number_2" value="<%=prodSaleInfo.getLocalAcessNumber2()%>"></td>
	</tr>
	<tr>
		<td>National Access Number 1</td>
		<td><input type="text" name="national_access_number_1" value="<%=prodSaleInfo.getNationalAcessNumber1()%>"></td>
	</tr>
	<tr>
		<td>National Access Number 2</td>
		<td><input type="text" name="national_access_number_2" value="<%=prodSaleInfo.getNationalAcessNumber2()%>"></td>
	</tr>
	<tr>
		<td>Pay Phone Access Number 1</td>
		<td><input type="text" name="payphone_access_number_1" value="<%=prodSaleInfo.getPayPhoneAcessNumber1()%>"></td>
	</tr>
	<tr>
		<td>Pay Phone Access Number 2</td>
		<td><input type="text" name="payphone_access_number_2" value="<%=prodSaleInfo.getPayPhoneAcessNumber2()%>"></td>
	</tr>
	<tr>
		<td>Other Access Number 1</td>
		<td><input type="text" name="other_access_number_1" value="<%=prodSaleInfo.getOtherAcessNumber1()%>"></td>
	</tr>
	<tr>
		<td>Other Access Number 2</td>
		<td><input type="text" name="other_access_number_2" value="<%=prodSaleInfo.getOtherAcessNumber2()%>"></td>
	</tr>
	<tr>
		<td>Customer Support Number 1</td>
		<td><input type="text" name="customer_support_number_1" value="<%=prodSaleInfo.getSupportNumber1()%>" ></td>
	</tr>
	<tr>
		<td>Customer Support Number 2</td>
		<td><input type="text" name="customer_support_number_2" value="<%=prodSaleInfo.getSupportNumber2()%>" ></td>
	</tr>
	<tr>
		<td>Sale Rules</td>
		<td><input type="text" name="sale_rules" value="<%=prodSaleInfo.getSaleRules()%>" ></td>
	</tr>
	<tr>
		<td>Additional information</td>
		<td><input type="text" name="addtional_information" value="<%=prodSaleInfo.getAdditionalInfo()%>" ></td>
	</tr>
 -->
        <tr>
            <td align="right">
                Print Information
            </td>
            <td align="left">
                <p>
				<textarea name="print_info" rows="20" cols="64" WRAP="PHYSICAL">
					<%=prodSaleInfo.getPrintInfo() %>
				</textarea>
                </p>
            </td>
        </tr>
        <tr>
            <td>Notes</td>
            <td><input type="text" name="notes" value="<%=prodSaleInfo.getNotes()%>"></td>
        </tr>
        <tr>
            <td>
                Existing Image :
            </td>
            <td>
                <img width=300 height=200 src="<%=prodSaleInfo.getProductImageFile()%>"/>
            </td>
        </tr>
        <tr>
            <td align="right">
                New Image File to Upload
            </td>
            <td align="left">
                <input type="file" name="file_to_upload">
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
                <a href=MasterInformation.jsp> Go to Main </a>
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

<script src="${pageContext.request.contextPath}/js/validate.js"></script>
<script>
    function ValidateInput() {
        var errString = "";

        if (!CheckSpecialCharacters(document.the_form.product_id.value, " "))
            errString += "\r\Product Name can only be mix of characters and numbers.  Please enter a proper value";

        /*
         if (!IsNULL(document.the_form.toll_free_number_1.value))
         {
         if (!CheckNumbers(document.the_form.toll_free_number_1.value, "-."))
         errString += "\r\nToll Free Number 1 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.toll_free_number_2.value))
         {
         if (!CheckNumbers(document.the_form.toll_free_number_2.value, "-."))
         errString += "\r\nToll Free Number 2 can have only numbers.  Please enter a proper value";
         }
         if (!IsNULL(document.the_form.local_access_number_1.value))
         {
         if (!CheckNumbers(document.the_form.local_access_number_1.value, "-."))
         errString += "\r\nLocal Access Number 1 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.local_access_number_2.value))
         {
         if (!CheckNumbers(document.the_form.local_access_number_2.value, "-."))
         errString += "\r\nLocal Access Number 2 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.national_access_number_1.value))
         {
         if (!CheckNumbers(document.the_form.national_access_number_1.value, "-."))
         errString += "\r\nNational Access Number 1 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.national_access_number_2.value))
         {
         if (!CheckNumbers(document.the_form.national_access_number_2.value, "-."))
         errString += "\r\nNational Access Number 2 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.payphone_access_number_1.value))
         {
         if (!CheckNumbers(document.the_form.payphone_access_number_1.value, "-."))
         errString += "\r\nPay Phone Access Number 1 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.payphone_access_number_2.value))
         {
         if (!CheckNumbers(document.the_form.payphone_access_number_2.value, "-."))
         errString += "\r\nPay Phone Access Number 2 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.other_access_number_1.value))
         {
         if (!CheckNumbers(document.the_form.other_access_number_1.value, "-."))
         errString += "\r\nOther Access Number 1 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.other_access_number_2.value))
         {
         if (!CheckNumbers(document.the_form.other_access_number_2.value, "-."))
         errString += "\r\nOther Access Number 2 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.customer_support_number_1.value))
         {
         if (!CheckNumbers(document.the_form.customer_support_number_1.value, "-."))
         errString += "\r\nCustomer Support Number 1 can have only numbers.  Please enter a proper value";
         }

         if (!IsNULL(document.the_form.customer_support_number_2.value))
         {
         if (!CheckNumbers(document.the_form.customer_support_number_2.value, "-."))
         errString += "\r\nCustomer Support Number 2 can have only numbers.  Please enter a proper value";
         }

         if (!CheckSpecialCharacters(document.the_form.sale_rules.value, " "))
         errString += "\r\nSale Rules have only characters.  Please enter a proper value";
         */

        if (IsNULL(document.the_form.print_info.value))
            errString += "\r\nPrint Information can not be empty.  Please enter print information";
        else {
            var key_word_1_pos = -1;
            key_word_1 = document.the_form.print_info.value.search(/<<CARD_PIN_NUMBER>>/i);
            if (key_word_1 < 0)
                errString += "\r\nKeyword <<CARD_PIN_NUMBER>> missing.  Please include at appropriate place";
        }

        if (errString == null || errString.length <= 0) {
            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text" || document.the_form.elements[i].type == "textarea")
                    CheckDatabaseChars(document.the_form.elements[i]);

            document.the_form.action = "UpdateProductSaleInfo.jsp";
            document.the_form.submit();
        }
        else
            alert(errString);
    }


</script>