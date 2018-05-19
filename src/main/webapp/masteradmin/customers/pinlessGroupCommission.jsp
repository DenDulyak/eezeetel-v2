<link href="${pageContext.request.contextPath}/css/libs/sweetalert2.min.css" rel="stylesheet">

<div class="container-fluid">
    <h2>Pinless Group Commission</h2>

    <div class="row" style="margin-top: 20px">
        <form class="form-horizontal col-md-4" id="mobileTopupForm">
            <div class="form-group">
                <label for="group" class="control-label col-sm-6">Group: </label>

                <div class="col-sm-6">
                    <select id="group" class="form-control"></select>
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
                        <input id="save" type="button" class="btn btn-primary" value="Save">
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/libs/sweetalert2.min.js"></script>
<script>
    var groups = $('#group');
    var commission = $('#commission');

    groups.change(function () {
        getGroupCommission($(this).val());
    });

    $('#save').click(function (e) {
        save(groups.val(), commission.val());
    });

    var getGroupCommission = function (groupId) {
        if (!groupId) {
            return;
        }
        $.ajax({
            type: 'GET',
            url: '/masteradmin/pinless-group-commission/find-by-group',
            data: {groupId: groupId},
            dataType: 'json',
            success: function (data) {
                commission.val(data.percent);
            }
        });
    };

    var save = function (groupId, percent) {
        if (!groupId || !percent) {
            return;
        }
        var pinless = {
            groupId: groupId,
            percent: percent
        };
        $.ajax({
            type: 'POST',
            url: '/masteradmin/pinless-group-commission/save',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(pinless),
            dataType: 'json',
            success: function (data) {
                commission.val(data.percent);
                swal('Successful!', '', 'success')
            },
            error: function() {
                swal('Something went wrong!', '', 'error')
            }
        });
    };

    $.ajax({
        type: 'GET',
        url: '/masteradmin/group/find-all',
        dataType: 'json',
        success: function (data) {
            $.each(data, function (key, value) {
                groups.append(new Option(value.name, value.id));
            });
        },
        complete: function () {
            getGroupCommission(groups.val());
        }
    });
</script>