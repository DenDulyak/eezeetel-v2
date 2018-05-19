<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>TransferTo Report</title>
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
                        <h1>Transfer-To Transaction Report</h1>
                        <table border="1">
                            <tr>
                                <th> Transaction Time</th>
                                <th> Customer Group</th>
                                <th> Customer</th>
                                <th> Destination Country</th>
                                <th> Cost To Customer</th>
                                <th> Cost To Agent</th>
                                <th> Cost To Group</th>
                                <th> Cost To EezeeTel</th>
                                <th> Profit</th>
                                <th> EezeeTel Balance</th>
                            </tr>
                            <%
                                Session theSession = null;
                                try {
                                    theSession = HibernateUtil.openSession();

                                    Calendar cal = Calendar.getInstance();
                                    //cal.set(Calendar.DAY_OF_MONTH, 1);
                                    cal.set(Calendar.HOUR_OF_DAY, 0);
                                    cal.set(Calendar.MINUTE, 0);
                                    cal.set(Calendar.SECOND, 0);

                                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    String beginDate = df.format(cal.getTime());

                                    String strQuery = "from TTransfertoTransactions where Transaction_Time >= '" + beginDate +
                                            "' order by Transaction_Time desc";

                                    Query query = theSession.createQuery(strQuery);
                                    List report = query.list();


                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MMM-dd HH:mm:ss");

                                    float fTotalCostToCustomer = 0.0f;
                                    float fTotalCostToAgent = 0.0f;
                                    float fTotalCostToGroup = 0.0f;
                                    float fTotalCostToEezeeTel = 0.0f;
                                    float fTotalProfit = 0.0f;

                                    for (int i = 0; i < report.size(); i++) {
                                        TTransfertoTransactions theTrans = (TTransfertoTransactions) report.get(i);
                                        String strDate = sdf.format(theTrans.getTransactionTime());
                                        String strGroup = theTrans.getCustomer().getGroup().getName();
                                        String strCompany = theTrans.getCustomer().getCompanyName();
                                        String strCountry = theTrans.getDestinationCountry();
                                        float costToCustomer = theTrans.getCostToCustomer();
                                        float costToAgent = theTrans.getCostToAgent();
                                        float costToGroup = theTrans.getCostToGroup();
                                        float costToEezeeTel = theTrans.getCostToEezeeTel();
                                        float profit = costToGroup - costToEezeeTel;
                                        float balance = theTrans.getEezeeTelBalance();

                                        fTotalCostToCustomer += costToCustomer;
                                        fTotalCostToAgent += costToAgent;
                                        fTotalCostToGroup += costToGroup;
                                        fTotalCostToEezeeTel += costToEezeeTel;
                                        fTotalProfit += profit;
                            %>
                            <tr>
                                <td><%=strDate%>
                                </td>
                                <td><%=strGroup%>
                                </td>
                                <td><%=strCompany%>
                                </td>
                                <td><%=strCountry%>
                                </td>
                                <td><%=costToCustomer%>
                                </td>
                                <td><%=costToAgent%>
                                </td>
                                <td><%=costToGroup%>
                                </td>
                                <td><%=costToEezeeTel%>
                                </td>
                                <td><%=profit%>
                                </td>
                                <td><%=balance%>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr bgcolor="red">
                                <td></td>
                                <td></td>
                                <td></td>
                                <td>Total</td>
                                <td><%=fTotalCostToCustomer%>
                                </td>
                                <td><%=fTotalCostToAgent%>
                                </td>
                                <td><%=fTotalCostToGroup%>
                                </td>
                                <td><%=fTotalCostToEezeeTel%>
                                </td>
                                <td><%=fTotalProfit%>
                                </td>
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