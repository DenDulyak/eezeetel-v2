<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="../common/libs.jsp"/>
    <meta charset="utf-8">
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function update_customer_group_credit_list() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get customer group credit information");
                return;
            }

            var customerGroupID = 0;
            if (document.the_form.customer_group_list != null)
                customerGroupID = document.the_form.customer_group_list.value;
            var status = document.the_form.credit_status.value;


            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('customer_group_credit_info');
                    element.innerHTML = "";
                    element.innerHTML = httpObj.responseText;
                    ;
                }
            }

            var url = "AJAX_GetCustomerGroupCredit.jsp?customer_group_id=" + customerGroupID + "&credit_status=" + status;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function ModifyCredit() {
            var action_page = "/masteradmin/groupmanage/ModifyCustomerGroupCredit.jsp?credit_id=";

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
    <title>List, Modify, Customer Group Credit</title>
</head>
<section id="container">
    <c:import url="../common/header.jsp"/>
    <c:import url="../common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <form name="the_form" method="post" action="">
                            <%
                                String strStatus = request.getParameter("credit_status");
                                int nStatus = -1;
                                if (strStatus != null && !strStatus.isEmpty())
                                    nStatus = Integer.parseInt(strStatus);

                                Session theSession = null;
                                try {
                                    theSession = HibernateUtil.openSession();

                            %>

                            <table width="100%">
                                <tr>
                                    <td align="right"> Customer Group :</td>
                                    <td>

                                        <select name="customer_group_list" id="customer_group_list_id"
                                                onchange="update_customer_group_credit_list()">
                                            <option value="0">All</option>
                                            <%
                                                String strQuery = "from TMasterCustomerGroups where IsActive = 1 order by Customer_Group_Name";
                                                Query query = theSession.createQuery(strQuery);
                                                List records = query.list();
                                                for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                                    TMasterCustomerGroups custGroup = (TMasterCustomerGroups) records.get(nIndex);
                                            %>
                                            <option value="<%=custGroup.getId()%>"><%=custGroup.getName()%>
                                                - <%=custGroup.getCustomerGroupBalance()%>
                                            </option>
                                            <%
                                                }
                                            %>
                                        </select>

                                    </td>

                                    <td align="right">Status :</td>
                                    <td>
                                        <select name="credit_status" onchange="update_customer_group_credit_list()">
                                            <option value="-1">All</option>
                                            <option value="0">Just Added (DEBIT)</option>
                                            <option value="1">Pending Credit Update</option>
                                            <option value="2">Processed Credit Update</option>
                                        </select>
                                    </td>

                                    <td align="center">

                                    </td>

                                    <td align="center">
                                        <input type="button" name="add_button" value="Add" class="btn"
                                               OnClick="SubmitForm('NewCustomerGroupCredit.jsp', false);">
                                    </td>
                                </tr>
                            </table>

                            <div id="customer_group_credit_info">
                                <table class="table table-bordered">
                                    <tr bgcolor="#99CCFF">
                                        <th>Group Credit ID</th>
                                        <th>Customer Group</th>
                                        <th>Payment Type</th>
                                        <th>Payment Details</th>
                                        <th>Payment Amount</th>
                                        <th>Payment Received Date</th>
                                        <th>Collected By</th>
                                        <th>Entered By</th>
                                        <th>Topup Date</th>
                                        <th>redit OR Debit</th>
                                        <th>Notes</th>
                                    </tr>

                                    <%
                                        strQuery = "from TMasterCustomerGroupCredit where Entered_Time > '2011-01-01 00:00:00'";
                                        if (nStatus != -1) {
                                            if (nStatus == 0)
                                                strQuery += (" and Credit_or_Debit = 2 ");
                                            else
                                                strQuery += (" and Credit_ID_Status = " + nStatus);
                                        }
                                        strQuery += " order by Entered_Time desc";

                                        query = theSession.createQuery(strQuery);
                                        records = query.list();

                                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                            TMasterCustomerGroupCredit custGruopCredit = (TMasterCustomerGroupCredit) records.get(nIndex);
                                            TMasterCustomerGroups groupInfo = custGruopCredit.getGroup();
                                            String userCollectedBy = custGruopCredit.getCollectedBy().getUserFirstName();
                                            String userEnteredBy = custGruopCredit.getEnteredBy().getUserFirstName();

                                            String strPaymentType = "Not Paid Yet";
                                            switch (custGruopCredit.getPaymentType()) {
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

                                            String strBgColor = "danger";
                                            String strCreditOrDebit = "DEBIT";
                                            if (custGruopCredit.getCreditOrDebit() == 1) {
                                                strCreditOrDebit = "Credit";
                                                strBgColor = "";
                                            }
                                    %>
                                    <tr class="<%=strBgColor%>">
                                        <td align="right">
                                            <a href="/masteradmin/groupmanage/ModifyCustomerGroupCredit.jsp?credit_id=<%=custGruopCredit.getId()%>"><%=custGruopCredit.getId()%>
                                            </a>
                                            <input type="hidden" name="record_id"
                                                   value="<%=custGruopCredit.getId()%>">
                                        </td>

                                        <td align="left"><%=groupInfo.getName()%>
                                        </td>
                                        <td align="left"><%=strPaymentType%>
                                        </td>
                                        <td align="left"><%=custGruopCredit.getPaymentDetails()%>
                                        </td>
                                        <td align="left"><%=custGruopCredit.getPaymentAmount()%>
                                        </td>
                                        <td align="left"><%=custGruopCredit.getPaymentDate()%>
                                        </td>
                                        <td align="left"><%=userCollectedBy%>
                                        </td>
                                        <td align="left"><%=userEnteredBy%>
                                        </td>
                                        <td align="left"><%=custGruopCredit.getEnteredTime()%>
                                        </td>
                                        <td align="left"><%=strCreditOrDebit%>
                                        </td>
                                        <td align="left"><%=custGruopCredit.getNotes()%>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            HibernateUtil.closeSession(theSession);
                                        }
                                    %>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
<body>
</body>
</html>