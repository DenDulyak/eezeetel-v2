<%@ page import="com.eezeetel.service.CustomerCreditService" %>
<%@ page import="org.springframework.data.domain.Page" %>
<%@ page import="org.springframework.data.domain.PageRequest" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="../common/libs.jsp"/>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function update_customer_credit_list(page) {

            if (page == undefined) {
                page = 1;
            }

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get customer credit information");
                return;
            }

            var customerID = 0;
            if (document.the_form.customer_list != null)
                customerID = document.the_form.customer_list.value;
            var status = document.the_form.credit_status.value;


            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('customer_credit_info');
                    element.innerHTML = "";
                    element.innerHTML = httpObj.responseText;
                }
            };

            var url = "/admin/Accounts/AJAX_GetCustomerCredit.jsp?customer_id=" + customerID + "&credit_status=" + status + "&page=" + page;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function ModifyCredit() {
            var action_page = "/admin/Accounts/ModifyCustomerCredit.jsp?credit_id=";

            if (document.the_form.record_id != null) {
                var nItems = document.the_form.record_id.length;
                if (nItems == null || nItems <= 0) {
                    if (document.the_form.record_id.checked) {
                        action_page += document.the_form.record_id.value;
                        document.the_form.action = action_page;
                        document.the_form.submit();
                        return 1;
                    }
                    else
                        alert("Please select a record to perform the operation.");
                }
                else {
                    for (var i = 0; i < document.the_form.record_id.length; i++)
                        if (document.the_form.record_id[i].checked) {
                            action_page += document.the_form.record_id[i].value;
                            document.the_form.action = action_page;
                            document.the_form.submit();
                            return 1;
                        }
                    alert("Please select a record to perform the operation.");
                }
            }
            else
                alert("No records available to perform the operation.");
        }

    </script>
    <meta charset="utf-8">
    <title>List, Modify, Customer Credit</title>
</head>
<body>
<section id="container">
    <c:import url="../common/header.jsp"/>
    <c:import url="../common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <h2>Manage Customer Credit</h2>

                        <%
                            String strStatus = request.getParameter("credit_status");
                            int nStatus = -1;
                            if (strStatus != null && !strStatus.isEmpty())
                                nStatus = Integer.parseInt(strStatus);

                            Session theSession = null;
                            try {
                                theSession = HibernateUtil.openSession();
                                Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

                                WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
                                CustomerCreditService customerCreditService = context.getBean(CustomerCreditService.class);

                        %>

                        <form name="the_form" method="post" action="">

                            <table width="100%">
                                <tr>
                                    <td align="right"> Customer :</td>
                                    <td>

                                        <select name="customer_list" id="customer_list_id"
                                                onchange="update_customer_credit_list()">
                                            <option value="0">Select</option>
                                            <%
                                                String strQuery = "from TMasterCustomerinfo where Customer_Group_ID = " + nCustomerGroupID + " and Active_Status = 1 order by Customer_Company_Name";
                                                Query query = theSession.createQuery(strQuery);
                                                List records = query.list();
                                                for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                                    TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
                                            %>
                                            <option value="<%=custInfo.getId()%>"><%=custInfo.getCompanyName()%>
                                                - <%=custInfo.getCustomerBalance()%>
                                            </option>
                                            <%
                                                }
                                            %>
                                        </select>

                                    </td>

                                    <td align="right">Status :</td>
                                    <td>
                                        <select name="credit_status" onchange="update_customer_credit_list()">
                                            <option value="-1">All</option>
                                            <option value="0">Just Added (DEBIT)</option>
                                            <option value="1">Pending Credit Update</option>
                                            <option value="2">Processed Credit Update</option>
                                        </select>
                                    </td>

                                    <td align="center">
                                        <a href="/admin">Admin Main</a>
                                    </td>

                                    <td align="center">
                                        <input type="button" name="add_button" value="Add"
                                               OnClick="SubmitForm('/admin/Accounts/NewCustomerCredit.jsp', false);">
                                    </td>
                                </tr>
                            </table>

                            <div id="customer_credit_info">
                                <table class="table table-bordered">
                                    <tr>
                                        <th>Credit ID</th>
                                        <th>Customer</th>
                                        <th>Payment Type</th>
                                        <th>Payment Details</th>
                                        <th>Payment Amount</th>
                                        <th>Payment Received Date</th>
                                        <th>Collected By</th>
                                        <th>Entered By</th>
                                        <th>Topup Date</th>
                                        <th>Credit OR Debit</th>
                                        <th>Notes</th>
                                    </tr>

                                    <%
                                        Calendar calendar = Calendar.getInstance();
                                        calendar.set(Calendar.YEAR, 2011);
                                        calendar.set(Calendar.DAY_OF_YEAR, 1);

                                        Page<TMasterCustomerCredit> customerCredits = customerCreditService.findByGroupAndEnteredTime(nCustomerGroupID, null, calendar.getTime(), nStatus, new PageRequest(0, 100));
                                        records = customerCredits.getContent();

                                        int begin = Math.max(1, customerCredits.getNumber() - 5);
                                        long end = Math.min(begin + 10, customerCredits.getTotalElements());

                                        request.setAttribute("begin", begin);
                                        request.setAttribute("end", end);

                                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                            TMasterCustomerCredit custCredit = (TMasterCustomerCredit) records.get(nIndex);
                                            TMasterCustomerinfo custInfo = custCredit.getCustomer();
                                            if (custInfo.getGroup().getId().intValue() == nCustomerGroupID) {
                                                User userCollectedBy = custCredit.getCollectedBy();
                                                User userEnteredBy = custCredit.getEnteredBy();

                                                String strPaymentType = "Not Paid Yet";
                                                switch (custCredit.getPaymentType()) {
                                                    case 1:
                                                        strPaymentType = "Cash";
                                                        break;
                                                    case 2:
                                                        strPaymentType = "Cheque";
                                                        break;
                                                    case 3:
                                                        strPaymentType = "Bank Deposit";
                                                        break;
                                                    case 4:
                                                        strPaymentType = "Funds Transfer";
                                                        break;
                                                    case 5:
                                                        strPaymentType = "Debit/Credit Card";
                                                        break;
                                                }

                                                String strCreditOrDebit = "DEBIT";
                                                String strBgColor = "danger";
                                                if (custCredit.getCreditOrDebit() == 1) {
                                                    strCreditOrDebit = "Credit";
                                                    strBgColor = "";
                                                }

                                    %>
                                    <tr class="<%=strBgColor%>">
                                        <td align="right">
                                            <a href="/admin/Accounts/ModifyCustomerCredit.jsp?credit_id=<%=custCredit.getId()%>"><%=custCredit.getId()%>
                                            </a>
                                            <input type="hidden" name="record_id" value="<%=custCredit.getId()%>">
                                        </td>

                                        <td align="left"><%=custInfo.getCompanyName()%>
                                        </td>
                                        <td align="left"><%=strPaymentType%>
                                        </td>
                                        <td align="left"><%=custCredit.getPaymentDetails()%>
                                        </td>
                                        <td align="left"><%=custCredit.getPaymentAmount()%>
                                        </td>
                                        <td align="left"><%=custCredit.getPaymentDate()%>
                                        </td>
                                        <td align="left"><%=userCollectedBy.getUserFirstName()%>
                                        </td>
                                        <td align="left"><%=userEnteredBy.getUserFirstName()%>
                                        </td>
                                        <td align="left"><%=custCredit.getEnteredTime()%>
                                        </td>
                                        <td align="left"><%=strCreditOrDebit%>
                                        </td>
                                        <td align="left"><%=custCredit.getNotes()%>
                                        </td>
                                    </tr>
                                    <%
                                                }
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            HibernateUtil.closeSession(theSession);
                                        }
                                    %>
                                    <tr>
                                        <td></td>
                                    </tr>
                                </table>

                                <ul class="pagination">
                                    <c:forEach var="i" begin="${begin}" end="${end}">
                                        <li class="<c:if test="${i eq 1}">active</c:if>">
                                            <a onclick="update_customer_credit_list(${i})">${i}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
<body>
</body>
</html>