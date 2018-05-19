<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid" ng-controller="dailyCustomersTransactionsController">
    <h2>Daily Customers Transactions</h2>

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
    </div>

    <div class="row">
        <div class="col-lg-4 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control"
                        date-min-limit="{{minDate}}" date-max-limit="{{maxDate}}">
                <div class="input-group">
                    <input ng-model="day" class="form-control" placeholder="Choose a day"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12 form-group">
            <label class="radio-inline">
                <input type="radio" ng-model="transactionType" name="transactionType"
                       value="all" ng-checked="true">
                All
            </label>
            <label class="radio-inline">
                <input type="radio" ng-model="transactionType" name="transactionType"
                       value="card">
                Card Transactions
            </label>
            <label class="radio-inline">
                <input type="radio" ng-model="transactionType" name="transactionType"
                       value="ding">
                Ding Transactions
            </label>
            <label class="radio-inline">
                <input type="radio" ng-model="transactionType" name="transactionType"
                       value="mobitopup">
                Mobitopup Transactions
            </label>
            <label class="radio-inline">
                <input type="radio" ng-model="transactionType" name="transactionType"
                       value="pinless">
                Pinless Transactions
            </label>
            <label class="radio-inline">
                <input type="radio" ng-model="transactionType" name="transactionType"
                       value="mobileUnlockin">
                Mobile Unlocking Orders
            </label>
        </div>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Transaction ID</th>
            <th>Transaction Time</th>
            <th>Customer Balance Before</th>
            <th>Customer Balance After</th>
            <th>Purchase Price</th>
            <th>EezeeTel Profit</th>
            <th>Group Profit</th>
            <th>Agent Profit</th>
            <th>Customer Profit</th>
            <th>Retail Price</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Quantity</th>
        </tr>
        </thead>
        <tbody ng-init="totalCostToEezeeTel = 0"
               ng-init="totalCostToGroup = 0"
               ng-init="totalCostToAgent = 0"
               ng-init="totalCostToCustomer = 0"
               ng-init="totalEezeetelProfit = 0"
               ng-init="totalGroupProfit = 0"
               ng-init="totalAgentProfit = 0"
               ng-init="totalCustomerProfit = 0">
        <tr ng-repeat="transaction in transactions"
            class="{{transaction.productName == 'Mobile Topup' ? 'success' : ''}}">
            <td ng-init="$parent.totalCostToEezeeTel = $parent.totalCostToEezeeTel + transaction.purchasePrice">
                {{transaction.transactionId}}
            </td>
            <td ng-init="$parent.totalCostToGroup = $parent.totalCostToGroup + transaction.costToGroup">
                {{transaction.transactionTime}}
            </td>
            <td ng-init="$parent.totalCostToAgent = $parent.totalCostToAgent + transaction.costToAgent">
                {{transaction.balanceBefore}}
            </td>
            <td ng-init="$parent.totalCostToCustomer = $parent.totalCostToCustomer + transaction.costToCustomer">
                {{transaction.balanceAfter}}
            </td>
            <td ng-init="$parent.totalEezeetelProfit = $parent.totalEezeetelProfit + (transaction.costToGroup - transaction.purchasePrice)">
                {{transaction.purchasePrice}}
            </td>
            <td>{{(transaction.costToGroup - transaction.purchasePrice).toFixed(2)}}</td>
            <td ng-init="$parent.totalGroupProfit = $parent.totalGroupProfit + (transaction.costToAgent - transaction.costToGroup)">
                {{(transaction.costToAgent - transaction.costToGroup).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalAgentProfit = $parent.totalAgentProfit + (transaction.costToCustomer - transaction.costToAgent)">
                {{(transaction.costToCustomer - transaction.costToAgent).toFixed(2)}}
            </td>
            <td ng-init="$parent.totalCustomerProfit = $parent.totalCustomerProfit + (transaction.retailPrice - transaction.costToCustomer)">
                {{(transaction.retailPrice - transaction.costToCustomer).toFixed(2)}}
            </td>
            <td>{{transaction.retailPrice}}</td>
            <td>{{transaction.customer}}</td>
            <td>{{transaction.productName}}</td>
            <td>{{transaction.quantity}}</td>
        </tr>
        <tr>
            <td colspan="3">Total Purchase Price</td>
            <td>{{totalCostToEezeeTel.toFixed(2)}}</td>
            <td></td>
            <td></td>
            <td colspan="3">Total EezeeTel Profit</td>
            <td>{{totalEezeetelProfit.toFixed(2)}}</td>
        </tr>
        <tr>
            <td colspan="3">Total Cost To Group</td>
            <td>{{totalCostToGroup.toFixed(2)}}</td>
            <td></td>
            <td></td>
            <td colspan="3">Total Group Profit</td>
            <td>{{totalGroupProfit.toFixed(2)}}</td>
        </tr>
        <tr>
            <td colspan="3">Total Cost To Agents</td>
            <td>{{totalCostToAgent.toFixed(2)}}</td>
            <td></td>
            <td></td>
            <td colspan="3">Total Agents Profit</td>
            <td>{{totalAgentProfit.toFixed(2)}}</td>
        </tr>
        <tr>
            <td colspan="3">Total Cost To Customers</td>
            <td>{{totalCostToCustomer.toFixed(2)}}</td>
            <td></td>
            <td></td>
            <td colspan="3">Total Customers Profit</td>
            <td>{{totalCustomerProfit.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    app.controller('dailyCustomersTransactionsController', function ($scope, $http, spinnerService) {
        $scope.fetchTransactionsList = function (day, groupId, type) {
            if (day == undefined) {
                return;
            }

            spinnerService.show('html5spinner');

            $http.get('/masteradmin/report/daily-group-transactions', {
                params: {
                    date: day,
                    groupId: groupId,
                    type: type
                }
            }).success(function (transactions) {
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

        $scope.$watch('day', function (value) {
            if ($scope.group == undefined) {
                return;
            }

            setDefaultValues();
            $scope.fetchTransactionsList(value, $scope.group.id, $scope.transactionType);
        });

        $scope.$watch('group', function (value) {
            if (value == undefined || $scope.day == undefined) {
                return;
            }

            setDefaultValues();
            $scope.fetchTransactionsList($scope.day, value.id, $scope.transactionType);
        });

        $scope.$watch('transactionType', function (value) {
            if ($scope.group == undefined || $scope.day == undefined) {
                return;
            }

            setDefaultValues();
            $scope.fetchTransactionsList($scope.day, $scope.group.id, value);
        });

        var setDefaultValues = function () {
            $scope.totalCostToEezeeTel = 0.0;
            $scope.totalCostToGroup = 0.0;
            $scope.totalCostToAgent = 0.0;
            $scope.totalCostToCustomer = 0.0;
            $scope.totalEezeetelProfit = 0.0;
            $scope.totalGroupProfit = 0.0;
            $scope.totalAgentProfit = 0.0;
            $scope.totalCustomerProfit = 0.0;
        };

        //$scope.day = moment().format('YYYY-MM-D');
        $scope.minDate = moment("2010-05-31").toString();
        $scope.maxDate = new Date().toString();
        $scope.transactionType = 'all';
    });
</script>