<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../common/libs.jsp"/>
    <title>Pinless Commision Report</title>
</head>
<body>
<div class="no-print">
    <c:import url="headerNavbar.jsp"/>

    <div class="container">
        <div class="row">
            <div class="form-inline col-sm-12">
                <div class="form-group">
                    <label for="month" class="control-label">Select the month: </label>
                    <input id="month" type="text" class="form-control"/>
                </div>
            </div>
        </div>

        <div class="row" style="margin-top: 20px">
            <div class="col-md-4">
                <table id="report-table" class="table table-sm table-striped table-bordered">
                    <thead>
                    <tr>
                        <th>Number</th>
                        <th>Amount</th>
                    </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/libs/moment-with-locales.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/jquery.pleaseWait.js"></script>
    <script>
        $(function () {
            var reportTable = $('#report-table');

            $('#month').datepicker({
                format: "mm-yyyy",
                viewMode: "months",
                minViewMode: "months",
                startDate: new Date(2017, 1, 1)
            }).on('changeDate', function (ev) {
                updateTable('01-' + $(this).val());
            }).val(moment().format("MM-YYYY"));

            var updateTable = function (date) {
                $('.container').pleaseWait();
                var tbody = reportTable.find('tbody');
                tbody.empty();

                $.ajax({
                    url: '/customer/pinless/month-transactions',
                    data: {
                        month: date
                    },
                    dataType: 'json',
                    success: function (data) {
                        $.each(data, function (key, value) {
                            tbody.append('<tr><td>' + key + '</td><td>' + value + '</td></tr>');
                        });
                    },
                    complete: function () {
                        $('.container').pleaseWait('stop');
                    }
                });
            };

            updateTable('01-' + moment().format("MM-YYYY"));
        });
    </script>
</div>
</body>
</html>
