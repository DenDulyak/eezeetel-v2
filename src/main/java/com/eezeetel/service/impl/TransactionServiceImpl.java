package com.eezeetel.service.impl;

import com.eezeetel.bean.customer.Transaction;
import com.eezeetel.bean.report.TransactionReportBean;
import com.eezeetel.entity.*;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.repository.TransactionRepository;
import com.eezeetel.service.BatchService;
import com.eezeetel.service.CardService;
import com.eezeetel.service.TransactionBalanceService;
import com.eezeetel.service.TransactionService;
import com.eezeetel.util.DateUtil;
import com.eezeetel.util.HibernateUtil;
import org.apache.commons.lang.math.NumberUtils;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.hibernate.type.LongType;
import org.hibernate.type.StringType;
import org.hibernate.type.TimestampType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 07.10.2015.
 */
@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionRepository repository;

    @Autowired
    private TransactionBalanceService transactionBalanceService;

    @Autowired
    private BatchService batchService;

    @Autowired
    private CardService cardService;

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public List<TTransactions> findByTransactionIdAndCommitted(Long transactionId, byte committed) {
        return repository.findByTransactionIdAndCommitted(transactionId, committed);
    }

    @Override
    public List<TTransactions> findByCommitted(byte committed) {
        return repository.findByCommitted(committed);
    }

    @Override
    public List<TTransactions> findByTransactionId(Long transactionId) {
        return repository.findByTransactionId(transactionId);
    }

    @Override
    public List<TTransactions> findByTransactionIdFromHistory(Long transactionId) {
        return repository.findByTransactionIdFromHistory(transactionId);
    }

    @Override
    public List<TTransactions> findByGroupAndDateAndUser(User user, TransactionStatus status, TMasterCustomerGroups group, Date startDate, Date endDate) {
        return null;
    }

    @Override
    public List<TTransactions> findByGroupAndDateFromHistoryAndUser(User user, TransactionStatus status, Integer groupId, Date startDate, Date endDate) {
        return null;
    }

    @Override
    public BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate) {
        BigDecimal price = repository.calcCustomerPriceBetweenDates(customerId, startDate, endDate);
        price = price == null ? new BigDecimal("0") : price;
        if (DateUtil.toLocalDate(startDate).isBefore(LocalDate.now().minusDays(7))) {
            BigDecimal priceFromHistory = repository.calcCustomerPriceBetweenDatesFromHistory(customerId, startDate, endDate);
            priceFromHistory = priceFromHistory == null ? new BigDecimal("0") : priceFromHistory;
            price = price.add(priceFromHistory);
        }
        return price;
    }

    @Override
    public Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate) {
        return repository.countCustomerTransactionsBetweenDates(customerId, startDate, endDate);
    }

    @Override
    public Integer amountCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate) {
        Integer quantity = repository.amountCustomerTransactionsBetweenDates(customerId, startDate, endDate);
        return quantity == null ? 0 : quantity;
    }

    @Override
    public BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate) {
        BigDecimal price = repository.calcGroupPriceBetweenDates(groupId, startDate, endDate);
        return price == null ? new BigDecimal("0") : price;
    }

    @Override
    public Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate) {
        return repository.countGroupTransactionsBetweenDates(groupId, startDate, endDate);
    }

    @Override
    public Integer amountGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate) {
        Integer quantity = repository.amountGroupTransactionsBetweenDates(groupId, startDate, endDate);
        return quantity == null ? 0 : quantity;
    }

    @Override
    public Long getNextTransactionId() {
        return repository.getNextTransactionId();
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public TTransactions save(TTransactions transaction) {
        return repository.save(transaction);
    }

    @Override
    public List<TTransactions> findByUserAndStatus(User user, TransactionStatus status) {
        return repository.findByUserAndCommitted(user, (byte) status.ordinal());
    }

    @Override
    public List<TTransactions> findByGroupAndDate(TransactionStatus status, TMasterCustomerGroups group, Date startDate, Date endDate) {
        if (group == null || group.getId() == 0) {
            return repository.findByCommittedAndTransactionTimeBetween((byte) status.ordinal(), startDate, endDate);
        }

        return repository.findByCustomerGroupAndCommittedAndTransactionTimeBetween(group, (byte) status.ordinal(), startDate, endDate);
    }

    @Override
    public List<TTransactions> findByGroupAndDateFromHistory(TransactionStatus status, Integer groupId, Date startDate, Date endDate) {
        List<TTransactions> transactions;

        if (LocalDate.of(2013, 1, 1).isAfter(endDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate())) {
            transactions = repository.findByCommittedAndTransactionTimeBetweenFromHistory2010((byte) status.ordinal(), startDate, endDate);
        } else {
            transactions = repository.findByCommittedAndTransactionTimeBetweenFromHistory((byte) status.ordinal(), startDate, endDate);
        }

        if (groupId != null && groupId > 0) {
            transactions.removeIf(t -> !t.getCustomer().getGroup().getId().equals(groupId));
        }

        transactions.forEach(t -> t.setTransactionBalance(transactionBalanceService.findOneFromHistory(t.getTransactionId())));
        return transactions;
    }

    @Override
    public List<TTransactions> findByBatch(Integer batchId, boolean withBalance) {
        List<TTransactions> transactions = repository.findByBatchAndCommitted(new TBatchInformation(batchId), (byte) TransactionStatus.COMMITTED.ordinal());
        transactions.addAll(repository.findByBatchFromHistoryAndCommitted(batchId, (byte) TransactionStatus.COMMITTED.ordinal()));
        transactions.addAll(repository.findByBatchFromHistoryAndCommitted2010(batchId, (byte) TransactionStatus.COMMITTED.ordinal()));

        transactions.sort((t1, t2) -> t1.getTransactionTime().compareTo(t2.getTransactionTime()));
        if (!withBalance) {
            return transactions;
        }

        transactions.forEach(t -> {
            TTransactionBalance balance = transactionBalanceService.findOne(t.getTransactionId());
            if (balance == null) {
                balance = transactionBalanceService.findOneFromHistory(t.getTransactionId());
            }
            t.setTransactionBalance(balance);
        });

        return transactions;
    }

    @Override
    public List<TTransactions> findByCard(TCardInfo card) {
        List<TTransactions> transactions = Collections.emptyList();

        if (card != null && card.getIsSold()) {
            transactions = findByTransactionId(card.getTransactionId());
            if (transactions.isEmpty()) {
                transactions = findByTransactionIdFromHistory(card.getTransactionId());
            }
        }

        return transactions;
    }

    @Override
    public List<Transaction> getTransactionsByCustomerAndDate(Integer customerId, Date from, Date to) {
        List<TTransactions> transactions = repository.findByCustomerAndCommittedAndTransactionTimeBetween(new TMasterCustomerinfo(customerId), (byte) TransactionStatus.COMMITTED.ordinal(), from, to);
        if (transactions.isEmpty()) {
            transactions = repository.findByCustomerAndCommittedAndTransactionTimeBetweenFromHistory(customerId, (byte) TransactionStatus.COMMITTED.ordinal(), from, to);
        }
        return transactions.stream().map(Transaction::new).collect(Collectors.toList());
    }

    @Override
    public List<Transaction> getTransfertoTransactionsByCustomerAndDate(Integer customerId, Date from, Date to) {
        List<Transaction> beans = new ArrayList<>();
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT ttt.Transaction_ID AS transactionId, ttt.Transaction_Time AS transactionTime, " +
                    "tmu.User_First_Name AS userFirstName, tmu.User_Last_Name AS userLastName " +
                    "FROM t_transferto_transactions ttt " +
                    "INNER JOIN t_master_users tmu ON tmu.User_Login_ID = ttt.User_ID " +
                    "WHERE ttt.Customer_ID = :customerId " +
                    "AND ttt.Transaction_Time BETWEEN :dateFrom AND :dateTo " +
                    "AND ttt.User_ID = tmu.User_Login_ID " +
                    "AND ttt.Transaction_Status = 1 " +
                    "ORDER BY ttt.Transaction_Time DESC ";
            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.addScalar("transactionId", new LongType());
            sqlQuery.addScalar("transactionTime", new TimestampType());
            sqlQuery.addScalar("userFirstName", new StringType());
            sqlQuery.addScalar("userLastName", new StringType());
            sqlQuery.setParameter("customerId", customerId);
            sqlQuery.setParameter("dateFrom", from);
            sqlQuery.setParameter("dateTo", to);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(Transaction.class));
            beans = sqlQuery.list();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return beans;
    }

    @Override
    public List<Transaction> getSimTransactionsByCustomerAndDate(Integer customerId, Date from, Date to) {
        List<Transaction> beans = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT DISTINCT(tst.Transaction_ID) AS transactionId, tst.Transaction_Time AS transactionTime, " +
                    "tmu.User_First_Name AS userFirstName, tmu.User_Last_Name AS userLastName " +
                    "FROM t_sim_transactions tst " +
                    "INNER JOIN t_master_users tmu ON tmu.User_Login_ID = tst.User_ID " +
                    "WHERE tst.Customer_ID = :customerId " +
                    "AND tst.Transaction_Time BETWEEN :dateFrom AND :dateTo " +
                    "AND tst.Committed = 1 " +
                    "ORDER BY tst.Transaction_Time DESC ";
            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.addScalar("transactionId", new LongType());
            sqlQuery.addScalar("transactionTime", new TimestampType());
            sqlQuery.addScalar("userFirstName", new StringType());
            sqlQuery.addScalar("userLastName", new StringType());
            sqlQuery.setParameter("customerId", customerId);
            sqlQuery.setParameter("dateFrom", from);
            sqlQuery.setParameter("dateTo", to);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(Transaction.class));
            beans = sqlQuery.list();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return beans;
    }

    @Override
    public List<TTransactions> getSalesRetune(LocalDate start, LocalDate end) {
        List<TBatchInformation> batchs = batchService.findByArrivalDateBetweenAndQuantityGreaterThanAvailableQuantity(start, end);

        List<TTransactions> result = new ArrayList<>();
        for (TBatchInformation batch : batchs) {
            List<TTransactions> transactions = repository.findByBatchAndCommitted(batch, (byte) TransactionStatus.COMMITTED.ordinal());

            if (transactions.isEmpty()) {
                transactions = repository.findByBatchFromHistoryAndCommitted(batch.getSequenceId(), (byte) TransactionStatus.COMMITTED.ordinal());
            }

            result.addAll(transactions);
        }

        return result;
    }

    @Override
    public List<TransactionReportBean> findByProductIdAndDates(Integer productId, LocalDate start, LocalDate end) {
        Date startDate = DateUtil.getStartOfDay(start);
        Date endDate = DateUtil.getEndOfDay(end);

        List<TTransactions> transactions = repository.findByProductIdAndCommittedAndTransactionTimeBetween(productId, (byte) TransactionStatus.COMMITTED.ordinal(), startDate, endDate);
        transactions.addAll(repository.findByProductIdAndCommittedAndTransactionTimeBetweenFromHistory(productId, (byte) TransactionStatus.COMMITTED.ordinal(), startDate, endDate));
        if(start.isBefore(LocalDate.of(2013, 5, 31))) {
            transactions.addAll(repository.findByProductIdAndCommittedAndTransactionTimeBetweenFromHistory2010(productId, (byte) TransactionStatus.COMMITTED.ordinal(), startDate, endDate));
        }

        for (TTransactions t : transactions) {
            if (t.getTransactionBalance() != null) {
                t.getTransactionBalance().getBalanceAfterTransaction();
                continue;
            }
            TTransactionBalance balance = transactionBalanceService.findOne(t.getTransactionId());
            if (balance == null) {
                balance = transactionBalanceService.findOneFromHistory(t.getTransactionId());
            }
            t.setTransactionBalance(balance);
        }

        List<TransactionReportBean> beans = transactions.stream().map(TransactionReportBean::new).collect(Collectors.toList());
        for (TransactionReportBean bean : beans) {
            bean.setCardIds(cardService.findByProductIdAndTransactionIdAndSold(productId, bean.getTransactionId())
                    .stream().map(TCardInfo::getCardId).collect(Collectors.toList()));
        }

        return beans;
    }

    public Map<Integer, Map<String, Map.Entry<Integer, Integer>>> getSummaryReportByBatch(Integer batchId) {
        List<TTransactions> transactions = repository.findByBatchAndCommitted(new TBatchInformation(batchId), (byte) TransactionStatus.COMMITTED.ordinal());
        transactions.addAll(repository.findByBatchFromHistoryAndCommitted(batchId, (byte) TransactionStatus.COMMITTED.ordinal()));
        transactions.addAll(repository.findByBatchFromHistoryAndCommitted2010(batchId, (byte) TransactionStatus.COMMITTED.ordinal()));

        Map<Integer, Map<String, Map.Entry<Integer, Integer>>> result = new HashMap<>();
        Map<Integer, List<TTransactions>> yearTransactions = transactions.stream()
                .collect(Collectors.groupingBy(t -> DateUtil.toLocalDate(t.getTransactionTime()).getYear()));

        for (Map.Entry<Integer, List<TTransactions>> entry : yearTransactions.entrySet()) {
            Map<String, Map.Entry<Integer, Integer>> yearSummary = new HashMap<>();
            Map<String, List<TTransactions>> monthTransactions = entry.getValue().stream()
                    .collect(Collectors.groupingBy(t -> DateUtil.toLocalDate(t.getTransactionTime()).getMonth().name()));

            for (Map.Entry<String, List<TTransactions>> monthEntry : monthTransactions.entrySet()) {
                Integer totalTransactions = monthEntry.getValue().size();
                Integer totalQuantity = monthEntry.getValue().stream().mapToInt(TTransactions::getQuantity).sum();

                yearSummary.put(monthEntry.getKey(), new AbstractMap.SimpleEntry<>(totalTransactions, totalQuantity));
            }

            result.put(entry.getKey(), yearSummary);
        }

        return result;
    }

    @Override
    public Map<Integer, Map.Entry<Integer, Integer>> getSummarySalesAndTransactionsByBatchIds(List<Integer> batchIds) {
        Map<Integer, Map.Entry<Integer, Integer>> result = new HashMap<>();
        batchIds.forEach(id -> result.put(id, null));
        List<Object[]> rows = repository.getSummaryBatchsSalesAndTransactions(batchIds);
        for (Object[] row : rows) {
            Integer batchId = (Integer) row[0];
            Integer sales = NumberUtils.toInt(row[1] + "");
            Integer transactions = NumberUtils.toInt(row[2] + "");
            if (batchId != null) {
                result.put(batchId, new AbstractMap.SimpleEntry<>(sales, transactions));
            }
        }
        return result;
    }
}
