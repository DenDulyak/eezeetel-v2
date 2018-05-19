<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <h2>Mobile Unlocking</h2>
    <input type="button" class="btn btn-primary pull-right create" data-toggle="modal"
           data-target="#mobileUnlockingModal" value="Add"/>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Title</th>
            <th>Supplier</th>
            <th>Delivery Time</th>
            <th>Purchase Price</th>
            <th width="150">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${mobileUnlockings}" var="mobileUnlocking">
            <tr class="${mobileUnlocking.active ? '' : 'danger'}">
                <td>${mobileUnlocking.title}</td>
                <td>${mobileUnlocking.supplier.supplierName}</td>
                <td>${mobileUnlocking.deliveryTime}</td>
                <td>${mobileUnlocking.purchasePrice}</td>
                <td id="${mobileUnlocking.id}">
                    <input type="button" class="btn btn-sm btn-primary edit"
                           data-toggle="modal" data-target="#mobileUnlockingModal" value="Edit"/>
                    <input data-active="${mobileUnlocking.active}" type="button"
                           class="btn btn-sm btn-warning active"
                           value="${mobileUnlocking.active ? 'Deactivate' : 'Activate'}"/>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <c:import url="mobileunlocking/mobileUnlockingForm.jsp"/>
</div>

<script>
    $(function () {
        var init = function () {
            var supplier = $('#supplierId');
            $.ajax({
                type: 'GET',
                url: '/masteradmin/mobile-unlocking/suppliers-by-type',
                data: {typeId: 19},
                dataType: 'json',
                success: function (data) {
                    $.each(data, function (key, value) {
                        supplier.append(new Option(value.supplierName, value.supplierId));
                    });
                }
            });
        };

        init();

        $('.edit').click(function (e) {
            var mobileUnlockingId = $(this).parent().attr('id');

            $.ajax({
                type: 'GET',
                url: '/masteradmin/mobile-unlocking/get?id=' + mobileUnlockingId,
                dataType: 'json',
                success: function (data) {
                    $('#id').val(data.id);
                    $('#title').val(data.title);
                    $('#supplierId').find('option:eq(' + data.supplierId + ')').prop('selected', true);
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
            var active = !$(this).data('active');

            $.ajax({
                type: 'POST',
                url: '/masteradmin/mobile-unlocking/active',
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
                    url: '/masteradmin/mobile-unlocking/save',
                    dataType: "json",
                    data: form.serialize()
                });
            }
        });
    });
</script>