<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }
</style>

<div class="container-fluid" ng-controller="allTransactionsController">
    <h2>All Transactions Report</h2>

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
            <select class="form-control" ng-options="g.name for g in groups track by g.id"
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
                    <input ng-model="toDay" class="form-control" placeholder="To"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="fetchProductsList()" class="btn btn-primary" value="Search" />
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Product</th>
            <th>Transactions</th>
            <th>Total cards sold</th>
            <th>Total cost price</th>
            <th>Total sale price</th>
        </tr>
        </thead>
        <tbody ng-init="totalTransactions = 0"
               ng-init="totalCards = 0"
               ng-init="totalCost = 0"
               ng-init="totalSale = 0">
            <tr ng-repeat="product in products">
                <td>{{product.productName + " - " + product.faceValue}}</td>
                <td ng-init="$parent.totalTransactions = $parent.totalTransactions + product.transactions">
                    {{product.transactions}}
                </td>
                <td ng-init="$parent.totalCards = $parent.totalCards + product.totalCardsSold">
                    {{product.totalCardsSold}}
                </td>
                <td ng-init="$parent.totalCost = $parent.totalCost + product.totalCostPrice">
                    {{product.totalCostPrice}}
                </td>
                <td ng-init="$parent.totalSale = $parent.totalSale + product.totalSalePrice">
                    {{product.totalSalePrice}}
                </td>
            </tr>
            <tr class="info">
                <td>Total</td>
                <td>{{totalTransactions.toFixed(0)}}</td>
                <td>{{totalCards.toFixed(0)}}</td>
                <td>{{totalCost.toFixed(2)}}</td>
                <td>{{totalSale.toFixed(2)}}</td>
            </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('allTransactionsController', function ($scope, $http, spinnerService) {
        $scope.fetchProductsList = function () {
            spinnerService.show('html5spinner');

            $http.get('/masteradmin/report/product-summary', {
                params: {
                    groupId: $scope.group.id,
                    startDay: $scope.fromDay,
                    endDay: $scope.toDay
                }
            }).success(function (products) {
                setDefaultValues();
                $scope.products = products;
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
            $scope.totalTransactions = 0;
            $scope.totalCards = 0;
            $scope.totalCost = 0.00;
            $scope.totalSale = 0.00;
        };

        setDefaultValues();
        $scope.fromDay = moment().format("YYYY-MM-DD");
        $scope.toDay = moment().add(1, 'days').format("YYYY-MM-DD");
    });
</script>