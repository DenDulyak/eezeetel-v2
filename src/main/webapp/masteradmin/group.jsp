<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <h2>Customer groups</h2>
    <input type="button" class="btn btn-primary create" data-toggle="modal" data-target="#groupModal" value="Create new group"/>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Name</th>
            <th>Notes</th>
            <th>City</th>
            <th>Active</th>
            <th>Balance</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${groups}" var="group">
            <tr>
                <td>${group.name}</td>
                <td>${group.notes}</td>
                <td>${group.groupCity}</td>
                <td>${group.active}</td>
                <td>${group.customerGroupBalance}</td>
                <td><input data-group-id="${group.id}" type="button" class="btn btn-primary edit" data-toggle="modal"
                           data-target="#groupModal" value="Edit"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- Modal -->
    <c:import url="popups/groupForm.jsp"/>

    <script src="${pageContext.request.contextPath}/js/libs/moment-with-locales.min.js"></script>
    <script>
        $(function () {
            var remoteUser = '${pageContext.request.remoteUser}';

            $('.edit').click(function(e){
                var groupId = $(this).data('group-id');

                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/group/get?id=' + groupId,
                    dataType: 'json',
                    success: function(data){
                        $('#groupId').val(data.id);
                        $('#name').val(data.name);
                        $('#customerSince').val(formatTime(data.customerSince));
                        $('#createBy').val(data.createBy);
                        $('#notes').val(data.notes);
                        $('#balance').val(data.balance);
                        $('#address').val(data.address);
                        $('#city').val(data.city);
                        $('#pinCode').val(data.pinCode);
                        $('#phone').val(data.phone);
                        $('#mobile').val(data.mobile);
                        $('#email').val(data.email);
                        $('#companyRegNo').val(data.companyRegNo);
                        $('#vatRegNo').val(data.vatRegNo);
                        $('#active').prop('checked', data.active);
                        $('#checkAganinstGroupBalance').prop('checked', data.checkAganinstGroupBalance);
                        $('#applyDefaultCustomerPercentages').prop('checked', data.applyDefaultCustomerPercentages);
                        $('#sellAtFaceValue').prop('checked', data.sellAtFaceValue);
                        $('#style').val(data.style).prop('selected', true);

                        updateCustomers(groupId, data.defaultCustomerInfo);
                    },
                    error: function(request, textStatus, errorThrown) {
                        console.log(request);
                    }
                });
            });

            $('.create').click(function(e){
                $('form input').val('');
                $('#customerSince').val(formatTime(new Date()));
                $('#createBy').val(remoteUser);
                updateCustomers(0, '');
            });

            var formatTime = function(time){
                return moment(new Date(time)).format('YYYY-MM-DD');
            };

            var updateCustomers = function (groupId, defaultCustomer) {
                var customers = $('#defaultCustomerInfo');
                customers.empty();

                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/customer/find-by-group',
                    data: {
                        id: groupId
                    },
                    dataType: 'json',
                    success: function(data){
                        $.each(data, function(key, value) {
                            customers.append(new Option(value.value, value.value));
                        });

                        customers.val(defaultCustomer).prop('selected', true);
                    }
                });
            };

            $('.save').click(function(e){
                var form = $('form');
                $.ajax({
                    type: 'POST',
                    url: '/masteradmin/group/save',
                    dataType: "json",
                    data: form.serialize(),
                    success: function(data){
                        location.reload();
                    }
                });
            });
        });
    </script>
</div>