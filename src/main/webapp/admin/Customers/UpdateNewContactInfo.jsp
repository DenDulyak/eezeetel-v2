<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strAddressedBy = request.getParameter("addressed_by");
    int addressing_status = Integer.parseInt(request.getParameter("status"));
    String strComments = request.getParameter("the_comments");

    String strQuery = "update T_New_Contacts set Comments = '" + strComments + "',"
            + "Addressed_By = '" + strAddressedBy + "',"
            + "Addressed = " + addressing_status + ", Time_Addressed=now()"
            + " where Sequence_ID = " + record_id + " and Group_ID = " + nCustomerGroupID;

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("/admin/Customers/ManageNewContacts.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update New Contact Information</FONT></H4>" +
                "<A HREF='/admin/Customers/ManageNewContacts.jsp'>Manage New Contacts</A></BODY></HTML>";
        response.getWriter().println(strError);
    }
%>
