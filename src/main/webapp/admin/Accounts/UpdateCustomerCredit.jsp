<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    int nPaymentType = Integer.parseInt(request.getParameter("payment_type"));
    int nCreditOrDebit = Integer.parseInt(request.getParameter("credit_or_debit"));
    String strCollectedBy = request.getParameter("collected_by");
    int nCreditID = Integer.parseInt(request.getParameter("credit_id"));
    String strPaymentDetails = request.getParameter("payment_details");

    Session theSession = null;
    try {
        Calendar cal = Calendar.getInstance();
        Date dt = cal.getTime();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String strUpdateDate = "Updated to Credit on " + sdf.format(dt);

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

        String strQuery = "from TMasterCustomerCredit where Credit_ID = " + nCreditID;
        Query query = theSession.createQuery(strQuery);

        List theList = query.list();
        if (theList.size() > 0) {
            TMasterCustomerCredit custCredit = (TMasterCustomerCredit) theList.get(0);
            TMasterCustomerGroups custGroup = custCredit.getCustomer().getGroup();
            if (custGroup.getId().intValue() == nCustomerGroupID) {
                int nPreviousStateOfCredit_or_Debit = custCredit.getCreditOrDebit();
                custCredit.setCreditOrDebit((byte) nCreditOrDebit);

                if (strPaymentDetails == null || strPaymentDetails.isEmpty())
                    strPaymentDetails = "";

                custCredit.setPaymentDetails(strPaymentDetails);

                String theNotes = "";
                if (custCredit.getNotes() != null)
                    theNotes = custCredit.getNotes();

                if (nCreditOrDebit == 1 && nPreviousStateOfCredit_or_Debit == 2) // changing form debit to credit
                {
                    custCredit.setNotes(theNotes + ", " + strUpdateDate);
                    if (custCredit.getPaymentDate() == null)
                        custCredit.setPaymentDate(dt);
                    custCredit.setCreditIdStatus((byte) 2);
                }

                custCredit.setPaymentType((byte) nPaymentType);
                theSession.save(custCredit);
            }
        }

        theSession.getTransaction().commit();
        response.sendRedirect("/admin/Accounts/ManageCustomerCredit.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        if (theSession != null) {
            theSession.getTransaction().rollback();
        }
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Customer Credit.</FONT></H4>" +
                "<A HREF=\"/admin/Accounts/ManageCustomerCredit.jsp\">Manage Customer Credit</A></BODY></HTML>";
        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
