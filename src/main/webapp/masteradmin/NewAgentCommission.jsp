<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function ValidateInput() {
            var errString = "";

            if (IsNULL(document.the_form.agent_id.value))
                errString += "\r\Agent Id can not be empty.  Please enter a proper value";

            if (IsNULL(document.the_form.commission.value))
                errString += "\r\nCommission cannot be empty.  Please enter a proper value";

            if (!CheckNumbers(document.the_form.commission.value, "."))
                errString += "\r\Commission should be a number. Please enter a proper value";

            if (document.the_form.commissiontype.value == "Percentage") {
                if (document.the_form.commission.value > 100)
                    errString += "\r\nCommission Percentage cannot be greater than 100. Please enter a proper value";
            }


            if (errString == null || errString.length <= 0) {
                for (i = 0; i < document.the_form.elements.length; i++)
                    if (document.the_form.elements[i].type == "text")
                        CheckDatabaseChars(document.the_form.elements[i]);

                document.the_form.action = "AddAgentCommission.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }
    </script>
    <title>Agent Commission</title>
</head>
<body>
<form method="post" name="the_form" action="">
    <%
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
    %>
    <table width="100%">

        <tr>
            <td align="right">
                Agent :
            </td>
            <td align="left">
                <select name="agent_id">
                    <%
                        String strQuery = "from User where User_Type_And_Privilege = 6 and User_Active_Status=1";

                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();

                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            User userInfo = (User) records.get(nIndex);
                    %>
                    <option value="<%=userInfo.getLogin()%>"><%=userInfo.getUserFirstName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>

        <tr>
            <td align="right">
                Product :
            </td>
            <td align="left">
                <select name="product_id">
                    <%
                        strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
                        query = theSession.createQuery(strQuery);
                        records = query.list();
                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);
                    %>
                    <option value="<%=prodInfo.getId()%>"><%=prodInfo.getProductName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>

        <tr>
            <td align="right">
                Commission Type :
            </td>
            <td align="left">
                <select name="commissiontype">
                    <option value="1">Percentage</option>
                    <option value="0">Real Value</option>
                </select>
            </td>
        </tr>

        <tr>
            <td align="right">
                Commission :
            </td>
            <td align="left">
                <input type="text" name="commission" size="10" maxlength="10">
                <input type="hidden" name="created_by" value="<%=request.getRemoteUser()%>">
            </td>
        </tr>

        <tr>
            <td align="right">
                Notes :
            </td>
            <td align="left">
                <input type="text" name="notes" size="50" maxlength="50">
            </td>
        </tr>

        <tr>
            <td align="center">
                <a href=MasterInformation.jsp> Go to Main </a>
            </td>

            <td align="center">
                <input type="button" name="add_button" value="Add" onClick="ValidateInput()">
            </td>

            <td align="center">
                <input type="reset" name="clear_button" value="Clear">
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