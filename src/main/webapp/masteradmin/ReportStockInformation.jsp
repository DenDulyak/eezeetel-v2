<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Stock Information Report</title>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>

        var xmlDoc = null;
        var supplier_list = {};

        function displayReportData(supplier) {
            if (xmlDoc == null) return;
            if (supplier == null || supplier.length <= 0) return;
            var records = xmlDoc.getElementsByTagName("record");
            var total_stock_value = 0;
            var table_data = "<table class='table table-bordered'>";
            table_data += "<tr><th>Product ID</th><th>Product Name</th><th>Supplier Name</th><th>Face Value</th>";
            table_data += "<th>Original Quantity</th><th>Available Quantity</th><th>Unit Purchase Price</th>";
            table_data += "<th>Purchase Price</th></tr>";

            for (i = 0; i < records.length; i++) {
                var product_id = records[i].getAttribute("product_id");
                var product_name = records[i].getAttribute("product_name");
                var supplier_name = records[i].getAttribute("supplier_name");
                var face_value = records[i].getAttribute("face_value");
                var quantity = records[i].getAttribute("quantity");
                var availQuantity = records[i].getAttribute("available_quantity");
                var unitPrice = records[i].getAttribute("unit_price");
                var total = eval(unitPrice * availQuantity);
                supplier_list[supplier_name] = supplier_name;

                if (supplier != "All" && supplier != supplier_name)
                    continue;

                total_stock_value = eval(eval(total_stock_value) + eval(total));

                table_data += "<tr>";
                table_data += ("<td>" + product_id + "</td>");
                table_data += ("<td>" + product_name + "</td>");
                table_data += ("<td>" + supplier_name + "</td>");
                table_data += ("<td>" + eval(face_value).toFixed(2) + "</td>");
                table_data += ("<td>" + quantity + "</td>");
                table_data += ("<td>" + availQuantity + "</td>");
                table_data += ("<td>" + eval(unitPrice).toFixed(2) + "</td>");
                table_data += ("<td>" + total.toFixed(2) + "</td>");
                table_data += "</tr>";
            }
            table_data += "<tr><td></td><td></td><td></td><td></td><td></td><td></td>";
            table_data += "<td><font color=\"red\">Total</font></td>";
            table_data += ("<td><font color=\"red\">" + total_stock_value.toFixed(2) + "</font></td>");
            table_data += "</table>";
            document.getElementById("report_data").innerHTML = table_data;
        }

        function populateXMLData() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get transaction details");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    xmlDoc = httpObj.responseXML;
                    displayReportData("All");

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
            };

            var url = "AJAX_GetStockInformationReport.jsp";
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

    </script>
</head>
<body onLoad="populateXMLData()">
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        Supplier : <select name="supplier_name" id="supplier_field_id" onchange="displayReportData(this.value)"></select>
                        <br><br>

                        <div id="report_data"></div>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>