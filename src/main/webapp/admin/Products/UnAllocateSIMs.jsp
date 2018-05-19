<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strCustomerGroups = "" + nCustomerGroupID;
    if (nCustomerGroupID == 5)
        strCustomerGroups += ", 1";
    Session theSession = null;
    try {
        String strSIMCardIDs = request.getParameter("un_assign_list");

        if (strSIMCardIDs == null || strSIMCardIDs.isEmpty()) {
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Please select SIMS to un-assign.</FONT></H4>" +
                    "<A HREF=\"/admin/Products/AssignSIMs.jsp\">Un-Assign SIMs</A></BODY></HTML>";
            response.getWriter().println(strError);
            return;
        }

        String strQuery = "from TSimCardsInfo qc where Is_Sold = 1 and Customer_Group_ID in ( " + strCustomerGroups + ") and SequenceID in (" + strSIMCardIDs + ")";

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        Query query = theSession.createQuery(strQuery);
        query.setLockMode("qc", LockMode.UPGRADE);
        List simsList = query.list();

        for (int i = 0; i < simsList.size(); i++) {
            TSimCardsInfo simCardInfo = (TSimCardsInfo) simsList.get(i);
            simCardInfo.setCustomerId(0);
            simCardInfo.setIsSold(false);
            theSession.save(simCardInfo);
            theSession.flush();
        }

        theSession.getTransaction().commit();

        response.sendRedirect("/admin/Products/ManageSIMs.jsp");

    } catch (Exception e) {
        if (theSession != null)
            theSession.getTransaction().rollback();

        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">FAILED to Un-allocate SIMS.  Please try again.</FONT></H4>" +
                "<A HREF=\"/admin/Products/AssignSIMs.jsp\">Assign SIMs</A></BODY></HTML>";
        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>