<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>

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
            String customerID = request.getParameter("customer");

            int nYear = 0, nMonth = -1;

            if (theMonth != null && !theMonth.isEmpty())
                nMonth = Integer.parseInt(theMonth);
            if (theYear != null && !theYear.isEmpty())
                nYear = Integer.parseInt(theYear);
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

            <select name="customer">
                <%
                    theSession = HibernateUtil.openSession();

                    String strQuery = "from TMasterCustomerinfo where Active_Status = 1 " +
                            " order by Customer_Group_ID, Customer_Company_Name";
                    Query query = theSession.createQuery(strQuery);
                    List customerList = query.list();

                    for (int i = 0; i < customerList.size(); i++) {
                        TMasterCustomerinfo custInfo = (TMasterCustomerinfo) customerList.get(i);
                        TMasterCustomerGroups custGroup = custInfo.getGroup();

                        String customerToDisplay = custInfo.getCompanyName() + " - " + custGroup.getName();
                %>
                <option value=<%=custInfo.getId()%>><%=customerToDisplay%>
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
        if (nYear > 0 && nMonth != -1) {
            String strMonthAndYear = months[nMonth] + ", " + nYear;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar cal = Calendar.getInstance();
            cal.set(nYear, nMonth, 01);
            String beginDate = sdf.format(cal.getTime());
            cal.set(nYear, nMonth + 1, 01);
            String endDate = sdf.format(cal.getTime());

            strQuery = "call SP_VAT_Report_By_Customer('" + beginDate + "', " + customerID + ")";

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Sale Type", new StringType());
            sqlQuery.addScalar("Group", new StringType());
            sqlQuery.addScalar("Customer", new StringType());
            sqlQuery.addScalar("Product", new StringType());
            sqlQuery.addScalar("Net Sales", new FloatType());
            sqlQuery.addScalar("VAT", new FloatType());
            sqlQuery.addScalar("Total Sales", new FloatType());
            sqlQuery.addScalar("Profit", new FloatType());
            sqlQuery.addScalar("VAT On Profit", new FloatType());
            sqlQuery.addScalar("Quantity", new IntegerType());
            List vatReport = sqlQuery.list();
    %>
    <div style="text-align: center;"><h3>VAT Report for the month of <%=strMonthAndYear%>
    </h3></div>
    <table border="1" width="100%">
        <tr>
            <td><b>Sale Type</b></td>
            <td><b>Customer Group</b></td>
            <td><b>Customer</b></td>
            <td><b>Product</b></td>
            <td><b>Quantity</b></td>
            <td><b>Net Sales</b></td>
            <td><b>VAT</b></td>
            <td><b>Total Sales</b></td>
            <td><b>Profit</b></td>
            <td><b>VAT on Profit</b></td>
        </tr>
        <%
            DecimalFormat df = new DecimalFormat("0.00");

            float fNetSalesSum = 0.0f;
            float fVATSum = 0.0f;
            float fTotalSalesSum = 0.0f;
            float fProfitSum = 0.0f;
            float fVATOnProfitSum = 0.0f;
            int nQuantitySum = 0;

            float fSaleTypeNetSalesSum = 0.0f;
            float fSaleTypeVATSum = 0.0f;
            float fSaleTypeTotalSalesSum = 0.0f;
            float fSaleTypeProfitSum = 0.0f;
            float fSaleTypeVATOnProfitSum = 0.0f;
            int nSaleTypeQuantitySum = 0;

            String prevSaleType = "0";
            String bgColor = "";

            for (int i = 0; i < vatReport.size(); i++) {
                Object[] oneRecord = (Object[]) vatReport.get(i);
                String strSaleType = oneRecord[0].toString();
                System.out.println(strSaleType);
                String strCustomerGroup = oneRecord[1].toString();
                String strCustomer = oneRecord[2].toString();
                String strProduct = oneRecord[3].toString();
                float fNetSales = (Float) oneRecord[4];
                float fVAT = (Float) oneRecord[5];
                float fTotalSales = (Float) oneRecord[6];
                float fProfit = (Float) oneRecord[7];
                float fVATOnProfit = (Float) oneRecord[8];
                int nQuantity = (Integer) oneRecord[9];

                if (prevSaleType.compareToIgnoreCase(strSaleType) != 0) {
                    // sale type changed

        %>
        <tr bgcolor="<%=bgColor%>">
            <td></td>
            <td></td>
            <td></td>
            <td><b><span style="color: blue; ">Subd Total</span></b></td>
            <td><b><span style="color: blue; "><%=nSaleTypeQuantitySum%>
            </span></b></td>
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
                nSaleTypeQuantitySum = 0;
            }

            fSaleTypeNetSalesSum += fNetSales;
            fSaleTypeVATSum += fVAT;
            fSaleTypeTotalSalesSum += fTotalSales;
            fSaleTypeProfitSum += fProfit;
            fSaleTypeVATOnProfitSum += fVATOnProfit;
            nSaleTypeQuantitySum += nQuantity;

            fNetSalesSum += fNetSales;
            fVATSum += fVAT;
            fTotalSalesSum += fTotalSales;
            fProfitSum += fProfit;
            fVATOnProfitSum += fVATOnProfit;
            nQuantitySum += nQuantity;

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
            } else if (strSaleType.compareToIgnoreCase("3") == 0) {
                prevSaleType = strSaleType;
                bgColor = "#58f7fa";
                strSaleTypeDisplay = "Mobile Unlocking";
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
            <td><%=strProduct%>
            <td><%=nQuantity%>
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
            <td></td>
            <td><b><span style="color: blue; ">Sub Total</span></b></td>
            <td><b><span style="color: blue; "><%=nSaleTypeQuantitySum%>
            </span></b></td>
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

        <tr bgcolor="#FA8258">
            <td></td>
            <td></td>
            <td></td>
            <td><b><span style="color: red; ">Total</span></b></td>
            <td><b><span style="color: blue; "><%=nQuantitySum%>
            </span></b></td>
            <td><b><span style="color: red; "><%=df.format(fNetSalesSum)%>
            </span></b></td>
            <td><b><span style="color: red; "><%=df.format(fVATSum)%>
            </span></b></td>
            <td><b><span style="color: red; "><%=df.format(fTotalSalesSum)%>
            </span></b></td>
            <td><b><span style="color: red; "><%=df.format(fProfitSum)%>
            </span></b></td>
            <td><b><span style="color: red; "><%=df.format(fVATOnProfitSum)%>
            </span></b></td>
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

<script src="${pageContext.request.contextPath}/js/validate.js"></script>
<script>
    function show_summary() {
        //document.the_form.action = "/masteradmin/VAT_Report_By_Customer.jsp";
        document.the_form.action = "/masteradmin/report/vat-by-customer";
        document.the_form.submit();
    }
</script>
