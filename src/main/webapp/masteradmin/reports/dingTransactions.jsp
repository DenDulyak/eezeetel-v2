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
        padding: 0 6px;
        vertical-align: bottom;
    }
</style>

<div class="container-fluid" ng-controller="dingTransactionsController">
    <h2>Ding Transactions</h2>

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

        <input type="button" ng-click="fetchTransactionsList()" class="btn-sm btn-primary" value="Search"/>
    </div>

    <div class="row">
        <div class="col-lg-4">
            <div class="radio-inline">
                <label>
                    <input type="radio" ng-model="transactionType" name="transactionType" value="0" ng-checked="true">
                    All
                </label>
            </div>
            <div class="radio-inline">
                <label>
                    <input type="radio" ng-model="transactionType" name="transactionType" value="1">
                    All except Jamaica Digicel
                </label>
            </div>
            <div class="radio-inline">
                <label>
                    <input type="radio" ng-model="transactionType" name="transactionType" value="2">
                    Only Jamaica Digicel
                </label>
            </div>
        </div>
    </div>

    <table class="table-sm table-striped table-custom">
        <thead>
        <tr>
            <th>Transaction ID</th>
            <th>Transaction Time</th>
            <th>Group</th>
            <th>Customer</th>
            <th>Balance Before</th>
            <th>Balance After</th>
            <th>Destination Country</th>
            <th>Product Sent</th>
            <th>Cost To Customer</th>
            <th>Cost To Agent</th>
            <th>Cost To Group</th>
            <th>Profit</th>
            <th>EezeeTel Balance</th>
        </tr>
        </thead>
        <tbody ng-init="totalCostToEezeeTel = 0"
               ng-init="totalCostToGroup = 0"
               ng-init="totalCostToAgent = 0"
               ng-init="totalCostToCustomer = 0"
               ng-init="totalProfit = 0"
               ng-init="totalProductSent = 0">
        <tr ng-repeat="transaction in transactions"
            class="{{(transaction.costToGroup - transaction.costToEezeeTel) < 0.0 ? 'danger' : ''}}">
            <td>{{transaction.transactionId}}</td>
            <td>{{transaction.transactionTime}}</td>
            <td>{{transaction.customer.group.name}}</td>
            <td>{{transaction.customer.companyName}}</td>
            <td>{{transaction.transactionBalance.balanceBeforeTransaction}}</td>
            <td>{{transaction.transactionBalance.balanceAfterTransaction}}</td>
            <td>{{transaction.destinationCountry}}</td>
            <td ng-init="$parent.totalProductSent = $parent.totalProductSent + transaction.productSent">
                {{transaction.productSent}}
            </td>
            <td ng-init="$parent.totalCostToCustomer = $parent.totalCostToCustomer + transaction.costToCustomer">
                {{transaction.costToCustomer}}
            </td>
            <td ng-init="$parent.totalCostToAgent = $parent.totalCostToAgent + transaction.costToAgent">
                {{transaction.costToAgent}}
            </td>
            <td ng-init="$parent.totalCostToGroup = $parent.totalCostToGroup + transaction.costToGroup">
                {{transaction.costToGroup}}
            </td>
            <td ng-init="$parent.totalProfit = $parent.totalProfit + (transaction.customer.group.id == 1 ? (transaction.costToCustomer - transaction.productSent) : (transaction.costToGroup - transaction.productSent))">
                {{(transaction.customer.group.id == 1 ? (transaction.costToCustomer - transaction.productSent) : (transaction.costToGroup - transaction.productSent)).toFixed(3)}}
            </td>
            <td>{{transaction.eezeeTelBalance}}</td>
        </tr>
        <tr class="info">
            <td colspan="7">Total</td>
            <td>{{totalProductSent.toFixed(2)}}</td>
            <td>{{totalCostToCustomer.toFixed(2)}}</td>
            <td>{{totalCostToAgent.toFixed(2)}}</td>
            <td>{{totalCostToGroup.toFixed(2)}}</td>
            <td>{{totalProfit.toFixed(2)}}</td>
            <td></td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('dingTransactionsController', function ($scope, $http, spinnerService) {
        $scope.fetchTransactionsList = function () {
            spinnerService.show('html5spinner');
            $http.get('/masteradmin/ding/transactions-by-day', {
                params: {
                    startDay: $scope.startDay,
                    endDay: $scope.endDay,
                    groupId: $scope.group.id,
                    type: $scope.transactionType
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
            $scope.totalProductSent = 0.0;
        };

        setDefaultValues();
        $scope.transactionType = 0;
        $scope.startDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.endDay = moment().subtract(1, "days").format("YYYY-MM-DD");
        $scope.minDate = moment("2013-01-01").toString();
        $scope.maxDate = new Date().toString();
    });
</script>
