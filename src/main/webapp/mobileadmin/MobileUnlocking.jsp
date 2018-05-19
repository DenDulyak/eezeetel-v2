<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script src="${pageContext.request.contextPath}/js/mobileadmin/mobileUnlocking.js"></script>
    <meta charset="utf-8">
    <title>Mobile Unlocking</title>
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
                        <h2>Mobile Unlocking</h2>
                        <input type="button" class="btn btn-primary create" data-toggle="modal"
                               data-target="#mobileUnlockingModal" value="Add"/>
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>Title</th>
                                <th>Supplier</th>
                                <th>Delivery Time</th>
                                <th>Purchase Price</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${mobileUnlockings}" var="mobileUnlocking">
                                <tr <c:if test="${!mobileUnlocking.active}">class="danger"</c:if> >
                                    <td>${mobileUnlocking.title}</td>
                                    <td>${mobileUnlocking.supplier.supplierName}</td>
                                    <td>${mobileUnlocking.deliveryTime}</td>
                                    <td>${mobileUnlocking.purchasePrice}</td>
                                    <td id="${mobileUnlocking.id}">
                                        <input type="button" class="btn btn-primary edit"
                                               data-toggle="modal" data-target="#mobileUnlockingModal" value="Edit"/>
                                        <c:choose>
                                            <c:when test="${mobileUnlocking.active}">
                                                <input data="${!mobileUnlocking.active}" type="button"
                                                       class="btn btn-warning active" value="Deactivate"/>
                                            </c:when>
                                            <c:otherwise>
                                                <input data="${!mobileUnlocking.active}" type="button"
                                                       class="btn btn-success active" value="Activate"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <c:import url="mobileUnlockingForm.jsp"/>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>