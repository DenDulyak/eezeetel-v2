<style>
    .table-sm {
        width: 100% !important;
    }

    .table-sm th {
        padding: 2px;
    }
</style>

<div class="container-fluid">
    <h2>World Mobile Topup Customer Commission</h2>

    <br/>

    <div class="row" style="margin-bottom: 5px">
        <form class="form-horizontal col-md-6" id="mobileTopupForm">
            <div class="form-group-sm">
                <label class="control-label col-sm-6" for="country">Country:</label>

                <div class="col-sm-6">
                    <select id="country" class="form-control input-sm">
                        <option value="0">Select a country</option>
                    </select>
                </div>
            </div>
            <div class="form-group-sm">
                <div class="col-sm-6 col-sm-offset-6">
                    <div class="checkbox">
                        <label><input type="checkbox" onclick="return false" class="availableInDing">Available in
                            Ding</label>
                    </div>
                    <div class="checkbox">
                        <label><input type="checkbox" onclick="return false" class="availableInMobitopup">Available in
                            Mobitopup</label>
                    </div>
                </div>
            </div>
            <div class="form-group-sm mobitopupNetworks" hidden>
                <label class="control-label col-sm-6" for="mobitopupNetwork">Mobitopup networks:</label>

                <div class="col-sm-6">
                    <input type="hidden" id="mobitopupCountryId"/>
                    <select id="mobitopupNetwork" class="form-control input-sm">
                        <option value="0">Select a network</option>
                    </select>
                </div>
            </div>
            <div class="form-group-sm">
                <label for="agent" class="control-label col-sm-6">Agent: </label>

                <div class="col-sm-6">
                    <select id="agent" class="form-control input-sm"></select>
                </div>
            </div>
            <div class="form-group-sm">
                <label for="customer" class="control-label col-sm-6">Customer: </label>

                <div class="col-sm-6">
                    <select id="customer" class="form-control input-sm"></select>
                </div>
            </div>
            <div class="form-group-sm">
                <label for="groupCommission" class="control-label col-sm-6">
                    ${sessionScope.get("GROUP_NAME")} commission percentage: </label>

                <div class="col-sm-6">
                    <input type="number" class="form-control input-sm" id="groupCommission" disabled/>
                </div>
            </div>
            <div class="form-group-sm">
                <label for="agentCommission" class="control-label col-sm-6">Agent commission percentage: </label>

                <div class="col-sm-6">
                    <input type="number" class="form-control input-sm" id="agentCommission" disabled/>
                </div>
            </div>
            <div class="form-group-sm">
                <div class="col-sm-offset-6 col-sm-6">
                    <div id="get_details_link_button_id">
                        <input type="button" class="btn-sm btn-primary save" value="Save" disabled/>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="col-md-12 dingTickets"
                 style="background-color: #dfe3f4; border-radius: 10px;"
                 hidden>
                <h3>Ding Tickets</h3>
                <table class="table-sm table-striped">
                    <thead>
                    <tr>
                        <th>Ticket</th>
                        <th>${sessionScope.get("GROUP_NAME")} Profit</th>
                        <th>Agent Profit</th>
                        <%--<th>Destination Value</th>--%>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-6">
            <div class="col-md-12 mobitopupTickets"
                 style="background-color: #dfe3f4; border-radius: 10px;"
                 hidden>
                <h3>Mobitopup Tickets</h3>
                <table class="table-sm table-striped">
                    <thead>
                    <tr>
                        <th>Destination Value</th>
                        <th>Buying Price</th>
                        <th>${sessionScope.get("GROUP_NAME")} Profit</th>
                        <th>Agent Profit</th>
                        <th>Customer Profit</th>
                        <th>Selling Price</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script>
    $(function () {

        $('.save').click(function (e) {
            var countryId = $('#country').val();
            var customerId = $('#customer').val();
            var groupPercent = $("#groupCommission").val();
            var agentPercent = $("#agentCommission").val();
            if (countryId > 0 && customerId > 0) {
                $.ajax({
                    type: 'POST',
                    url: '/admin/world-topup-customer-commission/save',
                    data: {
                        countryId: countryId,
                        customerId: customerId,
                        groupPercent: groupPercent,
                        agentPercent: agentPercent
                    },
                    dataType: 'json',
                    success: function (data) {
                        var customerId = $('#customer').val();

                        if (data.groupCommission.country.availableInMobitopup) {
                            var mobitopupCountryId = $('#mobitopupCountryId').val();
                            var networkId = $('#mobitopupNetwork').val();

                            if (customerId > 0 && mobitopupCountryId > 0 && networkId > 0) {
                                getMobitopupTickets(customerId, mobitopupCountryId, networkId);
                            }
                        }

                        if (data.groupCommission.country.availableInDing && customerId > 0) {
                            getDingTickets(customerId, data.groupCommission.country.iso);
                        }
                    }
                });
            }
        });

        $('#country').change(function () {
            var availableInDing = $(".availableInDing");
            var availableInMobitopup = $(".availableInMobitopup");
            var groupCommission = $("#groupCommission");
            var agentCommission = $("#agentCommission");
            var saveBtn = $(".save");

            availableInDing.prop('checked', false);
            availableInMobitopup.prop('checked', false);

            $(".mobitopupNetworks").hide();
            $('.mobitopupTickets').hide();
            $('.dingTickets').hide();

            groupCommission.val('');
            agentCommission.val('');

            groupCommission.prop('disabled', true);
            agentCommission.prop('disabled', true);

            saveBtn.prop('disabled', true);

            var countryId = $(this).val();
            var customerId = $('#customer').val();
            if (countryId > 0) {
                $.ajax({
                    type: 'GET',
                    url: '/admin/phone-topup-country/find-one',
                    data: {id: countryId},
                    dataType: 'json',
                    success: function (data) {
                        availableInDing.prop('checked', data.availableInDing);
                        availableInMobitopup.prop('checked', data.availableInMobitopup);
                        if (data.availableInMobitopup) {
                            $('#mobitopupCountryId').val(0);
                            getMobitopupNetworks(data.mobitopupCountryId);
                        }
                    },
                    complete: function () {
                        if (customerId > 0) {
                            groupCommission.prop('disabled', false);
                            agentCommission.prop('disabled', false);
                            saveBtn.prop('disabled', false);
                            getCommissionByCountryAndCustomer(countryId, customerId);
                        }
                    }
                });
            }
        });

        var getMobitopupNetworks = function (mobitopupCountryId) {
            $.ajax({
                type: 'GET',
                url: '/admin/mobitopup/get-networks',
                data: {
                    mobitopupCountryId: mobitopupCountryId
                },
                dataType: 'json',
                success: function (data) {
                    if (data.error_code == 0) {
                        var mobitopupNetwork = $('#mobitopupNetwork');
                        $(".mobitopupNetworks").show();

                        mobitopupNetwork.empty();
                        mobitopupNetwork.append(new Option('Select a network', 0));

                        $.each(data.networkList, function (index, item) {
                            mobitopupNetwork.append(new Option(index + ' "' + item + '"', item));
                        });

                        $('#mobitopupCountryId').val(mobitopupCountryId);
                    }
                }
            });
        };

        $('#mobitopupNetwork').change(function () {
            var customerId = $('#customer').val();
            var mobitopupCountryId = $('#mobitopupCountryId').val();
            var networkId = $(this).val();

            if (customerId > 0 && mobitopupCountryId > 0 && networkId > 0) {
                getMobitopupTickets(customerId, mobitopupCountryId, networkId);
            } else {
                $('.mobitopupTickets').hide();
            }
        });

        var getMobitopupTickets = function (customerId, mobitopupCountryId, networkId) {
            var mobitopupTickets = $('.mobitopupTickets');
            var tbody = mobitopupTickets.find('tbody');
            tbody.empty();

            $.ajax({
                type: 'GET',
                url: '/admin/mobitopup/get-tickets',
                data: {
                    customerId: customerId,
                    mobitopupCountryId: mobitopupCountryId,
                    networkId: networkId
                },
                dataType: 'json',
                success: function (data) {
                    if (data.error_code == 0) {
                        $.each(data.buy.split(','), function (index, item) {
                            var prices = item.split('-');
                            var tr = '<tr>';
                            tr += '<td>' + prices[0] + '</td>';
                            tr += '<td>' + prices[1] + '</td>';
                            tr += '<td>' + prices[2] + '</td>';
                            tr += '<td>' + prices[3] + '</td>';
                            tr += '<td>' + prices[4] + '</td>';
                            tr += '<td>' + prices[5] + '</td>';
                            tr += '</tr>';
                            tbody.append(tr);
                        });
                        mobitopupTickets.show();
                    }
                }
            });
        };

        $('#agent').change(function () {
            updateCustommers();
        });

        $('#customer').change(function () {
            var countryId = $("#country").val();
            var customerId = $(this).val();

            if (countryId > 0 && customerId > 0) {
                getCommissionByCountryAndCustomer(countryId, customerId);
            }
        });

        var getCommissionByCountryAndCustomer = function (countryId, customerId) {
            $.ajax({
                type: 'GET',
                url: '/admin/world-topup-customer-commission/find-by-country-and-customer',
                data: {
                    countryId: countryId,
                    customerId: customerId
                },
                dataType: 'json',
                success: function (data) {
                    $("#groupCommission").val(data.groupPercent);
                    $("#agentCommission").val(data.agentPercent);
                    var customerId = $('#customer').val();

                    if (data.groupCommission.country.availableInMobitopup) {
                        var mobitopupCountryId = $('#mobitopupCountryId').val();
                        var networkId = $('#mobitopupNetwork').val();

                        if (customerId > 0 && mobitopupCountryId > 0 && networkId > 0) {
                            getMobitopupTickets(customerId, mobitopupCountryId, networkId);
                        }
                    }

                    if (data.groupCommission.country.availableInDing && customerId > 0) {
                        getDingTickets(customerId, data.groupCommission.country.iso);
                    }
                }
            });
        };

        var getDingTickets = function (customerId, iso) {
            var dingTickets = $('.dingTickets');
            var tbody = dingTickets.find('tbody');

            dingTickets.hide();
            tbody.empty();

            $.ajax({
                type: 'GET',
                url: '/admin/ding/get-tickets',
                data: {
                    customerId: customerId,
                    iso: iso
                },
                dataType: 'json',
                success: function (data) {
                    if (data.length > 0) {
                        $.each(data, function (index, item) {
                            var tr = '<tr>';
                            tr += '<td>' + item.m_fSuggestedRetailPrice + '</td>';
                            tr += '<td>' + Math.round(item.m_fGroupPrice * 100) / 100 + '</td>';
                            tr += '<td>' + Math.round(item.m_fAgentPrice * 100) / 100 + '</td>';
                            /*tr += '<td>' + item.m_fDestinationValueWithTax + '</td>';*/
                            tr += '</tr>';
                            tbody.append(tr);
                        });
                        dingTickets.show();
                    }
                    /*else {
                     getDingOperators(iso);
                     }*/
                }
            });
        };

        $.ajax({
            type: 'GET',
            url: '/admin/phone-topup-country/find-all',
            dataType: 'json',
            success: function (data) {
                var countries = $('#country');
                $.each(data, function (index, item) {
                    countries.append(new Option(item.name, item.id));
                });
            }
        });

        $.ajax({
            type: 'GET',
            url: '/admin/user/find-agents',
            dataType: 'json',
            success: function (data) {
                var agent = $('#agent');
                $.each(data, function (key, value) {
                    agent.append(new Option(value, key));
                });
            },
            complete: function () {
                updateCustommers();
            }
        });

        var updateCustommers = function () {
            var agent = $('#agent').val();
            var customer = $('#customer');
            customer.empty();
            $.ajax({
                type: 'GET',
                url: '/admin/customer/find-by-user',
                data: {login: agent},
                dataType: 'json',
                success: function (data) {
                    $.each(data, function (key, value) {
                        customer.append(new Option(value.companyName, value.id));
                    });
                },
                complete: function () {
                    var countryId = $("#country").val();
                    var customerId = customer.val();

                    if (countryId > 0 && customerId > 0) {
                        getCommissionByCountryAndCustomer(countryId, customerId);
                    }
                }
            });
        };
    });
</script>
