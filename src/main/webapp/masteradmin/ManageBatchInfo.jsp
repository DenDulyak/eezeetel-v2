<%@ page import="org.springframework.data.domain.Page" %>
<%@ page import="org.springframework.data.domain.PageRequest" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page import="com.eezeetel.service.BatchService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <script language="javascript" src="${pageContext.request.contextPath}/js/validate.js"></script>
    <title>List, Modify, Delete, Activate or Status of the Batch Information</title>
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
                        <jsp:include page="buttons.jsp">
                            <jsp:param name="follow_up_page" value="BatchInfo"/>
                        </jsp:include>
                        <br>

                        <form name="the_form" action="">
                            <table class="table table-bordered">
                                <thead>
                                <tr bgcolor="#99CCFF">
                                    <th>Sequence ID</th>
                                    <th>Batch ID</th>
                                    <th>Supplier</th>
                                    <th>Product Name</th>
                                    <th>Quantity</th>
                                    <th>Available Quantity</th>
                                    <th>Unit Purchase Price</th>
                                    <th>Probable Sale Price</th>
                                    <td>Starting Batch Number</td>
                                    <th>Ending Batch Number</th>
                                    <th>Batch Arrival Date</th>
                                    <th>Batch Expiry Date</th>
                                    <th>Batch Activated By Supplier</th>
                                    <th>Batch Ready to Sell</th>
                                    <th>Batch Entry Time</th>
                                    <th>Batch Entered By</th>
                                    <th>Additional Information</th>
                                    <th>Notes</th>
                                    <th>File Location</th>
                                    <th>Batch up-load Status</th>
                                    <th>Batch Active</th>
                                    <th>Print Information</th>
                                    <th>Payment Amount To Supplier</th>
                                    <th>Paid to Supplier</th>
                                    <th>Payment Date To Supplier</th>
                                </tr>
                                </thead>

                                <%
                                    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
                                    BatchService batchService = context.getBean(BatchService.class);

                                    Integer pageNumber = NumberUtils.toInt(request.getParameter("page"), 0);
                                    Page<TBatchInformation> batchInformations = batchService.findByAvailableQuantityGreaterThanOrderByEntryTimeDesc(0, new PageRequest(pageNumber, 50));

                                    int begin = Math.max(1, batchInformations.getNumber() - 5);
                                    Double totalPages = Math.ceil(batchInformations.getTotalElements() / 100.0);
                                    long end = Math.min(begin + 10, totalPages.longValue());
                                    request.setAttribute("begin", begin);
                                    request.setAttribute("end", end);
                                    request.setAttribute("pageNumber", batchInformations.getNumber() + 1);

                                    try {
                                        for (TBatchInformation batchInfo : batchInformations.getContent()) {
                                            TMasterSupplierinfo supInfo = batchInfo.getSupplier();
                                            TMasterProductinfo productInfo = batchInfo.getProduct();
                                            TMasterProductsaleinfo productSaleInfo = batchInfo.getProductsaleinfo();
                                            User usersInfo = batchInfo.getUser();

                                            String strStartingBatchNumber = "";
                                            String strEndingBatchNumber = "";

                                            List<TCardInfo> cardsList = batchInfo.getCards();
                                            List<TSimCardsInfo> simCardsList = batchInfo.getSimCards();
                                            if (!cardsList.isEmpty()) {
                                                strStartingBatchNumber = cardsList.get(0).getCardId() + "";
                                                strEndingBatchNumber = cardsList.get(cardsList.size() - 1).getCardId() + "";
                                            }
                                            if (!simCardsList.isEmpty()) {
                                                strStartingBatchNumber = simCardsList.get(0).getSimCardId() + "";
                                                strEndingBatchNumber = simCardsList.get(simCardsList.size() - 1).getSimCardId() + "";
                                            }

                                            String strBatchActivated = (batchInfo.getBatchActivatedBySupplier()) ? "Yes" : "No";
                                            String strReadyToSell = (batchInfo.getBatchReadyToSell()) ? "Yes" : "No";
                                            String strIsActive = (batchInfo.getActive()) ? "Yes" : "No";
                                            String strBgColor = (batchInfo.getActive()) ? "active" : "danger";
                                            String strPaidToSupplier = (batchInfo.getPaidToSupplier()) ? "Yes" : "No";
                                %>
                                <tr class="<%=strBgColor%>">
                                    <td align="right">
                                        <input type="radio" name="record_id"
                                               value="<%=batchInfo.getSequenceId()%>"> <%=batchInfo.getSequenceId()%>
                                    </td>

                                    <td align="left"><%=batchInfo.getBatchId()%>
                                    </td>
                                    <td align="left"><%=supInfo.getSupplierName()%>
                                    </td>
                                    <td align="left"><%=productInfo.getProductName()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getQuantity()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getAvailableQuantity()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getUnitPurchasePrice()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getProbableSalePrice()%>
                                    </td>
                                    <td align="left"><%=strStartingBatchNumber%>
                                    </td>
                                    <td align="left"><%=strEndingBatchNumber%>
                                    </td>
                                    <td align="left"><%=batchInfo.getArrivalDate()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getExpiryDate()%>
                                    </td>
                                    <td align="left"><%=strBatchActivated%>
                                    </td>
                                    <td align="left"><%=strReadyToSell%>
                                    </td>
                                    <td align="left"><%=batchInfo.getEntryTime()%>
                                    </td>
                                    <td align="left"><%=usersInfo.getUserFirstName()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getAdditionalInfo()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getNotes()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getBatchFilePath()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getBatchUploadStatus()%>
                                    </td>
                                    <td align="left"><%=strIsActive%>
                                    </td>
                                    <td align="left" nowrap><%=productSaleInfo.getPrintInfo()%>
                                    </td>
                                    <td align="left"><%=batchInfo.getBatchCost()%>
                                    </td>
                                    <td align="left"><%=strPaidToSupplier%>
                                    </td>
                                    <td align="left"><%=batchInfo.getPaymentDateToSupplier()%>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                %>

                                <jsp:include page="buttons.jsp">
                                    <jsp:param name="follow_up_page" value="BatchInfo"/>
                                </jsp:include>
                            </table>
                        </form>

                        <ul class="pagination">
                            <c:forEach var="i" begin="${begin}" end="${end}">
                                <li class="<c:if test="${i eq pageNumber}">active</c:if>">
                                    <a href="${pageContext.request.contextPath}/masteradmin/ManageBatchInfo.jsp?page=${i - 1}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>