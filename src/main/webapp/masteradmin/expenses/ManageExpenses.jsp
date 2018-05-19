<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="../common/libs.jsp"/>
    <meta charset="utf-8">
    <script language="javascript" src="/js/validate.js"></script>
    <meta http-equiv="refresh" content="300"/>
    <title>Manage Expenses</title>
    <script language="javascript">
        function addExpense() {
            document.the_form.action = "/masteradmin/expenses/AddExpense.jsp";
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
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <%
                            Session theSession = null;
                            try {
                                theSession = HibernateUtil.openSession();

                                SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

                                String strQuery = "from TMasterExpenses order by Payment_Date desc, Expense_ID desc";
                                Query query = theSession.createQuery(strQuery);
                                List list = query.list();
                        %>
                        <table width="100%" border="1">
                            <tr>
                                <th>Expense ID</th>
                                <th>Expense Purpose</th>
                                <th>Payment Date</th>
                                <th>Payment Amount</th>
                                <th>Receipt Path</th>
                            </tr>
                            <%
                                for (int i = 0; i < list.size(); i++) {
                                    TMasterExpenses theExpense = (TMasterExpenses) list.get(i);
                                    String receiptPath = theExpense.getReceiptPath();

                            %>
                            <tr>
                                <td><%=theExpense.getId()%>
                                </td>
                                <td><%=theExpense.getExpensePurpose()%>
                                </td>
                                <td><%=theExpense.getPaymentDate()%>
                                </td>
                                <td><%=theExpense.getPaymentAmount()%>
                                </td>
                                <td>
                                    <%
                                        if (receiptPath != null && !receiptPath.isEmpty()) {
                                    %>
                                    <a href="<%=receiptPath%>">Receipt </a>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </table>
                        <%
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                HibernateUtil.closeSession(theSession);
                            }
                        %>

                        <form name="the_form" method="post" action="">
                            <input type="button" name="add_expense" OnClick="addExpense()" value="Add"/>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>