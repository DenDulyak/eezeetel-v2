<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<form ENCTYPE="multipart/form-data" name="the_form" method="post" action="">
    <%
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
    %>
    <input type="hidden" name=created_by value="<%=request.getRemoteUser()%>">
    <table>
        <tr>
            <td align="right">
                Supplier :
            </td>
            <td align="left">
                <select name="supplier_id" onChange="update_products()">
                    <option value="0">Select</option>
                    <%
                        String strQuery = "from TMasterSupplierinfo where Secondary_Supplier = 0 and Supplier_Active_Status = 1 order by Supplier_Name";
                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();

                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            TMasterSupplierinfo supplierInfo = (TMasterSupplierinfo) records.get(nIndex);
                    %>
                    <option value="<%=supplierInfo.getId()%>"><%=supplierInfo.getSupplierName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td align="right">
                Product :
            </td>
            <td align="left">
                <select name="product_id" id="product_name_field">
                    <option value="0">Select</option>

                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Print Information
            </td>
            <td align="left">
                <p>
				<textarea name="print_info" rows="20" cols="64" WRAP="PHYSICAL">
				</textarea>
                </p>
            </td>
        </tr>
        <tr>
            <td>Notes</td>
            <td><input type="text" name="notes"></td>
        </tr>
        <tr>
            <td align="right">
                Image File to Upload
            </td>
            <td align="left">
                <input type="file" name="file_to_upload">
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
    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>
</form>

<script src="${pageContext.request.contextPath}/js/validate.js"></script>
<script>
    function update_products() {
        var httpObj = getHttpObject();
        if (httpObj == null) {
            alert("Can not get product information");
            return;
        }

        httpObj.onreadystatechange = function () {
            if (httpObj.readyState == 4) {
                var element = document.getElementById('product_name_field');
                for (var i = 0; i < element.length; i++)
                    element.remove(i);
                element.innerHTML = "";

                var nl = httpObj.responseXML.getElementsByTagName('product');

                for (i = 0; i < nl.length; i++) {
                    var nli = nl.item(i);
                    var id = nli.getAttribute('id');
                    var name = nli.getAttribute('name');
                    var faceValue = nli.getAttribute("faceValue");

                    var strOption = name + " - " + faceValue;

                    var elOption = document.createElement('option');
                    elOption.value = id;
                    elOption.innerHTML = strOption;
                    element.appendChild(elOption);
                    httpObj = null;
                }

                //update_supplier();
            }
        };

        var url = "AJAX_GetProducts.jsp?supplier_id=" + document.the_form.supplier_id.value;
        httpObj.open("POST", url, true);
        httpObj.send(null);
    }

    function update_supplier() {
        var httpObj = getHttpObject();
        if (httpObj == null) {
            alert("Can not get supplier information");
            return;
        }

        if (document.the_form.product_name.value == null) return;
        if (document.the_form.product_name.value == "") return;

        httpObj.onreadystatechange = function () {
            if (httpObj.readyState == 4) {
                var sup_name = document.getElementById('supplier_name_field');
                var sup_prod_name = document.getElementById('supplier_product_name_field');

                var nl = httpObj.responseXML.getElementsByTagName('supplier');
                var nli = nl.item(0);
                var supplier_name = nli.getAttribute('name');
                var supplier_product_name = nli.getAttribute('supplier_product_name');
                sup_name.value = supplier_name;
                sup_prod_name.value = supplier_product_name;

                document.getElementById('toll_free_number_1').focus();
            }
        };

        var url = "AJAX_GetSupplierName.jsp?product_id=" + document.the_form.product_name.value;
        httpObj.open("POST", url, true);
        httpObj.send(null);
    }

    function ValidateInput() {
        var errString = "";

        if (!CheckSpecialCharacters(document.the_form.product_id.value, " "))
            errString += "\r\Product Name can only be mix of characters and numbers.  Please enter a proper value";

        /*	if (!IsNULL(document.the_form.toll_free_number_1.value))
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

         if (!IsNULL(document.the_form.sale_rules.value))
         {
         if (!CheckSpecialCharacters(document.the_form.sale_rules.value, " "))
         errString += "\r\nSale Rules have only characters.  Please enter a proper value";
         }*/

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

            document.the_form.action = "AddProductSaleInfo.jsp";
            document.the_form.submit();
        }
        else
            alert(errString);
    }

</script>