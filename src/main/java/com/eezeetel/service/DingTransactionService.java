package com.eezeetel.service;

import com.ding.DingMain;
import com.eezeetel.bean.report.WorldMobileTopupSummary;
import com.eezeetel.entity.TDingTransactions;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Service
public interface DingTransactionService {

    TDingTransactions findOne(Long id);
    List<TDingTransactions> findAll();
    TDingTransactions save(TDingTransactions transaction);
    TDingTransactions findByTransactionId(Long transactionId);
    List<TDingTransactions> findByRequesterPhone(String login, Integer errorCode, String requesterPhone);
    TDingTransactions findLastSuccessfulTransactionByDestinationPhone(TMasterCustomerinfo customer, String destinationPhone);
    Long checkTimeLimitForTransaction(TMasterCustomerinfo customer, String destinationPhone);
    List<TDingTransactions> findByGroupAndDate(int errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);

    List<TDingTransactions> findByGroupAndDateUser(User user, int errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);

    List<TDingTransactions> findByErrorCodeAndCustomerAndTransactionTimeBetween(int errorCode, TMasterCustomerinfo customer, Date startDate, Date endDate);
    List<TDingTransactions> findTransactionsBetweenDays(LocalDate startDay, LocalDate endDay, Integer groupId, Integer type);
    List<WorldMobileTopupSummary> getSummaryTransactions(LocalDate startDay, LocalDate endDay);
    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
    TDingTransactions create(DingMain.TopupResponse topuRes, Integer customerId, String user);
}
