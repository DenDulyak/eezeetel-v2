<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="../common/imports.jsp" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.eezeetel.customerapp.ProcessTransaction" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    boolean bElementsExist = false;
    boolean bProcessed = false;
    ProcessTransaction processTransaction = null;
    ArrayList listProductID = new ArrayList();
    ArrayList listRequiredQuantity = new ArrayList();
    String strUserId = (String) request.getRemoteUser();

    String strQueryString = request.getQueryString();

    StringTokenizer st = null;
    if (strQueryString != null && strQueryString.length() > 0)
        st = new StringTokenizer(strQueryString, "=&");

    while (st != null && st.hasMoreTokens()) {
        String name = st.nextToken();
        String value = st.nextToken();

        try {
            Integer nProductID = Integer.parseInt(name);
            Integer nRequiredQuantity = Integer.parseInt(value);

            if (nProductID.intValue() > 0
                    && nRequiredQuantity.intValue() > 0) {
                listProductID.add(nProductID);
                listRequiredQuantity.add(nRequiredQuantity);
                bElementsExist = true;
            }
        } catch (NumberFormatException e) {
        }
    }

    if (bElementsExist) {
        processTransaction = new ProcessTransaction();
        //bProcessed = processTransaction.process(listProductID, listRequiredQuantity, strUserId);
        bProcessed = processTransaction.process(listProductID, listRequiredQuantity, null,"");
        if (bProcessed) {
            if (processTransaction.m_fAvailableBalance < processTransaction.m_fTotalTransactionAmount) {
                processTransaction.cancel(processTransaction.m_nTransactionID);
                bProcessed = false;
%>
<font color="red"> Available
    balance <%=new DecimalFormat("0.##").format((double) processTransaction.m_fAvailableBalance)%> is not enough
    toprocess the transaction.</font>
<%
    return;
} else if (processTransaction.m_bGroupBalanceIsNotSufficient) {
%>
<font color="blue" size="8"> Insufficent reserve funds. Please contact your Agent.</font>
<%
        return;
    } else
        request.getSession().setAttribute(
                "CurrentTransactionID",
                processTransaction.m_nTransactionID);
} else {
%>
<font color="red"> Unable to process transaction </font>
<%
            bProcessed = false;
            return;
        }
    } /*else
		response.sendRedirect(ksContext + "ShowProducts.jsp");*/

    DatabaseHelper dbHelper = new DatabaseHelper();
    String strUserID = (String) session.getAttribute("USER_ID");
    int nGroupID = dbHelper.GetCustomerGroupID(strUserID);

    if (bProcessed && processTransaction != null) {
        if (processTransaction.m_fAvailableBalance < 25) {
%>
<h1><font color="red">Your balance is low. Please request a topup as soon as possible</font></h1>
<br><br>
<%
    }
%>
<table align="center" cellpadding="10">
    <%
        Session theSession = null;
        boolean bDisplayConfirmButton = false;
        try {
            theSession = HibernateUtil.openSession();
            String strQuery = "from TCustomerUsers where User_Login_ID = '" + strUserID + "'";
            Query query = theSession.createQuery(strQuery);
            List listCustomerID = query.list();
            String strScriptFunction = "confirm_and_print_transaction()";
            if (listCustomerID != null) {
                TCustomerUsers custUsers = (TCustomerUsers) listCustomerID.get(0);
                TMasterCustomerinfo custInfo = custUsers.getCustomer();
                if (custInfo.getSpecialPrinterCustomer() == 1)
                    strScriptFunction = "confirm_transaction()";
            }

            for (int i = 0; i < processTransaction.m_arrayRequirement.size(); i++) {
                ProcessTransaction.RequirementRecord oneRecord = (ProcessTransaction.RequirementRecord) processTransaction.m_arrayRequirement.get(i);
                String strHighlight = "";
    %>
    <tr>
        <td align="right"><span class="Normal-C0"><%=oneRecord.m_strProductName%></span></td>
        <td><IMG SRC="<%=oneRecord.m_strImageFilePath%>" width="170"
                 height="100"/></td>
    </tr>
    <tr>
        <td align="right"><span class="Normal-C0"> Quantity : </span></td>
        <td><span class="Normal-C0"> <%
            if (oneRecord.m_nProcessedQuantity < oneRecord.m_nRequiredQuantity)
                strHighlight = "<font color=red>"
                        + oneRecord.m_nProcessedQuantity
                        + "</font>";
            else
                strHighlight = "" + oneRecord.m_nProcessedQuantity
                        + "";
            if (oneRecord.m_nProcessedQuantity > 0)
                bDisplayConfirmButton = true;
        %> <%=strHighlight%>
		</span></td>
    </tr>

    <tr>
        <td align="right"><span class="Normal-C0">Value : </span></td>
        <td><span class="Normal-C0">£<%=new DecimalFormat("0.00").format((double) oneRecord.m_fCostToCustomer)%></span>
        </td>
    </tr>
    <%
        }
    %>
    <tr>
        <%
            if (bDisplayConfirmButton) {
        %>
        <td align="center" colspan="2"><a name="Confirm" class="productsButton"
                                          onClick="<%=strScriptFunction%>">Confirm</a></td>
        <%
            }
        %>
    </tr>
</table>
<%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    }
%>
