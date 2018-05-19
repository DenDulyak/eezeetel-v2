<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <h2>Mobile Unlocking Profit</h2>

    <div class="form-group form-inline">
        <label for="supplier" class="control-label">Supplier: </label>

        <div class="form-group">
            <select id="supplier" class="form-control"></select>
        </div>

        <label for="group" class="control-label">Group: </label>

        <div class="form-group">
            <select id="group" class="form-control group"></select>
        </div>
    </div>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Product</th>
            <th>EezeeTel Commission</th>
            <th>Purchase Price</th>
            <th>Price After EezeeTel Commission</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

    <div class="form-group form-inline">
        <input type="button" class="btn btn-primary copyToGroup" value="Copy to group"/>

        <div class="form-group">
            <select id="groupToCopy" class="form-control group"></select>
        </div>
        <div class="form-group pull-right">
            <input type="button" class="btn btn-primary saveAll" value="Save all"/>
        </div>
    </div>
</div>

<script>
    $(function () {
        var updateTableData = function (data) {
            var tbody = $('tbody');
            tbody.empty();
            $.each(data, function (key, value) {
                var row = '<tr id="' + value.id + '">';
                row += '<td>' + value.mobileUnlocking.title + '</td>';
                row += '<td class="col-sm-3"><input class="form-control commission" type="number" value="' + value.commission + '"/></td>';
                row += '<td>' + value.mobileUnlocking.purchasePrice + '</td>';
                row += '<td class="totalPrice">' + (value.mobileUnlocking.purchasePrice + value.commission).toFixed(2) + '</td>';
                row += '<td><input class="btn btn-primary save" type="button" value="Save"/></td>';
                row += '</tr>';
                tbody.append(row);
            });
            saveBtnClick();
        };

        var updateTable = function () {
            var groupId = $('#group').val();
            var supplierId = $('#supplier').val();
            if (groupId > 0 && supplierId > 0) {
                $('.container-fluid').pleaseWait();
                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/mobile-unlocking/commissions-by-supplier-and-group',
                    data: {
                        groupId: groupId,
                        supplierId: supplierId
                    },
                    dataType: 'json',
                    success: function (data) {
                        updateTableData(data);
                    },
                    complete: function () {
                        $('.container-fluid').pleaseWait('stop');
                    }
                });
            }
        };

        var init = function () {
            var supplier = $('#supplier');
            $.ajax({
                type: 'GET',
                url: '/masteradmin/mobile-unlocking/suppliers-by-type',
                data: {typeId: 19},
                dataType: 'json',
                success: function (data) {
                    $.each(data, function (key, value) {
                        supplier.append(new Option(value.supplierName, value.id));
                    });
                },
                complete: function () {
                    updateGroups();
                }
            });
        };

        var updateGroups = function () {
            var group = $('.group');
            $.ajax({
                type: 'GET',
                url: '/masteradmin/group/find-all',
                dataType: 'json',
                success: function (data) {
                    $.each(data, function (key, value) {
                        group.append(new Option(value.name, value.id));
                    });
                },
                complete: function () {
                    updateTable();
                }
            });
        };

        init();

        $('#group').change(function () {
            updateTable();
        });

        $('#supplier').change(function () {
            updateTable();
        });

        var saveBtnClick = function () {
            $('.save').click(function (e) {
                e.preventDefault();
                $('.container-fluid').pleaseWait();
                var tr = $(this).parent().parent();
                var commissionId = tr.attr('id');
                var commission = tr.children('td').children('input.commission').val();
                $.ajax({
                    type: 'POST',
                    url: '/masteradmin/mobile-unlocking/commission-save',
                    data: {
                        id: commissionId,
                        commission: commission
                    },
                    dataType: 'json',
                    success: function (data) {
                        tr.children('td.totalPrice').text(data.mobileUnlocking.purchasePrice + data.commission);
                    },
                    complete: function () {
                        $('.container-fluid').pleaseWait('stop');
                    }
                });
            });
        };

        $('.saveAll').click(function (e) {
            $('.container-fluid').pleaseWait();
            var map = {};
            $("tbody > tr").each(function () {
                var tr = $(this);
                map[tr.attr('id')] = tr.find('td > input.commission').val();
            });

            $.ajax({
                type: 'POST',
                url: '/masteradmin/mobile-unlocking/commission-save-all',
                data: map,
                dataType: 'json',
                success: function (data) {
                    updateTableData(data);
                },
                complete: function () {
                    $('.container-fluid').pleaseWait('stop');
                }
            });
        });

        $('.copyToGroup').click(function (e) {
            $('.container-fluid').pleaseWait();
            var groupFrom = $('#group').val();
            var groupTo = $('#groupToCopy').val();

            $.ajax({
                type: 'POST',
                url: '/masteradmin/mobile-unlocking/copy-to-group',
                data: {
                    groupFrom: groupFrom,
                    groupTo: groupTo
                },
                dataType: 'json',
                success: function (data) {

                },
                complete: function () {
                    $('.container-fluid').pleaseWait('stop');
                }
            });
        });
    });
</script>