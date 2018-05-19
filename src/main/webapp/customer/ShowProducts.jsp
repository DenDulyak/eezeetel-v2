<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/imports.jsp" %>

<%
    DingMain dingser = new DingMain(1, null);

    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/libs/sweetalert2.min.css">
    <c:import url="../common/libs.jsp"/>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0"/>
    <link rel="stylesheet" href="/css/${style}" type="text/css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <script src="${pageContext.request.contextPath}/js/customer/customer.js"></script>
    <script src="${pageContext.request.contextPath}/js/customer/mobileUnlocking.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/jquery.pleaseWait.js"></script>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        var theContext = "";
        var featureId = ${customerInfo.customerFeatureId};
        var isBulkUpload = ${not empty BULK_UPLOAD};
        var isCreditLimit = ${not empty CREDIT_LIMIT};
        var printByConfirm = ${not empty PRINT_BY_CONFIRM};
        var showMessage = ${not empty message};
        $(function () {
            if (showMessage) {
                $('#messageModal').modal('show');
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/CallingCardsInterface.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/WorldMobileInterface.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/WorldMobileInterface1.js" type="text/javascript"></script>
    <c:if test="${not empty SIMS}">
        <script src="${pageContext.request.contextPath}/js/SimCardsInterface.js" type="text/javascript"></script>
    </c:if>
    <script src="${pageContext.request.contextPath}/js/libs/sweetalert2.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/jquery.blockUI.js"></script>
    <title>Show Products</title>
</head>
<body>
<div class="no-print">
    <header>
        <c:import url="headerNavbar.jsp"/>
    </header>
<%--    <marquee behavior="scroll" direction="left" width="85%" height="20" scrolldelay="100" class="SCROLLTEXT">
        ${message}
    </marquee>--%>
    <ul class="list-inline text-center">
        <c:if test="${not empty MOBILE_VOUCHERS}">
            <li><a class="btn productsButton" onClick="update_suppliers('10,12', 0)">Mobile Vouchers</a></li>
        </c:if>
        <c:if test="${not empty CALLING_CARDS}">
            <li><a class="btn productsButton" onClick="update_suppliers('8,9', 0)">Calling Cards</a></li>
        </c:if>
        <c:if test="${not empty DING || not empty MOBIPOPUP}">
            <li>
                <a class="btn productsButton" onClick="list_services_1('<%=DingMain.Ding_SupplierID%>')">
                    £ World Mobile Topup
                </a>
            </li>
        </c:if>
        <c:if test="${not empty LOCAL_MOBILE_VOUCHERS}">
            <li><a class="btn productsButton" onClick="update_suppliers('16', 0)">ISP Provider</a></li>
        </c:if>
        <c:if test="${not empty PINLESS_CALLING_CARDS}">
            <%--<li><a class="btn productsButton" onClick="update_suppliers('18')">Pinless Calling Cards</a></li>--%>
        </c:if>
        <c:if test="${not empty SIMS}">
            <li><a class="btn productsButton" onClick="update_suppliers('17', 1)">SIM Cards</a></li>
        </c:if>
        <c:if test="${not empty MOBILE_UNLOCKING}">
            <li><a class="btn productsButton mobileUnlockingButton">Mobile Unlocking</a></li>
        </c:if>
        <c:if test="${not empty EEZEETEL_PINLESS}">
            <li><a class="btn productsButton eezeetelPinless" onClick="eezeetel_pinless()">EezeeTel Pinless</a></li>
        </c:if>
    </ul>
    <br>
    <br>

    <div id="the_suppliers_list"></div>
    <from id="the_form" name="the_form">
        <div id="product_list_field" class="container-fluid">
            <c:if test="${not empty callingCardPricesList}">
                <div style="margin: auto; width: 50%;">
                    <div style="display: block; margin: auto; width: 50%">
                        <a href="https://play.google.com/store/apps/details?id=com.eezeeTel.main" target="_blank">
                            <img width="150" height="60" src="${pageContext.request.contextPath}/images/icons/google_play_icon.png">
                        </a>
                        <a href="https://itunes.apple.com/ua/app/eezeetel/id1040109934?mt=8&ign-mpt=uo%3D4" target="_blank">
                            <img width="150" height="50" src="${pageContext.request.contextPath}/images/icons/app_store_icon.png">
                        </a>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 col-md-offset-4 text-center">
                        <h2>${callingCardPriceTitle.text}</h2>
                    </div>
                </div>
                <c:set var="first" value="true"></c:set>
                <c:forEach items="${callingCardPricesList}" var="callingCardPrices">
                    <div class="col-md-4
                <c:if test="${fn:length(callingCardPricesList) eq 1}"> col-md-offset-4 </c:if>
                <c:if test="${fn:length(callingCardPricesList) eq 2 && first}">
                 <c:set var="first" value="false"></c:set>
                 col-md-offset-2
                </c:if>
                ">
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>Country</th>
                                <th>Landline P/Min</th>
                                <th>Mobile P/Min</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${callingCardPrices}" var="callingCardPrice">
                                <tr>
                                    <th>${callingCardPrice.country}</th>
                                    <th>${callingCardPrice.landlinePrice}</th>
                                    <th>${callingCardPrice.mobilePrice}</th>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:forEach>
            </c:if>
        </div>
    </from>
    <div class="container-fluid products"></div>

    <%-- Bulk pin quantity --%>
    <div hidden>
        <div class="input-group bulkContainer" style="width: 150px">
            <span class="input-group-btn">
                <button type="button" class="btn btn-default btn-number" data-type="minus" data-field="quant">
                    <span class="glyphicon glyphicon-minus"></span>
                </button>
            </span>
            <input type="text" name="quant" class="form-control input-number" value="10" min="1">
            <span class="input-group-btn">
                <button type="button" class="btn btn-default btn-number" data-type="plus" data-field="quant">
                    <span class="glyphicon glyphicon-plus"></span>
                </button>
            </span>
        </div>
    </div>

    <%-- Mobile Unlocking Container --%>
    <div hidden>
        <div class="col-md-4 col-md-offset-4 mobileUnlockingContainer">
            <div class="row">
                <div class="col-lg-6">
                    <form id="mobileUnlockingOrderForm">
                        <input type="hidden" id="mobileUnlockingId" name="mobileUnlockingId"/>

                        <div class="form-group">
                            <label>Shop keeper name</label>

                            <p id="customerName" class="text-left"></p>
                        </div>
                        <div class="form-group">
                            <div class="form-inline">
                                <div class="multi-field-wrapper">
                                    <div class="multi-fields">
                                        <div class="multi-field">
                                            <label>IMIE</label>
                                            <input type="text" name="imeis[0]" class="form-control">
                                            <span class="glyphicon glyphicon-remove remove-field"></span>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-primary btn-sm add-field">Add</button>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="customerEmail">Customer email</label>
                            <input type="text" class="form-control" id="customerEmail" name="customerEmail">
                        </div>
                        <div class="form-group">
                            <label for="mobileNumber">Shop keeper mobile number</label>
                            <input type="text" class="form-control" id="mobileNumber" name="mobileNumber">
                        </div>
                        <div class="form-group">
                            <label for="notes">Notes</label>
                            <textarea id="notes" name="notes" class="form-control" rows="3"></textarea>
                        </div>
                        <button type="button" class="btn btn-success placeOrder">Place order</button>
                    </form>
                </div>
                <div class="col-lg-6">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-12">
                                    <label for="notes">Transaction Condition</label><br/>
                                    <span id="transactionCondition"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-success mobileUnlockingPanel">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-12">
                                    <label id="mobileUnlockingTitle"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-4 col-md-offset-8 text-right">
                                    <span class="glyphicon glyphicon-gbp"></span>
                                    <span id="mobileUnlockingPrice"></span>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer">
                            <span class="pull-right" id="mobileUnlockingDeliveryTime"
                                  style='font-family: "Times New Roman"'></span>

                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <c:import url="popups/message.jsp"/>
    <c:import url="popups/process.jsp"/>
    <c:import url="popups/confirm.jsp"/>
    <c:import url="popups/mobitopup.jsp"/>
</div>

<div class="printContainer" hidden></div>

</body>
</html>




