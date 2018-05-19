<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Essycall Master Admin</title>
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
                        <h2 id="dingBalance"></h2>
                        <h2 id="mobitopupBalance"></h2>
                        <h2 id="pinlessBalance"></h2>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>

<script>
    $(function () {
        /*$.ajax({
            type: 'GET',
            url: '/masteradmin/ding/get-balance',
            dataType: "json",
            success: function(data){
                $('#dingBalance').text('EezeeTel Balance with Ding is : ' + data);
            }
        });
        $.ajax({
            type: 'GET',
            url: '/masteradmin/mobitopup/get-balance',
            dataType: "json",
            success: function(data){
                $('#mobitopupBalance').text('EezeeTel Balance with Mobitopup is : ' + data.balance);
            }
        });
        $.ajax({
            type: 'GET',
            url: '/masteradmin/pinless/get-balance',
            dataType: "json",
            success: function(data){
                $('#pinlessBalance').text('EezeeTel Balance with Pinless is : ' + data.balance);
            }
        });*/
    });
</script>
</body>
</html>