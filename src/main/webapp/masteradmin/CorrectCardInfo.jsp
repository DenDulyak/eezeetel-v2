<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    td {
        padding: 0px !important;
    }
</style>

<div class="container-fluid" ng-controller="correctCardController">
    <div class="row">
        <div class="col-md-6">
            <form name="the_form" method="post" action="">
                <div class="form-group form-inline">
                    <label for="pin" class="control-label">Transaction ID to Correct :</label>
                    <input type="text" name="transaction_id" class="form-control">
                    <input type="button" name="display_button" class="btn" value="Display" onClick="DisplayTransaction()">
                </div>
                <div id="transaction_details"></div>
            </form>
        </div>

        <div class="col-md-6">
            <div class="form-group form-inline">
                <label for="pin" class="control-label">PIN: </label>
                <input id="pin" type="text" class="form-control" ng-model="pin" />
                <input type="button" class="btn" value="Display" ng-click="fetchTransactionList()"/>
            </div>

            <table class="table table-bordered" ng-show="showTable">
                <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Transaction Time</th>
                    <th>Customer</th>
                    <th>Product</th>
                    <th>Face Value</th>
                    <th>Quantity</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="transaction in transactions">
                    <td>{{transaction.transactionId}}</td>
                    <td>{{transaction.transactionTime}}</td>
                    <td>{{transaction.customer.companyName}}</td>
                    <td>{{transaction.product.name}}</td>
                    <td>{{transaction.product.faceValue}}</td>
                    <td>{{transaction.quantity}}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script language="javascript" src="${pageContext.request.contextPath}/js/validate.js"></script>
<script language="javascript">

    function DisplayTransaction() {
        var errString = "";

        if (IsNULL(document.the_form.transaction_id.value))
            errString += "\r\Transaction ID can not be empty.  Please enter a proper value";
        else {
            if (!CheckNumbers(document.the_form.transaction_id.value, ""))
                errString += "\r\Transaction ID can only be a number. Please enter a proper value";
        }

        if (errString == null || errString.length <= 0) {
            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text")
                    CheckDatabaseChars(document.the_form.elements[i]);

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get transaction details");
                return;
            }

            var element = document.getElementById('transaction_details');
            element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    element.innerHTML = httpObj.responseText;
                }
            };

            var url = "AJAX_GetTransactionDetailsToCorrect.jsp?transaction_id=" + document.the_form.transaction_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
        else
            alert(errString);
    }

    function Correct() {
        var sequence_id_list = "";

        document.the_form.action = "UpdateCorrectedCardInfo.jsp";
        document.the_form.submit();
    }

</script>

<script>
    app.controller('correctCardController', function ($scope, $http, spinnerService, toastr) {
        $scope.fetchTransactionList = function () {
            $scope.showTable = false;

            $http.get('/masteradmin/transaction/find-by-card-pin', {
                params: {
                    pin: $scope.pin
                }
            }).success(function (transactions, status) {
                if(status != 200) {
                    toastr.info(transactions);
                    return;
                }
                $scope.showTable = transactions.length > 0;
                $scope.transactions = transactions;
            }).catch(function (err) {
                console.error(err);
            });
        };
    });
</script>