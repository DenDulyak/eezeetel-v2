<style>
    .table-sm th {
        padding: 2px 6px;
    }
</style>

<div class="container-fluid" ng-controller="reportController">
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
        <div class="col-lg-4">
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

    <table class="table-sm table-striped">
        <thead>
        <tr>
            <th>Transaction ID</th>
            <th width="150px">Transaction Time</th>
            <%--<th>Group Balance Before</th>
            <th>Group Balance After</th>--%>
            <th>Customer Balance Before</th>
            <th>Customer Balance After</th>
            <th>Cost To Group</th>
            <th>Cost To Agent</th>
            <th>Cost To Customer</th>
            <th>Retail Price</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Quantity</th>
        </tr>
        </thead>
        <tbody ng-init="totalGroupProfit = 0"
               ng-init="totalAgentProfit = 0"
               ng-init="totalCustomerProfit = 0">
        <tr ng-repeat="transaction in transactions"
            class="{{transaction.productName == 'Mobile Topup' ? 'success' : ''}}">
            <td>{{transaction.transactionId}}</td>
            <td>{{transaction.transactionTime}}</td>
            <%--<td>{{transaction.groupBalanceBefore}}</td>
            <td>{{transaction.groupBalanceAfter}}</td>--%>
            <td>{{transaction.balanceBefore}}</td>
            <td>{{transaction.balanceAfter}}</td>
            <td ng-init="$parent.totalGroupProfit = $parent.totalGroupProfit + (transaction.costToAgent - transaction.costToGroup)">
                {{transaction.costToGroup}}
            </td>
            <td ng-init="$parent.totalAgentProfit = $parent.totalAgentProfit + (transaction.costToCustomer - transaction.costToAgent)">
                {{transaction.costToAgent}}
            </td>
            <td ng-init="$parent.totalCustomerProfit = $parent.totalCustomerProfit + (transaction.retailPrice - transaction.costToCustomer)">
                {{transaction.costToCustomer}}
            </td>
            <td>{{transaction.retailPrice}}</td>
            <td>{{transaction.customer}}</td>
            <td>{{transaction.productName}}</td>
            <td>{{transaction.quantity}}</td>
        </tr>
        <tr>
            <td colspan="2">Total Group Profit</td>
            <td>{{totalGroupProfit.toFixed(2)}}</td>
        </tr>
        <tr>
            <td colspan="2">Total Agents Profit</td>
            <td>{{totalAgentProfit.toFixed(2)}}</td>
        </tr>
        <tr>
            <td colspan="2">Total Customers Profit</td>
            <td>{{totalCustomerProfit.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

</div>
<script>
    app.controller('reportController', function ($scope, $http, spinnerService) {
        $scope.fetchTransactionsList = function (day) {
            spinnerService.show('html5spinner');

            $http.get('/admin/report/daily-customers-transactions', {params: {date: day}}).success(function (transactions) {
                $scope.transactions = transactions;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.$watch('day', function (value) {
            $scope.totalGroupProfit = 0.0;
            $scope.totalAgentProfit = 0.0;
            $scope.totalCustomerProfit = 0.0;
            $scope.fetchTransactionsList(value);
        });

        $scope.day = moment().format('YYYY-MM-D');
        $scope.minDate = moment("2013-01-01").toString();
        $scope.maxDate = new Date().toString();
    });
</script>
