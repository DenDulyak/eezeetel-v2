<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Monthly Stock Information Report</title>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>

        var xmlDoc = null;
        var supplier_list = {};
        var product_list = {};

        function displayReportData(supplier) {
            var supplier = document.the_form.supplier_name.value;
            var product = document.the_form.product_name.value;
            if (supplier == null || supplier.length <= 0) supplier = "All";
            if (product == null || product.length <= 0) product = "All";

            if (xmlDoc == null) return;
            if (supplier == null || supplier.length <= 0) return;
            if (product == null || product.length <= 0) return;
            var records = xmlDoc.getElementsByTagName("record");
            var total_stock_value = 0;
            var remaining_stock_value = 0;
            var table_data = "<table class='table table-bordered'>";
            table_data += "<tr><th>Product ID</th><th>Product Name</th><th>Supplier Name</th><th>Face Value</th>";
            table_data += "<th>Original Quantity</th><th>Available Quantity</th><th>Unit Purchase Price</th>";
            table_data += "<th>Remaining Stock Amount</th><th>Total Stock Amount</th></tr>";

            for (i = 0; i < records.length; i++) {
                var product_id = records[i].getAttribute("product_id");
                var product_name = records[i].getAttribute("product_name");
                var supplier_name = records[i].getAttribute("supplier_name");
                var face_value = records[i].getAttribute("face_value");
                var quantity = records[i].getAttribute("quantity");
                var availQuantity = records[i].getAttribute("available_quantity");
                var unitPrice = records[i].getAttribute("unit_price");
                var remaining_total = eval(unitPrice * availQuantity);
                var total_value = eval(unitPrice * quantity);

                supplier_list[supplier_name] = supplier_name;
                product_list[product_name] = product_name;

                if (supplier != "All" && supplier != supplier_name)
                    continue;

                if (product != "All" && product != product_name)
                    continue;

                remaining_stock_value = eval(eval(remaining_stock_value) + eval(remaining_total));
                total_stock_value = eval(eval(total_stock_value) + eval(total_value));


                table_data += "<tr>";
                table_data += ("<td>" + product_id + "</td>");
                table_data += ("<td>" + product_name + "</td>");
                table_data += ("<td>" + supplier_name + "</td>");
                table_data += ("<td>" + eval(face_value).toFixed(2) + "</td>");
                table_data += ("<td>" + quantity + "</td>");
                table_data += ("<td>" + availQuantity + "</td>");
                table_data += ("<td>" + eval(unitPrice).toFixed(2) + "</td>");
                table_data += ("<td>" + remaining_total.toFixed(2) + "</td>");
                table_data += ("<td>" + total_value.toFixed(2) + "</td>");
                table_data += "</tr>";
            }
            table_data += "<tr><td></td><td></td><td></td><td></td><td></td><td></td>";
            table_data += "<td><font color=\"red\">Total</font></td>";
            table_data += ("<td><font color=\"red\">" + remaining_stock_value.toFixed(2) + "</font></td>");
            table_data += ("<td><font color=\"red\">" + total_stock_value.toFixed(2) + "</font></td>");
            table_data += "</table>";
            document.getElementById("report_data").innerHTML = table_data;
        }

        function verifyDates() {
            if (eval(document.the_form.start_year_number.value) == eval(document.the_form.end_year_number.value)) {
                if (eval(document.the_form.start_month_number.value) > eval(document.the_form.end_month_number.value)) {
                    alert("Report Start Month must be before or same as Report End Month");
                    return false;
                }
            }
            else if (eval(document.the_form.start_year_number.value) > eval(document.the_form.end_year_number.value)) {
                alert("Report Start Year must be before or same as Report End Year");
                return false;
            }

            return true;
        }

        function populateXMLData() {
            if (!verifyDates()) return;

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get transaction details");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    xmlDoc = httpObj.responseXML;
                    displayReportData();

                    // populate suppliers

                    {
                        var element = document.getElementById('supplier_field_id');
                        for (var i = 0; i < element.length; i++)
                            element.remove(i);
                        element.innerHTML = "";
                        var elOption = document.createElement('option');
                        elOption.value = "All";
                        elOption.innerHTML = "All";
                        elOption.selected = true;
                        element.appendChild(elOption);

                        for (var key in supplier_list) {
                            var elOption1 = document.createElement('option');
                            elOption1.value = key;
                            elOption1.innerHTML = key;
                            element.appendChild(elOption1);
                        }
                    }

                    // populate products

                    {
                        var element = document.getElementById('product_field_id');
                        for (var i = 0; i < element.length; i++)
                            element.remove(i);
                        element.innerHTML = "";
                        var elOption = document.createElement('option');
                        elOption.value = "All";
                        elOption.innerHTML = "All";
                        elOption.selected = true;
                        element.appendChild(elOption);

                        for (var key in product_list) {
                            var elOption1 = document.createElement('option');
                            elOption1.value = key;
                            elOption1.innerHTML = key;
                            element.appendChild(elOption1);
                        }
                    }
                }
            }

            var url = "AJAX_GetMonthlyStockInformationReport.jsp?start_year_number=" +
                    document.the_form.start_year_number.value +
                    "&start_month_number=" + document.the_form.start_month_number.value +
                    "&end_year_number=" + document.the_form.end_year_number.value +
                    "&end_month_number=" + document.the_form.end_month_number.value;

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
                        <form name="the_form" method="post" action="">
                            <%
                                Calendar cal = Calendar.getInstance();
                                int nCurrentYear = cal.get(Calendar.YEAR);
                                int nPreviousYear = nCurrentYear - 1;
                                int nMonth = cal.get(Calendar.MONTH);
                                nMonth += 1;
                            %>
                            <table>
                                <tr>
                                    <td>
                                        Product : <select name="product_name" id="product_field_id" onchange="displayReportData()">
                                    </select>
                                    </td>
                                    <td>
                                        Supplier : <select name="supplier_name" id="supplier_field_id" onchange="displayReportData()">
                                    </select>
                                    </td>
                                    <td>
                                        Start Year : <select name="start_year_number">
                                        <option value="<%=nCurrentYear%>" selected><%=nCurrentYear%>
                                        </option>
                                        <option value="<%=nPreviousYear%>"><%=nPreviousYear%>
                                        </option>
                                    </select>
                                    </td>
                                    <td>
                                        Start Month : <select name="start_month_number">
                                        <option value="1" <%=((nMonth == 1) ? "selected" : "")%>>January</option>
                                        <option value="2" <%=((nMonth == 2) ? "selected" : "")%>>February</option>
                                        <option value="3" <%=((nMonth == 3) ? "selected" : "")%>>March</option>
                                        <option value="4" <%=((nMonth == 4) ? "selected" : "")%>>April</option>
                                        <option value="5" <%=((nMonth == 5) ? "selected" : "")%>>May</option>
                                        <option value="6" <%=((nMonth == 6) ? "selected" : "")%>>June</option>
                                        <option value="7" <%=((nMonth == 7) ? "selected" : "")%>>July</option>
                                        <option value="8" <%=((nMonth == 8) ? "selected" : "")%>>August</option>
                                        <option value="9" <%=((nMonth == 9) ? "selected" : "")%>>September</option>
                                        <option value="10" <%=((nMonth == 10) ? "selected" : "")%>>October</option>
                                        <option value="11" <%=((nMonth == 11) ? "selected" : "")%>>November</option>
                                        <option value="12" <%=((nMonth == 12) ? "selected" : "")%>>December</option>
                                    </select>
                                    </td>
                                    <td>
                                        End Year : <select name="end_year_number">
                                        <option value="<%=nCurrentYear%>" selected><%=nCurrentYear%>
                                        </option>
                                        <option value="<%=nPreviousYear%>"><%=nPreviousYear%>
                                        </option>
                                    </select>
                                    </td>
                                    <td>
                                        End Month : <select name="end_month_number">
                                        <option value="1" <%=((nMonth == 1) ? "selected" : "")%>>January</option>
                                        <option value="2" <%=((nMonth == 2) ? "selected" : "")%>>February</option>
                                        <option value="3" <%=((nMonth == 3) ? "selected" : "")%>>March</option>
                                        <option value="4" <%=((nMonth == 4) ? "selected" : "")%>>April</option>
                                        <option value="5" <%=((nMonth == 5) ? "selected" : "")%>>May</option>
                                        <option value="6" <%=((nMonth == 6) ? "selected" : "")%>>June</option>
                                        <option value="7" <%=((nMonth == 7) ? "selected" : "")%>>July</option>
                                        <option value="8" <%=((nMonth == 8) ? "selected" : "")%>>August</option>
                                        <option value="9" <%=((nMonth == 9) ? "selected" : "")%>>September</option>
                                        <option value="10" <%=((nMonth == 10) ? "selected" : "")%>>October</option>
                                        <option value="11" <%=((nMonth == 11) ? "selected" : "")%>>November</option>
                                        <option value="12" <%=((nMonth == 12) ? "selected" : "")%>>December</option>
                                    </select>
                                    </td>
                                    <td>
                                        <input type="button" name="Generate" value="Generate" onClick="populateXMLData()">
                                    </td>
                                </tr>
                            </table>
                            <BR><BR>

                            <div id="report_data"></div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>