<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Check Select SIM Product</title>
    <script language="javascript" src="/js/validate.js" type="text/javascript"></script>
    <script language="javascript" src="/js/SimCardsInterface.js" type="text/javascript"></script>
</head>
<body>
<form method="post" name="the_form" action="">
        <%
	response.addHeader("Pragma", "no-cache");
	response.addHeader("Expires", "-1");
	
	Long nSIMID = 0L;
	String strSIMID = request.getParameter("sim_id");
	if (strSIMID != null && !strSIMID.isEmpty())
		nSIMID = Long.parseLong(strSIMID);

	if (nSIMID <= 0) {
%>
    <h3><font color="red">Not a valid phone number. Please select a valid new mobile number to proceed.</font></h3>
    <br>
    <a href="/customer/products"> Show Products </a>
</body>
</html>
<%
        return;
    }

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        int nCustomerID = 0;
        String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";

        Query query = theSession.createQuery(strQuery);
        List customer = query.list();
        if (customer.size() > 0) {
            TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
            TMasterCustomerinfo theCustomer = custUsers.getCustomer();
            User theUser = custUsers.getUser();
            if (theCustomer.getActive() && theUser.getUserActiveStatus())
                nCustomerID = theCustomer.getId();
        }

        if (nCustomerID == 0) {
%>
<h3><font color="red">Can not obtain customer information. Please try again.</font></h3>
<br>
<a href="/customer/products">Show Products</a>
</body>
</html>
<%
        return;
    }

    strQuery = "from TSimCardsInfo where SequenceId = " + nSIMID +
            " and Customer_ID = " + nCustomerID + " and Is_Sold = 0 and Transaction_ID is NULL";
    query = theSession.createQuery(strQuery);
    List records = query.list();

    if (records.size() <= 0) {
%>
<h3><font color="red">Not a valid mobile number. Please select a valid new mobile number to proceed.</font></h3>
<br>
<a href="/customer/products"> Show Products </a>
</body>
</html>
<%
        return;
    }

    TSimCardsInfo simCardInfo = (TSimCardsInfo) records.get(0);
    String strImageFile = simCardInfo.getBatch().getProductsaleinfo().getProductImageFile();
    String strProductName = simCardInfo.getProduct().getProductName();

    strQuery = "select Mobile_Voucher_Product_ID from t_sim_card_mobile_vouchers_mapping where SIM_Product_ID = " + simCardInfo.getProduct().getId();
    SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
    sqlQuery.addScalar("Mobile_Voucher_Product_ID", new IntegerType());
    records = sqlQuery.list();
    if (records.size() <= 0) {
%>
<h3><font color="red">No mobile topups products available for the selected mobile number. Please select a different
    mobile number to proceed.</font></h3>
<br>
<a href="/customer/products"> Show Products </a>
</body>
</html>
<%
        return;
    }
    String strPossibleMobileTopupProducts = "";
    for (int i = 0; i < records.size(); i++) {
        strPossibleMobileTopupProducts += ((Integer) records.get(i));
        if (i + 1 != records.size())
            strPossibleMobileTopupProducts += ",";
    }
%>
<table width="100%">

    <tr>
        <td>SIM Product Image</td>
        <td>Product Name</td>
        <td>Mobile Number</td>
            <%
	for (int i = 0; i < simCardInfo.getMaxTopups(); i++)
	{
%>
        <td>Mobile Topup Transaction <%=i + 1%>
        </td>
            <%
	}
%>
    <tr>
        <td><IMG SRC="<%=strImageFile%>" height="50" width="100"/></td>
        <td><%=strProductName%>
        </td>
        <td><%=simCardInfo.getSimCardPin()%>
        </td>
    <tr>
            <%
		boolean bDisplayConfirmButton = true;
%>
    <tr>
        <%
            if (bDisplayConfirmButton) {
        %>
        <td><input type="button" name="Confirm" value="Confirm" onClick="confirm_sim_transaction()"></td>
        <%
            }
        %>
        <td><input type="button" name="Cancel" value="Cancel" onClick="cancel_sim_transaction()"></td>
        <td><a href="/customer/products"> Show Products </a></td>
    </tr>
</table>

<%
    int nLasthours = 1;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.HOUR, -nLasthours)
    ;
    String strCurTime = sdf.format(cal.getTime());
    strQuery = "select * from t_transactions where Customer_ID = " + nCustomerID +
            " and Product_ID in (" + strPossibleMobileTopupProducts +
            ") and Committed = 1 and Quantity = 1 and Transaction_Time > '" + strCurTime + "'" +
            " and Transaction_ID not in (select Mobile_Topup_Transaction_ID from t_sim_transactions where " +
            " Mobile_Topup_Transaction_ID is not null and Customer_ID = "
            + nCustomerID + ")" + " order by Transaction_Time desc";
    sqlQuery = theSession.createSQLQuery(strQuery);
    sqlQuery.addEntity(TTransactions.class);
    records = sqlQuery.list();
    for (int i = 0; i < records.size(); i++) {
        TTransactions transaction = (TTransactions) records.get(i);
        strProductName = transaction.getProduct().getProductName();
        strProductName += (" - " + transaction.getProduct().getProductFaceValue());
        String strTransTime = sdf.format(transaction.getTransactionTime());

    }
%>

<input type="hidden" name="sim_sequence_id" value="<%=strSIMID%>">
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