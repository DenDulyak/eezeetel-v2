<%@ page import="com.eezeetel.service.PhoneTopupCountryService" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    PhoneTopupCountryService countryService = context.getBean(PhoneTopupCountryService.class);
%>

<div class="container-fluid">
    <div class="col-md-12">
        <div style="text-align: center;">
            <span style="color: #000000; font-size: xx-large; ">Topup Any Mobile in the World</span>
        </div>

        <br>

        <div class="col-md-4 col-md-offset-4">
            <form class="form-horizontal" id="mobileTopupForm">
                <div class="form-group">
                    <label class="control-label col-sm-6" for="senderNumber">Sender Mobile Number:</label>

                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="senderNumber" name="senderNumber"
                               placeholder="44 + UK Mobile Number" oninput="validateSenderPhone($(this))">
                    </div>
                </div>
                <div class="form-group">
                    <table class="table table-striped" id="topupTransactionsTable" style="display: none">
                        <thead>
                        <tr>
                            <th>User</th>
                            <th>Destination Phone</th>
                            <th>Topup</th>
                        </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>
                <div class="form-group">
                    <div class="col-sm-6">
                        <select id="countries" class="form-control" onchange="countrySelected(this)" disabled>
                            <option value="">Country Code</option>
                            <%
                                List<PhoneTopupCountry> countries = countryService.findAll();

                                for (PhoneTopupCountry country : countries) {
                                    String value = country.getPhoneCode();
                                    if (country.getAvailableInDing()) {
                                        value += ",d";
                                    }
                                    if (country.getAvailableInMobitopup()) {
                                        value += ",m";
                                    }
                            %>
                            <option value="<%=value%>">
                                <%=country.getName()%>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-sm-6">
                        <div class="input-group">
                            <div class="input-group-addon countryCode">&nbsp;&nbsp;&nbsp;&nbsp;</div>
                            <input type="text" pattern="[0-9]*" name="dest_phone" id="dest_phone" class="form-control"
                                   disabled>
                            <input type="hidden" id="is_country_supported" value="true"/>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="operator_select_id">

                </div>
                <div class="form-group">
                    <div class="col-sm-offset-6 col-sm-6">
                        <div id="get_details_link_button_id">
                            <input type="button" class="btn btn-primary getDetails" value="Get Details"
                                   onClick="javascript:getDestinationInfo1()" disabled/>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<br>

<p align="justify">
    <span style="color: #000000; font-size: medium; ">
        <b> Send Instant mobile
            top-ups worldwide in few seconds. The following are few of many
            networks that you can instantly top-up various mobile networks.
        </b>
    </span>
</p>

<p align="justify">
    <span style="color: #000000; font-size: medium; ">
        <b>Now you can topup in GBP <img src="${pageContext.request.contextPath}/images/denominations.jpg" height="50"
                                         width="150"> and so on... </b>
    </span>
</p>

<table>
    <%
        int widthImage = 50;
        int heightImage = 50;
    %>
    <tr>
        <td><img src="${pageContext.request.contextPath}/images/3mobile.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/air tel.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/bangla.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/digicel.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/ele.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/glo.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/harmud.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/lime.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/mtn.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/natinal.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/roshan.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/safari com.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/smart.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/tigo.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/tmobile new.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/vodafone.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
    </tr>
    <tr>
        <td><img src="${pageContext.request.contextPath}/images/bsnl.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/carrerfour.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/claro.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/dialog.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/digi.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/econet.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/eplus.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/ideao.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/jazz.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/mobilink.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/nepaltelecom.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/telenoe.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
        <td><img src="${pageContext.request.contextPath}/images/touch.jpg" height="<%=heightImage%>"
                 width="<%=widthImage%>"/></td>
    </tr>
</table>

<p align="justify">
    <span style="color: #000000; font-size: medium; "> <BR> <BR> <b><u>Terms and Conditions:</u></b> <BR> **
        It is the customer's responsibility to make sure they enter the right
        mobile number before top-up. <BR> ** If the top-up is made to the
        wrong mobile number, there is no possibility that the company can
        trace and get the money back. <BR>
    </span>
</p>