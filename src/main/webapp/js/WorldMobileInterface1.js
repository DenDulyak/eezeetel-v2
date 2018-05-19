var xmlATProducts = null;

function list_services_1(supplier_id) {
    var element1 = document.getElementById('the_suppliers_list');
    element1.innerHTML = "";

    var element = document.getElementById('product_list_field');
    element.innerHTML = "";

    var httpObj = getHttpObject();
    if (httpObj == null) {
        alert("Can not show the interface");
        return;
    }

    httpObj.onreadystatechange = function () {
        if (httpObj.readyState == 4) {
            var element = document.getElementById('product_list_field');
            element.innerHTML = httpObj.responseText;
        }
    };

    var url = theContext + "/customer/ED/AJAX_DisplayAITInterface1.jsp";
    httpObj.open("POST", url, true);
    httpObj.send(null);
}

function getDestinationInfo1() {
    var countryCode = $('.countryCode').text();
    var country = $('#countries').val();
    var destPhoneNumber = $('#dest_phone').val().match(/\d+/);
    var senderPhoneNumber = $('#senderNumber').val().match(/\d+/);
    var res = country.split(",");

    if ("" + parseInt(countryCode) == "NaN") {
        alert("Please select a country.");
        return;
    }

    if (IsNULL(destPhoneNumber)) {
        alert("Please enter a valid mobile phone number");
        return;
    }

    if (senderPhoneNumber.toString().length > 16) {
        alert("Please enter a valid sender mobile phone number");
        return;
    }

    if(senderPhoneNumber == (res[0] + destPhoneNumber)) {
        alert("Sender number cannot be the same as destination number.");
        return;
    }

    var is_country_supported = $('#is_country_supported').val();
    var operators_list = $('#operators_list').val();

    if (is_country_supported == 'false' && !operators_list) {
        alert("Please select an operator.");
        return;
    }

    var httpObj = getHttpObject();
    if (httpObj == null) {
        alert("Can not get product information");
        return;
    }

    var buttonWrapper = document.getElementById('get_details_link_button_id');
    buttonWrapper.innerHTML = "<h2>Please wait...</h2>";

    httpObj.onreadystatechange = function () {
        if (httpObj.readyState == 4) {
            var element = document.getElementById('product_list_field');
            element.innerHTML = httpObj.responseText;
            httpObj = null;
        }
    };

    for (var key in requiredProducts)
        delete requiredProducts[key];

    delete xmlATProducts;
    xmlATProducts = null;

    var url = theContext + "/customer/ED/AJAX_GetIATProductInfo1.jsp?country_code=" + res[0] +
        "&is_country_supported=" + is_country_supported +
        "&dest_phone=" + destPhoneNumber + "&sender_number=" + senderPhoneNumber;

    if (is_country_supported == 'false' && operators_list) {
        url += "&operator_id=" + operators_list;
    }

    httpObj.open("POST", url, true);
    httpObj.send(null);
}

function validateSenderPhone(elem) {
    var senderPhone = elem.val().match(/\d/g);
    if (senderPhone != null) {
        $('#topupTransactionsTable').hide();
        senderPhone = senderPhone.join('');
        if (senderPhone.length > 10) {
            $('#countries').attr('disabled', false);
            $('#dest_phone').attr('disabled', false);
            $('.getDetails').attr('disabled', false);
            //getMobileTopupTransaction(senderPhone);
        } else {
            $('#countries').attr('disabled', true);
            $('#dest_phone').attr('disabled', true);
            $('.getDetails').attr('disabled', true);
        }
    }
}

function getMobileTopupTransaction(requesterPhone) {
    var table = $('#topupTransactionsTable');
    var tbody = table.find('tbody');
    tbody.empty();
    $.ajax({
        type: 'GET',
        url: '/customer/mobitopup/find-by-number',
        data: {
            requesterPhone: requesterPhone,
        },
        dataType: 'json',
        success: function (data) {
            $.each(data, function (key, value) {
                var row = '<tr>';
                row += '<td>' + value.user.login + '</td>';
                row += '<td>' + value.destinationPhone + '</td>';
                row += '<td><a href="#" data-id="' + value.id + '" data-type="m" onclick="fastTopup($(this))">' + value.retailPrice + '</a></td>';
                row += '</tr>';
                tbody.append(row);
            });
            if ($(data).size() > 0) {
                table.show();
            }
        }
    });

    $.ajax({
        type: 'GET',
        url: '/customer/ding/find-by-number',
        data: {
            requesterPhone: requesterPhone
        },
        dataType: 'json',
        success: function (data) {
            $.each(data, function (key, value) {
                var row = '<tr>';
                row += '<td>' + value.user.login + '</td>';
                row += '<td>' + value.destinationPhone + '</td>';
                row += '<td><a href="#" data-id="' + value.id + '" data-type="d" onclick="fastTopup($(this))">' + value.retailPrice + '</a></td>';
                row += '</tr>';
                tbody.append(row);
            });
            if ($(data).size() > 0) {
                table.show();
            }
        }
    });
}

function confirmMobileTopup1(customer_value, index) {
    var selectedIndex = document.getElementById("selected_index");
    selectedIndex.value = index;

    validateAndSubmitMobileTopup1();
}

function confirmMobitopup(value) {
    var warningText = "Please make sure the destination mobile number you entered is correct.  All mobile topup transactions are final and refunds are not allowed.";
    warningText += "If the number is not correct, please cancel and proceed with correct destination phone number.";

    if (!confirm(warningText))
        return;

    var senderPhone = $('#sender_phone_id');
    var senderPhoneNumber = senderPhone.length ? senderPhone.val() : '';
    var destPhone = $('#dest_phone_id').val();
    var message = $('#sms_text').val();

    if (destPhone > 0 && destPhone.length > 8) {
        var ticketsContainer = $('#topup_form .container');
        ticketsContainer.empty();
        ticketsContainer.append('<h2>Please wait...</h2>');

        $.ajax({
            type: 'POST',
            url: '/customer/mobitopup/topup',
            data: {
                destnumber: destPhone,
                srcnumber: senderPhoneNumber,
                product: value,
                message: message
            },
            dataType: 'json',
            success: function (data) {
                updateMobitopupTable(data);
            },
            complete: function () {
                ticketsContainer.empty();
                $('#mobipopupModal').modal('show');
                updateBalance();
            }
        });
    }
}

function updateMobitopupTable(data) {
    var container = $('#mobipopupModal .container-fluid');
    var table = container.find('table');

    if (data.errorCode == 0) {
        table.find('#m_company').html('<b>' + data.customer.companyName + '</b>');
        table.find('#m_operator').html('<b>Operator : ' + data.network + '</b>');
        table.find('#m_country').html('<b>Country : ' + data.country.name + '</b>');
        table.find('#m_amount').html('<b>Topup Amount : £' + data.retailPrice + '</b>');
        table.find('#m_receiver').html('<b>Receiver : ' + data.destinationPhone + '</b>');
        table.find('#m_transaction').html('<b>Transaction Number : ' + data.transactionId + '</b>');
        table.find('#m_order_id').html('<b>Reference Number : ' + data.orderId + '</b>');
        table.find('#m_transaction_time').html('<b>Time : ' + data.transactionTime + '</b>');
        table.find('#m_destination_value').html('<b>Destination Value : ' + data.productRequested + '</b>');
        table.find('#m_local_currency').html('<b>Destination Currency : ' + data.localCurrency + '</b>');
    } else {
        table.find('td').text('');
        table.find('#m_company').html('<b>' + data.errorText + '</b>');
    }

    $('.printContainer').append(container.clone());
}

function updateDingTable(data) {
    var container = $('#mobipopupModal .container-fluid');
    var table = container.find('table');

    if (data.m_nErrorCode == 1) {
        table.find('#m_company').html('<b>' + data.m_strCompany + '</b>');
        table.find('#m_operator').html('<b>Operator : ' + data.m_strOperator + '</b>');
        table.find('#m_country').html('<b>Country : ' + data.m_strCountry + '</b>');
        table.find('#m_amount').html('<b>Topup Amount : £' + data.m_fRetailPrice + '</b>');
        table.find('#m_receiver').html('<b>Receiver : ' + data.m_strReceiver + '</b>');
        table.find('#m_transaction').html('<b>Transaction Number : ' + data.m_eezeeTelTransactionID + '</b>');
        table.find('#m_order_id').html('<b>Reference Number : ' + data.m_dingTransactionID + '</b>');
        table.find('#m_transaction_time').html('<b>Time : ' + data.m_strTime + '</b>');
        table.find('#m_destination_value').html('<b>Destination Value : ' + data.m_fDestTopupValue + '</b>');
        table.find('#m_local_currency').html('<b>Destination Currency : ' + data.m_strCurrencyCode + '</b>');
    } else {
        table.find('td').text('');
        table.find('#m_company').html('<b>' + data.m_strErrorText + '</b>');
    }

    $('.printContainer').append(container.clone());
}

function fastTopup(el) {
    var warningText = "Please make sure the destination mobile number you entered is correct.  All mobile topup transactions are final and refunds are not allowed.";
    warningText += "If the number is not correct, please cancel and proceed with correct destination phone number.";

    if (!confirm(warningText))
        return;

    var id = el.data('id');
    var type = el.data('type');

    var div = $('#mobileTopupForm').parent();
    div.empty();
    div.append('<h2>Please wait...</h2>');

    if (type == 'd') {
        $.ajax({
            type: 'POST',
            url: '/customer/ding/repeat',
            data: {
                id: id
            },
            dataType: 'json',
            success: function (data) {
                updateDingTable(data);
            },
            complete: function () {
                div.empty();
                $('#mobipopupModal').modal('show');
                updateBalance();
            }
        });
    } else if (type == 'm') {
        $.ajax({
            type: 'POST',
            url: '/customer/mobitopup/repeat',
            data: {
                id: id
            },
            dataType: 'json',
            success: function (data) {
                updateMobitopupTable(data);
            },
            complete: function () {
                div.empty();
                $('#mobipopupModal').modal('show');
                updateBalance();
            }
        });
    }
}

function updatePrices(commission) {
    var i = 0;
    var valueButton = document.getElementById("custValue" + i);
    while (valueButton) {
        var destValObj = document.getElementById("destRate" + i);
        var finalValue = eval(commission) + eval(valueButton.value);
        var tt = "Topup �" + parseFloat(finalValue).toFixed(2) + "<br/><font size=\"1\">DESTINATION VALUE : " + parseFloat(destValObj.value).toFixed(2) + "</font>";
        var rateButton = document.getElementById("rates" + i);
        rateButton.innerHTML = tt;
        i++;
        var valueButton = document.getElementById("custValue" + i);
    }
}

function validateAndSubmitMobileTopup1() {
    var warningText = "Please make sure the destination mobile number you entered is correct.  All mobile topup transactions are final and refunds are not allowed.";
    warningText += "If the number is not correct, please cancel and proceed with correct destination phone number.";

    if (!confirm(warningText))
        return;

    CheckDatabaseChars(document.topup_form.sms_text);

    var i = 0;
    var valueButton = document.getElementById("rates" + i);
    while (valueButton) {
        valueButton.style.visibility = "hidden";
        i++;
        valueButton = document.getElementById("rates" + i);
    }

    valueButton = document.getElementById("all_rate_buttons_id");
    valueButton.innerHTML = "<h2>Please wait...</h2>";

    document.topup_form.action = theContext + "/customer/ED/CompleteMobileTopup1.jsp";
    document.topup_form.submit();
}

function countrySelected(countryImageObj) {
    var operatorSelect = document.getElementById("operator_select_id");
    operatorSelect.innerHTML = "";

    var countryCode = $('.countryCode');

    if (IsNULL(countryImageObj.value)) {
        countryCode.text("");
        countryCode.append("&nbsp;&nbsp;&nbsp;&nbsp;");
        return;
    }

    var res = countryImageObj.value.split(",");
    countryCode.text(res[0]);

    var httpObj = getHttpObject();
    if (httpObj == null) {
        alert("Can not get operators information");
        return;
    }

    httpObj.onreadystatechange = function () {
        if (httpObj.readyState == 4) {
            var element = document.getElementById('operator_select_id');
            element.innerHTML = httpObj.responseText;
            $('#is_country_supported').val(IsNULL(httpObj.responseText.trim()));
            httpObj = null;
        }
    };

    var url = theContext + "/customer/ED/AJAX_GetAITOperaotrsList.jsp?country_code=" + res[0];
    httpObj.open("POST", url, true);
    httpObj.send(null);
}