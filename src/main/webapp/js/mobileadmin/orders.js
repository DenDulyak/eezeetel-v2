$(function () {

    $('.reject').click(function (e) {
        var rejectBtn = $(this);
        var tr = rejectBtn.parent().parent();
        var orderId = tr.attr('id');
        $.ajax({
            type: 'POST',
            url: '/mobileadmin/mobile-unlocking-order/reject',
            dataType: 'json',
            data: {orderId: orderId},
            success: function (data) {
                tr.addClass('danger');
                tr.find(':last-child').prev().text('Rejected');
                rejectBtn.hide();
            }
        });
    });

    $('.edit').click(function (e) {
        var orderId = $(this).parent().parent().attr('id');
        $.ajax({
            type: 'GET',
            url: '/mobileadmin/mobile-unlocking-order/get',
            dataType: 'json',
            data: {id: orderId},
            success: function (data) {
                var order = data;
                $('#id').val(order.id);
                $('#mobileUnlockingTitle').text(order.mobileUnlocking.title);
                $('#user').text(order.user.login);
                $('#imei').val(order.imei);
                $('#code').val(order.code);
                $('#customerEmail').text(order.customerEmail);
                $('#mobileNumber').text(order.mobileNumber);
                $('#status').text(order.status);
                $('#assigned').text(order.assigned.login);
                $('#createdDate').text(order.createdDate);
                $('#updatedDate').text(order.updatedDate);
                $('#notes').val(order.notes);
            }
        });
    });

    $('.save').click(function (e) {
        var orderId = $(this).parent().parent().attr('id');
        $.ajax({
            type: 'POST',
            url: '/mobileadmin/mobile-unlocking-order/edit',
            dataType: 'json',
            data: $('#orderForm').serialize(),
            success: function (data) {
                window.location.reload();
            }
        });
    });

    var formatTime = function (time) {
        if (time == null) return "";
        return moment(new Date(time)).format('YYYY-MM-DD h:mm:ss A');
    }
});

