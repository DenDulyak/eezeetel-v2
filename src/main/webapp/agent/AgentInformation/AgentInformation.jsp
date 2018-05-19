<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ include file="AgentSessionCheck.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Master Information</title>
</head>
<body>
<%
    String strQuery = "from User where User_Login_ID = '" + request.getRemoteUser() + "'";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();
        if (records.size() > 0) {
            User theUser = (User) records.get(0);
%>
<center>
    <H2>Welcome Agent - <%=theUser.getUserFirstName()%> <%=theUser.getUserLastName()%></H2>
</center>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
<table width="100%">
    <tr>
        <th align="center"></th>
        <th align="center">Customers</th>
        <th align="center">Accounts</th>
        <th align="center">Reports</th>
        <th align="center">Others</th>
    </tr>
    <tr></tr>
    <tr></tr>
    <tr>
        <td align="center"><a href="/AgentApp/AgentInformation/Logout.jsp"> <font size="6"> Logout </font></a></td>
        <td align="center"><a href="/AgentApp/AgentInformation/AgentCustomersList.jsp"> My Customers </a></td>
        <td align="center"><a href="/AgentApp/AgentInformation/CustomerProfitMargin.jsp"> Customer Profit Margin </a></td>
        <td align="center"><a href="/AgentApp/AgentInformation/CustomerBusiness.jsp"> Monthly Customer Business </a></td>
        <td align="center"><a href="/AgentApp/AgentInformation/ChangePassword.jsp"> Change My Password </a></td>
    </tr>
    <tr>
        <td align="center"></td>
        <td align="center"></td>
        <td align="center"></td>
        <td align="center"><a href="/AgentApp/AgentInformation/ReportCustomerDaySummary.jsp"> Customer Day Summary </a></td>
        <td align="center"></td>
    </tr>
</table>
</body>
</html>