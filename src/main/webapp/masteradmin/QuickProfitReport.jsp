<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Quick Profit Report</title>
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
                        <%
                            if (!request.isUserInRole("Employee_Master_Admin")) {
                                response.getWriter().println("Permission Denied");
                                return;
                            }

                            String strQuery = "from TReportEezeetelProfit order by Begin_Date desc, Customer_Group_ID";

                            Session theSession = null;
                            try {
                                theSession = HibernateUtil.openSession();
                                Query Query = theSession.createQuery(strQuery);
                                List report = Query.list();
                        %>

                        <form name="the_form" method="post">
                            <table class="table table-bordered">
                                <tr>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Customer Group</th>
                                    <th>Total Customers</th>
                                    <th>Total Calling Card Transactions</th>
                                    <th>Total World Mobile Transactions</th>
                                    <th>Total Local Mobile Transactions</th>
                                    <th>Profit From Calling Cards</th>
                                    <th>Profit From World Mobile Topup</th>
                                    <th>Profit From Local Mobile Vouchers</th>
                                    <th>Total Profit</th>
                                    <th>Total All Groups Profit</th>
                                    <th>Daily Average</th>
                                </tr>
                                <%
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MMMMMMMM", Locale.ENGLISH);
                                    int nTotalCustomers = 0;
                                    int nTotalCards = 0;
                                    int nTotalWorldMobile = 0;
                                    int nTotalLocalMobile = 0;
                                    float fTotalCallingCardsProfit = 0;
                                    float fTotalWorldMobileProfit = 0;
                                    float fTotalLocalMobileProfit = 0;
                                    float fTotalProfit = 0;
                                    float fTotalMonthlyProfit = 0.0f;

                                    for (int i = 0; i < report.size(); i++) {
                                        TReportEezeetelProfit oneProfit = (TReportEezeetelProfit) report.get(i);
                                        String strGroupName = oneProfit.getGroup().getName();

                                        nTotalCustomers += oneProfit.getTotalCustomers();
                                        nTotalCards += oneProfit.getTotalCards();
                                        nTotalWorldMobile += oneProfit.getTotalWorldMobileTransactions();
                                        nTotalLocalMobile += oneProfit.getTotalLocalMobileTransactions();
                                        fTotalCallingCardsProfit += oneProfit.getProfitFromCallingCards();
                                        fTotalWorldMobileProfit += oneProfit.getProfitFromWorldMobile();
                                        fTotalLocalMobileProfit += oneProfit.getProfitFromLocalMobile();

                                        float fLineTotalProfit = oneProfit.getProfitFromCallingCards() + oneProfit.getProfitFromWorldMobile() + oneProfit.getProfitFromLocalMobile();
                                        fTotalProfit += fLineTotalProfit;
                                        fTotalMonthlyProfit += fLineTotalProfit;

                                        String strMonthlyProfit = "", strDailyAverage = "";
                                        if (i + 1 >= report.size()) // last record
                                        {
                                            Calendar cal = Calendar.getInstance();
                                            cal.setTime(oneProfit.getBeginDate());
                                            int nTotalDays = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                                            strMonthlyProfit = new DecimalFormat("0.00").format((double) fTotalMonthlyProfit);
                                            strDailyAverage = new DecimalFormat("0.00").format((double) (fTotalMonthlyProfit / nTotalDays));
                                            fTotalMonthlyProfit = 0;
                                        } else {
                                            TReportEezeetelProfit nextProfit = (TReportEezeetelProfit) report.get(i + 1);

                                            if (nextProfit != null && nextProfit.getBeginDate().before(oneProfit.getBeginDate())) {
                                                int nTotalDays = 0;
                                                Calendar cal = Calendar.getInstance();
                                                cal.setTime(oneProfit.getBeginDate());
                                                Calendar currentCal = Calendar.getInstance();
                                                if (cal.get(Calendar.YEAR) == currentCal.get(Calendar.YEAR) && cal.get(Calendar.MONTH) == currentCal.get(Calendar.MONTH)) {
                                                    // this is for current month.  just take days so far
                                                    nTotalDays = currentCal.get(Calendar.DAY_OF_MONTH);
                                                } else {
                                                    nTotalDays = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                                                }
                                                strMonthlyProfit = new DecimalFormat("0.00").format((double) fTotalMonthlyProfit);
                                                strDailyAverage = new DecimalFormat("0.00").format((double) (fTotalMonthlyProfit / nTotalDays));
                                                fTotalMonthlyProfit = 0;
                                            }
                                        }
                                %>
                                <tr>
                                    <td><%=sdf.format(oneProfit.getBeginDate())%>
                                    </td>
                                    <td><%=sdf.format(oneProfit.getEndDate())%>
                                    </td>
                                    <td><%=strGroupName%>
                                    </td>
                                    <td><%=oneProfit.getTotalCustomers()%>
                                    </td>
                                    <td><%=oneProfit.getTotalCards()%>
                                    </td>
                                    <td><%=oneProfit.getTotalWorldMobileTransactions()%>
                                    </td>
                                    <td><%=oneProfit.getTotalLocalMobileTransactions()%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) oneProfit.getProfitFromCallingCards())%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) oneProfit.getProfitFromWorldMobile())%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) oneProfit.getProfitFromLocalMobile())%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) fLineTotalProfit)%>
                                    </td>
                                    <td><%=strMonthlyProfit%>
                                    </td>
                                    <td><%=strDailyAverage%>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr bgcolor="#d3d3d3">
                                    <td></td>
                                    <td></td>
                                    <td>Total</td>
                                    <td><%=nTotalCustomers%>
                                    </td>
                                    <td><%=nTotalCards%>
                                    </td>
                                    <td><%=nTotalWorldMobile%>
                                    </td>
                                    <td><%=nTotalLocalMobile%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) fTotalCallingCardsProfit)%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) fTotalWorldMobileProfit)%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) fTotalLocalMobileProfit)%>
                                    </td>
                                    <td><%=new DecimalFormat("0.00").format((double) fTotalProfit)%>
                                    </td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </form>
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