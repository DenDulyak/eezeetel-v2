$(function () {

    $('.mobileUnlockingButton').click(function (e) {
        $.ajax({
            type: 'GET',
            url: '/customer/suppliers-by-type',
            dataType: "json",
            data: {typeId: 19},
            success: function (data) {
                serviceList(data);
            },
            complete: function () {
                init();
            }
        });
    });

    var serviceList = function (data) {
        var productListField = $('#product_list_field');
        productListField.empty();
        var services = '<div class="row">';
        $.each(data, function (key, value) {
            services += '<div class="col-md-3">';
            services += '<div class="col-md-12 mobileUnlockingSupplier">' +
                '<h4>' + value.seriviceName + '</h4>' +
                '</div>';
            services += '<select class="form-control mobileUnlocking">';
            services += '<option value="0"></option>';
            $.each(value.mobileUnlockings, function (muKey, mobileUnlocking) {
                services += '<option value="' + mobileUnlocking.id + '">' + mobileUnlocking.title + '</option>';
            });
            services += '</select>';
            services += '</div>';
            if ((key + 1) / 4 == 1) {
                services += '</div><div class="row">';
            }
        });
        services += '</div>';
        productListField.append(services);
    };

    function init() {
        $(".mobileUnlocking").change(function () {
            var id = $(this).val();
            $(".mobileUnlocking").val("0");
            $(this).val(id);
            if (id > 0) {
                $.ajax({
                    type: 'GET',
                    url: '/customer/mobile-unlocking/get',
                    dataType: "json",
                    data: {id: $(this).val()},
                    success: function (data) {
                        showMobileUnlocking(data);
                    }
                });
            }
        });
    }

    var showMobileUnlocking = function (data) {
        var container = $('.products');
        container.empty();
        $('#mobileUnlockingId').val(data.id);
        $('#mobileUnlockingTitle').text(data.title);
        $('#mobileUnlockingPrice').text(data.sellingPrice);
        $('#mobileUnlockingDeliveryTime').text('Delivery Time: ' + data.deliveryTime);
        $('#customerName').text(data.customerName);
        $('#transactionCondition').text(data.transactionCondition);
        $('#mobileNumber').val(data.customerMobileNumber);
        container.append($('.mobileUnlockingContainer').clone());

        $('.placeOrder').click(function (e) {
            var form = $('#mobileUnlockingOrderForm');
            if (form.valid()) {
                $.ajax({
                    type: 'POST',
                    url: '/customer/mobile-unlocking/order',
                    dataType: "json",
                    data: form.serialize(),
                    success: function (data) {
                        if (data.success) {
                            window.location = '/customer/products';
                        } else {
                            alert(data.error);
                        }
                    }
                });
            }
        });

        $('.multi-field-wrapper').each(function () {
            var $wrapper = $('.multi-fields', this);
            $(".add-field", $(this)).click(function (e) {
                var lastChild = $('.multi-field:last-child', $wrapper);
                lastChild.clone(true).appendTo($wrapper).find('input').val('').attr('name', 'imeis[' + (lastChild.index() + 1) + ']').focus();
                $('.multi-field:last-child', $wrapper).find('label').text('IMIE ' + (lastChild.index() + 2));
            });
            $('.multi-field .remove-field', $wrapper).click(function () {
                if ($('.multi-field', $wrapper).length > 1)
                    $(this).parent('.multi-field').remove();
            });
        });

        $("#mobileUnlockingOrderForm").validate({
            rules: {
                'imeis[0]': {
                    required: true,
                    minlength: 2,
                    number: true
                },
                'imeis[1]': {
                    required: true,
                    minlength: 2,
                    number: true
                },
                'imeis[2]': {
                    required: true,
                    minlength: 2,
                    number: true
                },
                'imeis[3]': {
                    required: true,
                    minlength: 2,
                    number: true
                },
                'imeis[4]': {
                    required: true,
                    minlength: 2,
                    number: true
                }
            }
        });
    };
});
