<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid" ng-controller="vatReportController">
    <h2>Vat Report</h2>

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
                    ng-options="c.value for c in customers track by c.key"
                    ng-model="customer">
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

    <h3>Calculate VAT</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Supplier</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Product Type</th>
            <th>Transactions</th>
            <th>Cards</th>
            <th>Total Transaction Cost Price</th>
            <th>Total Transaction Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalTransactions = 0"
               ng-init="totalQuantity = 0"
               ng-init="totalTransactionCostPrice = 0"
               ng-init="totalTransactionCustomerSalePrice = 0"
               ng-init="totalProfit = 0">
        <tr ng-repeat="transaction in vatTransactions">
            <td>{{transaction.supplier}}</td>
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td>{{transaction.productType}}</td>
            <td ng-init="$parent.totalTransactions = $parent.totalTransactions + transaction.transactions">
                {{transaction.transactions}}
            </td>
            <td ng-init="$parent.totalQuantity = $parent.totalQuantity + transaction.quantity">
                {{transaction.quantity}}
            </td>
            <td ng-init="$parent.totalTransactionCostPrice = $parent.totalTransactionCostPrice + (transaction.quantity * transaction.costPrice)">
                {{(transaction.quantity * transaction.costPrice).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalTransactionCustomerSalePrice = $parent.totalTransactionCustomerSalePrice + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfit = $parent.totalProfit + (transaction.customerPrice - (transaction.quantity * transaction.costPrice)) ">
                {{(transaction.customerPrice - (transaction.quantity * transaction.costPrice)).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td></td>
            <td></td>
            <td>{{totalTransactions.toFixed(0)}}</td>
            <td>{{totalQuantity.toFixed(0)}}</td>
            <td>{{totalTransactionCostPrice.toFixed(2)}}</td>
            <td>{{totalTransactionCustomerSalePrice.toFixed(2)}}</td>
            <td>{{totalProfit.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

    <h3>No Calculate VAT</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Supplier</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Product Type</th>
            <th>Transactions</th>
            <th>Cards</th>
            <th>Total Transaction Cost Price</th>
            <th>Total Transaction Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalTransactionsNo = 0"
               ng-init="totalQuantityNo = 0"
               ng-init="totalTransactionCostPriceNo = 0"
               ng-init="totalTransactionCustomerSalePriceNo = 0"
               ng-init="totalProfitNo = 0">
        <tr ng-repeat="transaction in noVatTransactions">
            <td>{{transaction.supplier}}</td>
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td>{{transaction.productType}}</td>
            <td ng-init="$parent.totalTransactionsNo = $parent.totalTransactionsNo + transaction.transactions">
                {{transaction.transactions}}
            </td>
            <td ng-init="$parent.totalQuantityNo = $parent.totalQuantityNo + transaction.quantity">
                {{transaction.quantity}}
            </td>
            <td ng-init="$parent.totalTransactionCostPriceNo = $parent.totalTransactionCostPriceNo + (transaction.quantity * transaction.costPrice)">
                {{(transaction.quantity * transaction.costPrice).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalTransactionCustomerSalePriceNo = $parent.totalTransactionCustomerSalePriceNo + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfitNo = $parent.totalProfitNo + (transaction.customerPrice - (transaction.quantity * transaction.costPrice)) ">
                {{(transaction.customerPrice - (transaction.quantity * transaction.costPrice)).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td></td>
            <td></td>
            <td>{{totalTransactionsNo.toFixed(0)}}</td>
            <td>{{totalQuantityNo.toFixed(0)}}</td>
            <td>{{totalTransactionCostPriceNo.toFixed(2)}}</td>
            <td>{{totalTransactionCustomerSalePriceNo.toFixed(2)}}</td>
            <td>{{totalProfitNo.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

    <h3>Local Topup</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Supplier</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Product Type</th>
            <th>Transactions</th>
            <th>Cards</th>
            <th>Total Transaction Cost Price</th>
            <th>Total Transaction Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalTransactionsLocal = 0"
               ng-init="totalQuantityLocal = 0"
               ng-init="totalTransactionCostPriceLocal = 0"
               ng-init="totalTransactionCustomerSalePriceLocal = 0"
               ng-init="totalProfitLocal = 0">
        <tr ng-repeat="transaction in localTransactions">
            <td>{{transaction.supplier}}</td>
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td>{{transaction.productType}}</td>
            <td ng-init="$parent.totalTransactionsLocal = $parent.totalTransactionsLocal + transaction.transactions">
                {{transaction.transactions}}
            </td>
            <td ng-init="$parent.totalQuantityLocal = $parent.totalQuantityLocal + transaction.quantity">
                {{transaction.quantity}}
            </td>
            <td ng-init="$parent.totalTransactionCostPriceLocal = $parent.totalTransactionCostPriceLocal + (transaction.quantity * transaction.costPrice)">
                {{(transaction.quantity * transaction.costPrice).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalTransactionCustomerSalePriceLocal = $parent.totalTransactionCustomerSalePriceLocal + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfitLocal = $parent.totalProfitLocal + (transaction.customerPrice - (transaction.quantity * transaction.costPrice)) ">
                {{(transaction.customerPrice - (transaction.quantity * transaction.costPrice)).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td></td>
            <td></td>
            <td>{{totalTransactionsLocal.toFixed(0)}}</td>
            <td>{{totalQuantityLocal.toFixed(0)}}</td>
            <td>{{totalTransactionCostPriceLocal.toFixed(2)}}</td>
            <td>{{totalTransactionCustomerSalePriceLocal.toFixed(2)}}</td>
            <td>{{totalProfitLocal.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

    <h3>Mobile Topup</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Provider</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Cost Price</th>
            <%--<th>Agent Sale Price</th>--%>
            <th>Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalCostPriceMobile = 0"
               ng-init="totalAgentPriceMobile = 0"
               ng-init="totalCustomerPriceMobile = 0"
               ng-init="totalProfitMobile = 0">
        <tr ng-repeat="transaction in mobileTransactions">
            <td>{{transaction.provider}}</td>
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td ng-init="$parent.totalCostPriceMobile = $parent.totalCostPriceMobile + transaction.groupPrice">
                {{transaction.groupPrice}}
            </td>
            <%--<td ng-init="$parent.totalAgentPriceMobile = $parent.totalAgentPriceMobile + transaction.agentPrice">
                {{transaction.agentPrice}}
            </td>--%>
            <td ng-init="$parent.totalCustomerPriceMobile = $parent.totalCustomerPriceMobile + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfitMobile = $parent.totalProfitMobile + (transaction.customerPrice - transaction.groupPrice) ">
                {{(transaction.customerPrice - transaction.groupPrice).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td></td>
            <td>{{totalCostPriceMobile.toFixed(2)}}</td>
            <%--<td>{{totalAgentPriceMobile.toFixed(2)}}</td>--%>
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
            <%--<th>Agent Sale Price</th>--%>
            <th>Customer Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
        <tbody ng-init="totalGroupPriceUnlocking = 0"
               ng-init="totalAgentPriceUnlocking = 0"
               ng-init="totalCustomerPriceUnlocking = 0"
               ng-init="totalProfitUnlocking = 0">
        <tr ng-repeat="transaction in mobileUnlockingTransactions">
            <td>{{transaction.customer}}</td>
            <td>{{transaction.product}}</td>
            <td ng-init="$parent.totalGroupPriceUnlocking = $parent.totalGroupPriceUnlocking + transaction.groupPrice">
                {{transaction.groupPrice}}
            </td>
            <%--<td ng-init="$parent.totalAgentPriceUnlocking = $parent.totalAgentPriceUnlocking + transaction.agentPrice">
                {{transaction.agentPrice}}
            </td>--%>
            <td ng-init="$parent.totalCustomerPriceUnlocking = $parent.totalCustomerPriceUnlocking + transaction.customerPrice">
                {{transaction.customerPrice}}
            </td>
            <td ng-init="$parent.totalProfitUnlocking = $parent.totalProfitUnlocking + (transaction.customerPrice - transaction.groupPrice) ">
                {{(transaction.customerPrice - transaction.groupPrice).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td>{{totalGroupPriceUnlocking.toFixed(2)}}</td>
            <%--<td>{{totalAgentPriceUnlocking.toFixed(2)}}</td>--%>
            <td>{{totalCustomerPriceUnlocking.toFixed(2)}}</td>
            <td>{{totalProfitUnlocking.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

    <div class="col-md-6">
        <h3>Totals</h3>
        <table class="table table-striped">
            <thead>
            <tr>
                <th></th>
                <th></th>
            </tr>
            </thead>
            <tbody ng-init="totalCostPriceAll = 0"
                   ng-init="totalCustomerPriceAll = 0"
                   ng-init="totalProfitAll = 0">
            <tr>
                <td>Cost Price</td>
                <td>{{totalCostPriceAll.toFixed(2)}}</td>
            </tr>
            <tr>
                <td>Customer Sale Price</td>
                <td>{{totalCustomerPriceAll.toFixed(2)}}</td>
            </tr>
            <tr>
                <td>Profit</td>
                <td>{{totalProfitAll.toFixed(2)}}</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<script>
    app.controller('vatReportController', function ($scope, $http, spinnerService) {
        $scope.fetchTransactionsList = function () {
            spinnerService.show('html5spinner');

            $scope.totalTransactions = 0.0;
            $scope.totalQuantity = 0.0;
            $scope.totalTransactionCostPrice = 0.0;
            $scope.totalTransactionCustomerSalePrice = 0.0;
            $scope.totalProfit = 0.0;

            $scope.totalTransactionsNo = 0.0;
            $scope.totalQuantityNo = 0.0;
            $scope.totalTransactionCostPriceNo = 0.0;
            $scope.totalTransactionCustomerSalePriceNo = 0.0;
            $scope.totalProfitNo = 0.0;

            $scope.totalTransactionsLocal = 0.0;
            $scope.totalQuantityLocal = 0.0;
            $scope.totalTransactionCostPriceLocal = 0.0;
            $scope.totalTransactionCustomerSalePriceLocal = 0.0;
            $scope.totalProfitLocal = 0.0;

            $http.get('/admin/report/vat-report', {
                params: {
                    customerId: $scope.customer.key,
                    fromDate: $scope.fromDay,
                    toDate: $scope.toDay
                }
            }).success(function (transactions) {
                var vatTransactions = [];
                var noVatTransactions = [];
                var localTransactions = [];
                transactions.forEach(function (entry) {
                    if (entry.productType == 'localtopup') {
                        localTransactions.push(entry);
                    } else if (entry.calculateVat == 1) {
                        vatTransactions.push(entry);
                    } else {
                        noVatTransactions.push(entry);
                    }
                });

                $scope.calculateTotals(transactions, true);

                $scope.vatTransactions = vatTransactions;
                $scope.noVatTransactions = noVatTransactions;
                $scope.localTransactions = localTransactions;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.fetchMobileTransactionsList = function () {
            $scope.totalCostPriceMobile = 0.0;
            $scope.totalAgentPriceMobile = 0.0;
            $scope.totalCustomerPriceMobile = 0.0;
            $scope.totalProfitMobile = 0.0;

            $http.get('/admin/report/profit-report-mobile-topup', {
                params: {
                    customerId: $scope.customer.key,
                    fromDate: $scope.fromDay,
                    toDate: $scope.toDay
                }
            }).success(function (transactions) {
                $scope.mobileTransactions = transactions;
                $scope.calculateTotals(transactions, false);
            }).catch(function (err) {
                console.error(err);
            });
        };

        $scope.fetchMobileUnlockingTransactionsList = function () {
            $scope.totalGroupPriceUnlocking = 0.0;
            $scope.totalAgentPriceUnlocking = 0.0;
            $scope.totalCustomerPriceUnlocking = 0.0;
            $scope.totalProfitUnlocking = 0.0;

            $http.get('/admin/report/profit-report-mobile-unlocking', {
                params: {
                    customerId: $scope.customer.key,
                    fromDate: $scope.fromDay,
                    toDate: $scope.toDay
                }
            }).success(function (transactions) {
                $scope.mobileUnlockingTransactions = transactions;
                $scope.calculateTotals(transactions, false);
            }).catch(function (err) {
                console.error(err);
            });
        };

        $scope.showTransactions = function () {
            $scope.totalCostPriceAll = 0.0;
            $scope.totalAgentPriceAll = 0.0;
            $scope.totalCustomerPriceAll = 0.0;
            $scope.totalProfitAll = 0.0;

            $scope.fetchTransactionsList();
            $scope.fetchMobileTransactionsList();
            $scope.fetchMobileUnlockingTransactionsList();
        };

        $scope.calculateTotals = function (transactions, isCard) {
            transactions.forEach(function (entry) {
                if (isCard) {
                    $scope.totalCostPriceAll += (entry.quantity * entry.costPrice);
                    $scope.totalCustomerPriceAll += entry.customerPrice;
                    $scope.totalProfitAll += (entry.customerPrice - (entry.quantity * entry.costPrice));
                } else {
                    $scope.totalCostPriceAll += entry.groupPrice;
                    $scope.totalCustomerPriceAll += entry.customerPrice;
                    $scope.totalProfitAll += (entry.customerPrice - entry.groupPrice);
                }
            });
        };

        $http.get('/admin/customer/find-group-customers').success(function (customers) {
            customers.unshift(JSON.parse('{"key":"0", "value":"All"}'));
            $scope.customers = customers;
            $scope.customer = $scope.customers[0];
        }).catch(function (err) {
            console.error(err);
        });

        $scope.fromDay = moment().format("YYYY-MM-DD");
        $scope.toDay = moment().add(1, 'days').format("YYYY-MM-DD");
    });
</script>
