<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.setContentType("text/xml");
    String strFailResult = "<the_response> <the_result code=\"0\"/> </the_response>";
    String strSuccessResult = "<the_response> <the_result code=\"1\"/> </the_response>";
    Session theSession = null;

    try {
        String strCustomerGroupID = request.getParameter("customer_group_id");
        String strSupplierID = request.getParameter("supplier_id");

        int nCustomerGroupId = 0;
        if (strCustomerGroupID != null && !strCustomerGroupID.isEmpty())
            nCustomerGroupId = Integer.parseInt(strCustomerGroupID);

        int nSupplierID = 0;
        if (strSupplierID != null && !strSupplierID.isEmpty())
            nSupplierID = Integer.parseInt(strSupplierID);

        if (nCustomerGroupId <= 0 || nSupplierID <= 0) {
            response.getWriter().println(strFailResult);
            return;
        }

        DocumentBuilderFactory docBuildFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder = docBuildFactory.newDocumentBuilder();
        Document doc = docBuilder.parse(request.getInputStream());
        NodeList modifedProducts = doc.getElementsByTagName("product");
        int nModifedProducts = modifedProducts.getLength();

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        for (int i = 0; i < nModifedProducts; i++) {
            Node theProductNode = modifedProducts.item(i);
            if (theProductNode.getNodeType() == Node.ELEMENT_NODE) {
                Element theProduct = (Element) theProductNode;
                String strProductID = theProduct.getAttribute("id");
                String strEeezeeTelCommission = theProduct.getAttribute("ee_comm");
                //String strAgentCommission = theProduct.getAttribute("ag_comm");
                String strNotes = theProduct.getAttribute("notes");
                float fNewCommission = 0f;
                if (strEeezeeTelCommission != null && !strEeezeeTelCommission.isEmpty())
                    fNewCommission = Float.parseFloat(strEeezeeTelCommission);
            /*float fNewAgentCommission = 0f;
            if (strAgentCommission != null && !strAgentCommission.isEmpty())
    			fNewAgentCommission = Float.parseFloat(strAgentCommission); */
                if (strNotes == null)
                    strNotes = "";

                String strQuery = " from TCustomerGroupCommissions where Product_ID = " + strProductID +
                        " and Customer_Group_ID = " + nCustomerGroupId;

                Query query = theSession.createQuery(strQuery);
                List theRecord = query.list();
                if (theRecord.size() > 0) {
                    TCustomerGroupCommissions custgroupcomm = (TCustomerGroupCommissions) theRecord.get(0);

                    custgroupcomm.setCommission(fNewCommission); // set eezeetel commission
                    //custgroupcomm.setAgentCommission(fNewAgentCommission);  // set agent commission
                    if (strNotes != null)
                        custgroupcomm.setNotes(strNotes);
                    if (nSupplierID == TransferToServiceMain.TransferTo_SupplierID)
                        custgroupcomm.setCommissionType((byte) 1);

                    theSession.saveOrUpdate(custgroupcomm);
                } else {
                    // new entry

                    TCustomerGroupCommissionsId custgroupcommId = new TCustomerGroupCommissionsId();
                    custgroupcommId.setCustomerGroupId(nCustomerGroupId);
                    custgroupcommId.setProductId(Integer.parseInt(strProductID));

                    TCustomerGroupCommissions custgroupcomm = new TCustomerGroupCommissions();
                    custgroupcomm.setId(custgroupcommId);
                    custgroupcomm.setActiveStatus((byte) 1);
                    if (nSupplierID == TransferToServiceMain.TransferTo_SupplierID)
                        custgroupcomm.setCommissionType((byte) 1);
                    else
                        custgroupcomm.setCommissionType((byte) 0);
                    custgroupcomm.setCommission(fNewCommission);
                    //custgroupcomm.setAgentCommission(fNewAgentCommission);
                    if (strNotes != null)
                        custgroupcomm.setNotes(strNotes);
                    custgroupcomm.setNotes(strNotes);
                    custgroupcomm.setCreatedBy(request.getRemoteUser());
                    Date dt = Calendar.getInstance().getTime();
                    custgroupcomm.setCreationTime(dt);
                    custgroupcomm.setLastModifiedTime(dt);

                    theSession.saveOrUpdate(custgroupcomm);
                }
            }
        }

        theSession.getTransaction().commit();
        response.getWriter().println(strSuccessResult);
    } catch (Exception e) {
        e.printStackTrace();
        theSession.getTransaction().rollback();
        response.getWriter().println(strFailResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
