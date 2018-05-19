package com.eezeetel.job;

import com.eezeetel.util.HibernateUtil;
import org.apache.log4j.Logger;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.quartz.DisallowConcurrentExecution;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.PersistJobDataAfterExecution;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Created by Denis Dulyak on 06.04.2016.
 */
@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class MoveDataToHistory extends QuartzJobBean {

    private static Logger log = Logger.getLogger(MoveDataToHistory.class);

    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        log.info("Moving data on " + Calendar.getInstance().getTime().toString() + " to History -- ");
        moveDataToHistory();
        log.info("Moving data to History. -- Done.");
        log.info("Updating closing stock.");
        updateClosingStock();
        log.info("Updating closing stock. -- Done.");
    }

    public void moveDataToHistory() {
        try {
            Calendar now = Calendar.getInstance();
            Calendar weekAgo = (Calendar) now.clone();
            weekAgo.add(6, -7);
            Calendar monthAgo = (Calendar) now.clone();
            monthAgo.add(6, -30);

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
            String strWeekAgo = formatter.format(weekAgo.getTime());
            String strMonthAgo = formatter.format(monthAgo.getTime());

            moveTransactionBalanceToHistory(strWeekAgo);
            moveCardInfoToHistory(strMonthAgo);
            moveTransfertoTransactionsToHistory(strWeekAgo);
            moveTransactionsToHistory(strWeekAgo);
            moveUserLogToHistory(strWeekAgo);
            moveBatchInformationToHistory(strMonthAgo);

        } catch (Exception e) {
            log.info("ERROR : " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void moveTransactionBalanceToHistory(String strWeekAgo) {
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "insert into t_history_transaction_balance (select * from t_transaction_balance where  Transaction_ID in (select Transaction_ID from t_transactions where  Transaction_Time < '"
                    + strWeekAgo + "'))";

            SQLQuery query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            strQuery = "delete from t_transaction_balance where  Transaction_ID in (select Transaction_ID from t_transactions where  Transaction_Time < '" + strWeekAgo + "')";

            query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error on moveTransactionBalanceToHistory. Message - " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
    }

    private void moveCardInfoToHistory(String strMonthAgo) {
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "insert into t_history_card_info (select * from t_card_info where  IsSold = 1 and Transaction_ID in (select Transaction_ID from t_transactions  where Transaction_Time < '"
                    + strMonthAgo + "' ))";

            SQLQuery query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            strQuery = "delete from t_card_info where  Transaction_ID in (select Transaction_ID from t_transactions  where Transaction_Time < '"
                    + strMonthAgo + "' )";

            query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error on moveCardInfoToHistory. Message - " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
    }

    private void moveTransfertoTransactionsToHistory(String strWeekAgo) {
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "insert into t_history_transferto_transactions (select * from t_transferto_transactions  where Transaction_Time < '" + strWeekAgo + "')";

            SQLQuery query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            strQuery = "delete from t_transferto_transactions where Transaction_Time < '" + strWeekAgo + "'";

            query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error on moveTransfertoTransactionsToHistory. Message - " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
    }

    private void moveTransactionsToHistory(String strWeekAgo) {
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "insert into t_history_transactions (select * from t_transactions  where Transaction_Time < '" + strWeekAgo + "')";

            SQLQuery query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            strQuery = "delete from t_transactions where Transaction_Time < '" + strWeekAgo + "'";

            query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error on moveTransactionsToHistory. Message - " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
    }

    private void moveUserLogToHistory(String strWeekAgo) {
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "insert into t_history_user_log (select * from t_user_log where  Login_Time < '" + strWeekAgo + "')";

            SQLQuery query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            strQuery = "delete from t_user_log where Login_Time < '" + strWeekAgo + "'";

            query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error on moveUserLogToHistory. Message - " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
    }

    private void moveBatchInformationToHistory(String strMonthAgo) {
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "insert into t_history_batch_information (select * from t_batch_information  where Available_Quantity = 0 and Last_Touch_Time < '"
                    + strMonthAgo
                    + "'"
                    + " and SequenceID not in (select distinct(Batch_Sequence_ID) from t_card_info) "
                    + " and SequenceID not in (select distinct(Batch_Sequence_ID) from t_sim_cards_info))";

            SQLQuery query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            strQuery = "delete from t_batch_information  where Available_Quantity = 0 and Last_Touch_Time < '"
                    + strMonthAgo
                    + "' "
                    + " and SequenceID not in (select distinct(Batch_Sequence_ID) from t_card_info) "
                    + " and SequenceID not in (select distinct(Batch_Sequence_ID) from t_sim_cards_info)";

            query = session.createSQLQuery(strQuery);
            query.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error on moveBatchInformationToHistory. Message - " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
    }

    public void updateClosingStock() {
        Session session = null;
        String strQuery = "";
        String strBigQuery = "";
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            SimpleDateFormat sqlDtFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String strSqlDate = sqlDtFormat.format(Calendar.getInstance().getTime());

            strQuery = "insert into t_dialy_batch_log (select '" + strSqlDate
                    + "', SequenceID, Available_Quantity from t_batch_information)";

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            log.info("Failed to update closing stock.");
            e.printStackTrace();
            if (session != null) {
                session.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(session);
        }
    }
}
