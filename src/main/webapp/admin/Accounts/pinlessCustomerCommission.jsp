<link href="${pageContext.request.contextPath}/css/libs/sweetalert2.min.css" rel="stylesheet">

<style>
    .m-t-20 {
        margin-top: 20px;
    }
</style>

<div class="container-fluid">

    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
        <h2>Pinless Customer Commission</h2>

        <form class="form-horizontal m-t-20">
            <div class="form-group">
                <label for="agent" class="control-label col-sm-6">Agent: </label>

                <div class="col-sm-6">
                    <select id="agent" class="form-control"></select>
                </div>
            </div>
            <div class="form-group">
                <label for="customer" class="control-label col-sm-6">Customer: </label>

                <div class="col-sm-6">
                    <select id="customer" class="form-control"></select>
                </div>
            </div>
            <div class="form-group">
                <label for="groupCommission" class="control-label col-sm-6">${sessionScope.get("GROUP_NAME")} Commission
                    Percentage: </label>

                <div class="col-sm-6">
                    <input type="number" class="form-control" id="groupCommission"/>
                </div>
            </div>
            <div class="form-group">
                <label for="agentCommission" class="control-label col-sm-6">Agent Commission Percentage: </label>

                <div class="col-sm-6">
                    <input type="number" class="form-control" id="agentCommission"/>
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-6 col-sm-6">
                    <input id="save" type="button" class="btn btn-primary" value="Save">
                </div>
            </div>
        </form>
    </div>

    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
        <h2>Copy Commissions</h2>

        <form class="form-horizontal m-t-20">
            <div class="form-group">
                <label for="agentFrom" class="control-label col-sm-6">From Agent: </label>

                <div class="col-sm-6">
                    <select id="agentFrom" class="form-control"></select>
                </div>
            </div>
            <div class="form-group">
                <label for="customerFrom" class="control-label col-sm-6">From Customer: </label>

                <div class="col-sm-6">
                    <select id="customerFrom" class="form-control"></select>
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 0">
                <label for="customerTo" class="control-label col-sm-6">To Customer: </label>

                <div class="col-sm-6">
                    <select id="customerTo" class="form-control"></select>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-6 col-sm-offset-6">
                    <div class="checkbox">
                        <label><input id="copyGropuCommission" type="checkbox" class="commissionType">
                            Copy ${sessionScope.get("GROUP_NAME")} Commissions</label>
                    </div>
                    <div class="checkbox">
                        <label><input id="copyAgentCommission" type="checkbox" class="commissionType">Copy Agent Commissions</label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-6 col-sm-6">
                    <div id="get_details_link_button_id2">
                        <input id="copy" type="button" class="btn btn-primary" value="Copy" disabled>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/libs/jquery.blockUI.js"></script>
<script src="${pageContext.request.contextPath}/js/libs/sweetalert2.min.js"></script>
<script>
    $(function () {
        var agents = $('#agent');
        var customers = $('#customer');
        var groupCommission = $('#groupCommission');
        var agentCommission = $('#agentCommission');

        agents.change(function () {
            updateCustommers();
        });

        customers.change(function () {
            getCustomerCommission($(this).val());
        });

        $('#save').click(function (e) {
            save(customers.val(), groupCommission.val(), agentCommission.val());
        });

        var getCustomerCommission = function (customerId) {
            $.blockUI();
            if (!customerId) {
                return;
            }
            $.ajax({
                type: 'GET',
                url: '/admin/pinless-customer-commission/find-by-customer',
                data: {customerId: customerId},
                dataType: 'json',
                success: function (data) {
                    groupCommission.val(data.groupPercent);
                    agentCommission.val(data.agentPercent);
                },
                complete: function () {
                    $.unblockUI();
                }
            });
        };

        var save = function (customerId, groupPercent, agentPercent) {
            if (!customerId || !groupPercent || !agentPercent) {
                return;
            }
            var pinless = {
                customerId: customerId,
                groupPercent: groupPercent,
                agentPercent: agentPercent
            };
            $.ajax({
                type: 'POST',
                url: '/admin/pinless-customer-commission/save',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(pinless),
                dataType: 'json',
                success: function (data) {
                    groupCommission.val(data.groupPercent);
                    agentCommission.val(data.agentPercent);
                    swal('Successful!', '', 'success')
                },
                error: function () {
                    swal('Something went wrong!', '', 'error')
                }
            });
        };

        var updateCustommers = function () {
            var agent = agents.val();
            customers.empty();

            $.ajax({
                type: 'GET',
                url: '/admin/customer/find-by-agent',
                data: {agent: agent},
                dataType: 'json',
                success: function (data) {
                    $.each(data, function (key, value) {
                        customers.append(new Option(value, key));
                    });
                },
                complete: function () {
                    getCustomerCommission(customers.val());
                }
            });
        };

        $.ajax({
            type: 'GET',
            url: '/admin/user/find-agents',
            dataType: 'json',
            success: function (data) {
                $.each(data, function (key, value) {
                    agents.append(new Option(value, key));
                });
            },
            complete: function () {
                updateCustommers();
            }
        });
    });
</script>
<script>
    $(function () {
        var agentFrom = $('#agentFrom');
        var customerFrom = $('#customerFrom');
        var customerTo = $('#customerTo');

        agentFrom.change(function () {
            updateCustommers();
        });

        $('#copy').click(function (e) {
            copy(customerFrom.val(), customerTo.val());
        });

        $('.commissionType').change(function() {
            $('#copy').attr('disabled', $(".commissionType:checked").length < 1);
        });

        var copy = function (customerIdFrom, customerIdTo) {
            var copyGropuCommission = $("#copyGropuCommission").is(':checked');
            var copyAgentCommission = $("#copyAgentCommission").is(':checked');
            if(!copyGropuCommission && !copyAgentCommission) {
                swal('Please choose commission which must be copied.', '', 'error');
                return;
            }

            var data = {
                customerIdFrom: customerIdFrom,
                customerIdTo: customerIdTo,
                copyGropuCommission: copyGropuCommission,
                copyAgentCommission: copyAgentCommission
            };
            $.blockUI();
            $.ajax({
                type: 'POST',
                url: '/admin/pinless-customer-commission/copy',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(data),
                dataType: 'json',
                success: function (data) {
                    swal('Successful!', '', 'success')
                },
                error: function () {
                    swal('Something went wrong!', '', 'error')
                },
                complete: function () {
                    $.unblockUI();
                }
            });
        };

        var updateCustommers = function () {
            var agent = agentFrom.val();
            customerFrom.empty();
            customerTo.empty();

            $.ajax({
                type: 'GET',
                url: '/admin/customer/find-by-agent',
                data: {agent: agent},
                dataType: 'json',
                success: function (data) {
                    customerTo.append(new Option('All', 0));
                    $.each(data, function (key, value) {
                        customerFrom.append(new Option(value, key));
                        customerTo.append(new Option(value, key));
                    });
                }
            });
        };

        $.ajax({
            type: 'GET',
            url: '/admin/user/find-agents',
            dataType: 'json',
            success: function (data) {
                $.each(data, function (key, value) {
                    agentFrom.append(new Option(value, key));
                });
            },
            complete: function () {
                updateCustommers();
            }
        });
    });
</script>