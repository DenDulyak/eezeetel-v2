<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<style>
    .callingCardPriceTitle {
        font-size: 22px;
        font-weight: 300;
        color: #00a0df;
        margin-top: 15px;
        margin-right: 15px;
    }
</style>

<div class="container-fluid">
    <div class="row">
        <div class="form-inline">
            <div class="form-group">
                <input type="button" class="btn btn-primary add" data-toggle="modal"
                       data-target="#callingCardPriceModal" value="Add"/>
            </div>
            <div class="form-group pull-right">
                <span class="callingCardPriceTitle"></span>
                                    <span class="glyphicon glyphicon-edit"
                                          data-toggle="modal"
                                          data-target="#callingCardPriceTitleModal"></span>
            </div>
        </div>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Country</th>
            <th>Landline P/Min</th>
            <th>Mobile P/Min</th>
            <th></th>
        </tr>
        </thead>
        <tbody>

        </tbody>
    </table>

    <c:import url="customers/callingCardPriceForm.jsp"/>
    <c:import url="customers/callingCardPriceTitleEdit.jsp"/>
</div>

<script>
    $(function () {

        $('.add').click(function (e) {
            $('#callingCardPriceModal').find('input').val('');
        });

        var edit = function () {
            $('.edit').click(function (e) {
                var cardPriceId = $(this).parent().parent().attr('data-id').split('_')[1];
                var form = $('#callingCardPriceModal');
                form.find("input[name='id']").val(cardPriceId);
                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/calling-card-price/get?id=' + cardPriceId,
                    dataType: 'json',
                    success: function (data) {
                        form.find('#country').val(data.country);
                        form.find('#landlinePrice').val(data.landlinePrice);
                        form.find('#mobilePrice').val(data.mobilePrice);
                    }
                });
            });
        };

        var deleteClick = function () {
            $('.delete').click(function (e) {
                var cardPriceId = $(this).parent().parent().attr('data-id').split('_')[1];
                $.ajax({
                    type: 'GET',
                    url: '/masteradmin/calling-card-price/delete?id=' + cardPriceId,
                    dataType: 'json',
                    success: function (data) {

                    },
                    complete: function () {
                        updateTable();
                    }
                });
            });
        };

        $('.save').click(function (e) {
            $.ajax({
                type: 'POST',
                url: '/masteradmin/calling-card-price/save',
                dataType: 'json',
                data: $('#callingCardPriceForm').serialize(),
                success: function (data) {

                },
                complete: function () {
                    $('#callingCardPriceModal').modal('hide');
                    updateTable();
                }
            });
        });

        var updateTable = function () {
            var tbody = $('table tbody');
            tbody.empty();
            $.ajax({
                type: 'GET',
                url: '/masteradmin/calling-card-price/find-all?size=500&page=0',
                dataType: 'json',
                success: function (data) {
                    $.each(data.content, function (key, value) {
                        var tr = '<tr data-id="cardPrice_' + value.id + '">';
                        tr += '<td>' + value.country + '</td>';
                        tr += '<td>' + value.landlinePrice + '</td>';
                        tr += '<td>' + value.mobilePrice + '</td>';
                        tr += '<td class="pull-right">' +
                                '<button class="btn btn-primary edit" data-toggle="modal" data-target="#callingCardPriceModal">Edit</button>' +
                                '<button class="btn btn-danger delete">Delete</button>' +
                                '</td>';
                        tr += '</tr>';
                        tbody.append(tr);
                    });

                    edit();
                    deleteClick();
                }
            });
        };

        var getTitle = function () {
            $.ajax({
                type: 'GET',
                url: '/masteradmin/calling-card-price/get-title',
                dataType: 'json',
                success: function (data) {
                    $('#title').val(data.text);
                    $('.callingCardPriceTitle').text(data.text);
                }
            });
        };

        $('.saveTitle').click(function (e) {
            $.ajax({
                type: 'POST',
                url: '/masteradmin/calling-card-price/update-title',
                dataType: 'json',
                data: {title: $('#title').val()},
                success: function (data) {
                    $('#title').val(data.text);
                    $('.callingCardPriceTitle').text(data.text);
                },
                complete: function () {
                    $('#callingCardPriceTitleModal').modal('hide');
                }
            });
        });

        getTitle();
        updateTable();
    });
</script>