<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>
    <title>VAT Report</title>
    <style>
        @media print {
            .no-print {
                display: none;
            }

            @page {
                margin: 10px;
            }
        }
    </style>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function show_summary() {
            document.the_form.action = "/masteradmin/VATReport.jsp";
            document.the_form.submit();
        }
    </script>
</head>
<body>
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-9 col-md-12">
                    <div class="container">
                        <%
                            if (!request.isUserInRole("Employee_Master_Admin")) {
                                response.getWriter().println("Permission Denied");
                                return;
                            }

                            Session theSession = null;

                            try {
                                String theMonth = request.getParameter("the_month");
                                String theYear = request.getParameter("the_year");
                                String theGroup = request.getParameter("the_group");

                                int nYear = 0, nMonth = -1, custGroupID = -1;

                                if (theMonth != null && !theMonth.isEmpty())
                                    nMonth = Integer.parseInt(theMonth);
                                if (theYear != null && !theYear.isEmpty())
                                    nYear = Integer.parseInt(theYear);
                                if (theGroup != null && !theGroup.isEmpty())
                                    custGroupID = Integer.parseInt(theGroup);

                                theSession = HibernateUtil.openSession();

                                String queryString = "from TMasterCustomerGroups where active = 1";
                                Query groupQuery = theSession.createQuery(queryString);
                                List groupsList = groupQuery.list();

                                String[] months = {"January", "February",
                                        "March", "April", "May", "June", "July",
                                        "August", "September", "October", "November",
                                        "December"};

                                Calendar calNew = Calendar.getInstance();
                                int nCurrentYear = calNew.get(Calendar.YEAR);
                                int startYear = 2010;

                        %>

                        <form name="the_form" action="" method="post">
                            <div id="nav">
                                Month :
                                <select name="the_month">
                                    <%
                                        for (int i = 0; i < 12; i++) {
                                    %>
                                    <option value="<%=i%>"><%=months[i]%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
                                Year :
                                <select name="the_year">
                                    <%
                                        for (int i = nCurrentYear; i >= startYear; i--) {
                                    %>
                                    <option value="<%=i%>"><%=i%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>

                                Group :
                                <select name="the_group">
                                    <%
                                        for (int i = 0; i < groupsList.size(); i++) {
                                            TMasterCustomerGroups group = (TMasterCustomerGroups) groupsList.get(i);
                                    %>
                                    <option value="<%=group.getId()%>">
                                        <%=group.getName()%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>

                                <input type="button" name="generate_button" value="Generate" onClick="show_summary()">
                                <hr>
                            </div>
                        </form>
                        <%
                            if (nYear > 0 && nMonth != -1 && custGroupID != -1) {

                                String strMonthAndYear = months[nMonth] + ", " + nYear;
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                Calendar cal = Calendar.getInstance();
                                cal.set(nYear, nMonth, 01);
                                String beginDate = sdf.format(cal.getTime());
                                cal.set(nYear, nMonth + 1, 01);
                                String endDate = sdf.format(cal.getTime());

                                String strQuery = "call SP_VAT_Report_New('" + beginDate + "'," + custGroupID + ")";
                                SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                                sqlQuery.addScalar("Sale Type", new StringType());
                                sqlQuery.addScalar("Group", new StringType());
                                sqlQuery.addScalar("Customer", new StringType());
                                sqlQuery.addScalar("Net Sales", new FloatType());
                                sqlQuery.addScalar("VAT", new FloatType());
                                sqlQuery.addScalar("Total Sales", new FloatType());
                                sqlQuery.addScalar("Profit", new FloatType());
                                sqlQuery.addScalar("VAT On Profit", new FloatType());
                                List vatReport = sqlQuery.list();
                        %>
                        <div style="text-align: center;">
                            <h3>VAT Report for the month of <%=strMonthAndYear%>
                            </h3>
                        </div>
                        <table border="1" width="100%">
                            <tr>
                                <th>Sale Type</th>
                                <th>Customer Group</th>
                                <th>Customer</th>
                                <th>Net Sales</th>
                                <th>VAT</th>
                                <th>Total Sales</th>
                                <th>Profit</th>
                                <th>VAT on Profit</th>
                            </tr>
                            <%
                                DecimalFormat df = new DecimalFormat("0.00");

                                float fNetSalesSum = 0.0f;
                                float fVATSum = 0.0f;
                                float fTotalSalesSum = 0.0f;
                                float fProfitSum = 0.0f;
                                float fVATOnProfitSum = 0.0f;

                                float fSaleTypeNetSalesSum = 0.0f;
                                float fSaleTypeVATSum = 0.0f;
                                float fSaleTypeTotalSalesSum = 0.0f;
                                float fSaleTypeProfitSum = 0.0f;
                                float fSaleTypeVATOnProfitSum = 0.0f;

                                String prevSaleType = "0";
                                String bgColor = "";

                                for (int i = 0; i < vatReport.size(); i++) {
                                    Object[] oneRecord = (Object[]) vatReport.get(i);
                                    String strSaleType = oneRecord[0].toString();
                                    String strCustomerGroup = oneRecord[1].toString();
                                    String strCustomer = oneRecord[2].toString();
                                    float fNetSales = (Float) oneRecord[3];
                                    float fVAT = (Float) oneRecord[4];
                                    float fTotalSales = (Float) oneRecord[5];
                                    float fProfit = (Float) oneRecord[6];
                                    float fVATOnProfit = (Float) oneRecord[7];

                                    if (prevSaleType.compareToIgnoreCase(strSaleType) != 0) {
                            %>
                            <tr bgcolor="<%=bgColor%>">
                                <td></td>
                                <td></td>
                                <td><b><span style="color: blue; ">Sub Total</span></b></td>
                                <td><b><span style="color: blue; "><%=df.format(fSaleTypeNetSalesSum)%>
                                </span></b></td>
                                <td><b><span style="color: blue; "><%=df.format(fSaleTypeVATSum)%>
                                </span></b></td>
                                <td><b><span style="color: blue; "><%=df.format(fSaleTypeTotalSalesSum)%>
                                </span></b></td>
                                <td><b><span style="color: blue; "><%=df.format(fSaleTypeProfitSum)%>
                                </span></b></td>
                                <td><b><span style="color: blue; "><%=df.format(fSaleTypeVATOnProfitSum)%>
                                </span></b></td>
                            </tr>
                            <%

                                    fSaleTypeNetSalesSum = 0.0f;
                                    fSaleTypeVATSum = 0.0f;
                                    fSaleTypeTotalSalesSum = 0.0f;
                                    fSaleTypeProfitSum = 0.0f;
                                    fSaleTypeVATOnProfitSum = 0.0f;
                                }

                                fSaleTypeNetSalesSum += fNetSales;
                                fSaleTypeVATSum += fVAT;
                                fSaleTypeTotalSalesSum += fTotalSales;
                                fSaleTypeProfitSum += fProfit;
                                fSaleTypeVATOnProfitSum += fVATOnProfit;

                                fNetSalesSum += fNetSales;
                                fVATSum += fVAT;
                                fTotalSalesSum += fTotalSales;
                                fProfitSum += fProfit;
                                fVATOnProfitSum += fVATOnProfit;

                                String strSaleTypeDisplay = "";
                                String strVATDisplay = "";
                                String strVATOnProfitDisplay = "";

                                if (strSaleType.compareToIgnoreCase("0") == 0) {
                                    prevSaleType = strSaleType;
                                    bgColor = "#D8F781";
                                    strSaleTypeDisplay = "VAT Product";
                                    strVATDisplay = df.format(fVAT);
                                    strVATOnProfitDisplay = df.format(fVATOnProfit);
                                } else if (strSaleType.compareToIgnoreCase("1") == 0) {
                                    prevSaleType = strSaleType;
                                    bgColor = "#58FAAC";
                                    strSaleTypeDisplay = "Non VAT Product";
                                    strVATDisplay = "NIL";
                                    strVATOnProfitDisplay = "NIL";

                                } else if (strSaleType.compareToIgnoreCase("2") == 0) {
                                    prevSaleType = strSaleType;
                                    bgColor = "#00BFFF";
                                    strSaleTypeDisplay = "3R Product";
                                    strVATDisplay = "NIL";
                                    strVATOnProfitDisplay = "NIL";
                                }

                            %>
                            <tr bgcolor="<%=bgColor%>">
                                <td><%=strSaleTypeDisplay%>
                                </td>
                                <td><%=strCustomerGroup%>
                                </td>
                                <td><%=strCustomer%>
                                </td>
                                <td><%=df.format(fNetSales)%>
                                </td>
                                <td><%=strVATDisplay%>
                                </td>
                                <td><%=df.format(fTotalSales)%>
                                </td>
                                <td><%=df.format(fProfit)%>
                                </td>
                                <td><%=strVATOnProfitDisplay%>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr bgcolor="<%=bgColor%>">
                                <td></td>
                                <td></td>
                                <td><b><span style="color: blue; ">Sub Total</span></b></td>
                                <td><b><span style="color: blue; "><%=df.format(fSaleTypeNetSalesSum)%>
                                </span></b></td>
                                <td><b><font color="blue"><%=df.format(fSaleTypeVATSum)%>
                                </font></b></td>
                                <td><b><font color="blue"><%=df.format(fSaleTypeTotalSalesSum)%>
                                </font></b></td>
                                <td><b><font color="blue"><%=df.format(fSaleTypeProfitSum)%>
                                </font></b></td>
                                <td><b><font color="blue"><%=df.format(fSaleTypeVATOnProfitSum)%>
                                </font></b></td>
                            </tr>

                            <tr bgcolor="#FA8258">
                                <td></td>
                                <td></td>
                                <td><b><font color="red">Total</font></b></td>
                                <td><b><font color="red"><%=df.format(fNetSalesSum)%>
                                </font></b></td>
                                <td><b><font color="red"><%=df.format(fVATSum)%>
                                </font></b></td>
                                <td><b><font color="red"><%=df.format(fTotalSalesSum)%>
                                </font></b></td>
                                <td><b><font color="red"><%=df.format(fProfitSum)%>
                                </font></b></td>
                                <td><b><font color="red"><%=df.format(fVATOnProfitSum)%>
                                </font></b></td>
                            </tr>
                        </table>
                        <%
                                }
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
