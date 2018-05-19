<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <title>Revoked Transactions Status and Report</title>
</head>
<body>
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <table border="1">
                            <tr>
                                <td> Old Customer Group</td>
                                <td> Old Customer</td>
                                <td> Old Transaction ID</td>
                                <td> Old Transaction Time</td>
                                <td> Sale Price</td>
                                <td> Product</td>
                                <td> Batch ID</td>
                                <td> Card Pin</td>
                                <td> Revoked Date</td>
                                <td> New Customer Group</td>
                                <td> New Customer</td>
                                <td> New Transaction ID</td>
                                <td> New Transaction Time</td>
                                <td> Credit</td>
                                <td> Reject</td>
                            </tr>
                            <%
                                String strQuery = "from TRevokedTransactions order by Sequence_ID desc";
                                Session theSession = null;
                                try {
                                    theSession = HibernateUtil.openSession();
                                    Query query = theSession.createQuery(strQuery);
                                    List revokedTransactionsList = query.list();

                                    for (int i = 0; i < revokedTransactionsList.size(); i++) {
                                        TRevokedTransactions oneTransaction = (TRevokedTransactions) revokedTransactionsList.get(i);

                                        strQuery = "from TTransactions where Transaction_ID = " + oneTransaction.getOriginalTransactionId();
                                        query = theSession.createQuery(strQuery);
                                        List oldTransactionList = query.list();

                                        if (oldTransactionList.size() <= 0) {
                                            strQuery = "select * from t_history_transactions where Transaction_ID = " + oneTransaction.getOriginalTransactionId();
                                            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                                            sqlQuery.addEntity(TTransactions.class);
                                            oldTransactionList = sqlQuery.list();
                                        }
                                        if (!oldTransactionList.isEmpty()) {
                                            String strStatus = "Not Sold";
                                            String strStatus1 = "";
                                            strQuery = "from TCardInfo where SequenceID = " + oneTransaction.getCardSequenceId();
                                            query = theSession.createQuery(strQuery);
                                            List cardsList = query.list();

                                            if (cardsList.size() <= 0) {
                                                strQuery = "from t_history_card_info where SequenceID = " + oneTransaction.getCardSequenceId();
                                                SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                                                cardsList = sqlQuery.list();
                                            }

                                            String strBatchID = "";
                                            String strCardPin = "";
                                            List newTransactionList = null;

                                            if (cardsList.size() > 0) {
                                                TCardInfo cardInfo = (TCardInfo) cardsList.get(0);
                                                strBatchID = cardInfo.getCardId();
                                                strCardPin = cardInfo.getCardPin();

                                                strQuery = "from TTransactions where Transaction_ID = " + cardInfo.getTransactionId();
                                                query = theSession.createQuery(strQuery);
                                                newTransactionList = query.list();

                                                if (newTransactionList.size() <= 0) {
                                                    strQuery = "select * from t_history_transactions where Transaction_ID = " + cardInfo.getTransactionId();
                                                    SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                                                    sqlQuery.addEntity(TTransactions.class);
                                                    newTransactionList = sqlQuery.list();
                                                }
                                            }

                                            TTransactions oldTransaction = (TTransactions) oldTransactionList.get(0);
                                            TTransactions newTransaction = null;
                                            if (newTransactionList.size() > 0) {
                                                newTransaction = (TTransactions) newTransactionList.get(0);
                                                if (oneTransaction.getSoldAgainStatus() == 0) {
                                                    oneTransaction.setNewSequenceId(newTransaction.getId());
                                                    oneTransaction.setNewTransctionId(newTransaction.getTransactionId());
                                                    oneTransaction.setSoldAgainStatus((byte) 1);
                                                    strStatus = "<a href=\"/masteradmin/CreditThisRevokedTransaction.jsp" +
                                                            "?Transaction=" + oneTransaction.getOriginalSequenceId() +
                                                            "&RevokeSequence=" + oneTransaction.getId() +
                                                            "\"> Credit This </a>";
                                                    theSession.save(oneTransaction);
                                                } else if (oneTransaction.getSoldAgainStatus() == 1) {
                                                    strStatus = "<a href=\"/masteradmin/CreditThisRevokedTransaction.jsp" +
                                                            "?Transaction=" + oneTransaction.getOriginalSequenceId() +
                                                            "&RevokeSequence=" + oneTransaction.getId() +
                                                            "\"> Credit This </a>";

                                                    strStatus1 = "<a href=\"/masteradmin/RejectThisRevokedTransaction.jsp" +
                                                            "?Transaction=" + oneTransaction.getNewSequenceId() +
                                                            "&RevokeSequence=" + oneTransaction.getId() +
                                                            "\"> Reject This </a>";
                                                }
                                                if (oneTransaction.getSoldAgainStatus() == 2) {
                                                    strStatus = "Already Credited";
                                                }

                                                if (oneTransaction.getSoldAgainStatus() == 3) {
                                                    strStatus = "Rejected";
                                                }
                                            }

                                            TMasterCustomerinfo oldCustInfo = oldTransaction.getCustomer();
                                            TMasterProductinfo productInfo = oldTransaction.getProduct();
                                            String strProduct = productInfo.getProductName() + " - " + productInfo.getProductFaceValue();

                                            TMasterCustomerinfo newCustomer = null;
                                            if (newTransaction != null)
                                                newCustomer = newTransaction.getCustomer();

                                            String oldCustomerGroup = oldCustInfo.getGroup().getName();
                                            String oldCustomerName = oldCustInfo.getCompanyName();
                                            long oldTransactionID = oldTransaction.getTransactionId();
                                            Date oldDate = oldTransaction.getTransactionTime();
                                            float fOldSalePrice = oldTransaction.getUnitPurchasePrice();
                                            if (oldCustInfo.getGroup().getId() != 1)
                                                fOldSalePrice = oldTransaction.getUnitGroupPrice();

                                            Date revokedDate = oneTransaction.getRevokedDate();

                                            String newCustomerGroup = "";
                                            String newCustomerName = "";
                                            long newTransactionID = 0;
                                            Date newDate = null;

                                            if (newCustomer != null) {
                                                newCustomerGroup = newCustomer.getGroup().getName();
                                                newCustomerName = newCustomer.getCompanyName();
                                                newTransactionID = newTransaction.getTransactionId();
                                                newDate = newTransaction.getTransactionTime();
                                            }
                            %>
                            <tr>
                                <td> <%=oldCustomerGroup%>
                                <td><%=oldCustomerName%>
                                </td>
                                <td><%=oldTransactionID%>
                                </td>
                                <td><%=oldDate%>
                                </td>
                                <td><%=fOldSalePrice%>
                                </td>
                                <td><%=strProduct%>
                                </td>
                                <td><%=strBatchID%>
                                </td>
                                <td><%=strCardPin%>
                                </td>
                                <td><%=revokedDate%>
                                </td>
                                <td><%=newCustomerGroup%>
                                </td>
                                <td><%=newCustomerName%>
                                </td>
                                <td><%=newTransactionID%>
                                </td>
                                <td><%=newDate%>
                                </td>
                                <td><%=strStatus%>
                                </td>
                                <td><%=strStatus1%>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    HibernateUtil.closeSession(theSession);
                                }
                            %>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>