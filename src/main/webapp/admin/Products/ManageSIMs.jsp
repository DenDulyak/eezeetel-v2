<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strCustomerGroups = "" + nCustomerGroupID;
    if (nCustomerGroupID == 5)
        strCustomerGroups += ", 1";
    String strQuery = "select Product_ID, Customer_ID, count(SequenceID) as Quantity from t_sim_cards_info where " +
            " Customer_Group_ID in ( " + strCustomerGroups + ")"
            + " and Is_Sold = 0 group by Customer_ID, Product_ID order by Customer_ID, Product_ID";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("Product_ID", new IntegerType());
        sqlQuery.addScalar("Customer_ID", new IntegerType());
        sqlQuery.addScalar("Quantity", new IntegerType());
        List records = sqlQuery.list();

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>SIM Information</title>
    <script language="javascript" src="/js/validate.js"></script>
</head>
<body>
<form name="the_form" method="post" action="">
    <a href="/admin"> Admin Main </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="/admin/Products/AssignSIMs.jsp">Assign SIMS</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="/admin/Products/ShowSIMs.jsp">Show SIMS</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <br><br>
    <table width="100%" border="1">
        <tr>
            <td align="left">Product</td>
            <td align="left">Unsold Quantity</td>
            <td align="left">Customer</td>
        </tr>
        <%
            for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                Object[] oneRecord = (Object[]) records.get(nIndex);
                int nProduct_ID = (Integer) oneRecord[0];
                int nCustomer_ID = (Integer) oneRecord[1];
                int nQuantity = (Integer) oneRecord[2];

                strQuery = "from TMasterProductinfo where Product_Active_Status = 1 and Product_ID = " + nProduct_ID;
                Query query = theSession.createQuery(strQuery);
                List prodList = query.list();
                String strProductName = "";
                if (prodList != null && prodList.size() > 0) {
                    TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);
                    strProductName = prodInfo.getProductName();
                }

                String strCustomerName = "UN ASSIGNED";
                if (nCustomer_ID > 0) {
                    strQuery = "from TMasterCustomerinfo where Active_Status = 1 and Customer_ID = " + nCustomer_ID;
                    query = theSession.createQuery(strQuery);
                    List custList = query.list();

                    if (custList != null && custList.size() > 0) {
                        TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
                        strCustomerName = custInfo.getCompanyName();
                    }
                }
        %>
        <tr>
            <td align="left"><%=strProductName%>
            </td>
            <td align="left"><%=nQuantity%>
            </td>
            <td align="left"><%=strCustomerName%>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</form>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>