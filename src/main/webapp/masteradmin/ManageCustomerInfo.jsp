<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Delete or Activate Customer Information</title>
</head>
<body>
<form name="the_form" action="">

    <table border="1" width="100%">
        <tr bgcolor="#99CCFF">
            <td></td>
            <td><h5>Customer Group</h5></td>
            <td><h5>Customer Company Name</h5></td>
            <td><h5>Customer Type</h5></td>
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
            <td><h5>Balance</h5></td>
            <td><h5>Created By</h5></td>
            <td><h5>Customer Introduced By</h5></td>
            <td><h5>Customer Info Modified Time</h5></td>
            <td><h5>Customer Info Creation Time</h5></td>
            <td><h5>Customer Notes</h5></td>
            <td><h5>Customer Active Status</h5></td>
            <td><h5>Customer Features</h5></td>
        </tr>

        <%
            String strQuery = "from TMasterCustomerinfo order by Active_Status desc, Customer_Group_ID, Customer_Company_Name";

            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, -5);
            SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
            String str5DaysBack = dt.format(cal.getTime());

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

                    String strCustomerDoingTransactionsColor = "#FF8080";

                    String strTransQuery = "select count(*) as Trans_Count from t_transactions where Customer_ID = " + custInfo.getId() +
                            " and Transaction_Time > '" + str5DaysBack + "'";

                    SQLQuery sqlQuery = theSession.createSQLQuery(strTransQuery);
                    sqlQuery.addScalar("Trans_Count", new IntegerType());
                    List transList = sqlQuery.list();
                    if (transList != null && transList.size() > 0) {
                        Integer transCount = (Integer) transList.get(0);
                        if (transCount.intValue() > 0)
                            strCustomerDoingTransactionsColor = "#00FF00";
                    }

                    String strIsActive = (custInfo.getActive() == 1) ? "Yes" : "No";
                    String strBgColor = (custInfo.getActive() == 1) ? "#FFFFFF" : "#808080";
                    strCustomerDoingTransactionsColor = (custInfo.getActive() == 1) ? strCustomerDoingTransactionsColor : strBgColor;

                    String strCustomerFeatues = "All";
                    if (custInfo.getCustomerFeatureId() == 1)
                        strCustomerFeatues = "Only Mobile Topup";
                    if (custInfo.getCustomerFeatureId() == 2)
                        strCustomerFeatues = "Only Calling Cards";
        %>

        <tr bgcolor="<%=strBgColor%>">
            <td align="right">
                <input type="radio" name="record_id" value="<%=custInfo.getId()%>"> <%=custInfo.getId()%>
            </td>
            <td align="left"><%=custGroup.getName()%>
            </td>
            <td align="left" bgColor="<%=strCustomerDoingTransactionsColor%>">
                <a href="ModifyCustomerInfo.jsp?record_id=<%=custInfo.getId()%>"><%=custInfo.getCompanyName()%>
                </a>
            </td>
            <td align="left"><%=custType.getCustomerType()%>
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
            <td align="left"><font color=red><%=custInfo.getCustomerBalance()%>
            </font></td>
            <td align="left"><%=userCreated.getUserFirstName()%>
            </td>
            <td align="left"><%=userIntroduced.getUserFirstName()%>
            </td>
            <td align="left"><%=custInfo.getLastModifiedTime()%>
            </td>
            <td align="left"><%=custInfo.getCreationTime()%>
            </td>
            <td align="left"><%=custInfo.getNotes()%>
            </td>
            <td align="left"><%=strIsActive%>
            </td>
            <td align="left"><%=strCustomerFeatues%>
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
        <jsp:include page="buttons.jsp">
            <jsp:param name="follow_up_page" value="CustomerInfo"/>
        </jsp:include>
    </table>
</form>
</body>
</html>