<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <script language="javascript">
        function validate_and_submit(status) {
            if (status == 2)
                if (!confirm("Are you sure that it is an invalid contact?")) return;

            if (document.the_form.addressed_by.value == "Pending") {
                alert("Please enter who addressed / rejected this contact");
                return;
            }

            CheckDatabaseChars(document.the_form.the_comments);
            document.the_form.action = "UpdateNewContactInfo.jsp?status=" + status;
            document.the_form.submit();
        }
    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Delete New Contacts</title>
</head>
<body>
<form name="the_form" action="" method="post">
    <table border="1" width="50%">

        <a href="MasterInformation.jsp"> Go to Main </a>
        <%
            String strNewContactID = request.getParameter("new_contact_id");
            String strQuery = "from TNewContacts where Sequence_ID = " + strNewContactID;

            Session theSession = null;
            try {
                theSession = HibernateUtil.openSession();

                Query query = theSession.createQuery(strQuery);
                List records = query.list();

                if (records.size() > 0) {
                    TNewContacts newContact = (TNewContacts) records.get(0);
                    String strIsContacted = (newContact.getAddressed() == 0) ? "No" : "Yes";
                    String strBgColor = (newContact.getAddressed() == 1 || newContact.getAddressed() == 2) ? "#808080" : "#FFFFFF";
        %>

        <input type="hidden" name="record_id" value="<%=newContact.getId()%>"/>
        <tr>
            <td align="right"> Sequence ID</td>
            <td align="left"><%=newContact.getId()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Contact Name</td>
            <td align="left"><%=newContact.getContactName()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Business Name</td>
            <td align="left"><%=newContact.getContactBusinessName()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Referred By</td>
            <td align="left"><%=newContact.getReferredBy()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Contact Number</td>
            <td align="left"><%=newContact.getContactNumber()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Email ID</td>
            <td align="left"><%=newContact.getContactEmail()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Contact Time</td>
            <td align="left"><%=newContact.getContactTime()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Additional Info</td>
            <td align="left"><%=newContact.getAdditionalNotes()%>
            </td>
        </tr>
        <%
            if (newContact.getAddressed() == 0) {
        %>
        <tr>
            <td align="right"> Addressed By</td>
            <td><select name="addressed_by">
                <%
                    strQuery = "from User where User_Type_And_Privilege = 2 OR User_Type_And_Privilege = 5 and User_Active_Status = 1";
                    query = theSession.createQuery(strQuery);
                    List list = query.list();
                    for (int i = 0; i < list.size(); i++) {
                        User theUser = (User) list.get(i);
                        String strSelected = "";
                        if (theUser.getLogin().compareToIgnoreCase("Pending") == 0)
                            strSelected = "selected";
                %>

                <option value="<%=theUser.getLogin()%>" <%=strSelected%>><%=theUser.getUserFirstName()%>
                </option>
                <%
                    }
                %>
            </select>
            </td>
        <tr>
            <td align="right">Comments</td>
            <td><input type="text" maxlength="90" name="the_comments" value=""/>
        <tr>
            <td></td>
            <td align="center"><input type="button" name="addressed" value="Addressed"
                                      onClick="validate_and_submit(1)"/>
                <input type="button" name="invalid" value="Invalid Contact" onClick="validate_and_submit(2)"/></td>
        </tr>
        <%
        } else {
        %>
        <tr>
            <td align="right"> Time Addressed</td>
            <td align="left"><%=newContact.getTimeAddressed()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Addressed</td>
            <td align="left"><%=strIsContacted%>
            </td>
        </tr>
        <tr>
            <td align="right"> Comments</td>
            <td align="left"><%=newContact.getComments()%>
            </td>
        </tr>
        <tr>
            <td align="right"> Addressed By</td>
            <td align="left"><%=newContact.getUser().getUserFirstName()%>
            </td>
        </tr>
        <%
            }
        %>
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
<a href="MasterInformation.jsp"> Go to Main </a>
</body>
</html>