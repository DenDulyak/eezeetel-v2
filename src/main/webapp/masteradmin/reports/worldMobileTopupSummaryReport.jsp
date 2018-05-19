<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid" ng-controller="worldMobileTopupSummaryController">
    <h2>World Mobile Topup Summary Report</h2>

    <div class="row">
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="startDay" class="form-control"/>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="endDay" class="form-control"/>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </datepicker>
        </div>
        <input type="button" ng-click="updateReport()" class="btn btn-primary" value="Run Report"/>
    </div>

    <div class="row">
        <div class="col-lg-4">
            <div class="radio">
                <label>
                    <input type="radio" ng-model="transactionType" name="transactionType" value="0" ng-checked="true">
                    Ding
                </label>
            </div>
            <div class="radio">
                <label>
                    <input type="radio" ng-model="transactionType" name="transactionType" value="1">
                    Mobitopup
                </label>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-4">
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Nr. of Sales</th>
                    <th>Sale Amount</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="transaction in transactions">
                    <td>{{transaction.transactions}}</td>
                    <td>{{transaction.amount}}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    app.controller('worldMobileTopupSummaryController', function ($scope, $http) {
        $scope.updateReport = function () {
            $http.get('/masteradmin/report/summary', {
                params: {
                    startDay: $scope.startDay,
                    endDay: $scope.endDay,
                    type: $scope.transactionType
                }
            }).success(function (transactions) {
                $scope.transactions = transactions;
            }).catch(function (err) {
                console.error(err);
            });
        };

        $scope.transactionType = 0;
        $scope.startDay = moment().format('YYYY-MM-DD');
        $scope.endDay = moment().format('YYYY-MM-DD');
    });
</script>
