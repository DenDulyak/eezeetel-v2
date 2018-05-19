<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>


<div class="container-fluid" ng-controller="profitReportController">

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
            <select class="form-control"
                    ng-options="g.name for g in groups track by g.id"
                    ng-model="group">
            </select>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="fromDay" class="form-control"/>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="toDay" class="form-control"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="showTransactions()" class="btn btn-primary" value="Search"/>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Customer</th>
            <th>Product</th>
            <th>Transactions</th>
            <th>Cards</th>
            <th>Cost Price</th>
            <th>Total Cost Price</th>
            <th>Total Group Sale Price</th>
            <th>Total Agent Sale Price</th>
            <th>Total Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalTransactions = 0"
               ng-init="totalQuantity = 0"
               ng-init="totalCostPrice = 0"
               ng-init="totalTransactionCostPrice = 0"
               ng-init="totalTransactionGroupSalePrice = 0"
               ng-init="totalTransactionAgentSalePrice = 0"
               ng-init="totalTransactionCustomerSalePrice = 0"
               ng-init="totalProfit = 0">
        <tr ng-repeat="transaction in transactions">
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td ng-init="$parent.totalTransactions = $parent.totalTransactions + transaction.transactions">
                {{transaction.transactions}}
            </td>
            <td ng-init="$parent.totalQuantity = $parent.totalQuantity + transaction.quantity">
                {{transaction.quantity}}
            </td>
            <td ng-init="$parent.totalCostPrice = $parent.totalCostPrice + transaction.costPrice">
                {{transaction.costPrice}}
            </td>
            <td ng-init="$parent.totalTransactionCostPrice = $parent.totalTransactionCostPrice + (transaction.quantity * transaction.costPrice)">
                {{(transaction.quantity * transaction.costPrice).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalTransactionGroupSalePrice = $parent.totalTransactionGroupSalePrice + transaction.groupPrice">
                {{transaction.groupPrice}}
            </td>
            <td ng-init="$parent.totalTransactionAgentSalePrice = $parent.totalTransactionAgentSalePrice + transaction.agentPrice">
                {{transaction.agentPrice}}
            </td>
            <td ng-init="$parent.totalTransactionCustomerSalePrice = $parent.totalTransactionCustomerSalePrice + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfit = $parent.totalProfit + (transaction.groupPrice - (transaction.quantity * transaction.costPrice)) ">
                {{(transaction.groupPrice - (transaction.quantity * transaction.costPrice)).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td>{{totalTransactions.toFixed(2)}}</td>
            <td>{{totalQuantity.toFixed(2)}}</td>
            <td>{{totalCostPrice.toFixed(2)}}</td>
            <td>{{totalTransactionCostPrice.toFixed(2)}}</td>
            <td>{{totalTransactionGroupSalePrice.toFixed(2)}}</td>
            <td>{{totalTransactionAgentSalePrice.toFixed(2)}}</td>
            <td>{{totalTransactionCustomerSalePrice.toFixed(2)}}</td>
            <td>{{totalProfit.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

    <h3>Mobile Topup</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Customer</th>
            <th>Product</th>
            <th>Cost Price</th>
            <th>Group Price</th>
            <th>Agent Sale Price</th>
            <th>Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalCostPriceMobile = 0"
               ng-init="totalGroupPriceMobile = 0"
               ng-init="totalAgentPriceMobile = 0"
               ng-init="totalCustomerPriceMobile = 0"
               ng-init="totalProfitMobile = 0">
        <tr ng-repeat="transaction in mobileTransactions">
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td ng-init="$parent.totalCostPriceMobile = $parent.totalCostPriceMobile + transaction.costPrice">
                {{transaction.costPrice}}
            </td>
            <td ng-init="$parent.totalGroupPriceMobile = $parent.totalGroupPriceMobile + transaction.groupPrice">
                {{transaction.groupPrice}}
            </td>
            <td ng-init="$parent.totalAgentPriceMobile = $parent.totalAgentPriceMobile + transaction.agentPrice">
                {{transaction.agentPrice}}
            </td>
            <td ng-init="$parent.totalCustomerPriceMobile = $parent.totalCustomerPriceMobile + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfitMobile = $parent.totalProfitMobile + (transaction.groupPrice - transaction.costPrice) ">
                {{(transaction.groupPrice - transaction.costPrice).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td>{{totalCostPriceMobile.toFixed(2)}}</td>
            <td>{{totalGroupPriceMobile.toFixed(2)}}</td>
            <td>{{totalAgentPriceMobile.toFixed(2)}}</td>
            <td>{{totalCustomerPriceMobile.toFixed(2)}}</td>
            <td>{{totalProfitMobile.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

    <h3>Mobile Unlocking</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Customer</th>
            <th>Product</th>
            <th>Cost Price</th>
            <th>Group Sale Price</th>
            <th>Agent Sale Price</th>
            <th>Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalCostPriceUnlocking = 0"
               ng-init="totalGroupPriceUnlocking = 0"
               ng-init="totalAgentPriceUnlocking = 0"
               ng-init="totalCustomerPriceUnlocking = 0"
               ng-init="totalProfitUnlocking = 0">
        <tr ng-repeat="transaction in mobileUnlockingTransactions">
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td ng-init="$parent.totalCostPriceUnlocking = $parent.totalCostPriceUnlocking + transaction.costPrice">
                {{transaction.costPrice}}
            </td>
            <td ng-init="$parent.totalGroupPriceUnlocking = $parent.totalGroupPriceUnlocking + transaction.groupPrice">
                {{transaction.groupPrice}}
            </td>
            <td ng-init="$parent.totalAgentPriceUnlocking = $parent.totalAgentPriceUnlocking + transaction.agentPrice">
                {{transaction.agentPrice}}
            </td>
            <td ng-init="$parent.totalCustomerPriceUnlocking = $parent.totalCustomerPriceUnlocking + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfitUnlocking = $parent.totalProfitUnlocking + (transaction.groupPrice - transaction.costPrice) ">
                {{(transaction.groupPrice - transaction.costPrice).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td>{{totalCostPriceUnlocking.toFixed(2)}}</td>
            <td>{{totalGroupPriceUnlocking.toFixed(2)}}</td>
            <td>{{totalAgentPriceUnlocking.toFixed(2)}}</td>
            <td>{{totalCustomerPriceUnlocking.toFixed(2)}}</td>
            <td>{{totalProfitUnlocking.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('profitReportController', function ($scope, $http, spinnerService) {
        $scope.fetchTransactionsList = function () {
            spinnerService.show('html5spinner');

            $scope.totalTransactions = 0.0;
            $scope.totalQuantity = 0.0;
            $scope.totalCostPrice = 0.0;
            $scope.totalTransactionCostPrice = 0.0;
            $scope.totalTransactionGroupSalePrice = 0.0;
            $scope.totalTransactionAgentSalePrice = 0.0;
            $scope.totalTransactionCustomerSalePrice = 0.0;
            $scope.totalProfit = 0.0;

            $http.get('/masteradmin/report/profit-report', {
                params: {
                    type: 0,
                    groupId: $scope.group.id,
                    fromDate: $scope.fromDay,
                    toDate: $scope.toDay
                }
            }).success(function (transactions) {
                $scope.transactions = transactions;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.fetchMobileTransactionsList = function () {
            $scope.totalCostPriceMobile = 0.0;
            $scope.totalGroupPriceMobile = 0.0;
            $scope.totalAgentPriceMobile = 0.0;
            $scope.totalCustomerPriceMobile = 0.0;
            $scope.totalProfitMobile = 0.0;

            $http.get('/masteradmin/report/profit-report', {
                params: {
                    type: 6,
                    groupId: $scope.group.id,
                    fromDate: $scope.fromDay,
                    toDate: $scope.toDay
                }
            }).success(function (transactions) {
                $scope.mobileTransactions = transactions;
            }).catch(function (err) {
                console.error(err);
            });
        };

        $scope.fetchMobileUnlockingTransactionsList = function () {
            $scope.totalCostPriceUnlocking = 0.0;
            $scope.totalGroupPriceUnlocking = 0.0;
            $scope.totalAgentPriceUnlocking = 0.0;
            $scope.totalCustomerPriceUnlocking = 0.0;
            $scope.totalProfitUnlocking = 0.0;

            $http.get('/masteradmin/report/profit-report', {
                params: {
                    type: 5,
                    groupId: $scope.group.id,
                    fromDate: $scope.fromDay,
                    toDate: $scope.toDay
                }
            }).success(function (transactions) {
                $scope.mobileUnlockingTransactions = transactions;
            }).catch(function (err) {
                console.error(err);
            });
        };

        $scope.showTransactions = function () {
            $scope.fetchTransactionsList();
            $scope.fetchMobileTransactionsList();
            $scope.fetchMobileUnlockingTransactionsList();
        };

        $http.get('/masteradmin/group/find-all').success(function (groups) {
            groups.unshift(JSON.parse('{"id":"0", "name":"All"}'));
            $scope.groups = groups;
            $scope.group = $scope.groups[0];
        }).catch(function (err) {
            console.error(err);
        });

        $scope.fromDay = moment().format("YYYY-MM-DD");
        $scope.toDay = moment().add(1, 'days').format("YYYY-MM-DD");
    });
</script>