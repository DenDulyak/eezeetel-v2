package com.eezeetel.service;

import com.eezeetel.bean.customer.Transaction;
import com.eezeetel.bean.report.TransactionReportBean;
import com.eezeetel.entity.TCardInfo;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TTransactions;
import com.eezeetel.entity.User;
import com.eezeetel.enums.TransactionStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public interface TransactionService {

    List<TTransactions> findByTransactionIdAndCommitted(Long transactionId, byte committed);
    List<TTransactions> findByCommitted(byte committed);
    List<TTransactions> findByTransactionId(Long transactionId);
    List<TTransactions> findByTransactionIdFromHistory(Long transactionId);

    List<TTransactions> findByGroupAndDateAndUser(User user, TransactionStatus status, TMasterCustomerGroups group, Date startDate, Date endDate);
    List<TTransactions> findByGroupAndDateFromHistoryAndUser(User user, TransactionStatus status, Integer groupId, Date startDate, Date endDate);

    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);
    Integer amountCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer amountGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
    Long getNextTransactionId();
    TTransactions save(TTransactions transaction);
    List<TTransactions> findByUserAndStatus(User user, TransactionStatus status);
    List<TTransactions> findByGroupAndDate(TransactionStatus status, TMasterCustomerGroups group, Date startDate, Date endDate);
    List<TTransactions> findByGroupAndDateFromHistory(TransactionStatus status, Integer groupId, Date startDate, Date endDate);
    List<TTransactions> findByBatch(Integer batchId, boolean withBalance);
    List<TTransactions> findByCard(TCardInfo card);
    List<Transaction> getTransactionsByCustomerAndDate(Integer customerId, Date from, Date to);
    List<Transaction> getTransfertoTransactionsByCustomerAndDate(Integer customerId, Date from, Date to);
    List<Transaction> getSimTransactionsByCustomerAndDate(Integer customerId, Date from, Date to);
    List<TTransactions> getSalesRetune(LocalDate start, LocalDate end);
    List<TransactionReportBean> findByProductIdAndDates(Integer productId, LocalDate start, LocalDate end);
    Map<Integer, Map<String, Map.Entry<Integer, Integer>>> getSummaryReportByBatch(Integer batchId);
    Map<Integer, Map.Entry<Integer, Integer>> getSummarySalesAndTransactionsByBatchIds(List<Integer> batchIds);
}
