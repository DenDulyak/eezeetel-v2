<%@ page import="com.eezeetel.service.DingTransactionService" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strDestinationPhone = request.getParameter("dest_phone_id");
    String senderPhone = request.getParameter("sender_phone_id");
    String strCountry = request.getParameter("dest_country");
    String strCountryID = request.getParameter("dest_country_code");
    String strOperator = request.getParameter("dest_operator");
    String strOperatorID = request.getParameter("dest_operator_id");
    String strCommission = request.getParameter("customer_commission");
    String strSMSText = request.getParameter("sms_text");
    String selectedIndex = request.getParameter("selected_index");
    String destDenomination = request.getParameter("destRate" + selectedIndex);
    String strProductAmount = request.getParameter("ratesToSend" + selectedIndex);
    String strCustomerCost = request.getParameter("custValue" + selectedIndex);
    String strRangeOperator = request.getParameter("RangeOp");
    boolean bRangeOp = false;
    if (strRangeOperator != null && !strRangeOperator.isEmpty())
        bRangeOp = Boolean.parseBoolean(strRangeOperator);

    Float fCustomerCommission = 0f;
    if (strCommission != null)
        fCustomerCommission = Float.parseFloat(strCommission);

    Float fTopupAmount = 0f;
    if (strProductAmount != null)
        fTopupAmount = Float.parseFloat(strProductAmount);

    Float fCostToCustomer = 0f;
    if (strCustomerCost != null)
        fCostToCustomer = Float.parseFloat(strCustomerCost);

    fCostToCustomer += fCustomerCommission;
    DecimalFormat df = new DecimalFormat("0.00");

    String userAgent = request.getHeader("User-Agent");
    boolean bAutoPrint = true;
    if (userAgent.compareToIgnoreCase("CallingCardsApp") == 0)
        bAutoPrint = false;

    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    DingTransactionService dingTransactionService = context.getBean(DingTransactionService.class);

    Session theSession = null;
    DingMain.TopupResponse theResponse = null;
    boolean bEnoughBalance = false;
    Long minutesLimit = 0L;
    try {
        theSession = HibernateUtil.openSession();

        String strUserID = request.getRemoteUser();
        String strQuery = "from TCustomerUsers where User_Login_ID = '" + strUserID + "'";
        Query query = theSession.createQuery(strQuery);
        List listCustomerID = query.list();
        if (listCustomerID.size() > 0) {
            TCustomerUsers custUsers = (TCustomerUsers) listCustomerID.get(0);
            TMasterCustomerinfo custInfo = custUsers.getCustomer();
            TMasterCustomerGroups custGroup = custInfo.getGroup();
            float fAvailableBalance = custInfo.getCustomerBalance();

            if (fAvailableBalance > fCostToCustomer) {
                if (custGroup.getCheckAganinstGroupBalance()) {
                    if (custGroup.getCustomerGroupBalance() > 500)
                        bEnoughBalance = true;
                } else
                    bEnoughBalance = true;
            }

            minutesLimit = dingTransactionService.checkTimeLimitForTransaction(custInfo, strDestinationPhone);

            int nCustomerID = custInfo.getId();

            if (bEnoughBalance && minutesLimit == 0L) {
                DingMain dingService = new DingMain(nCustomerID, strUserID);
                theResponse = dingService.PerformTopUpOperation(strDestinationPhone, senderPhone, strCountryID, strOperatorID,
                        strSMSText, fTopupAmount, bRangeOp, application);
            } else {
                System.out.println("Warning. bEnoughBalance - " + bEnoughBalance + ". Minutes - " + minutesLimit);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <c:import url="../../common/libs.jsp"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>
    <title>Receipt</title>
    <style>
        P.pagebreakhere {
            page-break-before: always
        }

        td.font_style {
            font-family: "Verdana";
            font-weight: bolder;
            font-size: 14px;
        }
    </style>
    <%
        if (theResponse != null && theResponse.success) {
    %>
    <script>
        function pausecomp(milsec) {
            milsec += new Date().getTime();
            while (new Date() < milsec) {
            }
            window.location.href = "/customer/products";
        }

        function PrintPage() {
            window.print();
            setTimeout("pausecomp(5000)", 5000);
        }
        <%
        if (bAutoPrint) {
        %>
        window.onload = PrintPage;
        <%
        }
        %>
    </script>
    <%
        }
    %>
</head>
<body>
<div class="container-fluid">
    <%
        if (theResponse != null && theResponse.success) {
    %>
    <table>
        <tr>
            <td align="left"><b><%=theResponse.m_strCompany%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>Operator : <%=strOperator%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>Country : <%=strCountry%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>* Top-Up Successful *</b></td>
        </tr>
        <tr>
            <td align="left"><b>Topup Amount : £<%=df.format(theResponse.m_fRetailPrice)%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>Receiver : <%=theResponse.m_strReceiver%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>****************************</b></td>
        </tr>
        <tr>
            <td align="left"><b>Transaction Number : <%=theResponse.m_eezeeTelTransactionID%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>Reference Number : <%=theResponse.m_dingTransactionID%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>Time : <%=theResponse.m_strTime%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>****************************</b></td>
        </tr>
        <tr>
            <td align="left"><b>Destination Value : <%=df.format(theResponse.m_fDestTopupValue)%>
            </b></td>
        </tr>
        <tr>
            <td align="left"><b>Destination Value(Excl. Tax) : <%=df.format(theResponse.m_fDestTopupValueAfterTax)%>
                % </b>
            </td>
        </tr>
        <tr>
            <td align="left"><b>Destination Tax : <%=df.format(theResponse.m_fDestTax)%>% </b></td>
        </tr>
        <tr>
            <td align="left"><b>Destination Currency : <%=theResponse.m_strCurrencyCode%>
            </b></td>
        </tr>
        <tr>
            <td align="center"><b>International Recharge Successful</b></td>
        </tr>
        <tr>
            <td align="left"><b>Customer Care : <%=theResponse.m_strCustomerCare%>
            </b></td>
        </tr>
    </table>
    <%
    } else {
    %>
    <div id="nav">
        <%
            if (minutesLimit > 0L) {
        %>
        <font color="red" size="10"> Please try again in <%=minutesLimit%> minutes. </font>
        <%
        } else if (bEnoughBalance) {
        %>
        <font color="red" size="10"> Unable to process transaction. Please try again. </font>
        <%
        } else {
        %>
        <font color="red" size="10"> You do not have sufficient balance. Please request a topup and try again. </font>
        <%
            }
        %>
        <br>
        <a href="${pageContext.request.contextPath}/customer/products">Show Products</a>
    </div>
    <%
        }
    %>
</div>
</body>
</html>