$(function () {

    var init = function () {
        var supplier = $('#supplierId');
        $.ajax({
            type: 'GET',
            url: '/mobileadmin/mobile-unlocking/suppliers-by-type',
            data: {typeId: 19},
            dataType: 'json',
            success: function (data) {
                $.each(data, function (key, value) {
                    supplier.append(new Option(value.supplierName, value.id));
                });
            }
        });
    };

    init();

    $('.edit').click(function (e) {
        var mobileUnlockingId = $(this).parent().attr('id');

        $.ajax({
            type: 'GET',
            url: '/mobileadmin/mobile-unlocking/get?id=' + mobileUnlockingId,
            dataType: 'json',
            success: function (data) {
                $('#id').val(data.id);
                $('#title').val(data.title);
                $('#supplierId option:eq(' + data.supplierId + ')').prop('selected', true);
                $('#deliveryTime').val(data.deliveryTime);
                $('#purchasePrice').val(data.purchasePrice);
                $('#transactionCondition').val(data.transactionCondition);
                $('#notes').val(data.notes);
            }
        });
    });

    $('.create').click(function (e) {
        $('form input').val('');
    });

    $('.active').click(function (e) {
        var mobileUnlockingId = $(this).parent().attr('id');
        var active = $(this).attr('data');

        $.ajax({
            type: 'POST',
            url: '/mobileadmin/mobile-unlocking/active',
            dataType: 'json',
            data: {id: mobileUnlockingId, active: active},
            success: function (data) {
                window.location.reload();
            }
        });
    });

    $("#mobileUnlockingForm").validate({
        rules: {
            title: {
                required: true,
                minlength: 2
            },
            supplierId: {
                required: true
            },
            deliveryTime: {
                required: true
            },
            purchasePrice: {
                required: true,
                number: true
            }
        },
        submitHandler: function (form) {
            $.ajax({
                type: 'POST',
                url: '/mobileadmin/mobile-unlocking/save',
                dataType: "json",
                data: form.serialize()
            });
        }
    });
});
