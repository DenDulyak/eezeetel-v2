<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    .search-container {
        padding-bottom: 15px;
    }

    .table-custom {
        width: 100%;
        margin-top: 15px;
    }

    .table-custom th, td {
        padding: 0 6px !important;
        vertical-align: bottom;
    }
</style>

<div class="container-fluid" ng-controller="pinlessTransactionsController">
    <h2>Pinless Transactions</h2>

    <spinner name="html5spinner" ng-cloak="">
        <div class="overlay"></div>
        <div class="spinner">
            <div class="double-bounce1"></div>
            <div class="double-bounce2"></div>
        </div>
        <div class="please-wait">Please Wait...</div>
    </spinner>

    <div class="row search-container">
        <div class="col-lg-3 form-group-sm">
            <select class="form-control" ng-options="g.name for g in groups track by g.id"
                    ng-model="group">
            </select>
        </div>
        <div class="col-lg-2 form-group-sm">
            <datepicker date-format="yyyy-MM-dd" selector="form-control"
                        date-min-limit="{{minDate}}"
                        date-max-limit="{{maxDate}}">
                <div class="input-group">
                    <input ng-model="startDay" class="form-control"/>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2 form-group-sm">
            <datepicker date-format="yyyy-MM-dd" selector="form-control"
                        date-min-limit="{{minDate}}"
                        date-max-limit="{{maxDate}}">
                <div class="input-group">
                    <input ng-model="endDay" class="form-control"/>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="fetchTransactionsList()" class="btn btn-sm btn-primary" value="Search"/>
    </div>

    <table class="table table-sm table-striped table-custom">
        <thead>
        <tr>
            <th>Transaction ID</th>
            <th>Transaction Time</th>
            <th>Customer</th>
            <th>Balance Before</th>
            <th>Balance After</th>
            <th>Product Sent</th>
            <th>Retail Price</th>
            <th>Cost To Customer</th>
            <th>Cost To Agent</th>
            <th>Cost To Group</th>
            <th>Cost Price</th>
            <th>Profit</th>
            <th>EezeeTel Balance</th>
        </tr>
        </thead>
        <tbody ng-init="totalCostToEezeeTel = 0"
               ng-init="totalCostToGroup = 0"
               ng-init="totalCostToAgent = 0"
               ng-init="totalCostToCustomer = 0"
               ng-init="totalProfit = 0"
               ng-init="totalRetailPrice = 0">
        <tr ng-repeat="transaction in transactions"
            class="{{(transaction.costToGroup - transaction.costToEezeeTel) < 0.0 ? 'danger' : ''}}">
            <td>{{transaction.transactionId}}</td>
            <td>{{transaction.transactionTime}}</td>
            <td>{{transaction.customer.companyName}}</td>
            <td>{{transaction.transactionBalance.balanceBeforeTransaction}}</td>
            <td>{{transaction.transactionBalance.balanceAfterTransaction}}</td>
            <td>{{transaction.productSent + ' &#8372'}}</td>
            <td ng-init="$parent.totalRetailPrice = $parent.totalRetailPrice + transaction.retailPrice">
                {{transaction.retailPrice}}
            </td>
            <td ng-init="$parent.totalCostToCustomer = $parent.totalCostToCustomer + (transaction.price + transaction.eezeetelCommission + transaction.groupCommission + transaction.agentCommission)">
                {{(transaction.price + transaction.eezeetelCommission + transaction.groupCommission + transaction.agentCommission).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalCostToAgent = $parent.totalCostToAgent + (transaction.price + transaction.eezeetelCommission + transaction.groupCommission)">
                {{(transaction.price + transaction.eezeetelCommission + transaction.groupCommission).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalCostToGroup = $parent.totalCostToGroup + (transaction.price + transaction.eezeetelCommission)">
                {{(transaction.price + transaction.eezeetelCommission).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalCostToEezeeTel = $parent.totalCostToEezeeTel + transaction.price">
                {{transaction.price}}
            </td>
            <td ng-init="$parent.totalProfit = $parent.totalProfit + transaction.eezeetelCommission">
                {{transaction.eezeetelCommission}}
            </td>
            <td>{{transaction.balance}}</td>
        </tr>
        <tr class="info">
            <td colspan="6">Total</td>
            <td>{{totalRetailPrice.toFixed(2)}}</td>
            <td>{{totalCostToCustomer.toFixed(2)}}</td>
            <td>{{totalCostToAgent.toFixed(2)}}</td>
            <td>{{totalCostToGroup.toFixed(2)}}</td>
            <td>{{totalCostToEezeeTel.toFixed(2)}}</td>
            <td>{{totalProfit.toFixed(2)}}</td>
            <td></td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('pinlessTransactionsController', function ($scope, $http, spinnerService) {
        $scope.fetchTransactionsList = function () {
            spinnerService.show('html5spinner');
            $http.get('/masteradmin/pinless/find', {
                params: {
                    startDay: $scope.startDay,
                    endDay: $scope.endDay,
                    groupId: $scope.group.id
                }
            }).success(function (transactions) {
                setDefaultValues();
                $scope.transactions = transactions;
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
            $scope.totalCostToEezeeTel = 0.0;
            $scope.totalCostToGroup = 0.0;
            $scope.totalCostToAgent = 0.0;
            $scope.totalCostToCustomer = 0.0;
            $scope.totalProfit = 0.0;
            $scope.totalRetailPrice = 0.0;
        };

        setDefaultValues();
        $scope.transactionType = 0;
        $scope.startDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.endDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.minDate = moment("2013-01-01").toString();
        $scope.maxDate = new Date().toString();
    });
</script>
