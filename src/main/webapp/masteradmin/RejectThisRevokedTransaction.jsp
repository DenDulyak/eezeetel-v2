<%@ page import="com.utilities.RevokeTransaction" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script src="${pageContext.request.contextPath}/js/masteradmin/reports/stockReconciliation.js"></script>
    <title>Stock Reconciliation Report</title>
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
                            String strResult = "Failed to credit and adjust profit for this transaction.";
                            String strSequenceID = request.getParameter("Transaction");
                            String strRevokeSequenceID = request.getParameter("RevokeSequence");
                            if (strSequenceID != null && !strSequenceID.isEmpty() && strRevokeSequenceID != null &&
                                    !strRevokeSequenceID.isEmpty()) {
                                long sequenceID = Long.parseLong(strSequenceID);
                                int revokeSequenceID = Integer.parseInt(strRevokeSequenceID);
                                RevokeTransaction revoke = new RevokeTransaction();
                                if (revoke.RevokeProfit(sequenceID, revokeSequenceID, false)) {
                                    //strResult = "Successfully credited this transaction and adjusted the profit for this transaction.";
                                    strResult = "Successfully rejected this transaction.";
                                }
                            }
                        %>
                        <br><br>

                        <%=strResult%>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>