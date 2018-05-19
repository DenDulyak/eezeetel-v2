package com.utilities;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.eezeetel.enums.RevokedTransactionStatus;
import org.hibernate.LockMode;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import com.eezeetel.util.HibernateUtil;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.TReportCustomerProfit;
import com.eezeetel.entity.TReportEezeetelProfit;
import com.eezeetel.entity.TReportGroupProfit;
import com.eezeetel.entity.TRevokedTransactions;
import com.eezeetel.entity.TTransactions;

public class RevokeTransaction {

    public boolean RevokeProfit(long nSequenceID, int revokeSequenceID, boolean creditThis) {
        float fTHEVAT = 1.2F;

        Session theSession = null;
        try {
            boolean bFromHistory = false;
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            if (!creditThis) {
                Query query = theSession.createQuery("from TRevokedTransactions where Sequence_ID = " + revokeSequenceID);
                query.setMaxResults(1);
                TRevokedTransactions revokedTransaction = (TRevokedTransactions) query.uniqueResult();
                if (revokedTransaction != null) {
                    revokedTransaction.setSoldAgainStatus((byte) RevokedTransactionStatus.REJECTED.ordinal());
                    theSession.save(revokedTransaction);
                    theSession.getTransaction().commit();
                    return true;
                }
                return false;
            }

            String strQuery = "from TTransactions qc where Sequence_ID = " + nSequenceID + " and Committed = 3 "
                    + " and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295) "
                    + " and Product_ID != 146 and Post_Processing_Stage = 0";

            Query query = theSession.createQuery(strQuery);

            List transList = query.list();
            if (transList.size() <= 0) {
                strQuery = "select * from t_history_transactions qc where Sequence_ID = " + nSequenceID + " and Committed = 3 "
                        + " and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295) "
                        + " and Product_ID != 146 and Post_Processing_Stage = 0";

                SQLQuery query1 = theSession.createSQLQuery(strQuery);
                query1.addEntity(TTransactions.class);
                transList = query1.list();

                bFromHistory = true;
            }

            if (transList.isEmpty()) return false;

            TTransactions theTransaction = (TTransactions) transList.get(0);
            TMasterCustomerinfo custInfo = theTransaction.getCustomer();
            TMasterCustomerGroups custGroup = custInfo.getGroup();

            Calendar dtBegin = Calendar.getInstance();
            dtBegin.setTime(theTransaction.getTransactionTime());
            Calendar dtEnd = Calendar.getInstance();
            dtEnd.setTime(theTransaction.getTransactionTime());
            dtEnd.add(Calendar.MONTH, 1);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
            String strBeginDate = sdf.format(dtBegin.getTime());
            String strEndDate = sdf.format(dtEnd.getTime());

            Date dateBegin = null;
            Date dateEnd = null;
            try {
                dateBegin = sdf.parse(strBeginDate);
                dateEnd = sdf.parse(strEndDate);
            } catch (ParseException e) {
                return false;
            }
            boolean bLocalMobile = false;
            if (theTransaction.getProduct().getSupplier().getSupplierType().getId() == 16) {
                bLocalMobile = true;
            }
            strQuery = "from TReportCustomerProfit qc1 where Customer_ID = " + custInfo.getId() + " and Product_ID = "
                    + theTransaction.getProduct().getId() + " and Begin_Date = '" + strBeginDate
                    + "' and End_Date = '" + strEndDate + "'";

            Query query2 = theSession.createQuery(strQuery);
            query2.setLockMode("qc1", LockMode.UPGRADE);
            List cust_profit_list = query2.list();

            float fCustomerVAT = 0.0F;
            float fAgentVAT = 0.0F;
            float fGroupVAT = 0.0F;
            float fEezeeTelVAT = 0.0F;

            float fCustComm = 0.0F;
            float fAgentComm = 0.0F;
            float fGroupComm = 0.0F;
            float fEezeeComm = 0.0F;
            if (cust_profit_list.size() > 0) {
                TReportCustomerProfit custProfit = (TReportCustomerProfit) cust_profit_list.get(0);

                float fBatchOriginalCost = custProfit.getBatchOriginalCost() / custProfit.getQuantity()
                        * theTransaction.getQuantity();

                custProfit.setBatchOriginalCost(custProfit.getBatchOriginalCost() - fBatchOriginalCost);
                custProfit.setQuantity(custProfit.getQuantity() - theTransaction.getQuantity());
                custProfit.setBatchCost(custProfit.getBatchCost() - theTransaction.getBatchUnitPrice());
                custProfit.setCostToGroup(custProfit.getCostToGroup() - theTransaction.getUnitGroupPrice());
                custProfit.setCostToAgent(custProfit.getCostToAgent() - theTransaction.getSecondaryTransactionPrice());
                custProfit.setCostToCustomer(custProfit.getCostToCustomer() - theTransaction.getUnitPurchasePrice());

                fCustComm = custProfit.getRetailCost() * theTransaction.getQuantity() - theTransaction.getUnitPurchasePrice();
                fAgentComm = theTransaction.getUnitPurchasePrice() - theTransaction.getSecondaryTransactionPrice();
                fGroupComm = theTransaction.getSecondaryTransactionPrice() - theTransaction.getUnitGroupPrice();
                fEezeeComm = theTransaction.getUnitGroupPrice() - fBatchOriginalCost;
                if (custInfo.getGroup().getId() == 1) {
                    fEezeeComm += fGroupComm;
                }
                if (theTransaction.getProduct().getCalculateVat() == 1) {
                    fCustomerVAT = custProfit.getRetailCost() - theTransaction.getUnitPurchasePrice();
                    fCustomerVAT -= fCustomerVAT / 1.2F;
                    fAgentVAT = theTransaction.getUnitPurchasePrice() - theTransaction.getSecondaryTransactionPrice();
                    fAgentVAT -= fAgentVAT / 1.2F;
                    fGroupVAT = theTransaction.getSecondaryTransactionPrice() - theTransaction.getUnitGroupPrice();
                    fGroupVAT -= fGroupVAT / 1.2F;
                    fEezeeTelVAT = theTransaction.getUnitGroupPrice() - theTransaction.getQuantity() * fBatchOriginalCost;
                    fEezeeTelVAT -= fEezeeTelVAT / 1.2F;
                    if (custInfo.getGroup().getId() == 1) {
                        fEezeeTelVAT += fGroupVAT;
                        fGroupVAT = fEezeeTelVAT;
                    }
                }
                custProfit.setCustomerVat(custProfit.getCustomerVat() - fCustomerVAT);
                custProfit.setAgentVat(custProfit.getAgentVat() - fAgentVAT);
                custProfit.setGroupVat(custProfit.getGroupVat() - fGroupVAT);
                custProfit.setEezeeTelVat(custProfit.getEezeeTelVat() - fEezeeTelVAT);

                theSession.save(custProfit);
            }
            strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + custInfo.getId() + " and Begin_Date = '"
                    + strBeginDate + "' and End_Date = '" + strEndDate + "'";

            query2 = theSession.createQuery(strQuery);
            query2.setLockMode("qc1", LockMode.UPGRADE);
            List group_profit_list = query2.list();
            if (group_profit_list.size() > 0) {
                TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() - fCustComm);
                groupProfit.setAgentCommission(groupProfit.getAgentCommission() - fAgentComm);

                groupProfit.setTotalAmount(groupProfit.getTotalAmount() - theTransaction.getUnitGroupPrice());

                groupProfit.setCustomerVat(groupProfit.getCustomerVat() - fCustomerVAT);
                groupProfit.setAgentVat(groupProfit.getAgentVat() - fAgentVAT);
                groupProfit.setGroupVat(groupProfit.getGroupVat() - fGroupVAT);
                groupProfit.setEezeeTelVat(groupProfit.getEezeeTelVat() - fEezeeTelVAT);
                if (bLocalMobile) {
                    float fValue = groupProfit.getProfitFromLocalMobile() - fGroupComm;
                    if (fValue < 0.0F) {
                        fValue = 0.0F;
                    }
                    groupProfit.setProfitFromLocalMobile(fValue);

                    fValue = groupProfit.getEezeeTelLocalMobileProfit() - fEezeeComm;
                    if (fValue < 0.0F) {
                        fValue = 0.0F;
                    }
                    groupProfit.setEezeeTelLocalMobileProfit(fValue);
                    groupProfit.setTotalLocalMobileTransactions(groupProfit.getTotalLocalMobileTransactions()
                            - theTransaction.getQuantity());
                } else {
                    float fValue = groupProfit.getProfitFromCallingCards() - fGroupComm;
                    if (fValue < 0.0F) {
                        fValue = 0.0F;
                    }
                    groupProfit.setProfitFromCallingCards(fValue);

                    fValue = groupProfit.getEezeeTelCardsProfit() - fEezeeComm;
                    if (fValue < 0.0F) {
                        fValue = 0.0F;
                    }
                    groupProfit.setEezeeTelCardsProfit(fValue);

                    groupProfit.setTotalCards(groupProfit.getTotalCards() - theTransaction.getQuantity());
                }
                theSession.save(groupProfit);
            }
            strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                    + custInfo.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                    + "' and End_Date = '" + strEndDate + "'";

            query2 = theSession.createQuery(strQuery);
            query2.setLockMode("qc1", LockMode.UPGRADE);
            List eezeetel_profit_list = query2.list();
            if (eezeetel_profit_list.size() > 0) {
                TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);
                if (bLocalMobile) {
                    float fValue = eezeeTelProfit.getProfitFromLocalMobile() - fEezeeComm;
                    if (fValue < 0.0F) {
                        fValue = 0.0F;
                    }
                    eezeeTelProfit.setProfitFromLocalMobile(fValue);
                    eezeeTelProfit.setTotalLocalMobileTransactions(eezeeTelProfit.getTotalLocalMobileTransactions()
                            - theTransaction.getQuantity());
                } else {
                    float fValue = eezeeTelProfit.getProfitFromCallingCards() - fEezeeComm;
                    if (fValue < 0.0F) {
                        fValue = 0.0F;
                    }
                    eezeeTelProfit.setProfitFromCallingCards(fValue);
                    eezeeTelProfit.setTotalCards(eezeeTelProfit.getTotalCards() - theTransaction.getQuantity());
                }
                theSession.save(eezeeTelProfit);
            }
            if (bFromHistory) {
                strQuery = "update t_history_transactions set Post_Processing_Stage = 1 where Sequence_ID = "
                        + theTransaction.getId();
                SQLQuery query1 = theSession.createSQLQuery(strQuery);
                query1.executeUpdate();
            } else {
                theTransaction.setPostProcessingStage(true);
                theSession.save(theTransaction);
            }
            strQuery = "insert into t_master_customer_credit (Customer_ID, Payment_Type, Payment_Details, Payment_Amount, Payment_Date, Collected_By, Entered_By, Entered_Time, Credit_or_Debit, Credit_ID_Status)values ("
                    + custInfo.getId()
                    + ", 1"
                    + ",' Revoked Transaction "
                    + theTransaction.getTransactionId()
                    + " Credit'," + theTransaction.getUnitPurchasePrice() + ", now(), 'raghuanik', 'raghuanik', now(), 1, 2)";

            SQLQuery creditQuery = theSession.createSQLQuery(strQuery);
            creditQuery.executeUpdate();
            custInfo.setCustomerBalance(custInfo.getCustomerBalance() + theTransaction.getUnitPurchasePrice());
            theSession.save(custInfo);
            if (custInfo.getGroup().getCheckAganinstGroupBalance()) {
                strQuery = "insert into t_master_customer_group_credit (Customer_Group_ID, Payment_Type, Payment_Details, Payment_Amount, Payment_Date, Collected_By, Entered_By, Entered_Time, Credit_or_Debit)values ("
                        + custInfo.getGroup().getId()
                        + ", 1"
                        + ",' Revoked Transaction "
                        + theTransaction.getTransactionId()
                        + " Credit',"
                        + theTransaction.getUnitGroupPrice()
                        + ", now(), 'raghuanik', 'raghuanik', now(), 1)";

                SQLQuery groupCreditQuery = theSession.createSQLQuery(strQuery);
                groupCreditQuery.executeUpdate();
                custGroup.setCustomerGroupBalance(custGroup.getCustomerGroupBalance() + theTransaction.getUnitGroupPrice());
                theSession.save(custGroup);
            }
            strQuery = "from TRevokedTransactions where Sequence_ID = " + revokeSequenceID;
            query = theSession.createQuery(strQuery);
            List revokedTransaction = query.list();
            TRevokedTransactions theRevokedTransaction = (TRevokedTransactions) revokedTransaction.get(0);
            if (creditThis) {
                theRevokedTransaction.setSoldAgainStatus((byte) 2);
            } else {
                theRevokedTransaction.setSoldAgainStatus((byte) 3);
            }
            theSession.save(theRevokedTransaction);

            theSession.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }
}
