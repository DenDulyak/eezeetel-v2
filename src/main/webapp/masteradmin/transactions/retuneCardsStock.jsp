<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0 !important;
    }
</style>

<div class="container-fluid" ng-controller="retuneCardsStockController">

    <spinner name="html5spinner" ng-cloak="">
        <div class="overlay"></div>
        <div class="spinner">
            <div class="double-bounce1"></div>
            <div class="double-bounce2"></div>
        </div>
        <div class="please-wait">Please Wait...</div>
    </spinner>

    <div class="row">
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="start" class="form-control"/>
                           <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                           </span>
                </div>
            </datepicker>
        </div>
        <div class="col-lg-2 form-group">
            <datepicker date-format="yyyy-MM-dd" selector="form-control">
                <div class="input-group">
                    <input ng-model="end" class="form-control" placeholder="To"/>
                           <span class="input-group-addon">
                               <span class="glyphicon glyphicon-calendar"></span>
                           </span>
                </div>
            </datepicker>
        </div>

        <input type="button" ng-click="fetchBatchsList()" class="btn btn-primary" value="Search"/>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Sequence ID</th>
            <th>Batch ID</th>
            <th>Supplier</th>
            <th>Product</th>
            <th>Quantity</th>
            <th>Available Quantity</th>
            <th>Sales</th>
            <th>Cost Price</th>
            <th>Start Batch Number</th>
            <th>End Batch Number</th>
            <th>Batch Arrival Date</th>
        </tr>
        </thead>
        <tbody>
        <tr class="info">
            <td colspan="2">VAT Batch</td>
            <td colspan="9"></td>
        </tr>
        <tr ng-repeat="batch in vatBatchs">
            <td>{{batch.sequenceId}}</td>
            <td>{{batch.batchId}}</td>
            <td>{{batch.supplier.name}}</td>
            <td>{{batch.product.name}}</td>
            <td>{{batch.quantity}}</td>
            <td>{{batch.availableQuantity}}</td>
            <td>{{batch.quantity - batch.availableQuantity}}</td>
            <td>{{batch.product.costPrice}}</td>
            <td>{{batch.startBatchNumber}}</td>
            <td>{{batch.endBatchNumber}}</td>
            <td>{{batch.arrivalDate}}</td>
        </tr>
        </tbody>
        <tbody>
        <tr class="info">
            <td colspan="2">Non VAT Batch</td>
            <td colspan="9"></td>
        </tr>
        <tr ng-repeat="batch in nonVatBatchs">
            <td>{{batch.sequenceId}}</td>
            <td>{{batch.batchId}}</td>
            <td>{{batch.supplier.name}}</td>
            <td>{{batch.product.name}}</td>
            <td>{{batch.quantity}}</td>
            <td>{{batch.availableQuantity}}</td>
            <td>{{batch.quantity - batch.availableQuantity}}</td>
            <td>{{batch.product.costPrice}}</td>
            <td>{{batch.startBatchNumber}}</td>
            <td>{{batch.endBatchNumber}}</td>
            <td>{{batch.arrivalDate}}</td>
        </tr>
        </tbody>
        <tbody>
        <tr class="info">
            <td colspan="2">Local And 3R Batch</td>
            <td colspan="9"></td>
        </tr>
        <tr ng-repeat="batch in localBatchs">
            <td>{{batch.sequenceId}}</td>
            <td>{{batch.batchId}}</td>
            <td>{{batch.supplier.name}}</td>
            <td>{{batch.product.name}}</td>
            <td>{{batch.quantity}}</td>
            <td>{{batch.availableQuantity}}</td>
            <td>{{batch.quantity - batch.availableQuantity}}</td>
            <td>{{batch.product.costPrice}}</td>
            <td>{{batch.startBatchNumber}}</td>
            <td>{{batch.endBatchNumber}}</td>
            <td>{{batch.arrivalDate}}</td>
        </tr>
        </tbody>
    </table>

</div>

<script>
    app.controller('retuneCardsStockController', function ($scope, $http, spinnerService) {
        $scope.fetchBatchsList = function () {
            spinnerService.show('html5spinner');

            $http.get('/masteradmin/batch/retune-cards-stock', {
                params: {
                    start: $scope.start,
                    end: $scope.end
                }
            }).success(function (batchs) {
                var vatBatchs = [];
                var nonVatBatchs = [];
                var localBatchs = [];

                batchs.forEach(function (entry) {
                    if (entry.supplier.supplierType.id == 9 || entry.supplier.supplierType.id == 12) {
                        nonVatBatchs.push(entry);
                    } else if (entry.supplier.supplierType.id == 10 || entry.supplier.supplierType.id == 16) {
                        localBatchs.push(entry);
                    } else {
                        vatBatchs.push(entry);
                    }
                });

                $scope.vatBatchs = vatBatchs;
                $scope.nonVatBatchs = nonVatBatchs;
                $scope.localBatchs = localBatchs;
            }).catch(function (err) {
                console.error(err);
            }).finally(function () {
                spinnerService.hide('html5spinner');
            });
        };

        $scope.start = moment().format('YYYY-MM-DD');
        $scope.end = moment().format('YYYY-MM-DD');
    });
</script>