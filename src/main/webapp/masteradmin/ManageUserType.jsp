<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <table class="table table-bordered">
        <thead>
        <tr>
            <th></th>
            <th>User Type</th>
            <th>Notes</th>
        </tr>
        </thead>
        <c:forEach items="${types}" var="type">
            <tr>
                <td align="right">
                    <input type="radio" name="record_id" value="${type.id}"/>
                </td>
                <td>${type.name}</td>
                <td>${type.notes}</td>
            </tr>
        </c:forEach>
    </table>
    <input type="button" class="btn btn-primary newUser pull-right"
           data-toggle="modal" data-target="#userModal" value="Add new user"/>

    <!-- Modal -->
    <c:import url="popups/addUser.jsp"/>
</div>

<script>
    $(function () {
        $.ajax({
            type: 'GET',
            url: '/masteradmin/user/countries',
            dataType: 'json',
            success: function (data) {
                var country = $('#country');
                $.each(data, function (key, value) {
                    country.append(new Option(value.countryName, value.countryName));
                });
            }
        });

        $('.newUser').click(function (e) {
            var recordId = $('input[name=record_id]:checked').val();
            $('#type').find('option[value=' + recordId + ']').prop('selected', true);
            var group = $('#group');
            var company = $('#company');
            group.find('option').remove();
            group.append(new Option('', '-1'));
            company.find('option').remove();
            $.ajax({
                type: 'GET',
                url: '/masteradmin/group/find-all',
                dataType: 'json',
                success: function (data) {
                    $.each(data, function (key, value) {
                        group.append(new Option(value.name, value.id));
                    });
                }
            });
        });

        $("#group").change(function () {
            var id = $("#group").val();
            if (id > 0) {
                var company = $('#company');
                company.find('option').remove();
                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/customer/find-by-group?id=' + id,
                    dataType: 'json',
                    success: function (data) {
                        $.each(data, function (key, value) {
                            company.append(new Option(value.value, value.key));
                        });
                    }
                });
            }
        });

        $.validator.addMethod("notNumber", function (value) {
            var reg = /[0-9]/;
            return !reg.test(value);
        }, "Number is not permitted.");

        $.validator.addMethod("charsAndNumbers", function (value) {
            var reg = /[^a-zA-Z0-9]/;
            return !reg.test(value);
        }, "This field can have only characters or numbers.");

        $.validator.addMethod("email", function (value) {
            var reg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            return reg.test(value);
        }, "Please enter a valid email address.");

        $.validator.addMethod("nospace", function (value, element) {
            return this.optional(element) || /^\S+$/i.test(value);
        }, "Without spaces please.");

        $("#userForm").validate({
            rules: {
                login: {
                    required: true,
                    minlength: 2,
                    maxlength: 50,
                    nospace: true
                },
                firstName: {
                    required: true,
                    maxlength: 50,
                    nospace: true,
                    notNumber: true
                },
                lastName: {
                    required: true,
                    maxlength: 50,
                    nospace: true,
                    notNumber: true
                },
                middleName: {
                    maxlength: 50,
                    nospace: true,
                    notNumber: true
                },
                group: {
                    required: true
                },
                addressLine1: {
                    required: true,
                    minlength: 4,
                    maxlength: 50
                },
                postalCode: {
                    charsAndNumbers: true
                },
                primaryPhone: {
                    required: true,
                    number: true
                },
                secondaryPhone: {
                    number: true
                },
                mobilePhone: {
                    number: true
                },
                email: {
                    required: true,
                    email: true
                },
                password1: {
                    required: true,
                    minlength: 4,
                    maxlength: 50
                },
                password2: {
                    required: true,
                    minlength: 4,
                    maxlength: 50
                }
            },
            submitHandler: function (form) {
                $.ajax({
                    type: 'POST',
                    url: '/masteradmin/user/save',
                    dataType: "json",
                    data: form.serialize()
                });
            }
        });
    });
</script>