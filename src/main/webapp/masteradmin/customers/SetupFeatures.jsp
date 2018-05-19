<%@ page import="com.eezeetel.enums.FeatureType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>


<div class="container-fluid">
    <%
        request.setAttribute("features", FeatureType.values());
    %>

    <div class="row">
        <div class="form-group form-inline col-sm-12 has-feedback has-feedback-left">
            <label for="groups" class="control-label">Group: </label>

            <div class="form-group">
                <select id="groups" class="form-control">
                    <option value="0">Select</option>
                </select>
            </div>
        </div>
    </div>
    <div class="row features-container" hidden>
        <div class="form-group col-md-2">
            <c:forEach items="${features}" var="feature">
                <label class="checkbox">
                    <input type="checkbox" name="${feature.name()}"/>${feature.description}
                </label>
            </c:forEach>
            <input type="button" class="btn btn-primary saveBtn" value="Save"/>
        </div>
    </div>
</div>

<script>
    $(function () {
        $('.saveBtn').click(function (e) {
            $('.container-fluid').pleaseWait();
            var features = $('input:checkbox:checked').map(function () {
                return this.name;
            }).get();

            $.ajax({
                url: '/masteradmin/customer/update-customer-features-by-group?groupId=' + $("#groups").val(),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                data: JSON.stringify(features),
                success: function (data) {

                },
                complete: function () {
                    $(":checkbox").prop("checked", false);
                    $('.features-container').hide();
                    $('.container-fluid').pleaseWait('stop');
                }
            });
        });

        $("#groups").change(function () {
            $(":checkbox").prop("checked", false);
            if ($(this).val() > 0) {
                $('.features-container').show();
            } else {
                $('.features-container').hide();
            }
        });

        $.ajax({
            url: '/masteradmin/group/find-all',
            type: 'GET',
            success: function (data) {
                var customers = $("#groups");
                $.each(data, function (key, value) {
                    customers.append(new Option(value.name, value.id));
                });
            }
        });
    });
</script>