<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">

        function DisplayTransaction() {
            var errString = "";

            if (IsNULL(document.the_form.transaction_id.value))
                errString += "\r\Transaction ID can not be empty.  Please enter a proper value";
            else {
                if (!CheckNumbers(document.the_form.transaction_id.value, ""))
                    errString += "\r\Transaction ID can only be a number. Please enter a proper value";
            }

            if (errString == null || errString.length <= 0) {
                for (i = 0; i < document.the_form.elements.length; i++)
                    if (document.the_form.elements[i].type == "text")
                        CheckDatabaseChars(document.the_form.elements[i]);

                var httpObj = getHttpObject();
                if (httpObj == null) {
                    alert("Cannot get transaction details");
                    return;
                }

                var element = document.getElementById('transaction_details');
                element.innerHTML = "";

                httpObj.onreadystatechange = function () {
                    if (httpObj.readyState == 4) {
                        element.innerHTML = httpObj.responseText;
                    }
                }

                var url = "AJAX_GetTransactionDetails.jsp?transaction_id=" + document.the_form.transaction_id.value;
                httpObj.open("POST", url, true);
                httpObj.send(null);
            }
            else
                alert(errString);
        }

        function Revoke() {
            var sequence_id_list = "";

            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "checkbox")
                    if (document.the_form.elements[i].checked == true)
                        sequence_id_list += (document.the_form.elements[i].value) + ",";

            if (IsNULL(sequence_id_list)) {
                alert("Please select items to revoke");
                return;
            }

            document.the_form.action = "ConfirmRevokeTransaction.jsp?sequence_ids=" + sequence_id_list;
            document.the_form.submit();
        }

    </script>
    <title>Revoke Transaction</title>
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
                        <form name="the_form" method="post" action="">
                            <table>
                                <tr>
                                    <td>Transaction ID to Revoke :</td>
                                    <td><input type="text" name="transaction_id"></td>
                                    <td><input type="button" name="display_button" value="Display" onClick="DisplayTransaction()"></td>
                                </tr>
                            </table>
                            <br>

                            <div id="transaction_details"></div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>