<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.setContentType("text/xml");
    String strFailResult = "<the_response> <the_result code=\"0\"/> </the_response>";
    String strSuccessResult = "<the_response> <the_result code=\"1\"/> </the_response>";

    String strToCustomerGroup = request.getParameter("to_customer_group_id");
    String strFromcustomerGroup = request.getParameter("from_customer_group_id");
    String strSupplier = request.getParameter("supplier_id");

    int nToCustomerGroupID = 0;
    if (strToCustomerGroup != null && !strToCustomerGroup.isEmpty())
        nToCustomerGroupID = Integer.parseInt(strToCustomerGroup);

    int nFromCustomerGroupID = 0;
    if (strFromcustomerGroup != null && !strFromcustomerGroup.isEmpty())
        nFromCustomerGroupID = Integer.parseInt(strFromcustomerGroup);

    int nSupplierId = 0;
    if (strSupplier != null && !strSupplier.isEmpty())
        nSupplierId = Integer.parseInt(strSupplier);

    if (nToCustomerGroupID <= 0 || nFromCustomerGroupID <= 0 || nSupplierId <= 0) {
        response.getWriter().println(strFailResult);
        return;
    }

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        String strQuery = "from TMasterProductinfo where Product_Active_Status = 1 and Supplier_ID = " + nSupplierId;
        Query query = theSession.createQuery(strQuery);
        List theProducts = query.list();
        for (int nProduct = 0; nProduct < theProducts.size(); nProduct++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) theProducts.get(nProduct);

            strQuery = " from TCustomerGroupCommissions where Product_ID = " + prodInfo.getId() +
                    " and Customer_Group_ID = " + nFromCustomerGroupID;

            query = theSession.createQuery(strQuery);
            List theRecord = query.list();
            if (theRecord.size() > 0) {
                TCustomerGroupCommissions custGroupFromcomm = (TCustomerGroupCommissions) theRecord.get(0);

                strQuery = " from TCustomerGroupCommissions where Product_ID = " + prodInfo.getId() +
                        " and Customer_Group_ID = " + nToCustomerGroupID;

                query = theSession.createQuery(strQuery);
                theRecord = query.list();
                if (theRecord.size() > 0) {
                    TCustomerGroupCommissions custGroupTocomm = (TCustomerGroupCommissions) theRecord.get(0);

                    custGroupTocomm.setCommission(custGroupFromcomm.getCommission());
                    custGroupTocomm.setNotes(custGroupFromcomm.getNotes());
                    if (nSupplierId == TransferToServiceMain.TransferTo_SupplierID)
                        custGroupTocomm.setCommissionType((byte) 1);
                    theSession.save(custGroupTocomm);
                } else {
                    // new entry

                    TCustomerGroupCommissions custGroupTocomm = new TCustomerGroupCommissions();
                    custGroupTocomm.setId(custGroupFromcomm.getId());
                    custGroupTocomm.getId().setCustomerGroupId(nToCustomerGroupID);
                    custGroupTocomm.setActiveStatus((byte) 1);
                    if (nSupplierId == TransferToServiceMain.TransferTo_SupplierID)
                        custGroupTocomm.setCommissionType((byte) 1);
                    else
                        custGroupTocomm.setCommissionType((byte) 0);
                    custGroupTocomm.setCommission(custGroupFromcomm.getCommission());
                    custGroupTocomm.setNotes(custGroupFromcomm.getNotes());
                    User theUser = new User();
                    theUser.setLogin(request.getRemoteUser());
                    custGroupTocomm.setCreatedBy(request.getRemoteUser());
                    Date dt = Calendar.getInstance().getTime();
                    custGroupTocomm.setCreationTime(dt);
                    custGroupTocomm.setLastModifiedTime(dt);

                    theSession.save(custGroupTocomm);
                }
            }
        }

        theSession.getTransaction().commit();
        response.getWriter().println(strSuccessResult);
    } catch (Exception e) {
        theSession.getTransaction().rollback();
        e.printStackTrace();
        response.getWriter().println(strFailResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>