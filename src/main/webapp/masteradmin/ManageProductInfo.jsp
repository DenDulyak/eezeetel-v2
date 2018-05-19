<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function update_products(isInitialLoad) {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get product information");
                return;
            }

            var sup_id = 0;
            if (!isInitialLoad)
                sup_id = document.the_form.supplier_id.value;
            if (sup_id == 0)
                sup_id = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var theHTML = "<table class='table table-striped'>" +
                            "<thead>" +
                            "<tr>" +
                            "<td></td>" +
                            "<td>Supplier</td>" +
                            "<td>Product Name</td>" +
                            "<td>Product Type</td>" +
                            "<td>Product Face Value</td>" +
                            "<td>Product Description</td>" +
                            "<td>Product Created By</td>" +
                            "<td>Notes</td>" +
                            "<td>Product Active</td>" +
                            "<td>Caliculate VAT</td> " +
                            "<td>Cost Price</td> " +
                            "</tr>" +
                            "</thead>";

                    var element = document.getElementById('product_detailed_info_id');
                    element.innerHTML = "";

                    var nl = httpObj.responseXML.getElementsByTagName('product');

                    for (i = 0; i < nl.length; i++) {
                        var nli = nl.item(i);
                        var id = nli.getAttribute('id');
                        var sup_name = nli.getAttribute('sup_name');
                        var name = nli.getAttribute('name');
                        var type = nli.getAttribute('type');
                        var value = nli.getAttribute('value');
                        var desc = nli.getAttribute('desc');
                        var first_name = nli.getAttribute('first_name');
                        var notes = nli.getAttribute('notes');
                        var active = nli.getAttribute('active');
                        var calcvat = nli.getAttribute('calcvat');
                        var costPrice = nli.getAttribute('costPrice');
                        var bgcolor = active ? "active" : "danger";
                        var strIsActive = active ? "Yes" : "No";
                        var strCalcVAT = (calcvat == 1) ? "Yes" : "No";

                        oneRow = ("<tr class=" + bgcolor + ">" +
                        "<td><input type='radio' name='record_id' value='" + id + "'></td>" +
                        "<td>" + sup_name + "</td>" +
                        "<td>" + name + "</td>" +
                        "<td>" + type + "</td>" +
                        "<td>" + value + "</td>" +
                        "<td>" + desc + "</td>" +
                        "<td>" + first_name + "</td>" +
                        "<td>" + notes + "</td>" +
                        "<td>" + strIsActive + "</td>" +
                        "<td>" + strCalcVAT + "</td>" +
                        "<td>" + costPrice + "</td>" +
                        "</tr>");

                        theHTML += oneRow;
                    }

                    theHTML += "</table>";

                    var element = document.getElementById('product_detailed_info_id');
                    element.innerHTML = theHTML;
                    httpObj = null;
                }
            };

            var url = "AJAX_GetProductInfo.jsp?supplier_id=" + sup_id;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
    </script>
    <meta charset="utf-8">
    <title>List, Modify, Delete or Activate Product Information</title>
</head>
<body onLoad="update_products(true)">
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <form name="the_form" action="">
                            <genericappdb:SupplierList name="supplier_id" active_records_only="1"
                                                       secondary_also="0"
                                                       initial_option="Select"
                                                       onChange="update_products(false)"
                                                       default_select="0"/>

                            <div id="product_detailed_info_id"></div>
                            <table width="100%">
                                <jsp:include page="buttons.jsp">
                                    <jsp:param name="follow_up_page" value="ProductInfo"/>
                                </jsp:include>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>