<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../common/libs.jsp"/>
    <meta charset="UTF-8">
    <title>Customer Day Transaction</title>
    <link href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>
    <style>
        table {
            width: 100%;
        }

        .table-sm td, th {
            padding: 0.3em;
        }
    </style>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        $(function () {
            $('#from').datepicker("setDate", new Date());
            $('#to').datepicker("setDate", new Date(new Date().getTime() + 24 * 60 * 60 * 1000));
        });

        $('.radioButton').click(function (e) {
            validator.element("#transaction");
        });

        function update_customer_daily_transaction(userID) {
            if (IsNULL(userID))
                userID = document.the_form.user_id.value;
            if (IsNULL(userID)) return;

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get cusomter daily transaction");
                return;
            }

            var element = document.getElementById('customer_daily_transaction');
            if (element != null)
                element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    if (element != null)
                        element.innerHTML = httpObj.responseText;
                }
            };

            var url = "/customer/AJAX_GetCustomerDailySummary.jsp?the_user_id=" + userID + "&from=" + $('#from').val() + "&to=" + $('#to').val();
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
        function PrintPage() {
            window.print();
        }

        function winUnload() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get product information");
                return;
            }

            var url = "/logout";
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
        window.onunload = function () {
//	winUnload();
        }

    </script>
</head>
<%
    String strUserId = request.getRemoteUser();
%>
<body onLoad="update_customer_daily_transaction('<%=strUserId%>')">
<c:import url="headerNavbar.jsp"/>
<%
    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        int nCustomer_ID = 0;
        String strUserFirstName = "";
        String strUserLastName = "";

        String strQuery = "from TCustomerUsers where User_Login_ID = '" + strUserId + "'";
        Query query = theSession.createQuery(strQuery);
        List<TCustomerUsers> records = query.list();
        if (records.size() > 0) {
            TCustomerUsers custUsers = records.get(0);
            TMasterCustomerinfo customer = custUsers.getCustomer();
            User users = custUsers.getUser();
            if (users.getUserActiveStatus()) {
                nCustomer_ID = customer.getId();
                strUserFirstName = users.getUserFirstName();
                strUserLastName = users.getUserLastName();
            }
        }

        if (request.isUserInRole("Customer_Supervisor")) {
            strQuery = "from TCustomerUsers where Customer_ID = " + nCustomer_ID;

            query = theSession.createQuery(strQuery);
            records = query.list();
        }
%>
<div class="container">
    <form name="the_form" method="post" action="">
        <div class="row">
            <div class="form-group form-inline col-sm-12 has-feedback has-feedback-left">
                <label for="from" class="control-label">From: </label>
                <input id="from" type="text" class="form-control" />
                <label for="to" class="control-label">To: </label>
                <input id="to" type="text" class="form-control" />
                <label for="user_id" class="control-label">User: </label>
                <div class="form-group">
                    <select id="user_id" name="user_id" class="form-control" onChange="update_customer_daily_transaction()">
                        <%
                            if (request.isUserInRole("Customer_Supervisor")) {
                        %>
                        <option value="All">All</option>
                        <%
                            for (TCustomerUsers custUsers : records) {
                                User users = custUsers.getUser();
                                TMasterUserTypeAndPrivilege privilege = users.getUserType();
                                if (!users.getUserActiveStatus()) continue;
                                if (privilege.getId() != 7 && privilege.getId() != 8)
                                    continue;
                                String strSelected = "";
                                if (users.getLogin().compareToIgnoreCase(strUserId) == 0)
                                    strSelected = "selected";
                        %>
                        <option value="<%=users.getLogin()%>"<%=strSelected%>><%=users.getUserFirstName()%>
                            , <%=users.getUserLastName()%>
                        </option>
                        <%
                            }
                        } else {
                        %>
                        <option value="<%=strUserId%>"><%=strUserFirstName%>, <%=strUserLastName%>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <input type="button" class="btn btn-primary" onclick="update_customer_daily_transaction()" value="Search" />
            </div>
        </div>
        <br>

        <div id="customer_daily_transaction"></div>
        <div id="nav">
            <input type="button" class="btn" name="print_button" value="Print" onClick="javascript:PrintPage()"/>
        </div>
    </form>
</div>
</body>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</html>