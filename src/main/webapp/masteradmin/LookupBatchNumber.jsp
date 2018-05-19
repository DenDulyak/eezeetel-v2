<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Lookup Batch Number</title>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>

        function get_batch_information() {
            if (document.the_form.supplier_id.value == 0) {
                alert("please select a supplier.");
                return;
            }

            if (document.the_form.product_name.value == 0) {
                alert("please select a product.");
                return;
            }

            if (!CheckNumbers(document.the_form.batch_number.value)) {
                alert("Please enter a correct batch number for look up.  Only numbers are allowed");
                return;
            }

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get batch information.  Internal error");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('batch_info');
                    element.innerHTML = "";
                    element.innerHTML = httpObj.responseText;
                }
            }

            var url = "AJAX_GetBatchInfo.jsp?supplier_id=" + document.the_form.supplier_id.value +
                    "&product_name=" + document.the_form.product_name.value +
                    "&batch_number=" + document.the_form.batch_number.value;

            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function get_all_batch_information() {
            if (document.the_form.supplier_id.value == 0) {
                alert("please select a supplier.");
                return;
            }

            if (document.the_form.product_name.value == 0) {
                alert("please select a product.");
                return;
            }

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get batch information.  Internal error");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('batch_info');
                    element.innerHTML = "";
                    element.innerHTML = httpObj.responseText;
                }
            }

            var url = "AJAX_GetAllBatchInfo.jsp?supplier_id=" + document.the_form.supplier_id.value +
                    "&product_name=" + document.the_form.product_name.value;

            httpObj.open("POST", url, true);
            httpObj.send(null);
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
                        httpObj = null;
                    }
                }
            }

            var url = "AJAX_GetProducts.jsp?supplier_id=" + document.the_form.supplier_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

    </script>

</head>
<body>
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <form name="the_form" action="">
                            <table class="table table-striped">
                                <tr>
                                    <td align="right">
                                        Supplier :
                                    </td>
                                    <td align="left">
                                        <genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also="1"
                                                                   initial_option="Select" onChange="update_products()" default_select="0"/>
                                    </td>
                                    <td align="right">
                                        Product :
                                    </td>
                                    <td align="left">
                                        <select name="product_name" id="product_name_field" onchange="">
                                            <option value="0">Select</option>
                                        </select>
                                    </td>
                                    <td align="right">Enter Batch Number for lookup:</td>
                                    <td align="left"><input type="number" name="batch_number" /></td>
                                </tr>
                            </table>
                            <div class="row">
                                <div class="form-group form-inline pull-right">
                                    <input type="button" name="Lookup" class="btn" value="Lookup" onClick="get_batch_information()">
                                    <input type="button" name="Show Batches" class="btn" value="Show All Batches"
                                           onClick="get_all_batch_information()">
                                </div>
                            </div>
                            <div id="batch_info"></div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>