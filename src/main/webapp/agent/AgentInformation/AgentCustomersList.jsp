<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ include file="AgentSessionCheck.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="<%=ksContext%>/js/validate.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List Customer Information</title>
</head>
<body>
<table border="1" width="100%">
    <tr bgcolor="#99CCFF">
        <td><h5>Customer Company Name</h5></td>
        <td><h5>Customer First Name</h5></td>
        <td><h5>Customer Last Name</h5></td>
        <td><h5>Customer Middle Name</h5></td>
        <td><h5>Customer Address Line1</h5></td>
        <td><h5>Customer Address Line2</h5></td>
        <td><h5>Customer Address Line3</h5></td>
        <td><h5>City</h5></td>
        <td><h5>State</h5></td>
        <td><h5>Postal Code</h5></td>
        <td><h5>Country</h5></td>
        <td><h5>Primary Phone</h5></td>
        <td><h5>Secondary Phone</h5></td>
        <td><h5>Mobile Phone</h5></td>
        <td><h5>Web Site Address</h5></td>
        <td><h5>Email Id</h5></td>
        <td><h5>Customer Active Status</h5></td>
    </tr>

    <%
        String strQuery = "from TMasterCustomerinfo where Customer_Introduced_By = '" + request.getRemoteUser() + "' "
                + " order by Customer_Company_Name";

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            Query query = theSession.createQuery(strQuery);
            List records = query.list();

            for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
                TMasterCustomertype custType = custInfo.getCustomerType();
                User userCreated = custInfo.getCreatedBy();
                User userIntroduced = custInfo.getIntroducedBy();
                TMasterCustomerGroups custGroup = custInfo.getGroup();

                String strIsActive = (custInfo.getActive()) ? "Yes" : "No";
                String strBgColor = (custInfo.getActive()) ? "#FFFFFF" : "#808080";

    %>

    <tr bgcolor="<%=strBgColor%>">
        <td align="left"><%=custInfo.getCompanyName()%>
        </td>
        <td align="left"><%=custInfo.getFirstName()%>
        </td>
        <td align="left"><%=custInfo.getLastName()%>
        </td>
        <td align="left"><%=custInfo.getMiddleName()%>
        </td>
        <td align="left"><%=custInfo.getAddressLine1()%>
        </td>
        <td align="left"><%=custInfo.getAddressLine2()%>
        </td>
        <td align="left"><%=custInfo.getAddressLine3()%>
        </td>
        <td align="left"><%=custInfo.getCity()%>
        </td>
        <td align="left"><%=custInfo.getState()%>
        </td>
        <td align="left"><%=custInfo.getPostalCode()%>
        </td>
        <td align="left"><%=custInfo.getCountry()%>
        </td>
        <td align="left"><%=custInfo.getPrimaryPhone()%>
        </td>
        <td align="left"><%=custInfo.getSecondaryPhone()%>
        </td>
        <td align="left"><%=custInfo.getMobilePhone()%>
        </td>
        <td align="left"><%=custInfo.getWebsiteAddress()%>
        </td>
        <td align="left"><%=custInfo.getEmailId()%>
        </td>
        <td align="left"><%=strIsActive%>
        </td>
    </tr>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>
</table>

<a href="<%=ksContext%>/AgentInformation/AgentInformation.jsp"> Go to Main </a>
</body>
</html>