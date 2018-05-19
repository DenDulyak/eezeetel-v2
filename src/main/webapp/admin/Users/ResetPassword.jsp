<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Reset Customer User Password</title>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function ClearUser() {
            if (IsNULL(document.the_form.user_to_clear.value)) {
                alert("Please select a locked up user to clear.");
                document.the_form.user_to_clear.focus();
                return;
            }

            var str = "Are you sure you want to reset the password for " + document.the_form.user_to_clear.value;

            if (confirm(str)) {
                document.the_form.action = "/admin/Users/ResetThePassword.jsp";
                document.the_form.submit();
            }
        }
    </script>
</head>
<body>
<form method="post" name="the_form" action="">
    <%
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    %>
    <table>
        <tr>
            <td align="right">
                Reset Password for User :
            </td>
            <td>
                <select name="user_to_clear">
                    <%
                        String strQuery = "select * from (" +
                                "select t1.User_Login_ID, t1.User_First_Name, t1.User_Last_Name, t2.Customer_Company_Name " +
                                " from t_master_users t1, t_master_customerinfo t2, t_customer_users t4 " +
                                " where t1.User_Login_ID = t4.User_Login_ID " +
                                " and t2.Customer_ID = t4.Customer_ID and t1.User_Active_Status = 1 and t2.Active_Status = 1 " +
                                " and t1.Customer_Group_ID = " + nCustomerGroupID + " and t2.Customer_Group_ID = " + nCustomerGroupID +
                                " union " +
                                " select t1.User_Login_ID, t1.User_First_Name, t1.User_Last_Name, 'Agent' " +
                                " from t_master_users t1 where User_Type_And_Privilege = 6 and t1.User_Active_Status = 1 " +
                                " and t1.Customer_Group_ID = " + nCustomerGroupID +
                                " ) pp order by User_Login_ID";

                        SQLQuery query = theSession.createSQLQuery(strQuery);
                        query.addScalar("User_Login_ID", new StringType());
                        query.addScalar("User_First_Name", new StringType());
                        query.addScalar("User_Last_Name", new StringType());
                        query.addScalar("Customer_Company_Name", new StringType());
                        List lockedUsers = query.list();

                        for (int nIndex = 0; nIndex < lockedUsers.size(); nIndex++) {
                            Object[] oneRecord = (Object[]) lockedUsers.get(nIndex);
                            String userLoginID = (String) oneRecord[0];
                            String userFirstName = (String) oneRecord[1];
                            String userLastName = (String) oneRecord[2];
                            String userCompanyName = (String) oneRecord[3];

                            String strCompleteString = "Login ID = " + userLoginID + ",  First Name = " + userFirstName +
                                    ", Last Name = " + userLastName + ", Company = " + userCompanyName;
                    %>
                    <option value="<%=userLoginID%>"><%=strCompleteString%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="center">
                <a href="/admin"> Admin Main </a>
            </td>
            <td>
                <input type="button" name="clear_button" value="Reset Password" onClick="ClearUser()">
            </td>
        </tr>
    </table>
    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>
</form>
</body>
</html>