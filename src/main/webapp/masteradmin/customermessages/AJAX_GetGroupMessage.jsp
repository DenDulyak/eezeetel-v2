<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String groupId = request.getParameter("group_id");
    Session theSession = null;
    String strMessage = "";
    try {
        theSession = HibernateUtil.openSession();

        String strQuery = "from TMessages where Is_Active = 1 and Target_Group = " + groupId;
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        if (records.size() > 0) {
            TMessages theMessages = (TMessages) records.get(0);
            strMessage = theMessages.getMessage();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }

    response.setContentType("text/plain");
    response.getWriter().println(strMessage);
%>
