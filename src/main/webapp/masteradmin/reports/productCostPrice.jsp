<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    table {
        width: 100%;
    }

    table li {
        display: grid;
    }
</style>

<div class="container-fluid" ng-controller="productCostPriceController">
    <h2>Product With Cost Price Report</h2>

    <spinner name="html5spinner" ng-cloak="">
        <div class="overlay"></div>
        <div class="spinner">
            <div class="double-bounce1"></div>
            <div class="double-bounce2"></div>
        </div>
        <div class="please-wait">Please Wait...</div>
    </spinner>

    <div class="row">
        <div class="col-lg-4">
            <select class="form-control"
                    ng-options="s.supplierName for s in suppliers track by s.id"
                    ng-model="supplier">
            </select>
        </div>
        <div class="col-lg-3" ng-show="showTransactions">
            <select class="form-control"
                    ng-options="p.productName for p in products track by p.id"
                    ng-model="product">
            </select>
        </div>
        <div class="col-lg-2">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="fromDay" class="form-control"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="toDay" class="form-control" placeholder="To"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="fetchTableData()" class="btn btn-primary" value="Search" />
    </div>

    <div class="row">
        <div class="col-lg-4 form-group">
            <div class="checkbox">
                <label><input type="checkbox" ng-model="showTransactions" value="">Show Product Transactions</label>
            </div>
        </div>
    </div>

    <table class="table-sm table-striped" ng-show="!showTransactions">
        <thead>
        <tr>
            <th>Product ID</th>
            <th>Supplier Name</th>
            <th>Product Name</th>
            <th>Product Cost price</th>
            <th>Quantity of Sales</th>
            <th>Sum of Cost Prices</th>
            <th>End Quantity</th>
            <th>End Quantity Amount</th>
        </tr>
        </thead>
        <tbody ng-init="totalSales = 0"
               ng-init="totalCostPrice = 0"
               ng-init="totalEndQuantity = 0"
               ng-init="totalEndQuantityAmount = 0">
        <tr ng-repeat="product in productData">
            <td>{{product.productId}}</td>
            <td>{{product.supplierName}}</td>
            <td>{{product.productName + ' - ' + product.faceValue}}</td>
            <td>{{product.productCostPrice}}</td>
            <td ng-init="$parent.totalSales = $parent.totalSales + product.sales">
                {{product.sales}}
            </td>
            <td ng-init="$parent.totalCostPrice = $parent.totalCostPrice + (product.productCostPrice * product.sales)">
                {{(product.productCostPrice * product.sales).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalEndQuantity = $parent.totalEndQuantity + product.availableQuantity">
                {{product.availableQuantity}}
            </td>
            <td ng-init="$parent.totalEndQuantityAmount = $parent.totalEndQuantityAmount + (product.productCostPrice * product.availableQuantity)">
                {{(product.productCostPrice * product.availableQuantity).toFixed(2)}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td></td>
            <td></td>
            <td>{{totalSales.toFixed(0)}}</td>
            <td>{{totalCostPrice.toFixed(2)}}</td>
            <td>{{totalEndQuantity.toFixed(0)}}</td>
            <td>{{totalEndQuantityAmount.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

    <table class="table-sm table-striped" ng-show="showTransactions">
        <thead>
        <tr>
            <th>Transaction Time</th>
            <th>Transaction ID</th>
            <th>Quantity</th>
            <th>Card Number</th>
            <th>Balance Before</th>
            <th>Balance After</th>
            <th>Price</th>
        </tr>
        </thead>
        <tbody ng-init="totalTransaction = 0"
               ng-init="totalTQuantity = 0"
               ng-init="totalTCostPrice = 0">
        <tr ng-repeat="transaction in transactionTableData">
            <td>{{transaction.transactionTime}}</td>
            <td ng-init="$parent.totalTransaction = $parent.totalTransaction + 1">
                {{transaction.transactionId}}
            </td>
            <td ng-init="$parent.totalTQuantity = $parent.totalTQuantity + transaction.quantity">
                {{transaction.quantity}}
            </td>
            <td>
                <li ng-repeat="pin in transaction.cardIds">
                    {{pin}}
                </li>
            </td>
            <td>{{transaction.balanceBefore}}</td>
            <td>{{transaction.balanceAfter}}</td>
            <td ng-init="$parent.totalTCostPrice = $parent.totalTCostPrice + transaction.costPrice">
                {{transaction.costPrice}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalTransaction.toFixed(0)}}</td>
            <td>{{totalTQuantity.toFixed(0)}}</td>
            <td></td>
            <td></td>
            <td></td>
            <td>{{totalTCostPrice.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('productCostPriceController', function ($scope, $http, spinnerService) {
        $scope.fetchTableData = function () {
            if($scope.showTransactions) {
                $scope.fetchTransactionTableData();
            } else {
                $scope.fetchProductTableData();
            }
        };

        $scope.fetchProductTableData = function () {
            spinnerService.show('html5spinner');
            $scope.totalSales = 0;
            $scope.totalCostPrice = 0.0;
            $scope.totalEndQuantity = 0;
            $scope.totalEndQuantityAmount = 0.0;

            $http.get('/masteradmin/report/product-sales-between-dates', {
                params: {
                    supplierId: $scope.supplier.id,
                    from: $scope.fromDay,
                    to: $scope.toDay
                }
            }).success(function (productData) {
                $scope.productData = productData;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.fetchTransactionTableData = function () {
            if ($scope.product == undefined || $scope.product.id < 1) {
                return;
            }

            spinnerService.show('html5spinner');
            $scope.totalTransaction = 0;
            $scope.totalTCostPrice = 0.0;
            $scope.totalTQuantity = 0;

            $http.get('/masteradmin/transaction/product-transactions-report', {
                params: {
                    productId: $scope.product.id,
                    start: $scope.fromDay,
                    end: $scope.toDay
                }
            }).success(function (transactionTableData) {
                $scope.transactionTableData = transactionTableData;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.updateProducts = function (supplierId) {
            spinnerService.show('html5spinner');

            $http.get('/masteradmin/product/find', {
                params: {
                    supplierId: supplierId
                }
            }).success(function (products) {
                $scope.products = products;
                $scope.product = $scope.products[0];
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $http.get('/masteradmin/supplier/find-all').success(function (suppliers) {
            suppliers.unshift(JSON.parse('{"id":"0", "supplierName":"All"}'));
            $scope.suppliers = suppliers;
            $scope.supplier = $scope.suppliers[0];
        }).catch(function (err) {
            console.error(err);
        });

        $scope.$watch('supplier', function (value) {
            if (value == undefined || value.id < 1 || !$scope.showTransactions) {
                return;
            }
            $scope.updateProducts(value.id);
        });

        $scope.$watch('showTransactions', function (value) {
            if (value == undefined || !value || $scope.supplier.id < 1) {
                return;
            }
            $scope.updateProducts($scope.supplier.id);
        });

        $scope.fromDay = moment().format("YYYY-MM-DD");
        $scope.toDay = moment().format("YYYY-MM-DD");
    });
</script>