<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    .table-custom {
        width: 100%;
        margin-top: 20px;
    }
</style>

<div class="container-fluid">
    <br/>

    <div class="row">
        <div class="form-group-sm form-inline col-sm-12 has-feedback has-feedback-left">
            <label for="from" class="control-label">From: </label>
            <input id="from" type="text" class="form-control"/>
            <label for="to" class="control-label">To: </label>
            <input id="to" type="text" class="form-control"/>
            <label for="supplier" class="control-label">Supplier: </label>

            <div class="form-group">
                <select id="supplier" class="form-control">
                    <option value="0">All</option>
                    <c:forEach items="${suppliers}" var="supplier">
                        <option value="${supplier.id}">${supplier.supplierName}</option>
                    </c:forEach>
                </select>
            </div>
            <input type="button" class="btn-sm btn-primary searchBtn" value="Search"/>
        </div>
    </div>
    <table class="table-sm table-striped table-custom">
        <thead>
        <tr>
            <th hidden>Batch ID</th>
            <th>Product ID</th>
            <th>Product Name</th>
            <th>Supplier Name</th>
            <th>Begining Quantity</th>
            <th>Transactions</th>
            <th>Sales</th>
            <th>Entered Quantity</th>
            <th>Purchase Price</th>
            <th>Sale Price</th>
            <th>End Quantity</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>

<script>
    $(function () {
        var container = $('.container-fluid');
        var tbody = $('tbody');
        var from = $('#from');
        var to = $('#to');

        from.datepicker({format: 'yyyy-mm-dd'})
                .datepicker("setDate", new Date(new Date().getTime() - 24 * 60 * 60 * 1000));

        to.datepicker({format: 'yyyy-mm-dd'})
                .datepicker("setDate", new Date());

        $('.searchBtn').click(function (e) {
            container.pleaseWait();
            tbody.empty();

            $.ajax({
                url: '/masteradmin/report/reconciliation',
                type: 'GET',
                dataType: 'json',
                data: {
                    from: from.val(),
                    to: to.val(),
                    supplierId: $("#supplier").val()
                },
                success: function (data) {
                    var totalTransactions = 0;
                    var totalSales = 0;
                    var totalPurchasePrice = 0.0;
                    var totalSalePrice = 0.0;
                    $.each(data, function (key, value) {
                        if (value.sales < 1) {
                            return;
                        }
                        var row = '<tr>';
                        row += '<td hidden>' + value.batchInfoId + '</td>';
                        row += '<td>' + value.productId + '</td>';
                        row += '<td>' + value.productName + ' - ' + value.faceValue + '</td>';
                        row += '<td>' + value.supplierName + '</td>';
                        row += '<td>' + value.beginingQuantity + '</td>';
                        row += '<td>' + value.transactions + '</td>';
                        row += '<td>' + value.sales + '</td>';
                        row += '<td>' + value.enteredQuantity + '</td>';
                        row += '<td>' + value.sumPurchasePrice + '</td>';
                        row += '<td>' + value.sumSalePrice + '</td>';
                        row += '<td>' + value.availableQuantity + '</td>';
                        row += '</tr>';
                        tbody.append(row);

                        totalTransactions += value.transactions;
                        totalSales += value.sales;
                        totalPurchasePrice += value.sumPurchasePrice;
                        totalSalePrice += value.sumSalePrice;
                    });

                    var row = '<tr style="background-color: #d9edf7 !important">' +
                            '<td colspan="4">Totals</td>' +
                            '<td>' + totalTransactions.toFixed(0) + '</td>' +
                            '<td>' + totalSales.toFixed(0) + '</td>' +
                            '<td></td>' +
                            '<td>' + totalPurchasePrice.toFixed(2) + '</td>' +
                            '<td colspan="2">' + totalSalePrice.toFixed(2) + '</td>' +
                            '</tr>';
                    tbody.append(row);

                    container.pleaseWait('stop');
                }
            });
        });
    });
</script>
