<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Stock Information Report</title>
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
                            Session theSession = null;
                            try {
                                theSession = HibernateUtil.openSession();

                                String strQuery = "from TMasterProductinfo where Product_Active_Status = 1 order by Supplier_ID, Product_Name";
                                Query query = theSession.createQuery(strQuery);
                                List report = query.list();

                        %>

                        <table class='table table-bordered'>
                            <tr>
                                <th>Product ID</th>
                                <th>Product Name</th>
                                <th>Supplier Name</th>
                                <th>Face Value</th>
                                <th>Original Quantity</th>
                                <th>Available Quantity</th>
                            </tr>

                            <%
                                for (int i = 0; i < report.size(); i++) {
                                    TMasterProductinfo prodInfo = (TMasterProductinfo) report.get(i);
                                    TMasterSupplierinfo supInfo = prodInfo.getSupplier();
                                    List<TBatchInformation> batchSet = prodInfo.getBatches();
                                    Iterator it = batchSet.iterator();

                                    int nOriginalQuantity = 0;
                                    int nAvailableQuantity = 0;
                                    while (it.hasNext()) {
                                        TBatchInformation batchInfo = (TBatchInformation) it.next();
                                        nAvailableQuantity += batchInfo.getAvailableQuantity();
                                        nOriginalQuantity += batchInfo.getQuantity();
                                    }

                                    if (nAvailableQuantity <= 0) {
                            %>
                            <tr>
                                <td><%=prodInfo.getId()%>
                                </td>
                                <td><%=prodInfo.getProductName()%>
                                </td>
                                <td><%=supInfo.getSupplierName()%>
                                </td>
                                <td><%=prodInfo.getProductFaceValue()%>
                                </td>
                                <td><%=nOriginalQuantity%>
                                </td>
                                <td><%=nAvailableQuantity%>
                                </td>
                            </tr>
                            <%
                                    }
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
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>