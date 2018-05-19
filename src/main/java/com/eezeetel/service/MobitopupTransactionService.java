package com.eezeetel.service;

import com.eezeetel.bean.report.WorldMobileTopupSummary;
import com.eezeetel.entity.*;
import com.eezeetel.mobitopup.response.CheckNumber;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Service
public interface MobitopupTransactionService {

    MobitopupTransaction findByTransactionId(Long transactionId);
    MobitopupTransaction findOne(Integer id);
    List<MobitopupTransaction> findAll();
    Page<MobitopupTransaction> findAll(Pageable pageable);
    List<MobitopupTransaction> findByCustomerAndTransactionTime(TMasterCustomerinfo customer, Date from, Date to);
    List<MobitopupTransaction> findByUserAndTransactionTimeBetween(User user, Date from, Date to);
    List<MobitopupTransaction> findByErrorCodeAndCustomerAndTransactionTimeBetween(Integer errorCode, TMasterCustomerinfo customer, Date startDate, Date endDate);
    List<MobitopupTransaction> findByRequesterPhone(String login, Integer errorCode, String requesterPhone);
    MobitopupTransaction save(MobitopupTransaction transaction);
    List<MobitopupTransaction> findByGroupAndDate(Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);

    List<MobitopupTransaction> findByGroupAndDateAndUser(User user, Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);

    List<WorldMobileTopupSummary> getSummaryTransactions(LocalDate startDay, LocalDate endDay);
    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
    MobitopupTransaction topup(String destnumber, String srcnumber, String product, String message, String login);
    CheckNumber checkNumberV2(String login, String number);
    PinlessTransaction topupV2(String destnumber, String srcnumber, String product, String message, String login);
}
