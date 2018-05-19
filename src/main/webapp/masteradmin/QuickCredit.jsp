<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function hasCreditLimit() {
            var customerId = $('#customer_id').val();
            var result = false;
            if (customerId > 0) {
                $.ajax({
                    type: 'GET',
                    async: false,
                    url: '/masteradmin/customer/has-credit-limit',
                    data: {
                        customerId: customerId
                    },
                    dataType: 'json',
                    success: function (data) {
                        result = data;
                    }
                });
            }
            return result;
        }

        function AddAmount() {
            if (document.the_form.customer_id.value == 0) {
                alert("Please select a customer first.");
                return;
            }

            if (!CheckNumbers(document.the_form.payment_amount.value, ".")) {
                alert("Please enter proper amount");
                return;
            }

            if (eval(document.the_form.payment_amount.value) <= 0) {
                alert("Please enter proper amount");
                return;
            }

            var isCreditLimit = hasCreditLimit();

            if (eval(document.the_form.payment_amount.value) > 500 && !isCreditLimit) {
                alert("Amount can not be more than 500.  Please enter proper amount");
                return;
            }

            if (eval(document.the_form.payment_amount.value) > 20000 && isCreditLimit) {
                alert("Amount can not be more than 20000.  Please enter proper amount");
                return;
            }

            var credit_or_debit = 2;
            var pay_type = 1;

            if (document.the_form.is_credit.checked == true) {
                credit_or_debit = 1;

                if (document.the_form.cash_payment.checked == false) {
                    pay_type = 3;
                    if (IsNULL(document.the_form.payment_details.value)) {
                        alert("Please enter bank payment details");
                        return;
                    }
                }
            }

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot contact server.");
                return;
            }

            var element = document.getElementById('credit_info');
            element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    element.innerHTML = httpObj.responseText;
                }
            };

            var url = "AJAX_AddCustomerCredit.jsp?customer_id=" + document.the_form.customer_id.value +
                    "&payment_type=" + pay_type +
                    "&credit_or_debit=" + credit_or_debit +
                    "&payment_amount=" + document.the_form.payment_amount.value +
                    "&collected_by=" + document.the_form.collected_by.value +
                    "&payment_details=" + document.the_form.payment_details.value;

            httpObj.open("POST", url, true);
            httpObj.send(null);
            document.the_form.payment_amount.value = 0;
        }

        function UpdateDebit(credit_id) {
            if (!CheckNumbers(credit_id)) {
                alert("Not a valid credit ID");
                return;
            }

            var answer = confirm("Are you sure you want to update the debit to credit?");
            if (answer) {
                var httpObj = getHttpObject();
                if (httpObj == null) {
                    alert("Cannot contact server.");
                    return;
                }

                var element = document.getElementById('credit_info');
                element.innerHTML = "";

                httpObj.onreadystatechange = function () {
                    if (httpObj.readyState == 4) {
                        element.innerHTML = httpObj.responseText;
                    }
                };

                var url = "AJAX_UpdateThisDebit.jsp?credit_id=" + credit_id + "&customer_id=" + document.the_form.customer_id.value;
                httpObj.open("POST", url, true);
                httpObj.send(null);
            }
            else return;
        }

        function UpdateCustomerCreditInfo() {
            if (document.the_form.customer_id.value == 0)
                return;

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get cusomter daily transaction");
                return;
            }

            var element = document.getElementById('credit_info');
            element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    element.innerHTML = httpObj.responseText;
                }
            };

            var url = "AJAX_GetCreditInfo.jsp?customer_id=" + document.the_form.customer_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
    </script>
    <title>Customer Credit Summary</title>
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
                                    <td> Customer :</td>
                                    <td align="left">
                                        <select id="customer_id" name="customer_id"
                                                onChange="UpdateCustomerCreditInfo()">
                                            <option value="0">Select</option>
                                                <%
                                    String strQuery = "from TMasterCustomerinfo where Active_Status = 1 and Customer_Group_ID = 1 order by Customer_Company_Name";
                                    Session theSession= null;
                                    try{
                                        theSession = HibernateUtil.openSession();

                                        Query query = theSession.createQuery(strQuery);
                                        List records = query.list();

                                        for (int nIndex = 0; nIndex < records.size(); nIndex++){
                                            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
                                    %>
                                            <option value="<%=custInfo.getId()%>"><%=custInfo.getCompanyName()%>
                                            </option>
                                                <%
                                        }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    } finally{
                                        HibernateUtil.closeSession(theSession);
                                    }
                                    %>
                                    </td>
                                </tr>
                            </table>
                            <div id="credit_info"></div>
                            <table>
                                <tr>
                                    <td>Amount :</td>
                                    <td>
                                        <input type="text" name="payment_amount" maxlength="5" size="5"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <font color="red"><b>Is Credit?</b></font>
                                    </td>
                                    <td>
                                        <input type="checkbox" name="is_credit"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <font color="red"><b>Is Cash Payment?</b></font>
                                    </td>
                                    <td>
                                        <input type="checkbox" name="cash_payment"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Payment Details:</td>
                                    <td>
                                        <input type="text" name="payment_details" maxlength="40" size="40"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Collected By:</td>
                                    <td>
                                        <input type="text" name="collected_by" value="<%=request.getRemoteUser()%>"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <input type="button" name="add_and_adjust" value="Add and Adjust Balance"
                                               OnClick="AddAmount()">
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>