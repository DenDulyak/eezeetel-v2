<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    %>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Insert title here</title>
</head>
<body>
<table border=1>
    <tr>
        <td>
            <b>Customer
        </td>

        <%
            int Product_id = 0;
            String Product_name = null;
            int CustID = 0;
            String custComapnyID = null;
            String strQuery = "select Product_ID,Product_Name from T_Master_Productinfo where Product_Active_Status = 1 and Product_Type_ID = 17 group by Product_Name order by Product_Name";
            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.addScalar("Product_ID", new IntegerType());
            query.addScalar("Product_Name", new StringType());
            List precords = query.list();
            for (int nIndex = 0; nIndex < precords.size(); nIndex++) {
        %>
        <td colspan=2>
            <%
                Object[] oneRecord = (Object[]) precords.get(nIndex);
                Product_id = (Integer) oneRecord[0];
                Product_name = (String) oneRecord[1];
            %>
            <b><%=Product_name%>
        </td>
        <%
            }
            Product_id = 0;
        %>
    </tr>
    <tr>
        <td></td>
        <%
            for (int i = 0; i < precords.size(); i++) {
        %>
        <td>sold</td>
        <td>unsold</td>
        <%
            }
        %>
    </tr>

    <%
        strQuery = "select Customer_Company_Name,Customer_ID from t_master_customerinfo where Customer_Group_ID = " + nCustomerGroupID + " group by Customer_Company_Name order by Customer_Company_Name";
        query = theSession.createSQLQuery(strQuery);
        query.addScalar("Customer_Company_Name", new StringType());
        query.addScalar("Customer_ID", new IntegerType());
        List crecords = query.list();
        for (int nIndex = 0; nIndex < crecords.size(); nIndex++) {
    %>
    <tr>
        <td>
            <%
                Object[] oneRecord = (Object[]) crecords.get(nIndex);
                custComapnyID = (String) oneRecord[0];
                CustID = (Integer) oneRecord[1];
            %>
            <%=custComapnyID%>
        </td>
        <%
            int SimSold = 0;
            int SimUnSold = 0;
            for (int j = 0; j < precords.size(); j++) {
                oneRecord = (Object[]) precords.get(j);
                Product_id = ((Integer) oneRecord[0]);
                strQuery = "select count(*) as SimSold from t_sim_cards_info where Is_Sold = 1 and " +
                        " Customer_ID = '" + CustID + "' and Product_ID =  '" + Product_id + "' ";
                SQLQuery sold = theSession.createSQLQuery(strQuery);

                strQuery = "select count(*) as SimUnSold from t_sim_cards_info where Is_Sold = 0 and " +
                        " Customer_ID = '" + CustID + "' and Product_ID =  '" + Product_id + "' ";
                SQLQuery unsold = theSession.createSQLQuery(strQuery);

                sold.addScalar("SimSold", new IntegerType());
                unsold.addScalar("SimUnSold", new IntegerType());
                List Srecords = sold.list();
                List UNrecords = unsold.list();
                SimSold = (Integer) Srecords.get(0);
                SimUnSold = (Integer) UNrecords.get(0);

        %>
        <td><%=SimSold %>
        </td>
        <td><%=SimUnSold %>
        </td>
        <%} %>
    </tr>
    <%} %>

</table>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</body>
</html>