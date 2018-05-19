<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    @media print {
        .no-print {
            display: none;
        }

        @page {
            margin: 10px;
        }

        #result {
            width: 100%;
        }

        #main-content {
            margin-left: 0;
        }
    }
</style>

<div class="container-fluid">
    <h2 class="no-print">Customer Commissions Report</h2>

    <div class="row no-print">
        <div class="col-lg-2 form-group">
            <select id="customer" class="form-control"></select>
        </div>
        <div class="col-lg-2 form-inline">
            <input id="month" type="text" class="form-control" />
        </div>
        <a id="generate" class="btn btn-link">Show the report for selected month</a>
    </div>

    <div id="result">

    </div>
</div>

<script>
    $(function () {
        var customer = $('#customer');
        var month = $('#month');

        $.ajax({
            type: 'GET',
            url: '/admin/customer/find-group-customers',
            dataType: 'json',
            success: function (data) {
                $.each(data, function (key, value) {
                    customer.append(new Option(value.value, value.key));
                });
            }
        });


        month.datepicker({
            format: "mm-yyyy",
            viewMode: "months",
            minViewMode: "months",
            startDate: new Date(2012, 1, 1)
        });

        month.val(moment().format("MM-YYYY"));

        $("#generate").click(function (e) {
            $.ajax({
                type: 'GET',
                url: '/admin/report/customer-commissions-report',
                data: {
                    customerId: customer.val(),
                    date: '01-' + month.val()
                },
                dataType: 'text',
                success: function (data) {
                    $('#result').html(data);
                }
            });
        });
    });
</script>