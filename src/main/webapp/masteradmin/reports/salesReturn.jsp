<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    table {
        width: 100%;
    }
</style>

<div class="container-fluid" ng-controller="productCostPriceController">
    <h2>Sales Return</h2>

    <spinner name="html5spinner" ng-cloak="">
        <div class="overlay"></div>
        <div class="spinner">
            <div class="double-bounce1"></div>
            <div class="double-bounce2"></div>
        </div>
        <div class="please-wait">Please Wait...</div>
    </spinner>

    <div class="row">
        <div class="col-lg-4 form-group">
            <select class="form-control"
                    ng-options="s.supplierName for s in suppliers track by s.id"
                    ng-model="supplier">
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
                    <input ng-model="toDay" class="form-control" placeholder="To"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="fetchProductsList()" class="btn btn-primary" value="Search" />
    </div>

    <table class="table-sm table-striped">
        <thead>
        <tr>
            <th>Product ID</th>
            <th>Supplier Name</th>
            <th>Product Name</th>
            <th>Quantity of Sales</th>
            <th>Vat</th>
        </tr>
        </thead>
        <tbody ng-init="totalSales = 0"
               ng-init="totalCostPrice = 0"
               ng-init="totalEndQuantity = 0"
               ng-init="totalEndQuantityAmount = 0">
        <tr ng-repeat="product in products">
            <td>{{product.productId}}</td>
            <td>{{product.supplierName}}</td>
            <td>{{product.productName + ' - ' + product.faceValue}}</td>
            <td ng-init="$parent.totalSales = $parent.totalSales + product.sales">
                {{product.sales}}
            </td>
            <th>{{product.calculateVat ? 'Yes' : 'No'}}</th>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td></td>
            <td></td>
            <td>{{totalSales.toFixed(0)}}</td>
            <td></td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('productCostPriceController', function ($scope, $http, spinnerService) {
        $scope.fetchProductsList = function () {
            spinnerService.show('html5spinner');
            $scope.totalSales = 0;
            $scope.totalCostPrice = 0.0;
            $scope.totalEndQuantity = 0;
            $scope.totalEndQuantityAmount = 0.0;

            $http.get('/masteradmin/report/sales-return-report', {
                params: {
                    supplierId: $scope.supplier.id,
                    startDay: $scope.fromDay,
                    endDay: $scope.toDay
                }
            }).success(function (products) {
                $scope.products = products;
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

        $scope.fromDay = moment().format("YYYY-MM-DD");
        $scope.toDay = moment().format("YYYY-MM-DD");
    });
</script>