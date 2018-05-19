<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }

    @media print {
        .no-print {
            display: none;
        }

        select {
            -webkit-appearance: none;
            -moz-appearance: none;
            text-indent: 1px;
            text-overflow: '';
        }

        tbody tr td {
            border: 1px solid #030303 !important;
            padding: 0 2px !important;
        }

        .info {
            font-weight: bold;
            font-size: larger !important;
        }

        @page {
            margin: 10px;
        }
    }
</style>

<div class="container-fluid" ng-controller="vatByMonthController">

    <spinner name="html5spinner" ng-cloak="" class="no-print">
        <div class="overlay"></div>
        <div class="spinner">
            <div class="double-bounce1"></div>
            <div class="double-bounce2"></div>
        </div>
        <div class="please-wait">Please Wait...</div>
    </spinner>

    <div class="row">
        <div class="col-lg-2 form-group no-print">
            <select class="form-control"
                    ng-options="g.name for g in groups track by g.id"
                    ng-model="group">
            </select>
        </div>
        <div class="col-lg-2 form-group">
            <select class="form-control"
                    ng-options="y.year for y in years track by y.year"
                    ng-model="year">
                <option style="display:none"></option>
            </select>
        </div>
        <div class="col-lg-2 form-group">
            <select class="form-control"
                    ng-options="m.name for m in months track by m.id"
                    ng-model="month">
                <option style="display:none"></option>
            </select>
        </div>

        <input type="button" ng-click="showTransactions()" class="btn btn-primary no-print" value="Generate"/>
        <a ng-href="{{downloadUrl}}" ng-click="updateUrl()" class="btn btn-link no-print">Download</a>
    </div>

    <table class="table printContainer">
        <tr>
            <th>Customer</th>
            <th>Net Sales</th>
            <th>Vat</th>
            <th>Total Sales</th>
        </tr>
        <tbody ng-init="totalNetSales = 0"
               ng-init="totalVat = 0"
               ng-init="totalAgentPrice = 0">
        <tr>
            <td>VAT Product</td>
            <td colspan="3"></td>
        </tr>
        <tr ng-repeat="transaction in vatTransactions" bgcolor="#D8F781">
            <td>{{transaction.customer}}</td>
            <td ng-init="$parent.totalNetSales = $parent.totalNetSales + transaction.netSales">
                {{transaction.netSales}}
            </td>
            <td ng-init="$parent.totalVat = $parent.totalVat + transaction.vat">
                {{transaction.vat}}
            </td>
            <td ng-init="$parent.totalAgentPrice = $parent.totalAgentPrice + transaction.totalSales">
                {{transaction.totalSales}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalNetSales.toFixed(2)}}</td>
            <td>{{totalVat.toFixed(2)}}</td>
            <td>{{totalAgentPrice.toFixed(2)}}</td>
        </tr>
        </tbody>

        <tbody ng-init="totalNetSalesNo = 0"
               ng-init="totalVatNo = 0"
               ng-init="totalAgentPriceNo = 0">
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td>Non VAT Product</td>
            <td colspan="3"></td>
        </tr>
        <tr ng-repeat="transaction in noVatTransactions" bgcolor="#58FAAC">
            <td>{{transaction.customer}}</td>
            <td ng-init="$parent.totalNetSalesNo = $parent.totalNetSalesNo + transaction.netSales">
                {{transaction.netSales}}
            </td>
            <td>NIL</td>
            <td ng-init="$parent.totalAgentPriceNo = $parent.totalAgentPriceNo + transaction.totalSales">
                {{transaction.totalSales}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalAgentPriceNo.toFixed(2)}}</td>
            <td>{{totalVatNo.toFixed(2)}}</td>
            <td>{{totalAgentPriceNo.toFixed(2)}}</td>
        </tr>
        </tbody>

        <tbody ng-init="totalNetSalesLocal = 0"
               ng-init="totalVatLocal = 0"
               ng-init="totalAgentPriceLocal = 0">
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td>Local Product</td>
            <td colspan="3"></td>
        </tr>
        <tr ng-repeat="transaction in localTransactions" bgcolor="#00BFFF">
            <td>{{transaction.customer}}</td>
            <td ng-init="$parent.totalNetSalesLocal = $parent.totalNetSalesLocal + transaction.netSales">
                {{transaction.netSales}}
            </td>
            <td>NIL</td>
            <td ng-init="$parent.totalAgentPriceLocal = $parent.totalAgentPriceLocal + transaction.totalSales">
                {{transaction.totalSales}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalNetSalesLocal.toFixed(2)}}</td>
            <td>{{totalVatLocal.toFixed(2)}}</td>
            <td>{{totalAgentPriceLocal.toFixed(2)}}</td>
        </tr>
        </tbody>

        <tbody ng-init="totalNetSalesDing = 0"
               ng-init="totalVatDing = 0"
               ng-init="totalAgentPriceDing = 0">
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td>World Mobile Topup</td>
            <td colspan="3"></td>
        </tr>
        <tr ng-repeat="transaction in dingTransactions">
            <td>{{transaction.customer}}</td>
            <td ng-init="$parent.totalNetSalesDing = $parent.totalNetSalesDing + transaction.netSales">
                {{transaction.netSales}}
            </td>
            <td>NIL</td>
            <td ng-init="$parent.totalAgentPriceDing = $parent.totalAgentPriceDing + transaction.totalSales">
                {{transaction.totalSales}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalNetSalesDing.toFixed(2)}}</td>
            <td>{{totalVatDing.toFixed(2)}}</td>
            <td>{{totalAgentPriceDing.toFixed(2)}}</td>
        </tr>
        </tbody>

        <tbody ng-init="totalNetSalesMobileUnlocking = 0"
               ng-init="totalVatMobileUnlocking = 0"
               ng-init="totalAgentPriceMobileUnlocking = 0">
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td>Mobile Unlocking</td>
            <td colspan="3"></td>
        </tr>
        <tr ng-repeat="transaction in mobileUnlockingTransactions">
            <td>{{transaction.customer}}</td>
            <td ng-init="$parent.totalNetSalesMobileUnlocking = $parent.totalNetSalesMobileUnlocking + transaction.netSales">
                {{transaction.netSales}}
            </td>
            <td>NIL</td>
            <td ng-init="$parent.totalAgentPriceMobileUnlocking = $parent.totalAgentPriceMobileUnlocking + transaction.totalSales">
                {{transaction.totalSales}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalNetSalesMobileUnlocking.toFixed(2)}}</td>
            <td>{{totalVatMobileUnlocking.toFixed(2)}}</td>
            <td>{{totalAgentPriceMobileUnlocking.toFixed(2)}}</td>
        </tr>
        </tbody>

        <tbody ng-init="totalNetSalesPinless = 0"
               ng-init="totalVatPinless = 0"
               ng-init="totalAgentPricePinless = 0">
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td>Pinless</td>
            <td colspan="3"></td>
        </tr>
        <tr ng-repeat="transaction in pinlessTransactions">
            <td>{{transaction.customer}}</td>
            <td ng-init="$parent.totalNetSalesPinless = $parent.totalNetSalesPinless + transaction.netSales">
                {{transaction.netSales}}
            </td>
            <td>NIL</td>
            <td ng-init="$parent.totalAgentPricePinless = $parent.totalAgentPricePinless + transaction.totalSales">
                {{transaction.totalSales}}
            </td>
        </tr>
        <tr class="info">
            <td>Totals</td>
            <td>{{totalNetSalesPinless.toFixed(2)}}</td>
            <td>{{totalVatPinless.toFixed(2)}}</td>
            <td>{{totalAgentPricePinless.toFixed(2)}}</td>
        </tr>
        </tbody>

        <tbody ng-init="totalNetSalesAll = 0"
               ng-init="totalVatAll = 0"
               ng-init="totalAgentPriceAll = 0">
        <tr>
            <td><br/></td>
        </tr>
        <tr class="info">
            <td>Grand Totals</td>
            <td>{{totalNetSalesAll.toFixed(2)}}</td>
            <td>{{totalVatAll.toFixed(2)}}</td>
            <td>{{totalAgentPriceAll.toFixed(2)}}</td>
        </tr>
        </tbody>
    </table>

</div>

<script>
    app.controller('vatByMonthController', function ($scope, $http, spinnerService) {
        $scope.years = [{year: 2018}, {year: 2017}, {year: 2016}, {year: 2015}, {year: 2014}, {year: 2013}, {year: 2012}, {year: 2011}, {year: 2010}];
        $scope.year = $scope.years[0];

        $scope.months = [{id: 1, name: 'January'},
            {id: 2, name: 'February'},
            {id: 3, name: 'March'},
            {id: 4, name: 'April'},
            {id: 5, name: 'May'},
            {id: 6, name: 'June'},
            {id: 7, name: 'July'},
            {id: 8, name: 'August'},
            {id: 9, name: 'September'},
            {id: 10, name: 'October'},
            {id: 11, name: 'November'},
            {id: 12, name: 'December'}];
        $scope.month = $scope.months[0];

        $scope.fetchTransactionsList = function () {
            spinnerService.show('html5spinner');

            $scope.totalNetSales = 0.0;
            $scope.totalVat = 0.0;
            $scope.totalAgentPrice = 0.0;

            $scope.totalNetSalesNo = 0.0;
            $scope.totalVatNo = 0.0;
            $scope.totalAgentPriceNo = 0.0;

            $scope.totalNetSalesLocal = 0.0;
            $scope.totalVatLocal = 0.0;
            $scope.totalAgentPriceLocal = 0.0;

            $scope.totalNetSalesDing = 0.0;
            $scope.totalVatDing = 0.0;
            $scope.totalAgentPriceDing = 0.0;

            $scope.totalNetSalesMobileUnlocking = 0.0;
            $scope.totalVatMobileUnlocking = 0.0;
            $scope.totalAgentPriceMobileUnlocking = 0.0;

            $scope.totalNetSalesPinless = 0.0;
            $scope.totalVatPinless = 0.0;
            $scope.totalAgentPricePinless = 0.0;

            $http.get('/masteradmin/report/get-vat-by-month', {
                params: {
                    type: 0,
                    groupId: $scope.group.id,
                    year: $scope.year.year,
                    month: $scope.month.id
                }
            }).success(function (transactions) {
                var vatTransactions = [];
                var noVatTransactions = [];
                var localTransactions = [];
                var dingTransactions = [];
                var mobileUnlockingTransactions = [];
                var pinlessTransactions = [];

                transactions.forEach(function (entry) {
                    if (entry.saleType == 0) {
                        vatTransactions.push(entry);
                    } else if (entry.saleType == 1) {
                        noVatTransactions.push(entry);
                    } else if (entry.saleType == 2) {
                        localTransactions.push(entry);
                    } else if (entry.saleType == 3) {
                        dingTransactions.push(entry);
                    } else if (entry.saleType == 4) {
                        mobileUnlockingTransactions.push(entry);
                    } else if (entry.saleType == 5) {
                        pinlessTransactions.push(entry);
                    }
                });

                transactions.forEach(function (entry) {
                    $scope.totalNetSalesAll += entry.netSales;
                    $scope.totalVatAll += entry.vat;
                    $scope.totalAgentPriceAll += entry.totalSales;
                });

                $scope.vatTransactions = vatTransactions;
                $scope.noVatTransactions = noVatTransactions;
                $scope.localTransactions = localTransactions;
                $scope.dingTransactions = dingTransactions;
                $scope.mobileUnlockingTransactions = mobileUnlockingTransactions;
                $scope.pinlessTransactions = pinlessTransactions;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.showTransactions = function () {
            $scope.totalNetSalesAll = 0.0;
            $scope.totalVatAll = 0.0;
            $scope.totalAgentPriceAll = 0.0;

            $scope.fetchTransactionsList();
        };

        $http.get('/masteradmin/group/find-all').success(function (groups) {
            //groups.unshift(JSON.parse('{"id":"0", "name":"All"}'));
            $scope.groups = groups;
            $scope.group = $scope.groups[0];
        }).catch(function (err) {
            console.error(err);
        });

        $scope.updateUrl = function () {
            $scope.downloadUrl = '/masteradmin/report/export-vat-by-month' +
                    '?groupId=' + $scope.group.id +
                    '&year=' + $scope.year.year +
                    '&month=' + $scope.month.id;
        };
    });
</script>