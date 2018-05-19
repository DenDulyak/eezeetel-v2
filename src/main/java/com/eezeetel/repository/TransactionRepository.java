package com.eezeetel.repository;

import com.eezeetel.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.persistence.LockModeType;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 09.12.2015.
 */
@Repository
public interface TransactionRepository extends JpaRepository<TTransactions, Integer> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    List<TTransactions> findByTransactionIdAndCommitted(Long transactionId, byte committed);

    List<TTransactions> findByTransactionId(Long transactionId);

    @Query(value = "CALL SP_GetTransactionID", nativeQuery = true)
    Long getNextTransactionId();

    List<TTransactions> findByUserAndCommitted(User user, byte committed);

    List<TTransactions> findByCommitted(byte committed);

    List<TTransactions> findByCommittedAndTransactionTimeBetween(byte committed, Date startDate, Date endDate);

    List<TTransactions> findByCustomerAndCommittedAndTransactionTimeBetween(TMasterCustomerinfo customer, byte committed, Date startDate, Date endDate);

    List<TTransactions> findByCustomerGroupAndCommittedAndTransactionTimeBetween(TMasterCustomerGroups group, byte committed, Date startDate, Date endDate);

    List<TTransactions> findByBatchAndCommitted(TBatchInformation batch, byte committed);

    List<TTransactions> findByProductIdAndCommittedAndTransactionTimeBetween(Integer productId, byte committed, Date startDate, Date endDate);

    @Query(value = "select round(sum(t.Unit_Purchase_Price), 2) from t_transactions t where t.Customer_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select count(DISTINCT t.Transaction_ID) as transactions from t_transactions t where t.Customer_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select sum(t.Quantity) from t_transactions t where t.Customer_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    Integer amountCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select round(sum(t.Unit_Group_Price), 2) from t_transactions t, t_master_customerinfo c " +
            "where t.Customer_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select count(DISTINCT t.Transaction_ID) as transactions from t_transactions t, t_master_customerinfo c " +
            "where t.Customer_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select sum(t.Quantity) from t_transactions t, t_master_customerinfo c " +
            "where t.Customer_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    Integer amountGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);

    /* From history */
    @Query(value = "SELECT * FROM t_history_transactions WHERE Transaction_ID = ?1", nativeQuery = true)
    List<TTransactions> findByTransactionIdFromHistory(Long transactionId);

    @Query(value = "SELECT ht.* FROM t_history_transactions ht WHERE ht.Committed = ?1 AND ht.Transaction_Time BETWEEN ?2 AND ?3 ", nativeQuery = true)
    List<TTransactions> findByCommittedAndTransactionTimeBetweenFromHistory(byte committed, Date startDate, Date endDate);

    @Query(value = "SELECT * FROM t_history_transactions WHERE Batch_Sequence_ID = ?1 and Committed = ?2 ", nativeQuery = true)
    List<TTransactions> findByBatchFromHistoryAndCommitted(Integer batchId, byte committed);

    @Query(value = "select round(sum(t.Unit_Purchase_Price), 2) from t_history_transactions t where t.Customer_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcCustomerPriceBetweenDatesFromHistory(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select t.* from t_history_transactions t where t.Customer_ID = ?1 and t.Committed = ?2 and t.Transaction_Time between ?3 and ?4 ", nativeQuery = true)
    List<TTransactions> findByCustomerAndCommittedAndTransactionTimeBetweenFromHistory(Integer customerId, byte committed, Date startDate, Date endDate);

    @Query(value = "select t.* from t_history_transactions t where t.Product_ID = ?1 and t.Committed = ?2 and t.Transaction_Time between ?3 and ?4 ", nativeQuery = true)
    List<TTransactions> findByProductIdAndCommittedAndTransactionTimeBetweenFromHistory(Integer productId, byte committed, Date startDate, Date endDate);

    /* From history 2010-05-31 - 2013-01-01 */
    @Query(value = "SELECT ht.* FROM t_history_transactions_2010_05_31__2013_01_01 ht WHERE ht.Committed = ?1 AND ht.Transaction_Time BETWEEN ?2 AND ?3 ", nativeQuery = true)
    List<TTransactions> findByCommittedAndTransactionTimeBetweenFromHistory2010(byte committed, Date startDate, Date endDate);

    @Query(value = "select t.* from t_history_transactions_2010_05_31__2013_01_01 t where t.Product_ID = ?1 and t.Committed = ?2 and t.Transaction_Time between ?3 and ?4 ", nativeQuery = true)
    List<TTransactions> findByProductIdAndCommittedAndTransactionTimeBetweenFromHistory2010(Integer productId, byte committed, Date startDate, Date endDate);

    @Query(value = "SELECT * FROM t_history_transactions_2010_05_31__2013_01_01 WHERE Batch_Sequence_ID = ?1 and Committed = ?2 ", nativeQuery = true)
    List<TTransactions> findByBatchFromHistoryAndCommitted2010(Integer batchId, byte committed);

    @Query(value = "select sum(total.sales) from (" +
            "   select sum(t.quantity) as sales " +
            "   from t_transactions t " +
            "       where t.Batch_Sequence_ID in (?1) and t.Committed = 1 and t.Transaction_Time between ?2 and ?3 " +
            "union all " +
            "   select sum(ht.quantity) as sales " +
            "   from t_history_transactions ht " +
            "       where ht.Batch_Sequence_ID in (?1) and ht.Committed = 1 and ht.Transaction_Time between ?2 and ?3 " +
            ") as total ",
            nativeQuery = true)
    Integer calcSumOfBatchSales(List<Integer> batchIds, Date startDate, Date endDate);

    @Query(value = "select batchId, sum(total.sales) as sales, sum(total.transactions) as transactions from ( " +
            "               select t.Batch_Sequence_ID as batchId, sum(t.quantity) as sales, count(t.TRANSACTION_ID) as transactions " +
            "               from t_transactions t " +
            "                   where t.Batch_Sequence_ID in (?1) and t.Committed = 1 group by t.Batch_Sequence_ID " +
            "            union all " +
            "               select ht.Batch_Sequence_ID as batchId, sum(ht.quantity) as sales, count(ht.TRANSACTION_ID) as transactions " +
            "               from t_history_transactions ht " +
            "                   where ht.Batch_Sequence_ID in (?1) and ht.Committed = 1 group by ht.Batch_Sequence_ID " +
            "            union all " +
            "               select ht2.Batch_Sequence_ID as batchId, sum(ht2.quantity) as sales, count(ht2.TRANSACTION_ID) as transactions " +
            "               from t_history_transactions_2010_05_31__2013_01_01 ht2 " +
            "                   where ht2.Batch_Sequence_ID in (?1) and ht2.Committed = 1 group by ht2.Batch_Sequence_ID " +
            ") as total group by batchId", nativeQuery = true)
    List<Object[]> getSummaryBatchsSalesAndTransactions(List<Integer> batchIds);
}
