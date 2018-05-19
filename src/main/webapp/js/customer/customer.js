function showProductsBySupplier(supplierId) {
    if (supplierId == 0) return;
    var productsDiv = $('.products');
    $.ajax({
        url: '/customer/products-by-supplier/' + supplierId,
        dataType: 'json',
        success: function (data) {
            productsDiv.empty();
            var result = '<ul class="list-inline text-center">';
            var iterator = 0;
            $.each(data, function (key, value) {
                if (!value.availableQuantity <= 0) {
                    result += '<li id="' + value.id + '" class="productCell" valign="top" align="center" nowrap>';
                    result += '<img class="productImg"  src="' + value.img + '" alt="' + value.name + ' - ' + value.faceValue + '" />';
                    result += '<br/>Quantity: <select class="productQuantity">';
                    for (var n = 0; n <= value.availableQuantity; n++) {
                        result += '<option value="' + n + '">' + n + '</option>';
                        if (n == 5) break;
                    }
                    result += '</select>';
                    result += '<br/><input class="btn btn-primary processButton" type="button" value="Confirm" />';
                    if (isBulkUpload) {
                        if (isCreditLimit && value.availableQuantity > 20000) {
                            value.availableQuantity = 20000;
                        }
                        result += '<br/><label class="bulkpin-checkbox checkbox-inline"><input type="checkbox" class="bulkpin">Bulkpin</label>';
                        result += '<input type="hidden" value="' + value.availableQuantity + '" />';
                    }
                    result += '</li>';
                }
            });
            result += '</ul>';
            productsDiv.append(result);
        },
        complete: function () {
            init();
        }
    });
}

function countProperties(obj) {
    var count = 0;
    for (var property in obj) {
        delete obj[property];
        if (Object.prototype.hasOwnProperty.call(obj, property)) count++;
    }
    return count;
}

//var needToCancel = true;

$(function () {
    $('.productsButton').click(function (e) {
        $('.products').empty();
    });
    $('.printButton').click(function (e) {
        window.print();
        $('#confirmModal').modal('hide');
    });

    var showDropdown = function (element) {
        var event;
        event = document.createEvent('MouseEvents');
        event.initMouseEvent('mousedown', true, true, window);
        element.dispatchEvent(event);
    };

    // This isn't magic.
    window.runThis = function () {
        var dropdown = document.getElementById('country_code');
        showDropdown(dropdown);
    };
});

function init() {
    var bulkpin = $('.bulkpin');
    var processButton = $('.processButton');
    var confirmButton = $('.confirmButton');
    var productImg = $('.productImg');

    bulkpin.unbind("change");
    bulkpin.change(function () {
        var td = $(this).parent().parent();
        $('.productCell .bulkContainer').remove();
        var bulkContainer = $('.bulkContainer').clone();
        var productQuantity = $('.productQuantity');
        productQuantity.attr('disabled', false);
        if ($(this).is(":checked")) {
            $('.bulkpin').prop("checked", false);
            $(this).prop("checked", true);
            productQuantity.attr('disabled', true);
            productQuantity.prop('selectedIndex', 0);
            td.append(bulkContainer);
            var maxValue = td.find(':input[type="hidden"]').val();
            if (maxValue < 1) maxValue = 1;
            var inputNumber = $('.input-number');
            inputNumber.attr('max', maxValue);
            inputNumber.val(1);
        }
        bulkEvents();
    });

    processButton.unbind("click");
    processButton.click(function (e) {
        process($(this));
    });

    confirmButton.unbind("click");
    confirmButton.click(function (e) {
        transactionConfirm();
    });

    productImg.unbind("click");
    productImg.click(function (e) {
        process($(this));
    });
}

function bulkEvents() {
    $('.btn-number').click(function (e) {
        e.preventDefault();

        fieldName = $(this).attr('data-field');
        type = $(this).attr('data-type');
        var input = $("input[name='" + fieldName + "']");
        var currentVal = parseInt(input.val());
        if (!isNaN(currentVal)) {
            if (type == 'minus') {
                if (currentVal > input.attr('min')) {
                    input.val(currentVal - 1).change();
                }
                if (parseInt(input.val()) == input.attr('min')) {
                    $(this).attr('disabled', true);
                }
            } else if (type == 'plus') {
                if (currentVal < input.attr('max')) {
                    input.val(currentVal + 1).change();
                }
                if (parseInt(input.val()) == input.attr('max')) {
                    alert('Sorry, the maximum value was reached');
                }
            }
        } else {
            input.val(0);
        }
    });

    $('.input-number').change(function () {

        minValue = parseInt($(this).attr('min'));
        maxValue = parseInt($(this).attr('max'));
        valueCurrent = parseInt($(this).val());

        name = $(this).attr('name');
        if (valueCurrent >= minValue) {
            $(".btn-number[data-type='minus'][data-field='" + name + "']").removeAttr('disabled')
        } else {
            alert('Sorry, the minimum value was reached');
        }
        if (valueCurrent <= maxValue) {
            $(".btn-number[data-type='plus'][data-field='" + name + "']").removeAttr('disabled')
        } else {
            $(this).val(maxValue);
            alert('Sorry, the maximum value was reached');
        }
    });

    $(".input-number").keydown(function (e) {
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
                // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) ||
                // Allow: home, end, left, right
            (e.keyCode >= 35 && e.keyCode <= 39)) {
            // let it happen, don't do anything
            return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
    });
}

function process(el) {
    var products = [];

    if (el.parent().find('.bulkpin').is(":checked")) {
        products.push(el.parent().attr('id') + ',' + $('.input-number').val());
    } else {
        $(".productQuantity option:selected").each(function () {
            if ($(this).val() > 0) {
                products.push($(this).parent().parent().attr('id') + ',' + $(this).val());
            }
        });
    }

    if (products.length < 1) {
        products.push(el.parent().attr('id') + ',1');
    }
    processRequest(products);
    $('#processModal').modal('show');
}

function processRequest(products) {

    var container = $('.processContainer');
    container.empty();
    container.append('<h3>Please wait...</h3>');

    var confirmButton = $('#processModal').find('.confirmButton');
    confirmButton.attr('disabled', true);

    $.ajax({
        type: 'POST',
        url: '/customer/process?products=' + products.join('-'),
        dataType: 'json',
        success: function (data) {
            var result = '';
            if (data.message != null) {
                result += '<span style="color: red">' + data.message + '</span>';
            }
            if (data.error != null) {
                result += '<span style="color: red">' + data.error + '</span>';
                confirmButton.hide();
            } else {
                confirmButton.show();
            }
            if (data.success) {
                if (data.message != null) {
                    result += '<span style="color: red">' + data.message + '</span>';
                }
                result += '<div class="row">';
                $.each(data.products, function (key, value) {
                    result += '<div class="col-md-3">' +
                        '<img src="' + value.m_strImageFilePath + '" class="product_type" /><br/>' +
                        '<span class="productInfo">' + value.m_strProductName + '</span><br/>' +
                        '<span class="productInfo">Quantity : ' + value.m_nProcessedQuantity + '</span><br/>' +
                        '<span class="productInfo">Value : ' + value.m_fCostToCustomer + '</span>' +
                        '</div>';
                });
                result += '</div><br/>';
            }
            container.empty();
            container.append(result);
        },
        complete: function () {
            confirmButton.attr('disabled', false);
            $('.productQuantity').prop('selectedIndex', 0);
        }
    });
}

function transactionConfirm() {
    //needToCancel = false;
    $('#processModal').modal('hide');
    $('#confirmModal').modal('toggle');
    var container = $('.confirm-container');
    var printContainer = $('.printContainer');
    container.empty();
    printContainer.empty();

    $.ajax({
        type: 'POST',
        url: '/customer/confirm',
        dataType: 'json',
        success: function (data) {
            var result = '';
            if (data.message != null) {
                result += '<span style="color: red">' + data.message + '</span>';
            }
            if (data.error != null) {
                result += '<span style="color: red">' + data.error + '</span>';
            }
            if (data.success) {
                $.each(data.products, function (key, value) {
                    var cardInfo = '<div class="pull-right">';
                    if (value.cardInfoBeans.length < 6) {
                        $.each(value.cardInfoBeans, function (key, bean) {
                            cardInfo += '<div style="page-break-inside: avoid"><table frame="box" style="border:solid 1px #000000;">' +
                                '<tr><td align="left"><b>' + data.customerCompanyName + '</b></td></tr>' +
                                '<tr><td align="left"><b>Transaction Number : ' + data.transactionId + '</b></td></tr>' +
                                '<tr><td align="left"><b>' + data.transactionTime + '</b></td></tr>' +
                                '<tr><td align="left"><b><span  style="font-size: small; font-family: Verdana; ">' + value.m_strProductName + '   ' + value.m_fFaceValue + '.0 </span></b></td></tr>' +
                                '<tr><td ><pre style="width: 350px;"><font face="Verdana"><b>' + bean.printInfo + '</b></font></pre></td></tr>' +
                                '</table><br/></div>';
                        });
                    }
                    cardInfo += '</div>';
                    var bulkDownload = '';
                    if (value.m_nProcessedQuantity > 5) {
                        bulkDownload += '<form action="/customer/bulk" method="POST">' +
                            '<input type="hidden" name="transactionId" value="' + data.transactionId + '" />' +
                            '<button type="submit" class="btn btn-primary">Bulk download</button>' +
                            '</form>';
                    }
                    result += '<div class="row">' +
                        '<div class="col-md-2">' +
                        '<img src="' + value.m_strImageFilePath + '" class="product_type" /><br/>' +
                        '<span class="productInfo">' + value.m_strProductName + '</span><br/>' +
                        '<span class="productInfo">Quantity : ' + value.m_nProcessedQuantity + '</span><br/>' +
                        '<span class="productInfo">Value : ' + value.m_fCostToCustomer + '</span>' +
                        bulkDownload +
                        '</div>' + cardInfo +
                        '</div><br/>';
                    printContainer.append(cardInfo);
                });
            }
            container.append(result);
        },
        complete: function () {
            $('.productQuantity').prop('selectedIndex', 0);
            $('.printContainer > div').removeClass("pull-right");

            setTimeout(function () {
                if (printByConfirm) {
                    window.print();
                }
            }, 200);

            updateBalance();
        }
    });
}

function updateBalance() {

    $.ajax({
        type: 'GET',
        url: '/customer/get-balance',
        dataType: 'json',
        success: function (data) {
            $('.customerBalance').html('Balance : &pound' + data);
        }
    });
}
