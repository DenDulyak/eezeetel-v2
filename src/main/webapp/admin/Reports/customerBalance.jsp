<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }
</style>

<div class="container-fluid" ng-controller="customerBalanceController">
    <h2>Customer Balance Report</h2>

    <spinner name="html5spinner" ng-cloak="">
        <div class="overlay"></div>
        <div class="spinner">
            <div class="double-bounce1"></div>
            <div class="double-bounce2"></div>
        </div>
        <div class="please-wait">Please Wait...</div>
    </spinner>

    <div class="row">
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control" date-min-limit="{{minDate}}"
                        date-max-limit="{{maxDate}}">
                <div class="input-group">
                    <input ng-model="fromDay" class="form-control"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control" date-min-limit="{{minDate}}"
                        date-max-limit="{{maxDate}}">
                <div class="input-group">
                    <input ng-model="toDay" class="form-control" placeholder="To"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="fetchProductsList()" class="btn btn-primary" value="Search"/>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Customer</th>
            <th>Balance before</th>
            <th>Balance after</th>
            <th>Topup</th>
            <th>Sales</th>
            <th>Transactions</th>
        </tr>
        </thead>
        <tbody ng-init="totalTopup = 0"
               ng-init="totalSales = 0"
               ng-init="totalTransactions = 0">
        <tr ng-repeat="credit in credits">
            <td>{{credit.customerName}}</td>
            <td>{{credit.balanceBefore}}</td>
            <td>{{credit.balanceAfter}}</td>
            <td ng-init="$parent.totalTopup = $parent.totalTopup + credit.topup">
                {{credit.topup}}
            </td>
            <td ng-init="$parent.totalSales = $parent.totalSales + credit.sales">
                {{credit.sales}}
            </td>
            <td ng-init="$parent.totalTransactions = $parent.totalTransactions + credit.transactions">
                {{credit.transactions}}
            </td>
        </tr>
        <tr class="info">
            <td colspan="3">Total</td>
            <td>{{totalTopup.toFixed(2)}}</td>
            <td>{{totalSales.toFixed(2)}}</td>
            <td>{{totalTransactions.toFixed(0)}}</td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('customerBalanceController', function ($scope, $http, spinnerService) {
        $scope.fetchProductsList = function () {
            spinnerService.show('html5spinner');

            $http.get('/admin/report/customer-balance-report', {
                params: {
                    startDay: $scope.fromDay,
                    endDay: $scope.toDay
                }
            }).success(function (credits) {
                setDefaultValues();
                $scope.credits = credits;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        var setDefaultValues = function () {
            $scope.totalTopup = 0.0;
            $scope.totalSales = 0.0;
            $scope.totalTransactions = 0;
        };

        setDefaultValues();
        $scope.fromDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.toDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.minDate = moment("2017-01-18").toString();
        $scope.maxDate = moment().subtract(1, "days").format("YYYY-MM-DD");
    });
</script>