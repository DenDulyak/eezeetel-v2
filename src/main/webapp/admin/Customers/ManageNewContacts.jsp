<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/js/validate.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Delete New Contacts</title>
</head>
<body>
<a href="/admin">Admin Main</a>

<form name="the_form" action="">

    <table border="1" width="100%">
        <tr bgcolor="#99CCFF">
            <td><h5>Sequence ID</h5></td>
            <td><h5>Contact Name</h5></td>
            <td><h5>Business Name</h5></td>
            <td><h5>Referred By</h5></td>
            <td><h5>Contact Number</h5></td>
            <td><h5>Email ID</h5></td>
            <td><h5>Contact Time</h5></td>
            <td><h5>Additional Info</h5></td>
            <td><h5>Addressed By</h5></td>
            <td><h5>Comments</h5></td>
            <td><h5>Time Addressed</h5></td>
            <td><h5>Addressed</h5></td>
        </tr>

        <%
            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
            String strQuery = "from TNewContacts where Group_ID = " + nCustomerGroupID + " order by Addressed, Contact_Time";

            Session theSession = null;
            try {
                theSession = HibernateUtil.openSession();

                Query query = theSession.createQuery(strQuery);
                List records = query.list();

                for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                    TNewContacts newContact = (TNewContacts) records.get(nIndex);

                    String strIsContacted = (newContact.getAddressed() == 0) ? "No" : "Yes";
                    if (newContact.getAddressed() == 2)
                        strIsContacted = "Invalid";
                    String strBgColor = (newContact.getAddressed() == 1 || newContact.getAddressed() == 2) ? "#808080" : "#FFFFFF";
        %>

        <tr bgcolor="<%=strBgColor%>">
            <td align="center">
                <a href="/admin/Customers/ViewNewContact.jsp?new_contact_id=<%=newContact.getId()%>"><%=newContact.getId()%>
                </a>
            </td>

            <td align="left"><%=newContact.getContactName()%>
            </td>
            <td align="left"><%=newContact.getContactBusinessName()%>
            </td>
            <td align="left"><%=newContact.getReferredBy()%>
            </td>
            <td align="left"><%=newContact.getContactNumber()%>
            </td>
            <td align="left"><%=newContact.getContactEmail()%>
            </td>
            <td align="left"><%=newContact.getContactTime()%>
            </td>
            <td align="left"><%=newContact.getAdditionalNotes()%>
            </td>
            <td align="left"><%=newContact.getUser().getUserFirstName()%>
            </td>
            <td align="left"><%=newContact.getComments()%>
            </td>
            <td align="left"><%=newContact.getTimeAddressed()%>
            </td>
            <td align="left"><%=strIsContacted%>
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
</form>
<a href="/admin"> Admin Main </a>
</body>
</html>