<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    .hide-arrows::-webkit-inner-spin-button,
    .hide-arrows::-webkit-outer-spin-button {
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        margin: 0;
    }
</style>

<div class="container-fluid">
    <br/>

    <div class="row">
        <div class="form-group form-inline col-sm-8">
            <label for="sequenceId" class="control-label">Sequence ID: </label>
            <input id="sequenceId" type="number" class="form-control hide-arrows"/>
            <input type="button" class="btn btn-primary searchBySequenceId" value="Search"/>
            <input type="button" class="btn btn-primary showSummaryReport" value="Summary"/>
        </div>
    </div>
    <table class="table table-striped sequenceTable" style="display: none">
        <thead>
        <tr>
            <th>Sequence ID</th>
            <th>Product Name</th>
            <th>Face Value</th>
            <th>Available Quantity</th>
            <th>Stack Quantity</th>
            <th>Total Sales</th>
            <th>Total Transactions</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

    <table class="table-sm table-striped transactionTable" style="display: none; width: 100%">
        <thead>
        <tr>
            <th>Transaction ID</th>
            <th>Quantity</th>
            <th>Date</th>
            <th>User</th>
            <th>Customer</th>
            <th>Balance Before</th>
            <th>Balance After</th>
            <th>Group</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

    <table class="table table-sm table-bordered table-striped summaryTable" style="display: none;">
        <thead>
        </thead>
        <tbody>
        </tbody>
    </table>

    <c:import url="popups/message.jsp"/>
</div>

<script>
    $(function () {
        var summaryTable = $('.summaryTable');

        $('.searchBySequenceId').click(function (e) {
            $('.container-fluid').pleaseWait();
            $('.transactionTable').hide();

            var sequenceId = $('#sequenceId').val();
            var batchTable = $('.sequenceTable');
            batchTable.show();
            summaryTable.hide();
            var tbody = batchTable.find('tbody');
            var modalBody = $('.modal-body');

            tbody.empty();
            modalBody.empty();

            $.ajax({
                url: '/masteradmin/report/by-sequence-id',
                type: 'GET',
                dataType: 'json',
                data: {id: sequenceId},
                success: function (data) {
                    if (data.productName == null) {
                        modalBody.append('<p class="error">Batch with id - ' + sequenceId + ' not found.</p>');
                        $('#modalMessage').modal('show');
                    } else {
                        if (data.sales == null) data.sales = 0;
                        var match = (data.quantity - data.availableQuantity) == data.sales ? '' : 'danger';
                        var row = '<tr class="' + match + '">';
                        row += '<td>' + data.batchInfoId + '</td>';
                        row += '<td>' + data.productName + '</td>';
                        row += '<td>' + data.faceValue + '</td>';
                        row += '<td>' + data.availableQuantity + '</td>';
                        row += '<td>' + data.quantity + '</td>';
                        row += '<td>' + data.sales + '</td>';
                        row += '<td><a class="showTransactions">' + data.amount + '</a></td>';
                        row += '</tr>';
                        tbody.append(row);
                        init();
                    }
                },
                complete: function () {
                    $('.container-fluid').pleaseWait('stop');
                }
            });
        });

        function init() {
            $('.showTransactions').click(function (e) {
                $('.container-fluid').pleaseWait();

                var sequenceId = $(this).parent().siblings(":first").text();
                var table = $('.transactionTable');
                table.show();
                var tbody = table.find('tbody');
                tbody.empty();
                $.ajax({
                    url: '/masteradmin/transaction/find-by-batch',
                    type: 'GET',
                    dataType: 'json',
                    data: {id: sequenceId},
                    success: function (data) {
                        var totalQuantity = 0;
                        $.each(data, function (key, value) {
                            totalQuantity += value.quantity;
                            var row = '<tr>';
                            row += '<td>' + value.transactionId + '</td>';
                            row += '<td>' + value.quantity + '</td>';
                            row += '<td>' + value.transactionTime + '</td>';
                            row += '<td>' + value.user.login + '</td>';
                            row += '<td>' + value.customer.companyName + '</td>';
                            row += '<td>' + (value.transactionBalance == null ? '' : value.transactionBalance.balanceBeforeTransaction) + '</td>';
                            row += '<td>' + (value.transactionBalance == null ? '' : value.transactionBalance.balanceAfterTransaction) + '</td>';
                            row += '<td>' + value.customer.group.name + '</td>';
                            row += '</tr>';
                            tbody.append(row);
                        });
                        tbody.append('<tr><td>Total</td><td>' + totalQuantity + '</td></tr>');
                    },
                    complete: function () {
                        $('.container-fluid').pleaseWait('stop');
                    }
                });
            });
        }

        $('.showSummaryReport').click(function (e) {
            $('.container-fluid').pleaseWait();

            var sequenceId = $('#sequenceId').val();
            summaryTable.show();

            var thead = summaryTable.find('thead');
            var tbody = summaryTable.find('tbody');
            thead.empty();
            tbody.empty();

            $.ajax({
                url: '/masteradmin/transaction/summary-by-batch',
                type: 'GET',
                dataType: 'json',
                data: {id: sequenceId},
                success: function (data) {
                    if (!data) {
                        return;
                    }

                    var header = '<tr><th>Year</th>';
                    var monthRow = '<tr><td>Month</td>';
                    var totalTransactionRow = '<tr><td>Transaction</td>';
                    var totalQuantityRow = '<tr><td>Quantity</td>';
                    $.each(data, function (year, months) {
                        header += '<th colspan=' + Object.keys(months).length + '>' + year + '</th>';
                        $.each(months, function (month, val) {
                            monthRow += '<td>' + month + '</td>';
                            totalTransactionRow += '<td>' + val.key + '</td>';
                            totalQuantityRow += '<td>' + val.value + '</td>';
                        });
                    });
                    header += '</tr>';
                    monthRow += '</tr>';
                    totalTransactionRow += '</tr>';
                    totalQuantityRow += '</tr>';

                    thead.append(header);
                    tbody.append(monthRow);
                    tbody.append(totalTransactionRow);
                    tbody.append(totalQuantityRow);
                },
                complete: function () {
                    $('.container-fluid').pleaseWait('stop');
                }
            });
        });
    });
</script>

