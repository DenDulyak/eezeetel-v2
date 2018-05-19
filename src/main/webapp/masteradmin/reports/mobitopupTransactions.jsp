<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    table {
        width: 100%;
    }

    table th, td {
        padding: 0 6px;
        vertical-align: bottom;
    }
</style>

<div class="container-fluid">
    <table class="table-sm table-striped">
        <thead>
        <tr>
            <th>Transaction ID</th>
            <th>Transaction Time</th>
            <th>Customer</th>
            <th>Balance Before</th>
            <th>Balance After</th>
            <th>Requester Phone</th>
            <th>Destination Phone</th>
            <th>Country</th>
            <th>Product</th>
            <th>Cost Price</th>
            <th>Retail Price</th>
            <th>Balance</th>
        </tr>
        </thead>
        <tbody>

        </tbody>
    </table>

    <ul class="pagination">

    </ul>
</div>

<script>
    $(function () {
        var updateTable = function (page, size) {
            var tbody = $('tbody');
            tbody.empty();

            $.ajax({
                url: '/masteradmin/mobitopup/find',
                type: 'GET',
                dataType: 'json',
                data: {
                    page: page,
                    size: size
                },
                success: function (data) {
                    $.each(data.content, function (key, value) {
                        var row = '<tr';
                        if (value.errorCode != 0) {
                            row += ' class="danger"';
                        }
                        row += '>';
                        row += '<td>' + value.transactionId + '</td>';
                        row += '<td>' + value.transactionTime + '</td>';
                        row += '<td>' + value.customer.companyName + '</td>';
                        if (value.transactionBalance) {
                            row += '<td>' + value.transactionBalance.balanceBeforeTransaction + '</td>';
                            row += '<td>' + value.transactionBalance.balanceAfterTransaction + '</td>';
                        } else {
                            row += '<td></td><td></td>';
                        }
                        row += '<td>' + value.requesterPhone + '</td>';
                        row += '<td>' + value.destinationPhone + '</td>';
                        row += '<td>' + (value.country == null ? "" : value.country.name) + '</td>';
                        row += '<td>' + value.productRequested + '</td>';
                        row += '<td>' + (value.price == null ? "" : value.price) + '</td>';
                        row += '<td>' + (value.retailPrice == null ? "" : value.retailPrice) + '</td>';
                        row += '<td>' + (value.balance == null ? "" : value.balance) + '</td>';
                        row += '</tr>';
                        tbody.append(row);
                    });

                    var pagination = $('.pagination');
                    pagination.empty();

                    for (var i = Math.max((data.number - 5), 1); i <= data.totalPages; i++) {
                        var li = '<li';
                        if (i == (data.number + 1)) {
                            li += ' class="active" ';
                        }
                        li += '><a>' + i + '</a></li>';
                        pagination.append(li);
                    }

                    $('.pagination a').click(function () {
                        updateTable(($(this).text() - 1), 50);
                    });
                }
            });
        };

        updateTable(0, 50);
    });
</script>