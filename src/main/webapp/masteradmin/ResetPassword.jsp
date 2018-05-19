<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script language="javascript" src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script language="javascript">
        function ClearUser() {
            if (IsNULL(document.the_form.user_to_clear.value)) {
                alert("Please select a locked up user to clear.");
                document.the_form.user_to_clear.focus();
                return;
            }

            var str = "Are you sure you want to reset the password for " + document.the_form.user_to_clear.value;

            if (confirm(str)) {
                document.the_form.action = "/masteradmin/ResetThePassword.jsp";
                document.the_form.submit();
            }
        }
    </script>
    <title>User was blocked. Clear User to login again</title>
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
                        <form method="post" name="the_form" action="">
                            <%
                                Session theSession = null;
                                try {
                                    theSession = HibernateUtil.openSession();
                            %>
                            <table>
                                <tr>
                                    <td align="right">
                                        Reset Password for User :
                                    </td>
                                    <td>
                                        <select name="user_to_clear">
                                            <%

                                                String strQuery = "select t1.User_Login_ID, t1.User_First_Name, t1.User_Last_Name, 'Group Admin' as Customer_Company_Name" +
                                                        " from t_master_users t1 where User_Type_And_Privilege <= 5 and t1.User_Active_Status = 1 " +
                                                        " and User_Login_ID != '" + request.getRemoteUser() + "'and User_Login_ID != 'Pending' order by User_Login_ID";

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
                                        <a href="MasterInformation.jsp"> Go to Main </a>
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
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>