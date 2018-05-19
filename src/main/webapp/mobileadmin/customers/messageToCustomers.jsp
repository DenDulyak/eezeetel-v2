<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="../common/libs.jsp"/>
    <script src="${pageContext.request.contextPath}/js/mobileadmin/customers/messageToCustomers.js"></script>
    <title>Message to customers</title>
</head>
<body>
<section id="container">
    <c:import url="../common/header.jsp"/>
    <c:import url="../common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <div class="form-group form-inline">
                            <label for="group" class="control-label">Group: </label>

                            <div class="form-group">
                                <select id="group" class="form-control">
                                    <c:forEach items="${groups}" var="group">
                                        <option value="${group.id}">${group.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="form-group col-md-4">
                                <textarea class="form-control" rows="5"></textarea>
                            </div>
                        </div>

                        <div class="row">
                            <div class="form-group col-md-4">
                                <input type="button" class="btn setupMessage" value="Setup"/>
                                <input type="button" class="btn pull-right removeMessage" value="Remove"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>
