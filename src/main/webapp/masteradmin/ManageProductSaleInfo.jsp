<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <form name="the_form" action="">

        <table class="table table-bordered">
            <thead>
            <tr>
                <th></th>
                <th>Sale Info ID</th>
                <th>Product Name</th>
                <th>Supplier Name</th>
                <th>Notes</th>
                <th>Sale Info Active</th>
                <th>Print Info</th>
            </tr>
            </thead>
            <tbody>
            <%
                String strQuery = "from TMasterProductsaleinfo";

                Session theSession = null;
                try {
                    theSession = HibernateUtil.openSession();
                    Query query = theSession.createQuery(strQuery);
                    List records = query.list();

                    for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                        TMasterProductsaleinfo prodSaleInfo = (TMasterProductsaleinfo) records.get(nIndex);
                        TMasterProductinfo prodInfo = prodSaleInfo.getProduct();
                        TMasterSupplierinfo supplierInfo = prodInfo.getSupplier();
                        String strIsActive = (prodSaleInfo.getActive()) ? "Yes" : "No";
                        String strBgColor = (prodSaleInfo.getActive()) ? "active" : "danger";
            %>
            <tr class="<%=strBgColor%>">
                <td align="right">
                    <input type="radio" name="record_id" value="<%=prodSaleInfo.getId()%>">
                </td>

                <td align="left"><%=prodSaleInfo.getId()%>
                </td>
                <td align="left"><%=prodInfo.getProductName()%>
                </td>
                <td align="left"><%=supplierInfo.getSupplierName()%>
                </td>
                <td align="left"><%=prodSaleInfo.getNotes()%>
                </td>
                <td align="left"><%=strIsActive%>
                </td>
                <td align="left"><%=prodSaleInfo.getPrintInfo()%>
                </td>
            </tr>
            </tbody>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    HibernateUtil.closeSession(theSession);
                }
            %>

            <jsp:include page="buttons.jsp">
                <jsp:param name="follow_up_page" value="ProductSaleInfo"/>
            </jsp:include>
        </table>
    </form>
</div>

<script src="${pageContext.request.contextPath}/js/validate.js"></script>