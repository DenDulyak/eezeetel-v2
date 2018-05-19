<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid navContainer">
    <div class="row col-sm-12 form-inline">
        <p class="navText">Customer ID : ${customerInfo.id}</p>
        <p class="navText customerBalance">Balance : &pound${customerBalance}</p>
        <p class="navText"><span class="glyphicon glyphicon-phone-alt"></span> Customer Service:</p>
        <p class="navText">+44 ${customerInfo.group.groupPhone}</p>
        <p class="navText">+44 ${customerInfo.group.groupMobile}</p>
        <a class="navLink pull-right" href="/logout"><span class="glyphicon glyphicon-log-out"></span>Signout</a>
    </div>
</div>
<nav class="navbar navbar-default" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
        </div>
        <div class="collapse navbar-collapse" id="navbar-collapse">
            <ul class="nav navbar-nav navbar-left">
                <li><a class="navLink" href="/customer/products"><span class="btn btn-default">Home</span></a></li>
                <li><a class="navLink" href="/customer/request-credit"><span class="btn btn-default">Request Topup</span></a></li>
                <li><a class="navLink" href="/customer/transactions"><span class="btn btn-default">Transactions</span></a></li>
                <li><a class="navLink" href="/customer/transactions-report"><span class="btn btn-default">Transaction Report</span></a></li>
                <%--d<li><a class="navLink" href="/customer/transactions-report"><span class="btn btn-default">Daily Transaction Report</span></a></li>--%>
                <li><a class="navLink" href="/customer/credit-report"><span class="btn btn-default">Credit Report</span></a></li>
                <li><a class="navLink" href="/customer/monthly-invoice"><span class="btn btn-default">Monthly Sales Report</span></a></li>
                <li><a class="navLink" href="/customer/sim-commision-report"><span class="btn btn-default">SIM Commission Report</span></a></li>
                <li><a class="navLink" href="/customer/mobile-unlocking-orders"><span class="btn btn-default">Orders</span></a></li>
                <c:if test="${sessionScope.GROUP_ID eq 1}">
                    <li><a class="navLink" href="/customer/pinless-commision-report"><span class="btn btn-default">Pinless Commision Report</span></a></li>
                </c:if>
                <li><a class="navLink" href="/customer/change-password"><span class="btn btn-default">Change Password</span></a></li>
            </ul>
        </div>
    </div>
</nav>
