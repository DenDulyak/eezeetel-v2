<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }

    .btn {
        padding: 2px 4px !important;
        margin: 2px;
    }
</style>

<div class="container-fluid">
    <h2>Mobile Unlocking Orders</h2>

    <div class="row">
        <div class="col-lg-12 form-group">
            <label class="radio-inline">
                <input type="radio" name="status" value="-1" checked>
                All
            </label>
            <label class="radio-inline">
                <input type="radio" name="status" value="0">
                New Order
            </label>
            <label class="radio-inline">
                <input type="radio" name="status" value="1">
                Assigned
            </label>
            <label class="radio-inline">
                <input type="radio" name="status" value="2">
                Completed
            </label>
            <label class="radio-inline">
                <input type="radio" name="status" value="3">
                Rejected
            </label>
        </div>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Mobile Unlocking</th>
            <th>User</th>
            <th>IMEI</th>
            <th>Code</th>
            <th>Order Date</th>
            <th>Assigned to</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>

        </tbody>
    </table>

    <ul class="pagination pagination-sm libraryPagination">

    </ul>

    <c:import url="mobileunlocking/orderForm.jsp"/>
    <c:import url="mobileunlocking/assignForm.jsp"/>
</div>

<script>
    $(function () {

        $.ajax({
            type: 'GET',
            url: '/masteradmin/user/find-by-type',
            data: {typeId: 9},
            dataType: 'json',
            success: function (data) {
                var mobileAdmin = $('#login');
                $.each(data, function (key, value) {
                    mobileAdmin.append(new Option(value.login, value.login));
                });
            }
        });

        var updateTable = function (page, status) {
            $.ajax({
                type: 'GET',
                url: '/masteradmin/mobile-unlocking-order/find-by-status',
                data: {
                    size: 50,
                    page: page,
                    status: status
                },
                dataType: 'json',
                success: function (data) {
                    updateTableData(data);
                    btnEvents();

                    var pagination = $('.pagination');
                    pagination.empty();

                    for (var i = 1; i <= data.totalPages; i++) {
                        var li = '<li';
                        if (i == (data.number + 1)) {
                            li += ' class="active" ';
                        }
                        li += '><a>' + i + '</a></li>';
                        pagination.append(li);
                    }

                    $('.pagination a').click(function () {
                        updateTable(($(this).text() - 1), $('input[type=radio][name=status]:checked').val());
                    });
                }
            });
        };

        var updateTableData = function (data) {
            var tbody = $('tbody');
            tbody.empty();
            $.each(data.content, function (key, order) {
                var row = '<tr id="' + order.id + '"';
                if (order.status == 'REJECTED') {
                    row += ' class="danger"';
                }
                row += '>';
                row += '<td>' + order.mobileUnlocking.title + '</td>';
                row += '<td>' + order.user.login + '</td>';
                row += '<td>' + order.imei + '</td>';
                row += '<td>' + (order.code == null ? '' : order.code) + '</td>';
                row += '<td>' + order.createdDate + '</td>';
                if (order.assigned != null) {
                    row += '<td>' + order.assigned.login + '</td>';
                } else {
                    row += '<td></td>';
                }
                row += '<td>' + order.status + '</td>';
                row += '<td>' +
                        '<input type="button" class="btn btn-info orderInfo" data-toggle="modal" data-target="#orderModal" value="Info"/>' +
                        '<input type="button" class="btn btn-primary assign" data-toggle="modal" data-target="#assignModal" value="Assign"/>' +
                        '</td>';
                tbody.append(row);
            });
        };

        var btnEvents = function () {
            var assign = $('.assign');
            assign.unbind("click");
            assign.click(function (e) {
                var orderId = $(this).parent().parent().attr('id');
                $('#orderId').val(orderId);
            });

            var assignSave = $('.assignSave');
            assignSave.unbind("click");
            assignSave.click(function (e) {
                $.ajax({
                    type: 'POST',
                    url: '/masteradmin/mobile-unlocking-order/assign',
                    data: $('#assignForm').serialize(),
                    dataType: 'json',
                    success: function (data) {
                        window.location.reload();
                    }
                });
            });

            var orderInfo = $('.orderInfo');
            orderInfo.unbind("click");
            orderInfo.click(function (e) {
                var orderId = $(this).parent().parent().attr('id');
                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/mobile-unlocking-order/get',
                    data: {id: orderId},
                    dataType: 'json',
                    success: function (data) {
                        var order = data;
                        $('#mobileUnlockingTitle').text(order.mobileUnlocking.title);
                        $('#user').text(order.user.login);
                        $('#imei').text(order.imei);
                        $('#code').text(order.code);
                        $('#price').text(order.price);
                        $('#balanceBefore').text(order.balanceBefore);
                        $('#balanceAfter').text(order.balanceAfter);
                        $('#customerEmail').text(order.customerEmail);
                        $('#mobileNumber').text(order.mobileNumber);
                        $('#status').text(order.status);
                        $('#assigned').text(order.assigned.login);
                        $('#createdDate').text(order.createdDate);
                        $('#updatedDate').text(order.updatedDate);
                        $('#transactionCondition').text(order.mobileUnlocking.transactionCondition);
                        $('#notes').text(order.notes);
                    }
                });
            });
        };

        $('input[type=radio][name=status]').change(function () {
            updateTable(0, this.value);
        });

        updateTable(0, -1);
    });
</script>
