<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Product Sale Report</title>
    <script language="javascript">
        function Generate() {
            if (document.the_form.selected_year.value == 0 || document.the_form.selected_month.value == 0) {
                alert("Please select an year and month");
                return;
            }
            document.the_form.action = "ProductSaleReport.jsp";
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
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <form name="the_form" method="post" action="">
                            <%
                                String strSelectedYear = request.getParameter("selected_year");
                                String strSelectedMonth = request.getParameter("selected_month");
                                String strSupplierID = request.getParameter("supplier");

                                int nSelectedYear = 0;
                                if (strSelectedYear != null && !strSelectedYear.isEmpty())
                                    nSelectedYear = Integer.parseInt(strSelectedYear);

                                int nSelectedMonth = 0;
                                if (strSelectedMonth != null && !strSelectedMonth.isEmpty())
                                    nSelectedMonth = Integer.parseInt(strSelectedMonth);

                                int nSupplierId = 0;
                                if (strSupplierID != null && !strSupplierID.isEmpty())
                                    nSupplierId = Integer.parseInt(strSupplierID);

                                Calendar cal = Calendar.getInstance();
                                int nCurrentYear = cal.get(Calendar.YEAR);
                                int nPreviousYear = nCurrentYear - 1;
                                int nMonth = cal.get(Calendar.MONTH);
                                nMonth += 1;
                            %>
                            <table width="100%">
                                <tr>
                                    <td>
                                        Start Year : <select name="selected_year">
                                        <option value="0" <%=((nSelectedYear == 0) ? "selected" : "")%>>Select</option>
                                        <option value="<%=nCurrentYear%>" <%=((nCurrentYear == nSelectedYear) ? "selected" : "")%>><%=nCurrentYear%>
                                        </option>
                                        <option value="<%=nPreviousYear%>" <%=((nPreviousYear == nSelectedYear) ? "selected" : "")%>><%=nPreviousYear%>
                                        </option>
                                    </select>
                                    </td>
                                    <td>
                                        Start Month : <select name="selected_month">
                                        <option value="0" <%=((0 == nSelectedMonth) ? "selected" : "")%>>Select</option>
                                        <option value="1" <%=((1 == nSelectedMonth) ? "selected" : "")%>>January</option>
                                        <option value="2" <%=((2 == nSelectedMonth) ? "selected" : "")%>>February</option>
                                        <option value="3" <%=((3 == nSelectedMonth) ? "selected" : "")%>>March</option>
                                        <option value="4" <%=((4 == nSelectedMonth) ? "selected" : "")%>>April</option>
                                        <option value="5" <%=((5 == nSelectedMonth) ? "selected" : "")%>>May</option>
                                        <option value="6" <%=((6 == nSelectedMonth) ? "selected" : "")%>>June</option>
                                        <option value="7" <%=((7 == nSelectedMonth) ? "selected" : "")%>>July</option>
                                        <option value="8" <%=((8 == nSelectedMonth) ? "selected" : "")%>>August</option>
                                        <option value="9" <%=((9 == nSelectedMonth) ? "selected" : "")%>>September</option>
                                        <option value="10" <%=((10 == nSelectedMonth) ? "selected" : "")%>>October</option>
                                        <option value="11" <%=((11 == nSelectedMonth) ? "selected" : "")%>>November</option>
                                        <option value="12" <%=((12 == nSelectedMonth) ? "selected" : "")%>>December</option>
                                    </select>
                                    </td>
                                    <%
                                        Session theSession = null;
                                        try {
                                            theSession = HibernateUtil.openSession();
                                            String strQuery0 = "from TMasterSupplierinfo order by Supplier_Name";
                                            Query query0 = theSession.createQuery(strQuery0);
                                            List suppliersList = query0.list();
                                    %>
                                    <td>
                                        Supplier : <select name="supplier">
                                        <option value="0" <%=((0 == nSupplierId) ? "selected" : "")%>>Select</option>
                                        <%
                                            for (int i = 0; i < suppliersList.size(); i++) {
                                                TMasterSupplierinfo supplier = (TMasterSupplierinfo) suppliersList.get(i);
                                                String strSelected = "";
                                                if (supplier.getId() == nSupplierId) strSelected = "selected";
                                        %>
                                        <option value="<%=supplier.getId()%>" <%=strSelected%>><%=supplier.getSupplierName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    </td>
                                    <td>
                                        <input type="button" name="generate" value="Generate" onClick="Generate()">
                                    </td>
                                </tr>
                                <%
                                    int nCustomerGroupId = 4;
                                    if (nSelectedMonth > 0 && nSelectedYear > 0 && nSupplierId > 0) {
                                %>
                                <tr>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>KAS Sales</th>
                                    <th>Other's Sales</th>
                                    <th>Total Sales</th>
                                    <th>KAS Amount</th>
                                    <th>Other's Amount</th>
                                    <th>Total Amount</th>
                                </tr>
                                <%
                                    cal.set(nSelectedYear, nSelectedMonth - 1, 1, 0, 0, 0);
                                    Date dtStart = cal.getTime();
                                    cal.add(Calendar.MONTH, 1);
                                    Date dtEnd = cal.getTime();

                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    String strStartDate = sdf.format(dtStart);
                                    String strEndDate = sdf.format(dtEnd);

                                    DecimalFormat df = new DecimalFormat("0.00");
                                    float totalAmount = 0.0f;
                                    float totalKASAmount = 0.0f;
                                    float totalOthersAmount = 0.0f;

                                    String strQuery = "from TMasterProductinfo where Supplier_ID = " + nSupplierId;
                                    Query query3 = theSession.createQuery(strQuery);
                                    List prodList = query3.list();
                                    for (int i = 0; i < prodList.size(); i++) {
                                        TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(i);

                                        strQuery = " select sum(Quantity) as q from " +
                                                "(select * from t_batch_information where Batch_Entry_Time >= '" + strStartDate + "'" +
                                                " and Batch_Entry_Time < '" + strEndDate + "' and " +
                                                " Product_ID = " + prodInfo.getId() +
                                                " union " +
                                                "select * from t_history_batch_information where Batch_Entry_Time >= '" + strStartDate + "'" +
                                                " and Batch_Entry_Time < '" + strEndDate + "' and " +
                                                " Product_ID = " + prodInfo.getId() + ") as kp";

                                        SQLQuery query = theSession.createSQLQuery(strQuery);
                                        query.addScalar("q", new IntegerType());
                                        List batchList = query.list();
                                        if (batchList == null || batchList.size() == 0) continue;
                                        Integer quantity = (Integer) batchList.get(0);
                                        if (quantity == null)
                                            quantity = 0;

                                        strQuery = "from TBatchInformation where Product_ID = " + prodInfo.getId();
                                        Query query4 = theSession.createQuery(strQuery);
                                        List batchCostList = query4.list();
                                        if (batchCostList == null || batchCostList.size() == 0) continue;
                                        TBatchInformation batchInfo = (TBatchInformation) batchCostList.get(0);
                                        Float unit_cost = (Float) batchInfo.getBatchCost();

                                        strQuery = "select sum(Total) as TheTotal from (" +
                                                "select sum(Quantity) as Total from t_transactions where Product_ID = " + prodInfo.getId() +
                                                " and Transaction_Time >= '" + strStartDate + "' and Transaction_Time < '" + strEndDate + "'" +
                                                " and Committed = 1 and Customer_ID in (select Customer_ID from t_master_customerinfo " +
                                                " where Customer_Group_ID = " + nCustomerGroupId + ")" +
                                                " union " +
                                                "select sum(Quantity) as Total from t_history_transactions where Product_ID = " + prodInfo.getId() +
                                                " and Transaction_Time >= '" + strStartDate + "' and Transaction_Time < '" + strEndDate + "'" +
                                                " and Committed = 1 and Customer_ID in (select Customer_ID from t_master_customerinfo " +
                                                " where Customer_Group_ID = " + nCustomerGroupId + ")) as pp";

                                        SQLQuery query1 = theSession.createSQLQuery(strQuery);
                                        query1.addScalar("TheTotal", new IntegerType());
                                        List groupSaleQuantity = query1.list();
                                        if (groupSaleQuantity == null || groupSaleQuantity.size() == 0) continue;
                                        Integer nTotal = (Integer) groupSaleQuantity.get(0);
                                        if (nTotal == null) nTotal = 0;
                                        float fGroupAmount = nTotal * unit_cost;
                                        strQuery = "select sum(Total) as TheTotal from (" +
                                                "select sum(Quantity) as Total from t_transactions where Product_ID = " + prodInfo.getId() +
                                                " and Transaction_Time >= '" + strStartDate + "' and Transaction_Time < '" + strEndDate + "'" +
                                                " and Committed = 1 and Customer_ID in (select Customer_ID from t_master_customerinfo " +
                                                " where Customer_Group_ID != " + nCustomerGroupId + ")" +
                                                " union " +
                                                "select sum(Quantity) as Total from t_history_transactions where Product_ID = " + prodInfo.getId() +
                                                " and Transaction_Time >= '" + strStartDate + "' and Transaction_Time < '" + strEndDate + "'" +
                                                " and Committed = 1 and Customer_ID in (select Customer_ID from t_master_customerinfo " +
                                                " where Customer_Group_ID != " + nCustomerGroupId + ")) as pp";

                                        SQLQuery query2 = theSession.createSQLQuery(strQuery);
                                        query2.addScalar("TheTotal", new IntegerType());
                                        List otherSaleQuantity = query2.list();

                                        if (otherSaleQuantity == null || otherSaleQuantity.size() == 0 || otherSaleQuantity.get(0) == null) continue;
                                        int nOthersSales = (Integer) otherSaleQuantity.get(0);
                                        float fOthersAmount = nOthersSales * unit_cost;
                                        totalKASAmount += nTotal;
                                        totalOthersAmount += fOthersAmount;
                                        totalAmount += (nTotal + fOthersAmount);

                                        String prodName = prodInfo.getProductName() + " - " + prodInfo.getProductFaceValue();
                                %>
                                <tr>
                                    <td><%=prodName%></td>
                                    <td><%=quantity%></td>
                                    <td><%=nTotal%></td>
                                    <td><%=nOthersSales%></td>
                                    <td><%=nTotal + nOthersSales%></td>
                                    <td><%=df.format(fGroupAmount)%></td>
                                    <td><%=df.format(fOthersAmount)%></td>
                                    <td><%=df.format(fGroupAmount + fOthersAmount)%></td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr bgcolor="yellow">
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td>Grand Total</td>
                                    <td><%=df.format(totalKASAmount)%></td>
                                    <td><%=df.format(totalOthersAmount)%></td>
                                    <td><%=df.format(totalAmount)%></td>
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
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>