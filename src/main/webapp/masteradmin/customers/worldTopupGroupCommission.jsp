<div class="container-fluid">
    <h2>World Mobile Topup Group Commission</h2>

    <br>

    <div class="row" style="margin-bottom: 5px">
        <form class="form-horizontal col-md-4" id="mobileTopupForm">
            <div class="form-group">
                <label class="control-label col-sm-6" for="country">Country:</label>

                <div class="col-sm-6">
                    <select id="country" class="form-control">
                        <option value="0">Select a country</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-6 col-sm-offset-6">
                    <div class="checkbox">
                        <label><input type="checkbox" onclick="return false"
                                      class="availableInDing">Available in Ding</label>
                    </div>
                    <div class="checkbox">
                        <label><input type="checkbox" onclick="return false"
                                      class="availableInMobitopup">Available in Mobitopup</label>
                    </div>
                </div>
            </div>
            <div class="form-group mobitopupNetworks" hidden>
                <label class="control-label col-sm-6" for="mobitopupNetwork">Mobitopup networks:</label>

                <div class="col-sm-6">
                    <input type="hidden" id="mobitopupCountryId"/>
                    <select id="mobitopupNetwork" class="form-control">
                        <option value="0">Select a network</option>
                    </select>
                </div>
            </div>
            <div class="form-group dingOperators" hidden>
                <label class="control-label col-sm-6" for="dingOperator">Ding operators:</label>

                <div class="col-sm-6">
                    <select id="dingOperator" class="form-control">
                        <option value="0">Select a operator</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="agent" class="control-label col-sm-6">Group: </label>

                <div class="col-sm-6">
                    <select id="agent" class="form-control"></select>
                </div>
            </div>
            <div class="form-group">
                <label for="commission" class="control-label col-sm-6">Commission percentage: </label>

                <div class="col-sm-6">
                    <input type="number" class="form-control" id="commission"/>
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-6 col-sm-6">
                    <div id="get_details_link_button_id">
                        <input type="button" class="btn btn-primary save" value="Save">
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
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Ticket</th>
                        <th>EezeeTel Profit</th>
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
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Destination Value</th>
                        <th>Buying Price</th>
                        <th>Selling Price</th>
                        <th>EezeeTel Profit</th>
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
            var groupId = $('#agent').val();
            var percent = $("#commission").val();
            if (percent >= 0 && countryId > 0 && groupId > 0) {
                $.ajax({
                    type: 'POST',
                    url: '/masteradmin/world-topup-group-commission/save',
                    data: {
                        countryId: countryId,
                        groupId: groupId,
                        percent: percent
                    },
                    dataType: 'json',
                    success: function (data) {
                        var groupId = $('#agent').val();

                        if (data.country.availableInMobitopup) {
                            var mobitopupCountryId = $('#mobitopupCountryId').val();
                            var networkId = $('#mobitopupNetwork').val();

                            if (groupId > 0 && mobitopupCountryId > 0 && networkId > 0) {
                                getMobitopupTickets(groupId, mobitopupCountryId, networkId);
                            }
                        }

                        if (data.country.availableInDing && groupId > 0) {
                            getDingTickets(groupId, data.country.iso);
                        }
                    }
                });
            }
        });

        $('#country').change(function () {
            var availableInDing = $(".availableInDing");
            var availableInMobitopup = $(".availableInMobitopup");
            var commission = $("#commission");
            var mobitopupNetworks = $(".mobitopupNetworks");

            availableInDing.prop('checked', false);
            availableInMobitopup.prop('checked', false);
            commission.val('');
            mobitopupNetworks.hide();

            $('#mobitopupNetwork').empty();
            $('.mobitopupTickets').hide();
            $('.dingTickets').hide();
            $('.dingOperators').hide();

            var countryId = $(this).val();
            var groupId = $('#agent').val();
            if (countryId > 0) {
                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/phone-topup-country/find-one',
                    data: {id: countryId},
                    dataType: 'json',
                    success: function (data) {
                        availableInDing.prop('checked', data.availableInDing);
                        availableInMobitopup.prop('checked', data.availableInMobitopup);
                        if (data.availableInMobitopup) {
                            mobitopupNetworks.show();
                            getMobitopupNetworks(data.mobitopupCountryId);
                        }
                    },
                    complete: function () {
                        if (groupId > 0) {
                            getCommissionByCountryAndGroup(countryId, groupId);
                        }
                    }
                });
            }
        });

        $('#mobitopupNetwork').change(function () {
            var groupId = $('#agent').val();
            var mobitopupCountryId = $('#mobitopupCountryId').val();
            var networkId = $(this).val();

            if (groupId > 0 && mobitopupCountryId > 0 && networkId > 0) {
                getMobitopupTickets(groupId, mobitopupCountryId, networkId);
            } else {
                $('.mobitopupTickets').hide();
            }
        });

        var getMobitopupTickets = function (groupId, mobitopupCountryId, networkId) {
            var mobitopupTickets = $('.mobitopupTickets');
            var tbody = mobitopupTickets.find('tbody');
            tbody.empty();

            $.ajax({
                type: 'GET',
                url: '/masteradmin/mobitopup/get-tickets',
                data: {
                    groupId: groupId,
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
                            tr += '</tr>';
                            tbody.append(tr);
                        });
                        mobitopupTickets.show();
                    }
                }
            });
        };

        var getDingTickets = function (groupId, iso) {
            var dingTickets = $('.dingTickets');
            var tbody = dingTickets.find('tbody');

            dingTickets.hide();
            tbody.empty();

            $.ajax({
                type: 'GET',
                url: '/masteradmin/ding/get-tickets',
                data: {
                    groupId: groupId,
                    iso: iso
                },
                dataType: 'json',
                success: function (data) {
                    if (data.length > 0) {
                        $.each(data, function (index, item) {
                            var tr = '<tr>';
                            tr += '<td>' + item.m_fDenomination + '</td>';
                            tr += '<td>' + Math.round((item.m_fDenomination - item.m_fEezeeTelPrice) * 100) / 100 + '</td>';
                            tr += '</tr>';
                            tbody.append(tr);
                        });
                        dingTickets.show();
                    } else {
                        getDingOperators(iso);
                    }
                }
            });
        };

        var getDingTicketsByOperator = function (countryId, groupId, operatorCode) {
            var dingTickets = $('.dingTickets');
            var tbody = dingTickets.find('tbody');

            dingTickets.hide();
            tbody.empty();

            $.ajax({
                type: 'GET',
                url: '/masteradmin/ding/get-tickets-by-operator',
                data: {
                    countryId: countryId,
                    groupId: groupId,
                    operatorCode: operatorCode
                },
                dataType: 'json',
                success: function (data) {
                    if (data.length > 0) {
                        $.each(data, function (index, item) {
                            var tr = '<tr>';
                            tr += '<td>' + item.m_fDenomination + '</td>';
                            tr += '<td>' + Math.round((item.m_fGroupPrice - item.m_fDenomination) * 100) / 100 + '</td>';
                            tr += '</tr>';
                            tbody.append(tr);
                        });
                        dingTickets.show();
                    }
                }
            });
        };

        var getDingOperators = function (iso) {
            var dingOperators = $(".dingOperators");

            $.ajax({
                type: 'GET',
                url: '/masteradmin/ding/get-operators',
                data: {
                    iso: iso
                },
                dataType: 'json',
                success: function (data) {
                    if (data.length > 0) {
                        var dingOperator = $("#dingOperator");
                        dingOperator.empty();
                        dingOperator.append(new Option('Select a operator', 0));

                        $.each(data, function (index, item) {
                            dingOperator.append(new Option(item.strOperator, item.strOperatorCode));
                        });

                        dingOperators.show();
                    }
                }
            });
        };

        $('#dingOperator').change(function () {
            var operatorCode = $(this).val();
            var countryId = $('#country').val();
            var groupId = $('#agent').val();

            if (countryId > 0 && groupId > 0 && operatorCode != 0) {
                getDingTicketsByOperator(countryId, groupId, operatorCode);
            }
        });

        $('#agent').change(function () {
            $("#commission").val('');

            var groupId = $(this).val();
            var countryId = $('#country').val();

            if (countryId > 0 && groupId > 0) {
                getCommissionByCountryAndGroup(countryId, groupId);
            }
        });

        var getCommissionByCountryAndGroup = function (countryId, groupId) {
            $.ajax({
                type: 'GET',
                url: '/masteradmin/world-topup-group-commission/find-by-country-and-group',
                data: {
                    countryId: countryId,
                    groupId: groupId
                },
                dataType: 'json',
                success: function (data) {
                    $("#commission").val(data.percent);
                    var groupId = $('#agent').val();

                    if (data.country.availableInMobitopup) {
                        var mobitopupCountryId = $('#mobitopupCountryId').val();
                        var networkId = $('#mobitopupNetwork').val();

                        if (groupId > 0 && mobitopupCountryId > 0 && networkId > 0) {
                            getMobitopupTickets(groupId, mobitopupCountryId, networkId);
                        }
                    }

                    if (data.country.availableInDing && groupId > 0) {
                        getDingTickets(groupId, data.country.iso);
                    }
                }
            });
        };

        var getMobitopupNetworks = function (mobitopupCountryId) {
            $.ajax({
                type: 'GET',
                url: '/masteradmin/mobitopup/get-networks',
                data: {
                    mobitopupCountryId: mobitopupCountryId
                },
                dataType: 'json',
                success: function (data) {
                    if (data.error_code == 0) {
                        var mobitopupNetwork = $('#mobitopupNetwork');

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

        $.ajax({
            type: 'GET',
            url: '/masteradmin/phone-topup-country/find-all',
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
            url: '/masteradmin/group/find-all',
            dataType: 'json',
            success: function (data) {
                var agents = $('#agent');
                $.each(data, function (key, value) {
                    agents.append(new Option(value.name, value.id));
                });
            }
        });
    });
</script>