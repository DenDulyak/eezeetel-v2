<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        String strProductIdList = request.getParameter("product_id_list");
        StringTokenizer st = new StringTokenizer(strProductIdList);

        int flag = 0;

        while (st.hasMoreTokens()) {
            int k = Integer.parseInt(st.nextToken());

            int nCustomerId = Integer.parseInt(request.getParameter("customer_id"));
            int nProductId = k;
            short nCommissionType = Short.parseShort(request.getParameter("commissiontype_" + k));
            float fCommission = Float.parseFloat(request.getParameter("commission_" + k));
            String strCreatedBy = request.getRemoteUser();
            String strNotes = request.getParameter("notes_" + k);


            String strQuery_insert = "insert into t_customer_commission(Customer_ID, Product_ID, CommissionType, Commission,Active_Status, " +
                    " Created_By,Creation_Time,Last_Modified_Time,Notes) values(" + nCustomerId + "," + nProductId + "," +
                    nCommissionType + "," + fCommission + ", 1, '" + strCreatedBy + "', now(), now(),'" + strNotes + "')";

            String strQuery_update = "update t_customer_commission set CommissionType = " + nCommissionType + ", Commission = " + fCommission +
                    ", Last_Modified_Time = now(), Notes = '" + strNotes + "' where Customer_ID =" + nCustomerId + " and Product_ID = " + nProductId;

            SQLQuery query = theSession.createSQLQuery(strQuery_insert);
            try {
                query.executeUpdate();
            } catch (HibernateException ee) {
                query = theSession.createSQLQuery(strQuery_update);
                query.executeUpdate();
            }
        }

        theSession.getTransaction().commit();
        response.sendRedirect("MultipleCustomerCommission.jsp");
    } catch (Exception e) {
        theSession.getTransaction().rollback();

        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add Customer Commission.</FONT></H4>" +
                "<A HREF=\"MultipleCustomerCommission.jsp\">Manage multiple customer commissions</A></BODY></HTML>";

        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
