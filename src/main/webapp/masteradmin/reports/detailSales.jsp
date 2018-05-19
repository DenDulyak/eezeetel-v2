<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }

    .detailBtn {
        padding: 2px 6px !important;
    }
</style>

<div class="container-fluid">
    <br/>

    <div class="row">
        <div class="form-group form-inline">
            <label for="from" class="control-label">From: </label>
            <input id="from" type="text" class="form-control"/>
            <label for="to" class="control-label">To: </label>
            <input id="to" type="text" class="form-control"/>
            <label for="supplier" class="control-label">Supplier: </label>

            <select id="supplier" class="form-control">
                <option value="0">All</option>
                <c:forEach items="${suppliers}" var="supplier">
                    <option value="${supplier.id}">${supplier.supplierName}</option>
                </c:forEach>
            </select>

            <div class="form-group products" style="display: none">
                <label for="product" class="control-label">Product: </label>

                <select id="product" class="form-control">
                </select>
            </div>
            <input type="button" class="btn btn-primary searchBtn" value="Search"/>
        </div>
    </div>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Product Name</th>
            <th>Face Value</th>
            <th>Transactions</th>
            <th>Sales</th>
            <th>Single Card purchase</th>
            <th>Multiple Card purchase</th>
            <th></th>
        </tr>
        </thead>
        <tbody class="detailSalesTableBody">
        </tbody>
    </table>
</div>

<c:import url="/masteradmin/popups/detailProductSales.jsp"/>

<script>
    $(function () {
        $('#from').datepicker("setDate", new Date());
        $('#to').datepicker("setDate", new Date(new Date().getTime() + 24 * 60 * 60 * 1000));

        $('.searchBtn').click(function (e) {
            var from = $('#from').val();
            var to = $('#to').val();
            var tbody = $('.detailSalesTableBody');
            tbody.empty();
            $('.container-fluid').pleaseWait();
            $.ajax({
                url: '/masteradmin/report/detail-sales-by-supplier-id',
                type: 'GET',
                dataType: 'json',
                data: {
                    from: from,
                    to: to,
                    supplierId: $("#supplier").val(),
                    productId: $("#product").val()
                },
                success: function (data) {
                    var totalTransactions = 0;
                    var totalSales = 0;

                    $.each(data, function (key, value) {
                        totalTransactions += value.transactions;
                        totalSales += value.sales;

                        var row = '<tr>';
                        row += '<td>' + value.productName + '</td>';
                        row += '<td>' + value.faceValue + '</td>';
                        row += '<td>' + value.transactions + '</td>';
                        row += '<td>' + value.sales + '</td>';
                        row += '<td>' + value.singlePurchases + '</td>';
                        row += '<td>' + value.multiplepurchases + '</td>';
                        row += '<td><button id="' + value.productId + '" class="btn btn-info detailBtn" data-toggle="modal" data-target="#detailProductSalesModal">In Details</button></td>';
                        row += '</tr>';
                        tbody.append(row);
                    });

                    var totals = "<tr class='info'>" +
                            "<td colspan='2'>Totals</td>" +
                            "<td>" + totalTransactions + "</td>" +
                            "<td colspan='4'>" + totalSales + "</td>" +
                            "</tr>";

                    tbody.append(totals);

                    $('.container-fluid').pleaseWait('stop');
                    init();
                }
            });
        });

        $("#supplier").change(function () {
            var productsDiv = $('.products');
            var product = $('#product');
            product.find('option').remove();
            var supplierId = $("#supplier").val();
            if (supplierId > 0) {
                productsDiv.show();
                $.ajax({
                    url: '/masteradmin/report/products-by-supplier-id',
                    type: 'GET',
                    dataType: 'json',
                    data: {
                        id: supplierId
                    },
                    success: function (data) {
                        product.append(new Option('All', 0));
                        $.each(data, function (key, value) {
                            product.append(new Option(value.productName + ' ' + value.productFaceValue, value.id));
                        });
                    }
                });
            } else {
                productsDiv.hide();
            }
        });

        var init = function () {
            var detailBtn = $('.detailBtn');
            detailBtn.unbind("click");
            detailBtn.click(function (e) {
                var from = $('#from').val();
                var to = $('#to').val();
                var tbody = $('.detailProductSalesTableBody');
                tbody.empty();
                $('.modal-dialog').pleaseWait();
                $.ajax({
                    url: '/masteradmin/report/detail-product-sales',
                    type: 'GET',
                    dataType: 'json',
                    data: {
                        from: from,
                        to: to,
                        productId: $(this).attr('id')
                    },
                    success: function (data) {
                        $.each(data, function (key, value) {
                            var row = '<tr>';
                            row += '<td>' + value.transactionId + '</td>';
                            row += '<td>' + value.transactionTime + '</td>';
                            row += '<td>' + value.customer + '</td>';
                            row += '<td>' + value.userName + '</td>';
                            row += '<td>' + value.purchasePrice + '</td>';
                            row += '<td>' + value.sales + '</td>';
                            row += '</tr>';
                            tbody.append(row);
                        });
                        $('.modal-dialog').pleaseWait('stop');
                    }
                });
            });
        }
    });
</script>