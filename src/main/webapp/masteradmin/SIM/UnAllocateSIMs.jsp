<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Session theSession = null;
    try {
        String strSIMSequenceIDs = request.getParameter("un_assign_list");

        if (strSIMSequenceIDs == null || strSIMSequenceIDs.isEmpty()) {
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Please select SIMS to un-assign.</FONT></H4>" +
                    "<A HREF=\"/masteradmin/SIM/UnAssignSIMs.jsp\">Un-Assign SIMs To Customer Groups</A></BODY></HTML>";
            response.getWriter().println(strError);
            return;
        }

        String strQuery = "from TSimCardsInfo qc where Is_Sold = 0 and SequenceID in (" + strSIMSequenceIDs + ")";

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        Query query = theSession.createQuery(strQuery);
        query.setLockMode("qc", LockMode.UPGRADE);
        List simsList = query.list();

        for (int i = 0; i < simsList.size(); i++) {
            TSimCardsInfo simCardInfo = (TSimCardsInfo) simsList.get(i);
            TBatchInformation batchInfo = simCardInfo.getBatch();
            batchInfo.setAvailableQuantity(batchInfo.getAvailableQuantity() + 1);
            simCardInfo.setCustomerGroupId(0);
            simCardInfo.setCustomerId(0);
            theSession.save(simCardInfo);
            theSession.save(batchInfo);
        }

        theSession.getTransaction().commit();

        response.sendRedirect("/masteradmin/SIM/ManageSIMs.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        if (theSession != null)
            theSession.getTransaction().rollback();

        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">FAILED to allocate SIMS.  Please try again.</FONT></H4>" +
                "<A HREF=\"/masteradmin/SIM/UnAssignSIMs.jsp\">Un-Assign SIMs To Customer Groups</A></BODY></HTML>";
        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>