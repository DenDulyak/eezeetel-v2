<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>


<%
    String strCustomerID = request.getParameter("customer_id");
    int nCustomerID = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerID = Integer.parseInt(strCustomerID);
    if (nCustomerID == 0 || nCustomerID == 28) return;

    String strCredit_ID = request.getParameter("credit_id");
    Session theSession = null;
    try {
        Calendar cal = Calendar.getInstance();
        Date dt = cal.getTime();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String strUpdateDate = "Updated to Credit on " + sdf.format(dt);

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        String strQuery = "from TMasterCustomerCredit where Credit_ID = " + strCredit_ID;
        Query query = theSession.createQuery(strQuery);
        List theList = query.list();
        if (theList.size() > 0) {
            TMasterCustomerCredit custCredit = (TMasterCustomerCredit) theList.get(0);
            custCredit.setCreditOrDebit((byte) 1);
            custCredit.setCreditIdStatus((byte) 2);
            custCredit.setPaymentDate(dt);
            custCredit.setPaymentType((byte) 1);
            custCredit.setPaymentDetails("Cash Received");

            String theNotes = "";
            if (custCredit.getNotes() != null)
                theNotes = custCredit.getNotes();
            custCredit.setNotes(theNotes + ", " + strUpdateDate);

            theSession.save(custCredit);
        }

        theSession.getTransaction().commit();

        String strUrl = "AJAX_GetCreditInfo.jsp?customer_id=" + strCustomerID;
        response.sendRedirect(strUrl);
    } catch (Exception e) {
        e.printStackTrace();
        theSession.getTransaction().rollback();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
