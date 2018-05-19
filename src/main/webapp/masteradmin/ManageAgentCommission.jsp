<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function setup_product() {
            if (document.the_form.record_id != null) {
                var nItems = document.the_form.record_id.length;
                if (nItems == null || nItems <= 0) {
                    if (document.the_form.record_id.checked) {
                        document.the_form.product_id.value = document.getElementById("product_id_0").value;
                        return 1;
                    }
                }
                else {
                    for (var i = 0; i < document.the_form.record_id.length; i++) {
                        if (document.the_form.record_id[i].checked) {
                            var theId = "product_id_" + i;
                            document.the_form.product_id.value = document.getElementById(theId).value;
                            return 1;
                        }
                    }
                }
            }
        }
    </script>

    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Delete or Activate Agent Commission</title>
</head>
<body>
<form name="the_form" action="">
    <input type="hidden" name="product_id" value="">
    <table border=1 width="100%">
        <tr bgcolor="#99CCFF">
            <td></td>
            <td><h5>Agent Name</h5></td>
            <td><h5>Product Name</h5></td>
            <td><h5>Commission Type</h5></td>
            <td><h5>Commission Value</h5></td>
            <td><h5>Created By</h5></td>
            <td><h5>Creation Time</h5></td>
            <td><h5>Last Modified Time</h5></td>
            <td><h5>Notes</h5></td>
            <td><h5>Active</h5></td>
        </tr>

        <%
            String strQuery = "from TAgentCommission order by Agent_ID, Product_ID";

            Session theSession = null;

            try {
                theSession = HibernateUtil.openSession();

                Query query = theSession.createQuery(strQuery);
                List records = query.list();

                for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                    TAgentCommission agentComm = (TAgentCommission) records.get(nIndex);
                    TMasterProductinfo prodInfo = agentComm.getProduct();
                    User userInfo = agentComm.getUser();

                    String strIsActive = (agentComm.getActiveStatus() == 1) ? "Yes" : "No";
                    String strBgColor = (agentComm.getActiveStatus() == 1) ? "#FFFFFF" : "#808080";
                    String strCommissionType = (agentComm.getCommissionType() == 1) ? "Percentage" : "Real Value";
        %>

        <tr bgcolor="<%=strBgColor%>">
            <td align="right">
                <input type="radio" name="record_id" value="<%=agentComm.getId().getAgentId()%>"
                       onClick="setup_product()">
                <input type="hidden" id="product_id_<%=nIndex%>" value="<%=prodInfo.getId()%>">
            </td>
            <td align="left"><%=agentComm.getId().getAgentId()%>
            </td>
            <td align="left"><%=prodInfo.getProductName()%>
            </td>
            <td align="left"><%=strCommissionType%>
            </td>
            <td align="left"><%=agentComm.getCommission()%>
            </td>
            <td align="left"><%=userInfo.getUserFirstName()%>
            </td>
            <td align="left"><%=agentComm.getCreationTime()%>
            </td>
            <td align="left"><%=agentComm.getLastModifiedTime()%>
            </td>
            <td align="left"><%=agentComm.getNotes()%>
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
        <jsp:include page="buttons.jsp">
            <jsp:param name="follow_up_page" value="AgentCommission"/>
        </jsp:include>
    </table>
</form>
</body>
</html>