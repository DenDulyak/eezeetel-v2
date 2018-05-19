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
        <div class="col-lg-3 form-group">
            <select class="form-control" ng-options="g.name for g in groups track by g.id"
                    ng-model="group">
            </select>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control" date-min-limit="{{minDate}}" date-max-limit="{{maxDate}}">
                <div class="input-group">
                    <input ng-model="fromDay" class="form-control"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control" date-min-limit="{{minDate}}" date-max-limit="{{maxDate}}">
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
            <th>Quantity</th>
        </tr>
        </thead>
        <tbody ng-init="totalTopup = 0"
               ng-init="totalSales = 0"
               ng-init="totalTransactions = 0"
               ng-init="totalQuantity = 0">
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
            <td ng-init="$parent.totalQuantity = $parent.totalQuantity + credit.quantity">
                {{credit.quantity}}
            </td>
        </tr>
        <tr class="info">
            <td colspan="3">Total</td>
            <td>{{totalTopup.toFixed(2)}}</td>
            <td>{{totalSales.toFixed(2)}}</td>
            <td>{{totalTransactions.toFixed(0)}}</td>
            <td>{{totalQuantity.toFixed(0)}}</td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('customerBalanceController', function ($scope, $http, spinnerService) {
        $scope.fetchProductsList = function () {
            spinnerService.show('html5spinner');

            $http.get('/masteradmin/report/customer-balance-report', {
                params: {
                    groupId: $scope.group.id,
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

        $http.get('/masteradmin/group/find-all').success(function (groups) {
            groups.unshift(JSON.parse('{"id":"0", "name":"All"}'));
            $scope.groups = groups;
            $scope.group = $scope.groups[0];
        }).catch(function (err) {
            console.error(err);
        });

        var setDefaultValues = function () {
            $scope.totalTopup = 0.0;
            $scope.totalSales = 0.0;
            $scope.totalTransactions = 0;
            $scope.totalQuantity = 0;
        };

        /*var sort_by = function (field, reverse, primer) {
            var key = primer ? function (x) {
                return primer(x[field])
            } : function (x) {
                return x[field]
            };

            reverse = !reverse ? 1 : -1;
            return function (a, b) {
                return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
            }
        };

        $scope.$watch('group', function (value) {
            if (!value) {
                return;
            }

            $http.get('/masteradmin/customer/find-by-group', {
                params: {
                    id: value.id
                }
            }).success(function (customersMap) {
                var customersArray = [];
                for (var key in customersMap) {
                    var customer = {};
                    customer.id = key;
                    customer.name = customersMap[key];
                    customersArray.push(customer);
                }

                customersArray.sort(sort_by('name', false, function (c) {
                    return c.toUpperCase()
                }));

                $scope.customers = customersArray;
                $scope.customer = $scope.customers[0];
            }).catch(function (err) {
                console.error(err);
            });
        });*/

        setDefaultValues();
        $scope.fromDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.toDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.minDate = moment("2017-01-18").toString();
        $scope.maxDate = moment().subtract(1, "days").format("YYYY-MM-DD");
    });
</script>