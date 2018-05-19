<style>
    .table-sm {
        width: 100%;
    }

    .table-sm td {
        padding: 0 8px 0 0;
    }
</style>

<div class="container-fluid">
    <h3>Mobile Unlocking Profit Margin</h3>

    <div class="form-group form-inline">
        <label for="supplier">Supplier: </label>

        <div class="form-group">
            <select id="supplier" class="form-control input-sm"></select>
        </div>

        <label for="agent" class="control-label">Agent: </label>

        <div class="form-group">
            <select id="agent" class="form-control input-sm"></select>
        </div>

        <label class="control-label">Customer: </label>

        <div class="form-group">
            <select id="customer" class="form-control input-sm customers"></select>
        </div>
    </div>

    <table class="table-sm table-striped">
        <thead>
        <tr>
            <th>Product</th>
            <th>Unit Price</th>
            <th>Group Commission</th>
            <th>Agent Commission</th>
            <th>Price After Group Commission</th>
            <th>Price After Agent Commission</th>
            <th>Selling Price</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

    <br>
    <div class="form-inline">
        <div class="form-group">
            <select id="copyToCustomer" class="form-control input-sm customers"></select>
            <input type="button" class="btn-sm copyToCustomerBtn" value="Copy to customer"/>
        </div>

        <div class="form-group pull-right">
            <input type="button" class="btn-sm saveAll" value="Save all"/>
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
                row += '<td>' + value.mobileUnlocking + '</td>';
                row += '<td>' + value.unitPrice + '</td>';
                row += '<td><input class="form-control input-sm groupCommission" type="number" value="' + value.groupCommission + '"/></td>';
                row += '<td><input class="form-control input-sm agentCommission" type="number" value="' + value.agentCommission + '"/></td>';
                row += '<td>' + (value.unitPrice + value.groupCommission).toFixed(2) + '</td>';
                row += '<td>' + (value.unitPrice + value.groupCommission + value.agentCommission).toFixed(2) + '</td>';
                row += '<td>' + (value.unitPrice + value.groupCommission + value.agentCommission).toFixed(2) + '</td>';
                row += '</tr>';
                tbody.append(row);
            });
        };

        var updateTable = function () {
            var supplierId = $('#supplier').val();
            var customerId = $('#customer').val();
            if (supplierId > 0 && customerId > 0) {
                $('.container-fluid').pleaseWait();
                $.ajax({
                    type: 'GET',
                    url: '/admin/mobile-unlocking/customer-commissions-by-supplier',
                    data: {
                        supplierId: supplierId,
                        customerId: customerId
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

        var updateCustommers = function () {
            var agent = $('#agent').val();
            var supplierId = $('#supplier').val();
            var customers = $('.customers');
            customers.empty();
            if (supplierId > 0) {
                $.ajax({
                    type: 'GET',
                    url: '/admin/customer/find-by-user',
                    data: {login: agent},
                    dataType: 'json',
                    success: function (data) {
                        $('#copyToCustomer').append(new Option('All', 0));
                        $.each(data, function (key, value) {
                            customers.append(new Option(value.companyName, value.id));
                        });
                    },
                    complete: function () {
                        updateTable();
                    }
                });
            }
        };

        var updateAgents = function () {
            var agent = $('#agent');
            $.ajax({
                type: 'GET',
                url: '/admin/user/find-agents',
                dataType: 'json',
                success: function (data) {
                    $.each(data, function (key, value) {
                        agent.append(new Option(value, key));
                    });
                },
                complete: function () {
                    updateCustommers();
                }
            });
        };

        $.ajax({
            type: 'GET',
            url: '/admin/mobile-unlocking/suppliers-by-type',
            data: {typeId: 19},
            dataType: 'json',
            success: function (data) {
                var supplier = $('#supplier');
                $.each(data, function (key, value) {
                    supplier.append(new Option(value.supplierName, value.id));
                });
            },
            complete: function () {
                updateAgents();
            }
        });

        $('#supplier').change(function () {
            updateTable();
        });

        $('#agent').change(function () {
            updateCustommers();
        });

        $('#customer').change(function () {
            updateTable();
        });

        $('.saveAll').click(function (e) {
            $('.container-fluid').pleaseWait();

            var map = {};
            $("tbody > tr").each(function () {
                var tr = $(this);
                map[tr.attr('id')] = tr.find('td > input.groupCommission').val() + '_' + tr.find('td > input.agentCommission').val() + '_' + tr.find('td > input.sellingPrice').val();
            });

            $.ajax({
                type: 'POST',
                url: '/admin/mobile-unlocking/customer-commissions-save',
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

        $('.copyToCustomerBtn').click(function (e) {
            $('.container-fluid').pleaseWait();
            var customerFrom = $('#customer').val();
            var customerTo = $('#copyToCustomer').val();
            $.ajax({
                type: 'POST',
                url: '/admin/mobile-unlocking/copy-commissions-to-customer',
                data: {
                    customerFrom: customerFrom,
                    customerTo: customerTo
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