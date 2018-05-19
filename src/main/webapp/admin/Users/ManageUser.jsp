<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String ksContext = application.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="<%=ksContext%>/js/validate.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Delete or Activate Users</title>
</head>
<body>
<form name="the_form" action="">

    <table border="1" width="100%">
        <tr bgcolor="#99CCFF">
            <td></td>
            <td><h5>User Login ID</h5></td>
            <td><h5>User First Name</h5></td>
            <td><h5>User Last Name</h5></td>
            <td><h5>User Middle Name</h5></td>
            <td><h5>User Company Name</h5></td>
            <td><h5>Address Line1</h5></td>
            <td><h5>Address Line2</h5></td>
            <td><h5>Address Line3</h5></td>
            <td><h5>City</h5></td>
            <td><h5>State</h5></td>
            <td><h5>Postal Code</h5></td>
            <td><h5>Country</h5></td>
            <td><h5>Primary Phone</h5></td>
            <td><h5>Secondary Phone</h5></td>
            <td><h5>Mobile Phone</h5></td>
            <td><h5>EMail ID</h5></td>
            <td><h5>User Type</h5></td>
            <td><h5>User Created By</h5></td>
            <td><h5>User Creation Time</h5></td>
            <td><h5>User Modified Time</h5></td>
            <td><h5>User Notes</h5></td>
            <td><h5>User Active Status</h5></td>
        </tr>

        <%
            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

            String strQuery = "from User where Customer_Group_ID = " + nCustomerGroupID + " order by User_Active_Status desc";

            Session theSession = null;
            try {
                theSession = HibernateUtil.openSession();
                Query query = theSession.createQuery(strQuery);
                List records = query.list();

                for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                    User userInfo = (User) records.get(nIndex);
                    TMasterUserTypeAndPrivilege userPrivilegeInfo = (TMasterUserTypeAndPrivilege) userInfo.getUserType();

                    String strIsActive = (userInfo.getUserActiveStatus()) ? "Yes" : "No";
                    String strBgColor = (userInfo.getUserActiveStatus()) ? "#FFFFFF" : "#808080";
        %>

        <tr bgcolor="<%=strBgColor%>">
            <td align="right">
                <input type="radio" name="record_id" value="<%=userInfo.getLogin()%>">
            </td>
            <td align="left"><%=userInfo.getLogin()%>
            </td>
            <td align="left"><%=userInfo.getUserFirstName()%>
            </td>
            <td align="left"><%=userInfo.getUserLastName()%>
            </td>
            <td align="left"><%=userInfo.getUserMiddleName()%>
            </td>
            <td align="left"><%=userInfo.getUserCompanyName()%>
            </td>
            <td align="left"><%=userInfo.getAddressLine1()%>
            </td>
            <td align="left"><%=userInfo.getAddressLine2()%>
            </td>
            <td align="left"><%=userInfo.getAddressLine3()%>
            </td>
            <td align="left"><%=userInfo.getCity()%>
            </td>
            <td align="left"><%=userInfo.getState()%>
            </td>
            <td align="left"><%=userInfo.getPostalCode()%>
            </td>
            <td align="left"><%=userInfo.getCountry()%>
            </td>
            <td align="left"><%=userInfo.getPrimaryPhone()%>
            </td>
            <td align="left"><%=userInfo.getSecondaryPhone()%>
            </td>
            <td align="left"><%=userInfo.getMobilePhone()%>
            </td>
            <td align="left"><%=userInfo.getEmailId()%>
            </td>
            <td align="left"><%=userPrivilegeInfo.getName()%>
            </td>
            <td align="left"><%=userInfo.getUserCreatedBy()%>
            </td>
            <td align="left"><%=userInfo.getUserCreationTime()%>
            </td>
            <td align="left"><%=userInfo.getUserModifiedTime()%>
            </td>
            <td align="left"><%=userInfo.getNotes()%>
            </td>
            <td align="left"><%=strIsActive%>
            </td>
        </tr>
        <%
                } // end for loop
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession(theSession);
            }
        %>

        <tr>
            <td></td>
        </tr>

        <tr>
            <td align="center">
                <a href="/admin"> Admin Main </a>
            </td>

            <td align="center">
                <input type="button" name="add_button" value="Add"
                       OnClick="SubmitForm('<%=ksContext%>/admin/Users/NewUser.jsp', false);">
            </td>

            <td align="center">
                <input type="button" name="modify_button" value="Modify"
                       OnClick="SubmitForm('<%=ksContext%>/admin/Users/ModifyUser.jsp', true);">
            </td>

            <td align="center">
                <input type="button" name="activate_button" value="Activate"
                       OnClick="SubmitForm('<%=ksContext%>/admin/Users/ActivateUser.jsp', true);">
            </td>

            <td align="center">
                <input type="button" name="delete_button" value="Delete"
                       OnClick="SubmitForm('<%=ksContext%>/admin/Users/DeleteUser.jsp', true);">
            </td>
        </tr>
    </table>
</form>
</body>
</html>