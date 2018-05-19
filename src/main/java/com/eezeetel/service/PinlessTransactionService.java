package com.eezeetel.service;

import com.eezeetel.entity.PinlessTransaction;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public interface PinlessTransactionService {

    List<PinlessTransaction> findByUserAndTransactionTimeBetween(User user, Date from, Date to);
    List<PinlessTransaction> findByCustomerAndTransactionTime(TMasterCustomerinfo customer, Date from, Date to);
    List<PinlessTransaction> findByGroupAndDate(Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);
    Map<String, Double> getMonthTransactions(LocalDate month, String login);
}
