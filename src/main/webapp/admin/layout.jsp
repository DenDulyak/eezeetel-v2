<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>${title}</title>
</head>
<body ng-app="adminApp">
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <c:import url="common/libs.jsp"/>

    <c:if test="${useAngular}">
        <link href="${pageContext.request.contextPath}/css/libs/angular/angular-datepicker.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/libs/angular/angular-toastr.min.css" rel="stylesheet">
    </c:if>
    <link href="${pageContext.request.contextPath}/css/spinner.css" rel="stylesheet">

    <script src="${pageContext.request.contextPath}/js/libs/angular/angular.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/angular/angular-datepicker.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/angular/angular-spinners.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/angular/angular-animate.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/libs/angular/angular-toastr.tpls.min.js"></script>

    <script src="${pageContext.request.contextPath}/js/admin/adminApp.js"></script>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <c:import url="${content}"/>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>
