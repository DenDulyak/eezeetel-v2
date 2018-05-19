<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../../common/libs.jsp"/>
    <style>
        table td {
            padding: 2px 6px !important;
        }
    </style>
    <title>Mobile Unlocking Orders</title>
</head>
<body>
<div class="no-print">
    <c:import url="../headerNavbar.jsp"/>

    <div id="base-container" class="container">
        <div class="row">
            <div class="form-group form-inline col-sm-12 has-feedback has-feedback-left">
                <label for="from" class="control-label">From: </label>
                <input id="from" type="text" class="datepicker form-control" data-date-format="yyyy-mm-dd"/>
                <label for="to" class="control-label">To: </label>
                <input id="to" type="text" class="datepicker form-control" data-date-format="yyyy-mm-dd"/>
                <input id="search" type="button" class="btn btn-primary" value="Search"/>
            </div>
        </div>

        <table id="orders" class="table table-striped" style="width: 100%">
            <thead>
            <tr>
                <th>Mobile Unlocking</th>
                <th>IMEI</th>
                <th>Date</th>
                <th>Code</th>
                <th>Price</th>
                <th>Customer Email</th>
                <th>Customer Mobile Number</th>
                <th>Notes</th>
                <th></th>
            </tr>
            </thead>
            <tbody>

            </tbody>
        </table>

        <c:import url="printOrder.jsp"/>

        <script src="${pageContext.request.contextPath}/js/libs/moment-with-locales.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/libs/jquery.pleaseWait.js"></script>
        <script>
            $(function () {
                var startDay = $('#from');
                var endDay = $('#to');
                startDay.datepicker("setDate", new Date());
                endDay.datepicker("setDate", new Date());
                endDay.datepicker("update", moment().add(1, "days").format("YYYY-MM-DD"));

                $('#search').click(function () {
                    $('#base-container').pleaseWait();
                    var tbody = $('#orders').find('tbody');
                    tbody.empty();

                    $.ajax({
                        url: '/customer/mobile-unlocking-order/find-between-dates',
                        type: 'GET',
                        dataType: 'json',
                        data: {
                            startDay: startDay.val(),
                            endDay: endDay.val()
                        },
                        success: function (data) {
                            $.each(data, function (key, value) {
                                var row = '<tr>' +
                                        '<td>' + value.mobileUnlocking.title + '</td>' +
                                        '<td>' + value.imei + '</td>' +
                                        '<td>' + value.createdDate + '</td>' +
                                        '<td>' + (value.code != null ? value.code : '') + '</td>' +
                                        '<td>' + value.sellingPrice + '</td>' +
                                        '<td>' + value.customerEmail + '</td>' +
                                        '<td>' + value.mobileNumber + '</td>' +
                                        '<td>' + value.notes + '</td>' +
                                        '<td><input type="button" data-toggle="modal" data-id="' + value.id + '" ' +
                                        'data-target="#printOrderModal" class="btn btn-primary print" value="Print"/></td>' +
                                        '</tr>';
                                tbody.append(row);
                                printClick();
                            });
                        },
                        complete: function () {
                            $('#base-container').pleaseWait('stop');
                        }
                    });
                });

                var printClick = function() {
                    $('.print').click(function (e) {
                        var orderId = $(this).data('id');
                        $.ajax({
                            type: 'GET',
                            url: '/customer/mobile-unlocking-order/get',
                            dataType: 'json',
                            data: {id: orderId},
                            success: function (data) {
                                var order = data;
                                $('#mobileUnlockingTitle').text(order.mobileUnlocking.title);
                                $('#user').text(order.user.login);
                                $('#imei').text(order.imei);
                                $('#code').text(order.code == null ? '' : order.code);
                                $('#customerEmail').text(order.customerEmail);
                                $('#mobileNumber').text(order.mobileNumber);
                                //$('#status').text(order.status);
                                $('#createdDate').text(order.createdDate);
                                $('#notes').val(order.notes);
                                $('.orderInfo').empty();
                                $('.orderInfo').append($('form').clone());
                            }
                        });
                    });
                };

                $('.printButton').click(function (e) {
                    window.print();
                });
            });
        </script>
    </div>
</div>

<div class="orderInfo" hidden></div>
</body>
</html>
