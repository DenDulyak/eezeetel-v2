<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    Session theSession = null;
    try {
        int nRequestID = 0;
        int nActionCase = 0;
        float fApprovedAmount = 0.0f;
        String strRequestID = request.getParameter("credit_request_id");
        String strActionCase = request.getParameter("action_case");
        String strApproverComments = request.getParameter("approver_comments");
        String strApprovedAmount = request.getParameter("approved_amount");
        String strCollectedBy = request.getParameter("collected_by");

        if (strRequestID != null && !strRequestID.isEmpty())
            nRequestID = Integer.parseInt(strRequestID);

        if (strActionCase != null && !strActionCase.isEmpty())
            nActionCase = Integer.parseInt(strActionCase);

        if (nRequestID <= 0 || nActionCase <= 0) return;

        if (strApprovedAmount != null && !strApprovedAmount.isEmpty())
            fApprovedAmount = Float.parseFloat(strApprovedAmount);

        String strCreditIDList = "";
        String[] listCreditIDs = request.getParameterValues("credit_id");
        if (listCreditIDs != null) {
            for (int i = 0; i < listCreditIDs.length; i++) {
                if (i != 0)
                    strCreditIDList += ", ";
                strCreditIDList += listCreditIDs[i];
            }
        }

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

        String strQuery = "from TCreditRequests qc where Request_Status = 1 and Request_ID = " + nRequestID;
        Query query = theSession.createQuery(strQuery);
        query.setLockMode("qc", LockMode.UPGRADE);
        List list = query.list();
        if (list.size() > 0) {
            TCreditRequests creditRequest = (TCreditRequests) list.get(0);
            TMasterCustomerinfo custInfo = creditRequest.getCustomer();
            TMasterCustomerGroups custGroups = custInfo.getGroup();

            if (nCustomerGroupID == custGroups.getId().intValue()) {
                String strStatus = "";
                switch (nActionCase) {
                    case 2:
                        strStatus = "Approved";
                        break;
                    case 3:
                        strStatus = "Partially Approved";
                        break;
                    case 4:
                        strStatus = "Pending Payment Verification";
                        break;
                    case 5:
                        strStatus = "Rejected";
                        break;
                    case 6:
                        strStatus = "Paid Debt";
                        break;
                }

                Date dt = Calendar.getInstance().getTime();
                creditRequest.setApprovalDate(dt);
                creditRequest.setApprovedBy(request.getRemoteUser());

                if (nActionCase == 2) // full approval
                {
                    creditRequest.setApproverComments(strApproverComments);
                    creditRequest.setApprovedAmount(creditRequest.getRequestAmount());
                    creditRequest.setRequestStatus((byte) 2);

                    // create new credit entry

                    TMasterCustomerCredit custCredit = new TMasterCustomerCredit();
                    custCredit.setId(0);
                    custCredit.setCustomer(custInfo);
                    custCredit.setPaymentType(creditRequest.getPaymentType());
                    custCredit.setNotes("Request ID :" + creditRequest.getId());
                    if (creditRequest.getAmountAlreadyPaid() == 1) {
                        custCredit.setPaymentDate(creditRequest.getPaymentDate());
                        custCredit.setCreditIdStatus((byte) 1);
                    }


                    strQuery = "from User where User_Login_ID = '" + strCollectedBy + "'";
                    query = theSession.createQuery(strQuery);
                    list = query.list();
                    if (list.size() > 0)
                        custCredit.setCollectedBy((User) list.get(0));

                    strQuery = "from User where User_Login_ID = '" + request.getRemoteUser() + "'";
                    query = theSession.createQuery(strQuery);
                    list = query.list();
                    if (list.size() > 0)
                        custCredit.setEnteredBy((User) list.get(0));
                    custCredit.setEnteredTime(dt);

                    custCredit.setCreditOrDebit((byte) 2);
                    custCredit.setPaymentAmount(creditRequest.getRequestAmount());

                    // update customer balance

                    custInfo.setCustomerBalance(custInfo.getCustomerBalance() + creditRequest.getRequestAmount());

                    // write to database
                    theSession.save(custCredit);
                    creditRequest.setCreditIdList(custCredit.getId().toString());
                    theSession.save(creditRequest);
                    theSession.save(custInfo);
                } else if (nActionCase == 3)  // partial approval
                {
                    creditRequest.setApprovedAmount(fApprovedAmount);
                    creditRequest.setRequestStatus((byte) 3);

                    if (creditRequest.getAmountAlreadyPaid() == 0 || strCreditIDList.isEmpty())
                        creditRequest.setApproverComments(strApproverComments);
                    if (creditRequest.getAmountAlreadyPaid() == 1) {
                        if (fApprovedAmount > 0)
                            strApproverComments += "- Credited " + fApprovedAmount;

                        if (!strCreditIDList.isEmpty())
                            strApproverComments += ", Adjusted to Previous Credit ID(s) - " + strCreditIDList;

                        query = theSession.createQuery("from TMasterCustomerCredit where Credit_ID in (" + strCreditIDList + ")");
                        List theCredits = query.list();
                        for (int i = 0; i < theCredits.size(); i++) {
                            TMasterCustomerCredit theCredit = (TMasterCustomerCredit) theCredits.get(i);
                            theCredit.setPaymentType(creditRequest.getPaymentType());
                            theCredit.setPaymentDate(creditRequest.getPaymentDate());
                            String theNotes = "";
                            if (theCredit.getNotes() != null)
                                theNotes = theCredit.getNotes();

                            theCredit.setNotes(theNotes + "- Paid by Request ID : " + creditRequest.getId());
                            theCredit.setCreditIdStatus((byte) 1);
                            theSession.save(theCredit);
                        }
                    }

                    creditRequest.setApproverComments(strApproverComments);

                    // write to database

                    if (fApprovedAmount > 0) {
                        TMasterCustomerCredit custCredit = new TMasterCustomerCredit();
                        custCredit.setId(0);
                        custCredit.setCustomer(custInfo);
                        custCredit.setPaymentType(creditRequest.getPaymentType());
                        custCredit.setNotes("Request ID :" + creditRequest.getId());
                        custCredit.setPaymentAmount(fApprovedAmount);

                        if (creditRequest.getAmountAlreadyPaid() == 1) {
                            custCredit.setPaymentDate(creditRequest.getPaymentDate());
                            custCredit.setCreditIdStatus((byte) 1);
                        }

                        strQuery = "from User where User_Login_ID = '" + strCollectedBy + "'";
                        query = theSession.createQuery(strQuery);
                        list = query.list();
                        if (list.size() > 0)
                            custCredit.setCollectedBy((User) list.get(0));

                        strQuery = "from User where User_Login_ID = '" + request.getRemoteUser() + "'";
                        query = theSession.createQuery(strQuery);
                        list = query.list();
                        if (list.size() > 0)
                            custCredit.setEnteredBy((User) list.get(0));
                        custCredit.setEnteredTime(dt);

                        custCredit.setCreditOrDebit((byte) 2);
                        theSession.save(custCredit);
                        creditRequest.setCreditIdList(custCredit.getId().toString());
                    }

                    // update customer balance
                    custInfo.setCustomerBalance(custInfo.getCustomerBalance() + fApprovedAmount);
                    theSession.save(custInfo);
                    theSession.save(creditRequest);
                } else if (nActionCase == 5)  //reject
                {
                    creditRequest.setApprovedAmount(0f);
                    creditRequest.setRequestStatus((byte) 5);
                    creditRequest.setApproverComments(strApproverComments);

                    theSession.save(creditRequest);
                }
            }
        }

        theSession.getTransaction().commit();
    } catch (Exception e) {
        e.printStackTrace();
        if (theSession != null)
            theSession.getTransaction().rollback();
    } finally {
        HibernateUtil.closeSession(theSession);
    }

    response.sendRedirect("/admin/Accounts/ManageCreditRequests.jsp");
%>


