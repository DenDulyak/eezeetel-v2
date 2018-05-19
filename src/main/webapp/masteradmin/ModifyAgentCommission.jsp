<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <script language="javascript">
        function ValidateInput() {
            var errString = "";

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

                document.the_form.action = "UpdateAgentCommission.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }
    </script>
    <title>Modify Agent Commission</title>
</head>
<body>
<form method="post" name="the_form" action="">
    <table width="100%">

        <%
            String record_id = request.getParameter("record_id");
            int product_id = Integer.parseInt(request.getParameter("product_id"));

            String strQuery = "from TAgentCommission where Agent_ID = '" + record_id + "' AND Product_ID = " + product_id;

            Session theSession = null;
            try {
                theSession = HibernateUtil.openSession();

                Query query = theSession.createQuery(strQuery);
                List records = query.list();

                if (records.size() > 0) {
                    TAgentCommission agentComm = (TAgentCommission) records.get(0);
                    TMasterProductinfo prodInfo = agentComm.getProduct();
        %>
        <tr>
            <td align="right">
                Agent :
            </td>
            <td align="left">
                <input name="agent_name" type="text" value="<%=agentComm.getId().getAgentId()%>" readonly>
                <input name="record_id" type="hidden" value="<%=agentComm.getId().getAgentId()%>">
            </td>
        </tr>

        <tr>
            <td align="right">
                Product :
            </td>
            <td align="left">
                <input name="product_id" type="hidden" value="<%=agentComm.getId().getProductId()%>">
                <input name="product_name" type="text" value="<%=prodInfo.getProductName()%>" readonly>
            </td>
        </tr>

        <tr>
            <td align="right">
                Commission Type :
            </td>
            <td align="left">

                <%
                    String strPercentSelected = "";
                    String strRealValueSelected = "";
                    if (agentComm.getCommissionType() == 1)
                        strPercentSelected = "Selected";
                    else
                        strRealValueSelected = "Selected";
                %>
                <select name=commissiontype>
                    <option value="1" <%= strPercentSelected%>>Percentage</option>
                    <option value="0" <%= strRealValueSelected%>>Real Value</option>
                </select>
            </td>
        </tr>

        <tr>
            <td align="right">
                Commission :
            </td>
            <td align="left">
                <input type="text" name="commission" size="10" maxlength="10" value="<%=agentComm.getCommission()%>">
            </td>
        </tr>

        <tr>
            <td align="right">
                Notes :
            </td>
            <td align="left">
                <input type="text" name="notes" size="50" maxlength="50" value="<%=agentComm.getNotes()%>">
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

        <tr>
            <td align="center">
                <a href=MasterInformation.jsp> Go to Main </a>
            </td>

            <td align="center">
                <input type="button" name="update_button" value="Update" onClick="ValidateInput()">
            </td>

            <td align="center">
                <input type="reset" name="clear_button" value="Clear">
            </td>
        </tr>

    </table>
</form>

</body>
</html>