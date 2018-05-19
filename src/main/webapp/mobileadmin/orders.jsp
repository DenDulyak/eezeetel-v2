<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp" />
    <script src="${pageContext.request.contextPath}/js/mobileadmin/orders.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/moment-with-locales.min.js"></script>
    <title>Mobile Unlocking Orders</title>
</head>
<body>
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Mobile Unlocking</th>
                                <%--<th>Customer</th>--%>
                                <th>User</th>
                                <th>IMEI</th>
                                <th>Code</th>
                                <th>Customer email</th>
                                <th>Customer mobile number</th>
                                <th>Price</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <c:forEach items="${orders}" var="order">
                                <tr id="${order.id}"
                                    <c:if test="${order.status == 'REJECTED'}">class="danger"</c:if>>
                                    <td>${order.mobileUnlocking.title}</td>
                                    <%--<td>${order.user.customerUsers.get(0).customer.companyName}</td>--%>
                                    <td>${order.user.login}</td>
                                    <td>${order.imei}</td>
                                    <td>${order.code}</td>
                                    <td>${order.customerEmail}</td>
                                    <td>${order.mobileNumber}</td>
                                    <td>${order.price}</td>
                                    <td>
                                        <input type="button" class="btn btn-info edit"
                                               data-toggle="modal"
                                               data-target="#orderModal" value="Edit"/>
                                        <c:if test="${order.status != 'REJECTED'}">
                                            <input type="button" class="btn btn-danger reject" value="Reject"/>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>

                        <c:import url="orderForm.jsp"/>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>