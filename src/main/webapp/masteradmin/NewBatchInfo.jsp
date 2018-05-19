<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <form ENCTYPE="multipart/form-data" method="post" name="the_form" action="">
        <table>

            <tr>
                <td align="right">
                    Supplier :
                </td>
                <td align="left">
                    <genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also="0"
                                               initial_option="Select" onChange="update_products()" default_select="0"/>
                </td>
                <td align="right">
                    Product :
                </td>
                <td align="left">
                    <select name="product_name" id="product_name_field" onchange="get_saleinfo()">
                        <option value="0">Select</option>
                    </select>
                </td>
            </tr>

            <tr>
                <td align="right">Product Sale Information</td>
                <td>
                    <select name="product_sale_id" id="product_sale_id_field" onchange="update_sale_info()">
                        <option value="0">Select</option>
                    </select>
                </td>
                <td nowrap>
                    <div id="product_detailed_info_id"></div>
                </td>
            </tr>

            <tr>
                <td align="right">
                    <font color="red"> Batch Supplied By : </font>
                </td>
                <td align="left">
                    <genericappdb:SupplierList name="batch_supplied_by" active_records_only="1" secondary_also="1"
                                               initial_option="Select" onChange="get_saleinfo()" default_select="0"/>
                </td>
            </tr>

            <tr>
                <td align="right">
                    Batch ID
                </td>
                <td align="left">
                    <input type="text" name="batch_id" size="50" maxlength="50">
                </td>
            </tr>

            <tr>
                <td align="right">
                    Quantity
                </td>
                <td align="left">
                    <input type="text" name="quantity" size="5" maxlength="5">
                </td>
            </tr>

            <tr>
                <td align="right">
                    <H2>Unit Purchase Price </H2>
                </td>
                <td align="left">
                    <input type="text" id="price_field" name="unit_purchase_price" size="4" maxlength="7"
                           style="width:60px; height:40px;font-size:28px;">
                    <input type="hidden" id="face_value_field" name="face_value" value="0">
                </td>
            </tr>

            <tr>
                <td align="right">
                    <H2>Probable Sale Price </H2>
                </td>
                <td align="left">
                    <input type="text" id="sale_price_field" name="probable_sale_price" size="4" maxlength="7"
                           style="width:60px; height:40px;font-size:28px;">
                </td>
            </tr>

            <%
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sf = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
                String strArrivalDate = sf.format(cal.getTime());
                cal.add(Calendar.YEAR, 1);
                String strExpiryDate = sf.format(cal.getTime());
            %>

            <tr>
                <td align="right">
                    Batch Arrival Date
                </td>
                <td align="left">
                    <input type="text" name="batch_arrival_date" size="11" maxlength="11" value="<%=strArrivalDate%>">
                    (dd-mmm-yyyy)
                </td>
            </tr>

            <tr>
                <td align="right">
                    Batch Expiration Date
                </td>
                <td align="left">
                    <input type="text" name="batch_expiry_date" size="11" maxlength="11" value="<%=strExpiryDate%>">
                </td>
            </tr>

            <tr>
                <td align="right">
                    Batch Activated by Supplier
                </td>
                <td align="left">
                    <input type="checkbox" name="batch_activiated_by_supplier" checked>
                </td>
            </tr>

            <tr>
                <td align="right">
                    Batch Ready To Sell
                </td>
                <td align="left">
                    <input type="checkbox" name="batch_ready_to_sell" checked>
                    <input type="hidden" name="batch_created_by" value="<%=request.getRemoteUser()%>">
                </td>
            </tr>

            <tr>
                <td align="right">
                    Additional Information
                </td>
                <td align="left">
                    <input type="text" name="additional_info" size="50" maxlength="50">
                </td>
            </tr>

            <tr>
                <td align="right">
                    Notes
                </td>
                <td align="left">
                    <input type="text" name="notes" size="50" maxlength="100">
                </td>
            </tr>

            <tr>
                <td align="right">
                    Max Topups (SIM Cards only)
                </td>
                <td align="left">
                    <input type="text" name="max_topus" id="max_topups_field" size="2" maxlength="1">
                </td>
            </tr>

            <tr>
                <td align="right">
                    File To Upload
                </td>
                <td align="left">
                    <input type="file" name="file_to_upload">
                </td>
            </tr>

            <tr>
                <td align="right" bgcolor="red">
                    <H2>Unit Batch Cost Price</H2>
                </td>
                <td align="left">
                    <input type="text" id="batch_cost_field" name="batch_cost" size="4" maxlength="7"
                           style="width:60px; height:40px;font-size:28px;">
                </td>
            </tr>

            <tr>
                <td align="right" bgcolor="red">
                    Paid to Supplier
                </td>
                <td align="left">
                    <input type="checkbox" name="paid_to_supplier">
                </td>
            </tr>

            <tr>
                <td align="right" bgcolor="red">
                    Payment Date
                </td>
                <td align="left">
                    <input type="text" name="batch_payment_date" size="11" maxlength="11" value="<%=strArrivalDate%>">
                    (dd-mmm-yyyy)
                </td>
            </tr>

            <tr>
                <td align="center">
                    <a href=MasterInformation.jsp> Go to Main </a>
                </td>

                <td align="left">
                    <input type="button" name="upload_batch" value="Submit" onClick="ValidateInput()">
                </td>
            </tr>
        </table>
    </form>
</div>

<script src="${pageContext.request.contextPath}/js/validate.js"></script>
<script>

    function CheckDatesValidtiy() {
        if (!CheckDate(document.the_form.batch_arrival_date.value)) return false;
        if (!CheckDate(document.the_form.batch_expiry_date.value)) return false;

        var temp = new Array();
        temp = document.the_form.batch_arrival_date.value.split('-');

        var month_no = getMonthNumber(temp[1]);
        var arrival_date = new Date(temp[2], month_no, temp[0]);

        temp = document.the_form.batch_expiry_date.value.split('-');
        month_no = getMonthNumber(temp[1]);
        var expiry_date = new Date(temp[2], month_no, temp[0]);

        var last_month_date = new Date();
        last_month_date.setDate(last_month_date.getDate() - 30);

        if (arrival_date < last_month_date) {
            alert("Batch Arrival Date is too old.  Please check it.  It can not be older than a month");
            return false;
        }

        if (expiry_date <= arrival_date) {
            alert("Batch Expiry Date must be future date compared to arrival date.  Please check it");
            return false;
        }

        return true;
    }

    function ValidateInput() {
        var errString = "";

        if (!CheckNumbers(document.the_form.batch_supplied_by.value, ""))
            errString += "\r\Batch Supplied By must have only numbers.  Please enter a proper value";

        if (eval(document.the_form.batch_supplied_by.value) == 0)
            errString += "\r\Batch Supplied By must be selected.  Please select a proper value";

        if (!CheckNumbers(document.the_form.product_name.value, ""))
            errString += "\r\nProduct ID must have only numbers.  Please enter a proper value";

        if (eval(document.the_form.product_name.value) == 0)
            errString += "\r\Product Name must be selected.  Please select a proper value";

        if (!CheckNumbers(document.the_form.product_sale_id.value, ""))
            errString += "\r\nProduct Sale Info ID must have only numbers.  Please enter a proper value";

        if (eval(document.the_form.product_sale_id.value) == 0)
            errString += "\r\Product sale information must be selected.  Please select a proper value";

        if (!CheckSpecialCharacters(document.the_form.batch_id.value, ""))
            errString += "\r\Batch ID must have only characters and numbers.  Please enter a proper value";

        if (!IsNULL(document.the_form.quantity.value)) {
            if (!CheckNumbers(document.the_form.quantity.value, ""))
                errString += "\r\nQuantity must have only numbers.  Please enter a proper value";
        }

        if (!CheckNumbers(document.the_form.unit_purchase_price.value, "."))
            errString += "\r\nUnit Purchase Price must have only numbers.  Please enter a proper value";

        if (Number(document.the_form.face_value.value) != 0 && Number(document.the_form.unit_purchase_price.value) > Number(document.the_form.face_value.value))
            errString += "\r\nUnit Purchase Price is more than Product Face Value.  Please enter a proper value";

        if (!CheckNumbers(document.the_form.probable_sale_price.value, "."))
            errString += "\r\Probable Sale Price must have only numbers.  Please enter a proper value";

        if (Number(document.the_form.face_value.value) != 0 && Number(document.the_form.probable_sale_price.value) > Number(document.the_form.face_value.value))
            errString += "\r\nProbable Sale Price is more than Product Face Value.  Please enter a proper value";

        if (!CheckNumbers(document.the_form.batch_cost.value, "."))
            errString += "\r\Unit Batch Cost Price must have only numbers.  Please enter a proper value";

        if (!IsNULL(document.the_form.max_topus.value) && !CheckNumbers(document.the_form.max_topus.value, ""))
            errString += "\r\Max Topups for the SIM Cards can only be a number.  Please enter a proper value";

        if (Number(document.the_form.batch_cost.value) > Number(document.the_form.unit_purchase_price.value))
            errString += "\r\nUnit Batch Cost Price is more than Unit Purchase Price.  Please correct it.";

        if (!CheckSpecialCharacters(document.the_form.file_to_upload.value, "-:\\/_. "))
            errString += "\r\nFile to upload must be a proper file path.";

        if (!CheckDatesValidtiy())
            errString += "\r\nBatch Arrival and Batch Expiry Dates are not matching.  Please select proper dates";

        if (IsNULL(document.the_form.batch_cost.value) || Number(document.the_form.batch_cost.value) <= 0)
            errString += "\r\nUnit Batch Cost Price is not a proper value.  Please enter proper COST PRICE.";

        if (IsNULL(document.the_form.unit_purchase_price.value) || Number(document.the_form.unit_purchase_price.value) <= 0)
            errString += "\r\nUnit Purchase Price is not a proper value.  Please enter proper unit purchase price.";

        if (IsNULL(document.the_form.probable_sale_price.value) || Number(document.the_form.probable_sale_price.value) <= 0)
            errString += "\r\nProbable Sale Price is not a proper value.  Please enter proper probable sale price.";

        if (errString == null || errString.length <= 0) {
            if (!confirm("Are these values correct?  \r\n" + "\r\nUnit BATCH COST Price = " + document.the_form.batch_cost.value + "\r\nUnit Purchase Price = " + document.the_form.unit_purchase_price.value + "\r\nProbable Sale Price = " + document.the_form.probable_sale_price.value))
                return;

            if (Number(document.the_form.batch_cost.value) == Number(document.the_form.unit_purchase_price.value))
                if (!confirm("Unit BATCH COST is same as Unit Purchase Price.  Is this Correct?")) return;

            if (Number(document.the_form.unit_purchase_price.value) == Number(document.the_form.face_value.value))
                if (!confirm("Unit Purchase Price is same as Face Value.  Is this Correct?")) return;

            if (Number(document.the_form.probable_sale_price.value) == Number(document.the_form.face_value.value))
                if (!confirm("Probable Sale Price is same as Face Value.  Is this Correct?")) return;

            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text")
                    CheckDatabaseChars(document.the_form.elements[i]);

            document.the_form.action = "AddBatchInfo.jsp";
            document.the_form.submit();
        }
        else
            alert(errString);
    }

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

                var elOptionDefault = document.createElement('option');
                elOptionDefault.value = 0;
                elOptionDefault.innerHTML = "Select";
                element.appendChild(elOptionDefault);

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
                }
                httpObj = null;

                get_saleinfo();
            }
        };

        var url = "AJAX_GetProducts.jsp?supplier_id=" + document.the_form.supplier_id.value;
        httpObj.open("POST", url, true);
        httpObj.send(null);
    }

    function get_saleinfo() {
        update_previous_unit_price();

        var httpObj = getHttpObject();
        if (httpObj == null) {
            alert("Can not get product sale information");
            return;
        }

        httpObj.onreadystatechange = function () {
            if (httpObj.readyState == 4) {
                var element = document.getElementById('product_sale_id_field');
                for (var i = 0; i < element.length; i++)
                    element.remove(i);
                element.innerHTML = "";

                var elDefaultOption = document.createElement('option');
                elDefaultOption.value = 0;
                elDefaultOption.innerHTML = "Select";
                element.appendChild(elDefaultOption);

                var nl = httpObj.responseXML.getElementsByTagName('product_sale_info');

                for (i = 0; i < nl.length; i++) {
                    var nli = nl.item(i);
                    var id = nli.getAttribute('id');
                    var prod_id = nli.getAttribute('product_id');
                    var selected = nli.getAttribute('selected');

                    var elOption = document.createElement('option');
                    elOption.value = id;
                    elOption.innerHTML = id;
                    if (selected == 1)
                        elOption.selected = true;
                    element.appendChild(elOption);
                }
                httpObj = null;
                update_sale_info();
            }
        };

        var url = "AJAX_GetProductSaleInfo.jsp?product_id=" + document.the_form.product_name.value + "&new_batch=1";
        httpObj.open("POST", url, true);
        httpObj.send(null);
    }

    function update_previous_unit_price() {
        if (document.the_form.product_name.value == 0) return;

        var httpObj = getHttpObject();
        if (httpObj == null) {
            alert("Can not get unit purchase price information");
            return;
        }

        httpObj.onreadystatechange = function () {
            if (httpObj.readyState == 4) {
                var element = document.getElementById('price_field');
                element.value = "";
                var nl = httpObj.responseXML.getElementsByTagName('unit_price');
                var nli = nl.item(0);
                var unit_value = nli.getAttribute('value');
                element.value = unit_value;

                element = document.getElementById('sale_price_field');
                element.value = "";
                unit_value = nli.getAttribute('probable_sale_price');
                element.value = unit_value;

                element = document.getElementById('face_value_field');
                element.value = "";
                unit_value = nli.getAttribute('face_value');
                element.value = unit_value;

                element = document.getElementById('batch_cost_field');
                element.value = "";
                unit_value = nli.getAttribute('cost_price');
                element.value = unit_value;

                element = document.getElementById('max_topups_field');
                var maxTopups = nli.getAttribute('max_topups');

                if (maxTopups < 0) {
                    element.value = 0;
                    element.disabled = true;
                    element.style.background = "#FFFFFF";
                }
                else {
                    element.value = maxTopups;
                    element.disabled = false;
                    element.style.background = "#33CC00";
                }

                httpObj = null;
            }
        };

        var supp_id = document.the_form.supplier_id.value;
        if (document.the_form.batch_supplied_by.value != 0)
            supp_id = document.the_form.batch_supplied_by.value;

        var url = "AJAX_GetUnitPrice.jsp?product_id=" + document.the_form.product_name.value +
                "&supplier_id=" + supp_id;
        httpObj.open("POST", url, true);
        httpObj.send(null);
    }

    function update_sale_info() {
        if (document.the_form.product_sale_id.value == 0) {
            var element = document.getElementById('product_detailed_info_id');
            element.innerHTML = "";
            return;
        }

        var httpObj = getHttpObject();
        if (httpObj == null) {
            alert("Can not get product sale information");
            return;
        }

        httpObj.onreadystatechange = function () {
            if (httpObj.readyState == 4) {
                var theHTML = httpObj.responseText;
                var element = document.getElementById('product_detailed_info_id');
                element.innerHTML = theHTML;
                httpObj = null;
            }
        };

        var url = "AJAX_UpdateProductSaleInfo.jsp?sale_info_id=" + document.the_form.product_sale_id.value;
        httpObj.open("POST", url, true);
        httpObj.send(null);
    }

</script>