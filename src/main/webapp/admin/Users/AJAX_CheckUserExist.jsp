<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strLoginId = request.getParameter("name");
    String strQuery = "from User where User_Login_ID = '" + strLoginId + "'";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<user_exists>";

        if (records.size() > 0) {
            User userInfo = (User) records.get(0);
            strResult += "<user name=\"" + userInfo.getLogin() + "\"/>";
        }

        strResult += "</user_exists>";

        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<user_exists></user_exists>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
