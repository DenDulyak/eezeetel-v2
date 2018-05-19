<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Insert title here</title>
</head>
<body>
<table border="1">
    <tr>
        <td>Product Name</td>
        <td>Face Value</td>
        <td>Quantity</td>
    </tr>
    <%

        String req_date = "2013-05-01";
        int supplier_id = 35;

        Session theSession = null;

        try {
            theSession = HibernateUtil.openSession();

            String strQuery = "call SP_Report_Monthly_Product_Uploads_By_Supplier(" + supplier_id + ", '" + req_date + "')";
            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.addScalar("Product_Name", new StringType());
            query.addScalar("Product_Face_Value", new FloatType());
            query.addScalar("Quantity", new IntegerType());

            List lst = query.list();
            for (int i = 0; i < lst.size(); i++) {
                Object[] oneRecord = (Object[]) lst.get(i);

                String productName = (String) oneRecord[0];
                Float productFaceValue = (Float) oneRecord[1];
                Integer quantity = (Integer) oneRecord[2];
    %>
    <tr>
        <td><%=productName%>
        </td>
        <td><%=productFaceValue%>
        </td>
        <td><%=quantity%>
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
</table>
</body>
</html>