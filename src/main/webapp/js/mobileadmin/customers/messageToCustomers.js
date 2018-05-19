$(function () {

    var showMessage = function (groupId) {
        var textarea = $('textarea');
        textarea.val('');
        $.ajax({
            type: 'GET',
            url: '/mobileadmin/customer/get-message-by-group',
            dataType: 'json',
            data: {groupId: groupId},
            success: function (data) {
                $.each(data, function (key, value) {
                    textarea.val(value.message);
                });
            }
        });
    };

    $('#group').change(function () {
        showMessage($(this).val());
    });

    $('.setupMessage').click(function (e) {
        var groupId = $('#group').val();
        var textarea = $('textarea');
        var message = textarea.val();
        if (message.length > 0) {
            $.ajax({
                type: 'POST',
                url: '/mobileadmin/customer/set-message-to-group',
                dataType: 'json',
                data: {
                    groupId: groupId,
                    message: textarea.val()
                },
                success: function (data) {
                    $.each(data, function (key, value) {
                        textarea.val(value.message);
                    });
                }
            });
        }
    });

    $('.removeMessage').click(function (e) {
        $('textarea').val('');
        $.ajax({
            type: 'POST',
            url: '/mobileadmin/customer/remove-message-from-group',
            dataType: 'json',
            data: {groupId: $('#group').val()},
            success: function (data) {
            }
        });
    });

    showMessage($('#group').val());
});