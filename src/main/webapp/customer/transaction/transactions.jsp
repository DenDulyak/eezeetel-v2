<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <style>
        input[type='number'] {
            -moz-appearance:textfield;
        }

        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
        }
    </style>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../../common/libs.jsp"/>
    <script src="${pageContext.request.contextPath}/js/libs/moment-with-locales.min.js"></script>
    <title>Transactions</title>
</head>
<body>
<div class="no-print">
    <c:import url="../headerNavbar.jsp"/>
    <div class="container">
        <div class="row">
            <div class="form-inline col-sm-12">
                <form id="transactionForm" class="form-group" action="${pageContext.request.contextPath}/customer/bulk"
                      method="POST">
                    <label for="transaction" class="control-label">
                        Enter or Select Transaction Number from below list:
                    </label>
                    <input id="transaction" name="transactionId" type="number" class="form-control"/>
                    <input class="btn btn-default printTransaction" type="button" value="Print"/>
                    <input class="btn btn-default bulkpinDownload" type="submit" value="Bulkpin Download"/>
                </form>
                <div class="form-group pull-right">
                    <label for="day" class="control-label">Select a day: </label>
                    <input id="day" type="text" class="form-control"/>
                    <input type="button" class="btn btn-primary searchTransactionsByDay" value="Search"/>
                </div>
            </div>
        </div>
        <hr/>
    </div>
    <div class="container">
        <div class="row transactionDiv" hidden>
            <table class="table">
                <thead>
                <tr>
                    <th width="5%"></th>
                    <th width="17%">Transaction Number</th>
                    <th width="25%">Transaction Date and Time</th>
                    <th width="25%">User</th>
                    <th>Product name</th>
                </tr>
                </thead>
                <tbody class="transactionsTableBody">
                </tbody>
            </table>
        </div>
        <div class="row simTransactionDiv" hidden>
            <h3>SIM Transactions</h3>
            <table class="table">
                <thead>
                <tr>
                    <th width="5%"></th>
                    <th width="17%"></th>
                    <th width="25%"></th>
                    <th width="25%"></th>
                    <th></th>
                </tr>
                </thead>
                <tbody class="simTransactionsTableBody">
                </tbody>
            </table>
        </div>
        <div class="row transfertoTransactionDiv" hidden>
            <h3>World Mobile Topup Transactions</h3>
            <table class="table">
                <thead>
                <tr>
                    <th width="5%"></th>
                    <th width="17%">Transaction Number</th>
                    <th width="25%">Transaction Date and Time</th>
                    <th width="25%">User</th>
                    <th>Product name</th>
                </tr>
                </thead>
                <tbody class="transfertoTransactionsTableBody">
                </tbody>
            </table>
        </div>
    </div>

    <c:import url="../popups/reprintTransaction.jsp"/>
</div>

<script>
    $(function () {
        $('#day').datepicker("setDate", new Date());

        var init = function () {
            var day = $('#day').val();
            getTransactions(day);
            getSimTransactions(day);
            getTransfertoTransactions(day);
        };

        var initRadioButton = function () {
            var radioButton = $('.radioButton');
            radioButton.unbind("click");
            radioButton.click(function (e) {
                $('#transaction').val($(this).val());
                validator.element("#transaction");
            });
        };

        $('.searchTransactionsByDay').click(function (e) {
            init();
        });

        var getTransactions = function (day) {
            var container = $('.transactionDiv');
            var tbody = $('.transactionsTableBody');
            $.ajax({
                url: '/customer/transactions-by-day',
                type: 'GET',
                dataType: 'json',
                data: {
                    type: "transaction",
                    day: day
                },
                success: function (data) {
                    tbody.empty();
                    $.each(data, function (key, value) {
                        var row = '<tr class="info">';
                        row += '<td><input type="radio" name="transactionId" class="radioButton" value="' + value.transactionId + '"/></td>';
                        row += '<td>' + value.transactionId + '</td>';
                        row += '<td>' + formatTime(value.transactionTime) + '</td>';
                        row += '<td>' + value.userFirstName + ' ' + value.userLastName + '</td>';
                        row += '<td>' + value.products + '</td>';
                        row += '</tr>';
                        tbody.append(row);
                    });
                    if (data.length > 0) {
                        container.show();
                        initRadioButton();
                    } else {
                        container.hide();
                    }
                }
            });
        };

        var getSimTransactions = function (day) {
            var container = $('.simTransactionDiv');
            var tbody = $('.simTransactionsTableBody');
            $.ajax({
                url: '/customer/transactions-by-day',
                type: 'GET',
                dataType: 'json',
                data: {
                    type: "sim",
                    day: day
                },
                success: function (data) {
                    tbody.empty();
                    $.each(data, function (key, value) {
                        var row = '<tr class="success">';
                        row += '<td><input type="radio" name="transactionId" class="radioButton" value="' + value.transactionId + '"/></td>';
                        row += '<td>' + value.transactionId + '</td>';
                        row += '<td>' + formatTime(value.transactionTime) + '</td>';
                        row += '<td>' + value.userFirstName + ' ' + value.userLastName + '</td>';
                        row += '<td>' + value.products + '</td>';
                        row += '</tr>';
                        tbody.append(row);
                    });
                    if (data.length > 0) {
                        container.show();
                        initRadioButton();
                    } else {
                        container.hide();
                    }
                }
            });
        };

        var getTransfertoTransactions = function (day) {
            var container = $('.transfertoTransactionDiv');
            var tbody = $('.transfertoTransactionsTableBody');
            $.ajax({
                url: '/customer/transactions-by-day',
                type: 'GET',
                dataType: 'json',
                data: {
                    type: "transfer",
                    day: day
                },
                success: function (data) {
                    tbody.empty();
                    $.each(data, function (key, value) {
                        var row = '<tr class="active">';
                        row += '<td><input type="radio" name="transactionId" class="radioButton" value="' + value.transactionId + '"/></td>';
                        row += '<td>' + value.transactionId + '</td>';
                        row += '<td>' + formatTime(value.transactionTime) + '</td>';
                        row += '<td>' + value.userFirstName + ' ' + value.userLastName + '</td>';
                        row += '<td>' + value.products + '</td>';
                        row += '</tr>';
                        tbody.append(row);
                    });
                    if (data.length > 0) {
                        container.show();
                        initRadioButton();
                    } else {
                        container.hide();
                    }
                }
            });
        };

        var validator = $('#transactionForm').validate({
            rules: {
                transaction: {
                    required: true,
                    number: true,
                    minlength: 4,
                    maxlength: 20
                }
            }
        });

        $('.printTransaction').click(function (e) {
            validator.element("#transaction");
            if (validator.valid()) {
                getTransactionInfo($('#transaction').val());
            }
        });

        init();

        var getTransactionInfo = function (transactionId) {
            var printContainer = $('.printContainer');
            printContainer.empty();
            $.ajax({
                url: '/customer/reprint-transaction',
                type: 'GET',
                dataType: 'json',
                data: {
                    transactionId: transactionId
                },
                success: function (data) {
                    var reprintContainer = $('.reprintContainer');
                    reprintContainer.empty();
                    if (data.success) {
                        if (data.transactionType == 'TRANSACTION') {
                            $('.modal-body').addClass('modalContainerBody');
                            $('#reprintTransactionModal').modal('show');
                            var result = '';
                            $.each(data.products, function (key, value) {
                                var cardInfo = '<div class="col-md-4">';
                                $.each(value.cardInfoBeans, function (key, bean) {
                                    cardInfo += '<table frame="box" style="border:solid 1px #000000;">' +
                                            '<tr><td align="left"><b>' + data.customerCompanyName + '</b></td></tr>' +
                                            '<tr><td align="left"><b>Transaction Number : ' + data.transactionId + '</b></td></tr>' +
                                            '<tr><td align="left"><b>' + data.transactionTime + '</b></td></tr>' +
                                            '<tr><td align="left"><b><font size="4" face="Verdana">' + value.m_strProductName + '   ' + value.m_fFaceValue + '.0 </font></b></td></tr>' +
                                            '<tr><td ><pre style="width: 350px;"><font face="Verdana"><b>' + bean.printInfo + '</b></font></pre></td></tr>' +
                                            '</table><br/>';
                                });
                                cardInfo += '</div>';
                                result += '<div class="row">' +
                                        '<div class="col-md-2">' +
                                        '<img src="' + value.m_strImageFilePath + '" class="productImgOnPopup" /><br/>' +
                                        '<span class="productInfo">' + value.m_strProductName + '</span><br/>' +
                                        '<span class="productInfo">Quantity : ' + value.m_nProcessedQuantity + '</span><br/>' +
                                        '<span class="productInfo">Value : ' + value.m_fCostToCustomer + '</span>' +
                                        '</div>' + cardInfo +
                                        '</div><br/>';
                                printContainer.append(cardInfo);
                            });
                            reprintContainer.append(result);
                        } else if (data.transactionType == 'SIM_TRANSACTION') {
                            $('.modal-body').removeClass('modalContainerBody');
                            $('#reprintTransactionModal').modal('show');
                            $('#simCardForm').clone().prependTo(reprintContainer);
                            $.each(data.products, function (key, value) {
                                $('#simCompanyName').append(value.companyName);
                                $('#simTransactionNumber').append(value.transactionId);
                                $('#simTransactionTime').append(formatTime(value.transactionTime));
                                $('#simProduct').append(value.productName);
                                $('#simPin').append(value.simCardPin);
                                $('#simTotalPopups').append(value.totalTopups);
                            });

                            reprintContainer.clone().prependTo(printContainer);
                        } else if (data.transactionType == 'DING_TRANSACTION') {
                            $('.modal-body').removeClass('modalContainerBody');
                            $('#reprintTransactionModal').modal('show');
                            $('#phoneTopupForm').clone().prependTo(reprintContainer);
                            $.each(data.products, function (key, value) {
                                var table = reprintContainer.find('table');
                                table.find('#m_company').html('<b>' + value.customer.companyName + '</b>');
                                table.find('#m_operator').html('<b>Operator : ' + value.destinationOperator + '</b>');
                                table.find('#m_country').html('<b>Country : ' + value.destinationCountry + '</b>');
                                table.find('#m_amount').html('<b>Topup Amount : £' + value.retailPrice + '</b>');
                                table.find('#m_receiver').html('<b>Receiver : ' + value.destinationPhone + '</b>');
                                table.find('#m_transaction').html('<b>Transaction Number : ' + value.transactionId + '</b>');
                                table.find('#m_order_id').html('<b>Reference Number : ' + value.dingTransactionId + '</b>');
                                table.find('#m_transaction_time').html('<b>Time : ' + value.transactionTime + '</b>');
                                table.find('#m_destination_value').html('<b>Destination Value : ' + value.productRequested + '</b>');
                                if(value.destinationCurrency) {
                                    table.find('#m_local_currency').html('<b>Destination Currency : ' + value.destinationCurrency + '</b>');
                                } else {
                                    table.find('#m_local_currency').hide();
                                }
                            });

                            reprintContainer.clone().prependTo(printContainer);
                        } else if (data.transactionType == 'MOBITOPUP_TRANSACTION') {
                            $('.modal-body').removeClass('modalContainerBody');
                            $('#reprintTransactionModal').modal('show');
                            $('#phoneTopupForm').clone().prependTo(reprintContainer);
                            $.each(data.products, function (key, value) {
                                var table = reprintContainer.find('table');
                                table.find('#m_company').html('<b>' + value.customer.companyName + '</b>');
                                table.find('#m_operator').html('<b>Operator : ' + value.network + '</b>');
                                table.find('#m_country').html('<b>Country : ' + value.country.name + '</b>');
                                table.find('#m_amount').html('<b>Topup Amount : £' + value.retailPrice + '</b>');
                                table.find('#m_receiver').html('<b>Receiver : ' + value.destinationPhone + '</b>');
                                table.find('#m_transaction').html('<b>Transaction Number : ' + value.transactionId + '</b>');
                                table.find('#m_order_id').html('<b>Reference Number : ' + value.orderId + '</b>');
                                table.find('#m_transaction_time').html('<b>Time : ' + value.transactionTime + '</b>');
                                table.find('#m_destination_value').html('<b>Destination Value : ' + value.productRequested + '</b>');
                                table.find('#m_local_currency').html('<b>Destination Currency : ' + value.localCurrency + '</b>');
                            });

                            reprintContainer.clone().prependTo(printContainer);
                        }
                    }
                }
            });
        };

        $('.printButton').click(function (e) {
            $('.printContainer > div').removeClass("col-md-4");
            window.print();
        });

        var formatTime = function (time) {
            return moment(new Date(time)).format('YYYY-MM-DD hh:mm:ss');
        }
    });
</script>

<div class="printContainer" hidden></div>
</body>
</html>
