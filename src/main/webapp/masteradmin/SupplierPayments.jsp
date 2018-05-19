<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script language="javascript" src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script language="javascript">
        function update_payments() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get supplier payments information");
                return;
            }

            var supplier_id = document.the_form.supplier_id.value;
            if (isNaN(supplier_id) || supplier_id <= 0)
                supplier_id = 0;

            var element = document.getElementById('payment_information');
            element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    element.innerHTML = httpObj.responseText;
                }
            }

            var url = "AJAX_GetSupplierPaymentInformation.jsp?supplier_id=" + supplier_id + "&already_paid=" + document.the_form.paid_ones.checked;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
    </script>
    <title>Customer Day Transaction</title>
</head>
<body onload="update_payments()">
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <form name="the_form" method="post" action="">
                            <table>
                                <tr>
                                    <td align="left">
                                        Supplier :
                                    </td>
                                    <td align="left">
                                        <genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also="1"
                                                                   initial_option="All" onChange="update_payments()" default_select="0"/>
                                    </td>
                                    <td align="left">
                                        Already Paid :
                                    </td>
                                    <td align="left">
                                        <input type="checkbox" name="paid_ones" onclick="update_payments()">
                                    </td>
                                </tr>
                            </table>
                            <div id="payment_information">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>