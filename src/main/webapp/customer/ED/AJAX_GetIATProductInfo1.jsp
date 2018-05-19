<%@ page import="com.eezeetel.enums.FeatureType" %>
<%@ page import="com.eezeetel.mobitopup.MobitopupMethod" %>
<%@ page import="com.eezeetel.mobitopup.MobitopupMethodImpl" %>
<%@ page import="com.eezeetel.mobitopup.MobitopupUtil" %>
<%@ page import="com.eezeetel.mobitopup.response.CheckNumber" %>
<%@ page import="com.eezeetel.mobitopup.response.Ticket" %>
<%@ page import="com.eezeetel.service.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.setContentType("text/html");
    String theCountryCode = request.getParameter("country_code");
    String strDestinationNumber = request.getParameter("dest_phone");
    String senderNumber = request.getParameter("sender_number");
    String strOperatorID = request.getParameter("operator_id");

    String errString = "Failed to get available product information ";
    if (strDestinationNumber == null || strDestinationNumber.isEmpty()) {
        errString += ".  Please enter a valid destination phone number along with country code.";
        response.getWriter().println(errString);
        return;
    }

    if (theCountryCode == null || theCountryCode.isEmpty()) {
        errString += ".  Please enter a valid destination phone number along with country code.";
        response.getWriter().println(errString);
        return;
    }

    if (senderNumber != null && senderNumber.length() > 16) {
        errString += ".  Please enter a valid sender phone number along with country code.";
        response.getWriter().println(errString);
        return;
    }

    strDestinationNumber = theCountryCode + strDestinationNumber;

    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    MobitopupMethod mobitopupMethod = context.getBean(MobitopupMethodImpl.class);
    CustomerService customerService = context.getBean(CustomerService.class);
    WorldTopupGroupCommissionService groupCommissionService = context.getBean(WorldTopupGroupCommissionService.class);
    WorldTopupCustomerCommissionService customerCommissionService = context.getBean(WorldTopupCustomerCommissionService.class);
    PhoneTopupCountryService countryService = context.getBean(PhoneTopupCountryService.class);
    DingTransactionService dingTransactionService = context.getBean(DingTransactionService.class);

    Session theSession = null;
    DingMain.PhoneNumberDetails theResponse = null;
    CheckNumber checkNumber = null;
    Ticket ticket = null;
    WorldTopupGroupCommission groupCommission = null;
    WorldTopupCustomerCommission customerCommission = null;
    float customerBalance = 0;
    try {
        theSession = HibernateUtil.openSession();

        String strUserID = request.getRemoteUser();
        String strQuery = "from TCustomerUsers where User_Login_ID = '" + strUserID + "'";
        Query query = theSession.createQuery(strQuery);
        List listCustomerID = query.list();
        if (listCustomerID.size() > 0) {
            TCustomerUsers custUsers = (TCustomerUsers) listCustomerID.get(0);
            TMasterCustomerinfo custInfo = custUsers.getCustomer();
            customerBalance = custInfo.getCustomerBalance();

            boolean hasDingFeature = customerService.hasFeature(custInfo, FeatureType.DING);
            boolean hasMobipopupFeature = customerService.hasFeature(custInfo, FeatureType.MOBIPOPUP);
            boolean dingEnoughBalance = false;
            boolean mobitopupEnoughBalance = false;

            if (hasDingFeature) {
                DingMain dingService = new DingMain(custInfo.getId(), strUserID);
                dingEnoughBalance = dingService.GetBalance() > 10;
                if(dingEnoughBalance) {
                    String countryCode = dingService.GetCountryFromTelephoneCode(theCountryCode);
                    if (strOperatorID == null || strOperatorID.isEmpty())
                        countryCode = null;

                    Long minutes = dingTransactionService.checkTimeLimitForTransaction(custInfo, strDestinationNumber);
                    if (minutes > 0) {
                        errString += ". Please try again in " + minutes + " minutes.";
                        response.getWriter().println(errString);
                        return;
                    }

                    theResponse = dingService.GetDetailsForPhoneNumber(strDestinationNumber, strOperatorID, countryCode);
                }
            }

            if (hasMobipopupFeature) {
                mobitopupEnoughBalance = NumberUtils.toDouble(mobitopupMethod.getBalance().getBalance()) > 5;
                if(mobitopupEnoughBalance) {
                    checkNumber = mobitopupMethod.checkNumber(strDestinationNumber);
                    if (checkNumber != null && checkNumber.getError_code() == 0) {
                        ticket = mobitopupMethod.getTickets(NumberUtils.toInt(checkNumber.getNetworkid()));
                        PhoneTopupCountry country = countryService.findByMobitopupCountryId(NumberUtils.toInt(checkNumber.getCountryid()));
                        if (country.getAvailableInMobitopup()) {
                            Integer groupId = NumberUtils.toInt(session.getAttribute("GROUP_ID") + "");
                            groupCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, groupId);
                            customerCommission = customerCommissionService.findOrCreateByGroupCommissionAndCustomer(groupCommission, custInfo);
                        }
                    }
                }
            }

            if(!dingEnoughBalance && !mobitopupEnoughBalance) {
                errString += ". Please try again later. ";
                response.getWriter().println(errString);
                return;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }

    if((theResponse == null || !theResponse.success) && (checkNumber != null && checkNumber.getError_code() == 0)) {
        theResponse = new DingMain.PhoneNumberDetails();
        theResponse.success = true;
        theResponse.Amounts = new ArrayList<DingMain.AmountsAndCommission>();
        theResponse.strReceiversNumber = strDestinationNumber;
        theResponse.strCountry = checkNumber.getCountry();
        theResponse.strCountryCode = checkNumber.getIso();
        theResponse.strOperator = checkNumber.getNetwork();
        theResponse.strOperatorID = checkNumber.getNetworkid();
    }

    if (theResponse != null && theResponse.success) {
        DecimalFormat df = new DecimalFormat("0.00");
%>
<form id="topup_form" name="topup_form">

    <table align="center">
        <%
            if (!StringUtils.isEmpty(senderNumber) && !Objects.equals(senderNumber, "null")) {
        %>
        <tr>
            <td align="right">
                <span class="Normal-C0">Sender's Mobile Number</span>
            </td>
            <td align="left">
                <input type="text" id="sender_phone_id" name="sender_phone_id" size="20" maxlength="20" readonly
                       value="<%=senderNumber%>"/>
            </td>
        </tr>
        <%
            }
        %>
        <tr>
            <td align="right"><span class="Normal-C0"> Receiver's Mobile Number</span>
            </td>
            <td align="left">
                <input type="text" id="dest_phone_id" name="dest_phone_id" size="20" maxlength="20" readonly
                       value="<%=theResponse.strReceiversNumber%>"/>
            </td>
        </tr>

        <tr>
            <td align="right">
                <span class="Normal-C0">Country</span>
            </td>
            <td align="left">
                <input type="text" name="dest_country" size="20" maxlength="20" value="<%=theResponse.strCountry%>"
                       readonly/>
            </td>
        </tr>

        <tr>
            <td align="right">
                <span class="Normal-C0">Country Code</span>
            </td>
            <td align="left">
                <input type="text" id="dest_country_code" name="dest_country_code" size="3" maxlength="3"
                       value="<%=theResponse.strCountryCode%>" readonly/>
            </td>
        </tr>

        <tr>
            <td align="right">
                <span class="Normal-C0">Operator</span>
            </td>
            <td align="left">
                <input type="text" name="dest_operator" size="20" maxlength="20" value="<%=theResponse.strOperator%>"
                       readonly/>
            </td>
        </tr>

        <tr>
            <td align="right">
                <span class="Normal-C0">Operator ID</span>
            </td>
            <td align="left">
                <input type="text" id="dest_operator_id" name="dest_operator_id" size="3" maxlength="3"
                       value="<%=theResponse.strOperatorID%>" readonly/>
            </td>
        </tr>

        <tr>
            <td align="right">
                <span class="Normal-C1">SMS Message To Receiver</span>
            </td>
            <td align="left">
                <input type="text" id="sms_text" name="sms_text" size="30" maxlength="29"
                       style="width:200px; height:40px;font-size:18px;"/>
            </td>
        </tr>
    </table>
    <br>
    <br>
    <br>

    <div class="container">
        <ul class="list-inline col-md-8 col-md-offset-2">

            <%
                for (int i = 0; i < theResponse.Amounts.size(); i++) {

                    DingMain.AmountsAndCommission amountAndCommission = theResponse.Amounts.get(i);
                    String str = df.format(amountAndCommission.m_fSuggestedRetailPrice);
                    float fAmountRequested = amountAndCommission.m_fSuggestedRetailPrice;
                    if (!theResponse.isRangeOperator)
                        fAmountRequested = amountAndCommission.m_fDenomination;
            %>
            <li class="col-md-3">
                <input type="hidden" id="destRate<%=i%>" name="destRate<%=i%>"
                       value="<%=amountAndCommission.m_fDestinationValueWithTax%>"/>
                <input type="hidden" id="custValue<%=i%>" name="custValue<%=i%>"
                       value="<%=amountAndCommission.m_fCustomerPrice%>"/>
                <input type="hidden" id="ratesToSend<%=i%>" name="ratesToSend<%=i%>" value="<%=fAmountRequested%>"/>
                <input type="hidden" id="RangeOp" name="RangeOp" value="<%=theResponse.isRangeOperator%>"/>
                <input type="hidden" id=selected_index name="selected_index" value="-1"/>

                <div id="all_rate_buttons_id">
                    <a id=rates<%=i%> name="rates<%=i%>" style="width: 100%"
                       onClick="confirmMobileTopup1('<%=amountAndCommission.m_fCustomerPrice%>', '<%=i%>')"
                       class="productsButton">
                        Topup £<%=str%> <br/>
                    <span style="font-size: x-small; ">
                        DESTINATION VALUE : <%=df.format(amountAndCommission.m_fDestinationValueWithTax)%>
                    </span>
                    </a>
                </div>
            </li>
            <%
                }
            %>
        </ul>
        <ul class="list-inline col-md-8 col-md-offset-2">
            <%
                if (checkNumber != null && checkNumber.getError_code() == 0 && customerCommission != null && ticket != null) {
                    for (String buy : Arrays.asList(ticket.getBuy().split(","))) {
                        String[] prices = buy.split("-");
                        BigDecimal priceWithCommission = PriceUtil.addPercentage(prices[1], groupCommission.getPercent());
                        priceWithCommission = PriceUtil.addPercentage(priceWithCommission, new BigDecimal(customerCommission.getGroupPercent() + ""));
                        priceWithCommission = PriceUtil.addPercentage(priceWithCommission, new BigDecimal(customerCommission.getAgentPercent() + ""));
                        priceWithCommission = PriceUtil.addPercentage(priceWithCommission,
                                MobitopupUtil.getCustomerCommission(MobitopupUtil.isDigicel(checkNumber.getIso(), checkNumber.getNetworkid())));

                        if(customerBalance < priceWithCommission.floatValue()) {
                            break;
                        }
            %>
            <li class="col-md-3">
                <a class="productsButton" style="width: 100%" onClick="confirmMobitopup(<%=prices[0]%>)">
                    Topup £<%=priceWithCommission%><br/>
                    <span style="font-size: x-small; ">
                        DESTINATION VALUE : <%=prices[0]%>
                    </span>
                </a>
            </li>
            <%
                    }
                }
            %>
        </ul>
    </div>
</form>
<%
    } else {
        errString += "for the destination phone number : " + strDestinationNumber;
        errString += ".  Destination Country or the mobile network operator may not be supported";
        response.getWriter().println(errString);
    }
%>