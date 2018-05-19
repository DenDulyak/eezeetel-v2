<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .m-t-20 {
        margin-top: 20px;
    }

    .remove-arrows::-webkit-inner-spin-button,
    .remove-arrows::-webkit-outer-spin-button {
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        margin: 0;
    }

    .denomination {
        -moz-border-radius: 10px;
        -webkit-border-radius: 10px;
        border-radius: 10px;
        border: 1px solid #1DABE3;
        display: inline-block;
        cursor: pointer;
        color: #000000;
        font-size: 17px;
        padding: 10px 10px;
        margin-bottom: 10px;
        width: 100%;
        min-width: 125px;
    }

    .price {
        font-weight: 300;
        line-height: 12px;
        font-size: 12px;
    }

    .price span {
        margin: 2px;
    }

    .denomination h4 {
        font-size: 16px;
        font-weight: normal;
        line-height: 20px;
        color: #005ab0;
    }
</style>

<div class="container-fluid">
    <div class="col-md-12 wait">
        <div class="text-center">
            <h2>EezeeTel Pinless</h2>
        </div>

        <div class="row">
            <div class="col-md-4 col-md-offset-4 m-t-20">
                <div class="col-sm-6 col-md-offset-3">
                    <div class="input-group">
                        <div class="input-group-addon countryCode" style="background-color: white">44</div>
                        <input id="dest_number" class="form-control remove-arrows"
                               type="number" placeholder="UK Mobile Number" name="dest_number"
                               data-validator="^[0-9]{10,11}$"/>
                    </div>
                </div>
            </div>
        </div>

        <ul class="list-inline col-md-6 col-md-offset-3 m-t-20 denominations">
            <%--<li class="text-center">
                <div class="denomination">
                    <h4>
                        <span style="display: block">GBP</span>
                        <span style="display: block">£5,00</span>
                    </h4>
                    <p class="price">
                        <span>Price</span>
                        <span>£0.75</span>
                    </p>
                </div>
            </li>--%>
        </ul>
    </div>
</div>

<script>
    $(function () {
        var container = $('.wait');

        $('#dest_number').on('input', function () {
            var el = $(this);
            var regex = new RegExp(el.data('validator'));
            if (regex.test(el.val())) {
                var number = el.val();
                if (number.charAt(0) == 0) {
                    number = number.slice(1);
                }
                if (number.length == 10) {
                    el.blur();
                    checkNumber('44' + number);
                }
            }
        });

        var checkNumber = function (number) {
            container.pleaseWait();

            $.ajax({
                type: 'GET',
                url: '/customer/mobitopup/check-number-v2',
                data: {number: number},
                dataType: 'json',
                success: function (data) {
                    if (data.error_code == 0) {
                        var tickets = data.tickets.split(',');
                        var result = '';
                        $.each(tickets, function (key, value) {
                            var ticket = value.split('-');
                            result += '<li class="text-center">' +
                                    '<div class="denomination" data-ticket="' + ticket[0] + '">' +
                                    '<h4>' +
                                    '<span style="display: block">GBP</span>' +
                                    '<span style="display: block">£' + ticket[0] + '</span>' +
                                    '</h4>' +
                                    '<p class="price">' +
                                    '<span>Price</span>' +
                                    '<span>£' + ticket[1] + '</span>' +
                                    '</p>' +
                                    '</div>' +
                                    '</li>';
                        });
                        $('.denominations').html(result);
                        denominationClick(number);
                    }
                },
                complete: function () {
                    container.pleaseWait('stop');
                }
            });
        };

        var denominationClick = function (number) {
            $('.denomination').click(function () {
                var ticket = $(this).data('ticket');
                checkBalance(number, ticket);
            });
        };

        var checkBalance = function(number, ticket) {
            container.pleaseWait();
            $.ajax({
                type: 'GET',
                url: '/customer/mobitopup/ottxbalance',
                data: {
                    number: number,
                    product: ticket
                },
                dataType: 'json',
                success: function (data) {
                    var html = 'Phone number <strong>+' + number.replace(/(\d{2})\-?(\d{3})\-?(\d{3,5})/, '$1 ($2) $3') + '</strong>';
                    if (data.error_code == 0) {
                        html += '. <br><br> Balance - <strong>' + data.balance + '</strong>';
                    }
                    if (data.error_code == 10) {
                        html += '. <br><br><span class="text-danger">' + data.error_text + '</strong>';
                        return;
                    }
                    swal({
                        title: 'Top up £' + ticket,
                        html: html,
                        type: 'question',
                        showCloseButton: true,
                        showCancelButton: true,
                        confirmButtonText: '<i class="fa fa-thumbs-up">Confirm</i>',
                        cancelButtonText: '<i class="fa fa-thumbs-down">Cancal</i>'
                    }).then(function () {
                        denominationConfirm(number, ticket);
                    }).catch(swal.noop);
                },
                complete: function () {
                    container.pleaseWait('stop');
                }
            });
        };

        var denominationConfirm = function (number, ticket) {
            $.blockUI();

            $.ajax({
                type: 'POST',
                url: '/customer/mobitopup/topup-v2',
                data: {
                    destnumber: number,
                    product: ticket
                },
                dataType: 'json',
                error: function(xhr, status, text) {
                    swal({
                        title: xhr.responseText,
                        type: 'error',
                        showCloseButton: true
                    });
                },
                success: function (data) {
                    if (data.errorCode == 0) {
                        swal({
                            title: 'Top-Up Successful!',
                            type: 'success',
                            showCloseButton: true
                        });
                    } else {
                        swal({
                            title: 'Unable to process transaction. Please try again.',
                            type: 'error',
                            showCloseButton: true
                        });
                    }
                },
                complete: function () {
                    $.unblockUI();
                }
            });
        };
    });
</script>