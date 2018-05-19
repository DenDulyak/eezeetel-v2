<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }
</style>

<div class="container-fluid" ng-controller="retuneCardsStockController">
    <h2>Customers Sales Retune</h2>

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
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="start" class="form-control"/>
                           <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                           </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="end" class="form-control" placeholder="To"/>
                           <span class="input-group-addon">
                               <span class="glyphicon glyphicon-calendar"></span>
                           </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="fetchBatchsList()" class="btn btn-primary" value="Search"/>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th></th>
            <th>Sequence ID</th>
            <th>Transaction ID</th>
            <th>Transaction Time</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Face Value</th>
            <th>Quantity</th>
            <th>Cost Price</th>
            <th>Sale Price</th>
            <th>Profit</th>
        </tr>
        </thead>
       <tbody ng-init="totalCostPrice = 0"
              ng-init="totalSalePrice = 0"
              ng-init="totalProfit = 0">
        <tr class="info">
            <td></td>
            <td colspan="2">VAT Transactions</td>
            <td colspan="8"></td>
        </tr>
        <tr ng-repeat="transaction in vatTransactions">
            <td style="text-align:center;"><input type="checkbox"></td>
            <td>{{transaction.batch.id}}</td>
            <td>{{transaction.transactionId}}</td>
            <td>{{transaction.transactionTime}}</td>
            <td>{{transaction.customer.companyName}}</td>
            <td>{{transaction.product.name}}</td>
            <td>{{transaction.product.faceValue}}</td>
            <td>{{transaction.quantity}}</td>
            <td ng-init="$parent.totalCostPrice = $parent.totalCostPrice + (transaction.product.costPrice * transaction.quantity)">
                {{(transaction.product.costPrice * transaction.quantity).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalSalePrice = $parent.totalSalePrice + transaction.unitPurchasePrice">
                {{transaction.unitPurchasePrice}}
            </td>
            <td ng-init="$parent.totalProfit = $parent.totalProfit + (transaction.unitPurchasePrice - (transaction.product.costPrice * transaction.quantity))">
                {{(transaction.unitPurchasePrice - (transaction.product.costPrice * transaction.quantity)).toFixed(2)}}
            </td>
        </tr>
        <tr class="warning">
            <td></td>
            <td colspan="7">Totals</td>
            <td>{{totalCostPrice.toFixed(2)}}</td>
            <td>{{totalSalePrice.toFixed(2)}}</td>
            <td>{{totalProfit.toFixed(2)}}</td>
        </tr>
        </tbody>
        <tbody ng-init="totalCostPriceNonVAT = 0"
               ng-init="totalSalePriceNonVAT = 0"
               ng-init="totalProfitNonVAT = 0">
        <tr>
            <td colspan="11"><br/></td>
        </tr>
        <tr class="info">
            <td></td>
            <td colspan="2">Non VAT Transactions</td>
            <td colspan="8"></td>
        </tr>
        <tr ng-repeat="transaction in nonVatTransactions">
            <td style="text-align:center;"><input type="checkbox"></td>
            <td>{{transaction.batch.id}}</td>
            <td>{{transaction.transactionId}}</td>
            <td>{{transaction.transactionTime}}</td>
            <td>{{transaction.customer.companyName}}</td>
            <td>{{transaction.product.name}}</td>
            <td>{{transaction.product.faceValue}}</td>
            <td>{{transaction.quantity}}</td>
            <td ng-init="$parent.totalCostPriceNonVAT = $parent.totalCostPriceNonVAT + (transaction.product.costPrice * transaction.quantity)">
                {{(transaction.product.costPrice * transaction.quantity).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalSalePriceNonVAT = $parent.totalSalePriceNonVAT + transaction.unitPurchasePrice">
                {{transaction.unitPurchasePrice}}
            </td>
            <td ng-init="$parent.totalProfitNonVAT = $parent.totalProfitNonVAT + (transaction.unitPurchasePrice - (transaction.product.costPrice * transaction.quantity))">
                {{(transaction.unitPurchasePrice - (transaction.product.costPrice * transaction.quantity)).toFixed(2)}}
            </td>
        </tr>
        <tr class="warning">
            <td></td>
            <td colspan="7">Totals</td>
            <td>{{totalCostPriceNonVAT.toFixed(2)}}</td>
            <td>{{totalSalePriceNonVAT.toFixed(2)}}</td>
            <td>{{totalProfitNonVAT.toFixed(2)}}</td>
        </tr>
        </tbody>
        <tbody ng-init="totalCostPriceLocal = 0"
               ng-init="totalSalePriceLocal = 0"
               ng-init="totalProfitLocal = 0">
        <tr>
            <td colspan="11"><br/></td>
        </tr>
        <tr class="info">
            <td></td>
            <td colspan="2">Local And 3R Transactions</td>
            <td colspan="8"></td>
        </tr>
        <tr ng-repeat="transaction in localTransactions">
            <td style="text-align:center;">
                <input type="checkbox">
            </td>
            <td>{{transaction.batch.id}}</td>
            <td>{{transaction.transactionId}}</td>
            <td>{{transaction.transactionTime}}</td>
            <td>{{transaction.customer.companyName}}</td>
            <td>{{transaction.product.name}}</td>
            <td>{{transaction.product.faceValue}}</td>
            <td>{{transaction.quantity}}</td>
            <td ng-init="$parent.totalCostPriceLocal = $parent.totalCostPriceLocal + (transaction.product.costPrice * transaction.quantity)">
                {{(transaction.product.costPrice * transaction.quantity).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalSalePriceLocal = $parent.totalSalePriceLocal + transaction.unitPurchasePrice">
                {{transaction.unitPurchasePrice}}
            </td>
            <td ng-init="$parent.totalProfitLocal = $parent.totalProfitLocal + (transaction.unitPurchasePrice - (transaction.product.costPrice * transaction.quantity))">
                {{(transaction.unitPurchasePrice - (transaction.product.costPrice * transaction.quantity)).toFixed(2)}}
            </td>
        </tr>
        <tr class="warning">
            <td></td>
            <td colspan="7">Totals</td>
            <td>{{totalCostPriceLocal.toFixed(2)}}</td>
            <td>{{totalSalePriceLocal.toFixed(2)}}</td>
            <td>{{totalProfitLocal.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

</div>

<script>
    app.controller('retuneCardsStockController', function ($scope, $http, spinnerService) {
        $scope.fetchBatchsList = function () {
            spinnerService.show('html5spinner');

            $http.get('/masteradmin/transaction/sales-retune', {
                params: {
                    start: $scope.start,
                    end: $scope.end
                }
            }).success(function (transactions) {
                $scope.setDefaultVal();

                var vatTransactions = [];
                var nonVatTransactions = [];
                var localTransactions = [];

                transactions.forEach(function (entry) {
                    if (entry.batch.supplier.supplierType.id == 9 || entry.batch.supplier.supplierType.id == 12) {
                        nonVatTransactions.push(entry);
                    } else if (entry.batch.supplier.supplierType.id == 10 || entry.batch.supplier.supplierType.id == 16) {
                        localTransactions.push(entry);
                    } else {
                        vatTransactions.push(entry);
                    }
                });

                $scope.vatTransactions = vatTransactions;
                $scope.nonVatTransactions = nonVatTransactions;
                $scope.localTransactions = localTransactions;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.setDefaultVal = function () {
            $scope.totalCostPrice = 0.0;
            $scope.totalSalePrice = 0.0;
            $scope.totalProfit = 0.0;

            $scope.totalCostPriceNonVAT = 0.0;
            $scope.totalSalePriceNonVAT = 0.0;
            $scope.totalProfitNonVAT = 0.0;

            $scope.totalCostPriceLocal = 0.0;
            $scope.totalSalePriceLocal = 0.0;
            $scope.totalProfitLocal = 0.0;
        };

        $scope.setDefaultVal();
        $scope.start = moment().format('YYYY-MM-DD');
        $scope.end = moment().format('YYYY-MM-DD');
    });
</script>