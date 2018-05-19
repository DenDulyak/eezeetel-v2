<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Ding Report</title>
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
                        <h1>Ding Transaction Report</h1>
                        <table class='table table-bordered'>
                            <tr>
                                <th>Transaction ID</th>
                                <th>Transaction Time</th>
                                <th>Customer Group</th>
                                <th>Customer</th>
                                <th>Customer Balance Before</th>
                                <th>Customer Balance After</th>
                                <th>Destination Country</th>
                                <th>Cost To Customer</th>
                                <th>Cost To Agent</th>
                                <th>Cost To Group</th>
                                <th>Cost To EezeeTel</th>
                                <th>Profit</th>
                                <th>EezeeTel Balance</th>
                            </tr>
                            <%
                                Session theSession = null;
                                try {
                                    theSession = HibernateUtil.openSession();

                                    Calendar cal = Calendar.getInstance();
                                    cal.set(Calendar.DAY_OF_MONTH, 1);
                                    cal.set(Calendar.HOUR_OF_DAY, 0);
                                    cal.set(Calendar.MINUTE, 0);
                                    cal.set(Calendar.SECOND, 0);

                                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    String beginDate = df.format(cal.getTime());

                                    String strQuery = "from TDingTransactions where Transaction_Time >= '" + beginDate +
                                            "' order by Transaction_Time desc";

                                    Query query = theSession.createQuery(strQuery);
                                    List report = query.list();


                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MMM-dd HH:mm:ss");

                                    float fTotalCostToCustomer = 0.0f;
                                    float fTotalCostToAgent = 0.0f;
                                    float fTotalCostToGroup = 0.0f;
                                    float fTotalCostToEezeeTel = 0.0f;
                                    BigDecimal totalProfit = new BigDecimal("0.00");

                                    for (int i = 0; i < report.size(); i++) {
                                        TDingTransactions theTrans = (TDingTransactions) report.get(i);
                                        Long transactionId = theTrans.getTransactionId();
                                        String strDate = sdf.format(theTrans.getTransactionTime());
                                        String strGroup = theTrans.getCustomer().getGroup().getName();
                                        int nCustomerGroupID = theTrans.getCustomer().getGroup().getId();
                                        String strCompany = theTrans.getCustomer().getCompanyName();
                                        float balanceBefore = theTrans.getTransactionBalance().getBalanceBeforeTransaction();
                                        float balanceAfter = theTrans.getTransactionBalance().getBalanceAfterTransaction();
                                        String strCountry = theTrans.getDestinationCountry();
                                        float costToCustomer = theTrans.getCostToCustomer();
                                        float costToAgent = theTrans.getCostToAgent();
                                        float costToGroup = theTrans.getCostToGroup();
                                        float costToEezeeTel = theTrans.getCostToEezeeTel();
                                        BigDecimal profit = new BigDecimal((costToGroup - costToEezeeTel) + "");
                                        if (nCustomerGroupID == 1)
                                            profit = new BigDecimal((costToAgent - costToEezeeTel) + "");
                                        float balance = theTrans.getEezeeTelBalance();

                                        profit = profit.setScale(2, BigDecimal.ROUND_HALF_UP);

                                        fTotalCostToCustomer += costToCustomer;
                                        fTotalCostToAgent += costToAgent;
                                        fTotalCostToGroup += costToGroup;
                                        fTotalCostToEezeeTel += costToEezeeTel;
                                        totalProfit = totalProfit.add(profit);
                            %>
                            <tr>
                                <td><%=transactionId%></td>
                                <td><%=strDate%></td>
                                <td><%=strGroup%></td>
                                <td><%=strCompany%></td>
                                <td><%=balanceBefore%></td>
                                <td><%=balanceAfter%></td>
                                <td><%=strCountry%></td>
                                <td><%=costToCustomer%></td>
                                <td><%=costToAgent%></td>
                                <td><%=costToGroup%></td>
                                <td><%=costToEezeeTel%></td>
                                <td><%=profit%></td>
                                <td><%=balance%></td>
                            </tr>
                            <%
                                }
                            %>
                            <tr class="info">
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td>Total</td>
                                <td><%=fTotalCostToCustomer%></td>
                                <td><%=fTotalCostToAgent%></td>
                                <td><%=fTotalCostToGroup%></td>
                                <td><%=fTotalCostToEezeeTel%></td>
                                <td><%=totalProfit%></td>
                                <td></td>
                            </tr>
                            <%
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    HibernateUtil.closeSession(theSession);
                                }
                            %>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>