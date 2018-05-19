<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        String strQuery = "from TMasterCustomerGroups where active = 1";
        Query query = theSession.createQuery(strQuery);
        List records = query.list();
%>

<!DOCTYPE html>
<html>
<head>
    <c:import url="../common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Manage Customer Messages</title>
    <style type="text/css">
        .SCROLLTEXT {
            font-family: "Arial", sans-serif;
            font-weight: 700;
            font-size: 18.0px;
            line-height: 1.25em;
            color: #1233B1;
        }
    </style>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>

        function getMessage() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get existing message");
                return;
            }

            if (document.the_form.customer_group_id.value == 0) {
                var element = document.getElementById('formfields');
                element.disabled = true;

                element = document.getElementById('the_message_id');
                element.value = "";
                return;
            }

            var element = document.getElementById('the_message_id');
            element.value = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('the_message_id');
                    element.value = "";
                    element.value = httpObj.responseText;
                    element = document.getElementById('formfields');
                    element.disabled = false;
                }
            };

            var url = "AJAX_GetGroupMessage.jsp?group_id=" + document.the_form.customer_group_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function testMessage() {
            var element = document.getElementById('test_message_id');
            if (element == null) return;
            element.innerHTML = "";
            if (IsNULL(document.the_form.the_message.value))
                return;
            CheckDatabaseChars(document.the_form.the_message.value);
            var text = document.the_form.the_message.value;

            element.innerHTML = "<marquee behavior=\"scroll\" direction=\"up\" width=\"50%\" height=\"250\" scrolldelay=\"100\" class=\"SCROLLTEXT\"><pre>" +
                    text + "</pre></marquee>";
        }

        function setupMessage() {
            if (IsNULL(document.the_form.the_message.value))
                return;
            CheckDatabaseChars(document.the_form.the_message.value);

            if (document.the_form.the_message.value.length > 1023) {
                alert("Plese enter only 1000 characters.")
                return;
            }

            var text = document.the_form.the_message.value;
            document.the_form.the_message.value = text.replace(/\n\r?/g, '\n');

            document.the_form.action = "/masteradmin/customermessages/SetupCustomerMessage.jsp";
            document.the_form.submit();
        }

        function removeMessage() {
            if (IsNULL(document.the_form.the_message.value))
                return;
            CheckDatabaseChars(document.the_form.the_message.value);

            document.the_form.action = "/masteradmin/customermessages/RemoveCustomerMessage.jsp";
            document.the_form.submit();
        }
    </script>
</head>
<body>
<section id="container">
    <c:import url="../common/header.jsp"/>
    <c:import url="../common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-9 col-md-12">
                    <div class="container">
                        <form name="the_form" action="" method="post">
                            <select id="customer_group_id" name="customer_group_id" onChange="getMessage()">
                                <option value="0">Select</option>
                                <%
                                    for (int i = 0; i < records.size(); i++) {
                                        TMasterCustomerGroups custGroup = (TMasterCustomerGroups) records.get(i);
                                %>
                                <option value="<%=custGroup.getId()%>"><%=custGroup.getName()%>
                                </option>
                                <%
                                    }
                                %>
                            </select>

                            <fieldset id="formfields" disabled>Message To Customers :
                            <textarea id="the_message_id" name="the_message" rows=10 cols=80>
                            </textarea>
                                <br><br><br><br>
                                <input type="button" name="test_message" value="Test Message"
                                       onClick="onClick=testMessage()">
                                <input type="button" name="setup_message" value="Setup Message"
                                       onClick="onClick=setupMessage()">
                                <input type="button" name="remove_message" value="Remove Message"
                                       onClick="onClick=removeMessage()">
                            </fieldset>
                        </form>
                        <br><br><br>

                        <div id="test_message_id"></div>

                        <%
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                HibernateUtil.closeSession(theSession);
                            }
                        %>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>