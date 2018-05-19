<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }
</style>

<div class="container-fluid" ng-controller="salesByAgentController">
    <h2>Sales By Agent Report</h2>

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

    <table class="table table-striped header-fixed">
        <thead>
        <tr>
            <th>Product Name</th>
            <th>Sales</th>
            <th>EEZEE tel Sales</th>
            <th>GSM Sales</th>
            <th>KAS Global Sales</th>
            <th>KuPay Sales</th>
            <th>Fast tel Sales</th>
        </tr>
        </thead>
        <tbody ng-init="totalEezeetelSales = 0"
               ng-init="totalGsmSales = 0"
               ng-init="totalKasGlobalSales = 0"
               ng-init="totalKupaySales = 0"
               ng-init="totalFastTelSales = 0">
        <tr ng-repeat="product in products">
            <td>{{product.productName + ' - ' + product.faceValue}}</td>
            <td>{{product.sales}}</td>
            <td ng-init="$parent.totalEezeetelSales = $parent.totalEezeetelSales + product.eezeetelSales">
                {{product.eezeetelSales}}
            </td>
            <td ng-init="$parent.totalGsmSales = $parent.totalGsmSales + product.gsmSales">
                {{product.gsmSales}}
            </td>
            <td ng-init="$parent.totalKasGlobalSales = $parent.totalKasGlobalSales + product.kasGlobalSales">
                {{product.kasGlobalSales}}
            </td>
            <td ng-init="$parent.totalKupaySales = $parent.totalKupaySales + product.kupaySales">
                {{product.kupaySales}}
            </td>
            <td ng-init="$parent.totalFastTelSales = $parent.totalFastTelSales + product.fastTelSales">
                {{product.fastTelSales}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{(totalEezeetelSales + totalGsmSales + totalKasGlobalSales + totalKupaySales + totalFastTelSales).toFixed(0)}}</td>
            <td>{{totalEezeetelSales.toFixed(0)}}</td>
            <td>{{totalGsmSales.toFixed(0)}}</td>
            <td>{{totalKasGlobalSales.toFixed(0)}}</td>
            <td>{{totalKupaySales.toFixed(0)}}</td>
            <td>{{totalFastTelSales.toFixed(0)}}</td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('salesByAgentController', function ($scope, $http, spinnerService) {

        $scope.fetchTableData = function () {
            spinnerService.show('html5spinner');

            $scope.totalEezeetelSales = 0;
            $scope.totalGsmSales = 0;
            $scope.totalKasGlobalSales = 0;
            $scope.totalKupaySales = 0;
            $scope.totalFastTelSales = 0;

            $http.get('/masteradmin/report/product-sales-by-group', {
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
            $scope.suppliers = suppliers;
            $scope.supplier = $scope.suppliers[0];
        }).catch(function (err) {
            console.error(err);
        });

        $scope.fromDay = moment().format("YYYY-MM-DD");
        $scope.toDay = moment().format("YYYY-MM-DD");
    });
</script>