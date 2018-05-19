<%@ page import="com.eezeetel.customerapp.ProcessTransaction" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.eezeetel.service.SimTransactionService" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="../../common/imports.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");
    String userAgent = request.getHeader("User-Agent");

    boolean bAutoPrint = true;
    if (userAgent.compareToIgnoreCase("CallingCardsApp") == 0)
        bAutoPrint = false;
%>

<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>
    <style TYPE='text/css'>
        P.pagebreakhere {
            page-break-before: always
        }

        td.font_style {
            font-family: "Verdana";
            font-weight: bolder;
            font-size: 14px;
        }
    </style>
    <script language="javascript">
        function pausecomp(milsec) {
            milsec += new Date().getTime();
            while (new Date() < milsec) {
            }
            window.location.href = "/customer/products";
        }

        function PrintPage() {
            <%
                if (userAgent.contains("Chrome/")) {
            %>
            window.print();
            setTimeout("pausecomp(5000)", 5000);
            <%
                } else {
            %>
            window.location.href = "/customer/products";
            window.print();
            <%
                }
            %>
        }
        <%
        if (bAutoPrint) {
        %>
        window.onload = PrintPage;
        <%
        }
        %>
    </script>
</head>
<body>

<%
    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        int nCustomerID = 0;
        int nCustomerGroupID = 0;
        TMasterCustomerinfo theCustomer = null;
        String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";

        Query query = theSession.createQuery(strQuery);
        List customer = query.list();
        if (customer.size() > 0) {
            TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
            theCustomer = custUsers.getCustomer();
            TMasterCustomerGroups custGroup = theCustomer.getGroup();
            User theUser = custUsers.getUser();
            if (theCustomer.getActive() && theUser.getUserActiveStatus())
                nCustomerID = theCustomer.getId();
            if (custGroup.getActive())
                nCustomerGroupID = custGroup.getId();
        }

        if (nCustomerID == 0 || nCustomerGroupID == 0) {
%>
<h4><span style="color: red; ">Failed to complete SIM Card Transaction</span></h4>
<%
        return;
    }

    String strSIMID = request.getParameter("sim_sequence_id");
    Long nSimSequenceID = Long.parseLong(strSIMID);
    strQuery = "from TSimCardsInfo where SequenceID = " + nSimSequenceID +
            " and Customer_ID = " + nCustomerID + " and Is_Sold = 0";

    query = theSession.createQuery(strQuery);
    List records = query.list();

    if (records == null || records.size() <= 0) {
%>
<h4><span style="color: red; ">Failed to complete SIM Card Transaction</span></h4>
<%
        return;
    }

    TSimCardsInfo simCardInfo = (TSimCardsInfo) records.get(0);
    ArrayList<String> topupTransactions = new ArrayList<String>();
    for (int i = 0; i < simCardInfo.getMaxTopups(); i++) {
        String strID = "mob_topup_" + (i + 1);
        String strTopupTran = request.getParameter(strID);
        if (strTopupTran == null || strTopupTran.isEmpty())
            break;
        topupTransactions.add(strTopupTran);
    }

    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    ProcessTransaction processTrans = (ProcessTransaction) context.getBean("processTransaction");
    SimTransactionService simTransactionService = context.getBean(SimTransactionService.class);

    Long transactionId = processTrans.processSIMCardTransaction(nCustomerID, nCustomerGroupID, request.getRemoteUser(), nSimSequenceID, topupTransactions);
    if (transactionId != 0L) {
        records = simTransactionService.findByTransactionId(transactionId);

        TSimTransactions simTran = (TSimTransactions) records.get(0);
        int nTotalTopups = records.size() - 1;
        TMasterProductinfo prodInfo = simTran.getSimCard().getProduct();

        String strProductID = "";
        if (!bAutoPrint)
            strProductID = "<tr><td align='left'><u><b>Product ID : " + prodInfo.getId() + "</b></u></td></tr>";
%>
<%
    if (nTotalTopups != topupTransactions.size()) {
%>
<script language="javascript">
    alert("Not all mobile topups have been attached.  Please do it separately.");
</script>
<%
    }
%>

<table>
    <tr>
        <td align="left"><b><%=theCustomer.getCompanyName()%>
        </b></td>
    </tr>
    <tr>
        <td align="left"><b>Transaction Number : <%=transactionId%>
        </b></td>
    </tr>
    <tr>
        <td align="left"><b><%=simTran.getTransactionTime()%>
        </b></td>
    </tr>
    <tr>
        <td align="left"><u><b><%=prodInfo.getProductName()%>
        </b></u></td>
    </tr>
    <%=strProductID%>
    <tr>
        <td align="left"><u><b>New Mobile Number: <%=simCardInfo.getSimCardPin()%>
        </b></u></td>
    </tr>
    <tr>
        <td align="left"><u><b>Total Topups: <%=nTotalTopups%>
        </b></u></td>
    </tr>
</table>

<div id="nav">
    <br>
    <a href="${pageContext.request.contextPath}/customer/products">Show Products</a>
</div>
<%
} else {
%>
<h4><font color="red">Failed to complete SIM Card Transaction</font></h4>
<br>
<a href="${pageContext.request.contextPath}/customer/products">Show Products</a>
<%
    }
} catch (Exception e) {
    e.printStackTrace();
%>
<h4><span style="color: red; ">Failed to complete SIM Card Transaction</span></h4>
<%
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>

</body>
</html>
