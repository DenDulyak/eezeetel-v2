<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    .table {
        margin-top: 20px;
    }
    .table td {
        padding: 2px 6px !important;
    }
</style>

<div class="container-fluid" ng-controller="productBatchesController">
    <h2>Product Batches Report</h2>

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
        <div class="col-lg-3">
            <select class="form-control"
                    ng-options="p.productName + ' ' + p.productFaceValue for p in products track by p.id"
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

    <table class="table table-sm table-striped">
        <thead>
        <tr>
            <th>Sequence ID</th>
            <th>Beginning Quantity</th>
            <th>Available Quantity</th>
            <th>Arrival date</th>
            <th>Expiry date</th>
            <th>Total Sales</th>
            <th>Total Transactions</th>
            <th>Starting Batch Number</th>
            <th>Ending Batch Number</th>
        </tr>
        </thead>
        <tbody ng-init="totalBeginningQuantity = 0"
               ng-init="totalAvailableQuantity = 0"
               ng-init="totalSales = 0"
               ng-init="totalTransactions = 0">
        <tr ng-repeat="batch in batches">
            <td>{{batch.id}}</td>
            <td ng-init="$parent.totalBeginningQuantity = $parent.totalBeginningQuantity + batch.beginningQuantity">
                {{batch.beginningQuantity}}
            </td>
            <td ng-init="$parent.totalAvailableQuantity = $parent.totalAvailableQuantity + batch.availableQuantity">
                {{batch.availableQuantity}}
            </td>
            <td>{{batch.arrivalDate}}</td>
            <td>{{batch.expiryDate}}</td>
            <td ng-init="$parent.totalSales = $parent.totalSales + batch.sales">
                {{batch.sales}}
            </td>
            <td ng-init="$parent.totalTransactions = $parent.totalTransactions + batch.transactions">
                {{batch.transactions}}
            </td>
            <td>{{batch.firstCardId}}</td>
            <td>{{batch.lastCardId}}</td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalBeginningQuantity.toFixed(0)}}</td>
            <td>{{totalAvailableQuantity.toFixed(0)}}</td>
            <td></td>
            <td></td>
            <td>{{totalSales.toFixed(0)}}</td>
            <td>{{totalTransactions.toFixed(0)}}</td>
            <td></td>
            <td></td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('productBatchesController', function ($scope, $http, spinnerService) {

        $scope.fetchTableData = function () {
            spinnerService.show('html5spinner');
            $scope.totalBeginningQuantity = 0;
            $scope.totalAvailableQuantity = 0;
            $scope.totalSales = 0;
            $scope.totalTransactions = 0;

            $http.get('/masteradmin/report/batch-info-by-product', {
                params: {
                    productId: $scope.product.id,
                    from: $scope.fromDay,
                    to: $scope.toDay
                }
            }).success(function (batches) {
                $scope.batches = batches;
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
            $scope.suppliers = suppliers;
            $scope.supplier = $scope.suppliers[0];
        }).catch(function (err) {
            console.error(err);
        });

        $scope.$watch('supplier', function (value) {
            if (value == undefined || value.id < 1) {
                return;
            }
            $scope.updateProducts(value.id);
        });

        $scope.fromDay = moment().format("YYYY-MM-DD");
        $scope.toDay = moment().format("YYYY-MM-DD");
    });
</script>
