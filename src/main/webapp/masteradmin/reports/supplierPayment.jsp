<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    .table-custom {
        width: 100%;
        margin-top: 20px;
    }
</style>

<div class="container-fluid">

    <div class="row">
        <div class="form-group-sm form-inline col-sm-12 has-feedback has-feedback-left">
            <label for="supplier" class="control-label">Supplier: </label>
            <div class="form-group">
                <select id="supplier" class="form-control">
                    <option value="0">All</option>
                    <c:forEach items="${suppliers}" var="supplier">
                        <option value="${supplier.id}">${supplier.supplierName}</option>
                    </c:forEach>
                </select>
            </div>
            <label for="from" class="control-label">From: </label>
            <input id="from" type="text" class="form-control"/>
            <label for="to" class="control-label">To: </label>
            <input id="to" type="text" class="form-control"/>
            <input type="button" class="btn-sm btn-primary searchBtn" value="Search"/>
        </div>
    </div>
    <table class="table-sm table-striped table-custom">
        <thead>
        <tr>

        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>

<script>

</script>
