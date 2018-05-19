<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strFromAgent = request.getParameter("from_agent_id");
    String strToAgent = request.getParameter("to_agent_id");
    String strSupplier = request.getParameter("supplier_id");
    String strProductsList = request.getParameter("products_list");

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        StringTokenizer st = new StringTokenizer(strProductsList);

        int flag = 0;

        String strSuccess = null;
        String strFailure = null;

        while (st.hasMoreTokens()) {
            int k = Integer.parseInt(st.nextToken());

            String strQuery_from = "from TAgentCommission where Product_ID = " + k;
            strQuery_from += " AND Agent_ID = '" + strFromAgent + "'";

            String strQuery_to = "from TAgentCommission where Product_ID = " + k;
            strQuery_to += " AND Agent_ID = '" + strToAgent + "'";

            Query query_from = theSession.createQuery(strQuery_from);
            List records_from = query_from.list();

            Query query_to = theSession.createQuery(strQuery_to);
            List records_to = query_to.list();

            float commission_from = 0;
            byte commissiontype_from = 1;
            String notes_from = null;

            float commission_to = 0;
            byte commissiontype_to = 1;
            String notes_to = null;

            String strCreatedBy = request.getRemoteUser();
            try {
                TAgentCommission agecomm_from = (TAgentCommission) records_from.get(0);
                commission_from = agecomm_from.getCommission();
                commissiontype_from = agecomm_from.getCommissionType();
                notes_from = agecomm_from.getNotes();

                if (records_to.size() == 1) {
                    TAgentCommission agecomm_to = (TAgentCommission) records_to.get(0);
                    commission_to = agecomm_to.getCommission();
                    commissiontype_to = agecomm_to.getCommissionType();
                    notes_to = agecomm_to.getNotes();
                }
            } catch (IndexOutOfBoundsException e) {
            }

            if ((commission_from != commission_to) || (commissiontype_from != commissiontype_to) || (!notes_from.equals(notes_to))) {
                String strQuery_insert = "insert into t_agent_commission(Agent_ID, Product_ID, CommissionType, Commission,Active_Status, " +
                        " Created_By,Creation_Time,Last_Modified_Time,Notes) values( '" + strToAgent + "' ," + k + "," +
                        commissiontype_from + "," + commission_from + ", 1, '" + strCreatedBy + "', now(), now(),'" + notes_from + "')";

                String strQuery_update = "update t_agent_commission set CommissionType = " + commissiontype_from + ", Commission = " + commission_from +
                        ", Last_Modified_Time = now(), Notes = '" + notes_from + "' where Agent_ID ='" + strToAgent + "' and Product_ID = " + k;


                SQLQuery query = theSession.createSQLQuery(strQuery_insert);
                try {
                    query.executeUpdate();
                } catch (HibernateException ee) {
                    query = theSession.createSQLQuery(strQuery_update);
                    query.executeUpdate();
                }
                strSuccess = "Records Copied Successfully";
                flag = 1;
            } else {
                strFailure = "No need to copy. From and To Agent Commission values are same";
            }

        }

        theSession.getTransaction().commit();
        if (flag == 1)
            response.getWriter().println(strSuccess);
        else
            response.getWriter().println(strFailure);
    } catch (NullPointerException e) {
        theSession.getTransaction().rollback();
        e.printStackTrace();
        String strError = "From Agent is a new entry. Add and save information before trying to COPY";
        response.getWriter().println(strError);
    } catch (Exception e) {
        theSession.getTransaction().rollback();
        e.printStackTrace();
        String strError = "Failed to Copy Customer Commission Values.";
        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>