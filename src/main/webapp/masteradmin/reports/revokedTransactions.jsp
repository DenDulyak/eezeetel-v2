<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .nowrap {
        white-space: nowrap;
    }
</style>

<div class="container-fluid">
    <div class="row">
        <div class="form-group form-inline col-sm-12 has-feedback has-feedback-left">
            <label for="from" class="control-label">From: </label>
            <input id="from" type="text" class="form-control"/>
            <label for="to" class="control-label">To: </label>
            <input id="to" type="text" class="form-control"/>
            <label for="revokedTransactionStatus" class="control-label">Status: </label>

            <div class="form-group">
                <select id="revokedTransactionStatus" class="form-control">
                    <option value="-1" selected>All</option>
                    <option value="0">Not Sold</option>
                    <option value="1">Sold Again</option>
                    <option value="2">Already Credited</option>
                    <option value="3">Rejected</option>
                </select>
            </div>
            <input type="button" class="btn btn-primary searchBtn" value="Search"/>
        </div>
    </div>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Old Customer Group</th>
            <th>Old Customer</th>
            <th>Old Transaction ID</th>
            <th>Old Transaction Time</th>
            <th>Sale Price</th>
            <th>Product</th>
            <th>Batch ID</th>
            <th>Card Pin</th>
            <th class="nowrap">Revoked Date</th>
            <th>New Customer Group</th>
            <th>New Customer</th>
            <th>New Transaction ID</th>
            <th>New Transaction Time</th>
            <th>Credit</th>
            <th>Reject</th>
        </tr>
        </thead>
        <tbody>

        </tbody>
    </table>

    <ul class="pagination">

    </ul>
</div>

<script src="${pageContext.request.contextPath}/js/libs/moment-with-locales.min.js"></script>
<script>
    $(function () {
        $('#from').datepicker("setDate", new Date(new Date().getTime() - (92 * 24 * 60 * 60 * 1000)));
        $('#to').datepicker("setDate", new Date(new Date().getTime() + 24 * 60 * 60 * 1000));

        $('.searchBtn').click(function (e) {
            var status = $('#revokedTransactionStatus').val();
            updateTable(0, status);
        });

        var updateTable = function (page, status) {
            $('.container-fluid').pleaseWait();

            var from = $('#from').val();
            var to = $('#to').val();

            $.ajax({
                url: '/masteradmin/report/find-revoked-transactions',
                type: 'GET',
                dataType: 'json',
                data: {
                    from: from,
                    to: to,
                    status: status,
                    page: page
                },
                success: function (data) {
                    var table = $('table tbody');
                    table.empty();
                    $.each(data.data, function (key, value) {
                        var row = '<tr>';
                        row += '<td>' + value.customerGroup + '</td>';
                        row += '<td>' + value.customerName + '</td>';
                        row += '<td>' + value.transactionId + '</td>';
                        row += '<td class="nowrap">' + formatTime(value.transactionTime) + '</td>';
                        row += '<td>' + value.salePrice + '</td>';
                        row += '<td class="nowrap">' + value.productName + '</td>';
                        row += '<td>' + value.batchId + '</td>';
                        row += '<td>' + value.cardPin + '</td>';
                        row += '<td>' + formatTime(value.revokedDate) + '</td>';
                        row += '<td>' + value.newCustomerGroup + '</td>';
                        row += '<td>' + value.newCustomerName + '</td>';
                        row += '<td>' + (value.newTransactionId == 0 ? "" : value.newTransactionId) + '</td>';
                        row += '<td class="nowrap">' + (value.newDate == null ? "" : formatTime(value.newDate)) + '</td>';
                        row += '<td>' + value.credit + '</td>';
                        row += '<td>' + value.reject + '</td>';
                        row += '</tr>';
                        table.append(row);
                    });

                    var pagination = $('.pagination');
                    pagination.empty();

                    for (var i = data.begin; i <= data.end; i++) {
                        var li = '<li';
                        if (i == (data.page + 1)) {
                            li += ' class="active" ';
                        }
                        li += '><a>' + i + '</a></li>';
                        pagination.append(li);
                    }

                    $('.pagination a').click(function () {
                        updateTable(($(this).text() - 1), $('#revokedTransactionStatus').val());
                    });
                },
                complete: function () {
                    $('.container-fluid').pleaseWait('stop');
                }
            });
        };

        var formatTime = function (time) {
            return moment(new Date(time)).format('YYYY-MM-DD');
        };

        updateTable(0, $('#revokedTransactionStatus').val());
    });
</script>