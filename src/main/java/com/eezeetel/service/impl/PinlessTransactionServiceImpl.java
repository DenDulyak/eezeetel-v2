package com.eezeetel.service.impl;

import com.eezeetel.entity.*;
import com.eezeetel.repository.PinlessTransactionRepository;
import com.eezeetel.service.CustomerUserService;
import com.eezeetel.service.PinlessTransactionService;
import com.eezeetel.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PinlessTransactionServiceImpl implements PinlessTransactionService {

    @Autowired
    private PinlessTransactionRepository repository;

    @Autowired
    private CustomerUserService customerUserService;

    @Override
    @Transactional
    public List<PinlessTransaction> findByUserAndTransactionTimeBetween(User user, Date from, Date to) {
        List<PinlessTransaction> transactions = repository.findByUserAndTransactionTimeBetweenAndErrorCode(user, from, to, 0);

        transactions.forEach(t -> {
            if (t.getTransactionBalance() != null) {
                t.getTransactionBalance().getBalanceAfterTransaction();
            }
        });

        return transactions;
    }

    @Override
    @Transactional
    public List<PinlessTransaction> findByCustomerAndTransactionTime(TMasterCustomerinfo customer, Date from, Date to) {
        List<PinlessTransaction> transactions = repository.findByCustomerAndTransactionTimeBetweenAndErrorCode(customer, from, to, 0);

        transactions.forEach(t -> {
            if (t.getTransactionBalance() != null) {
                t.getTransactionBalance().getBalanceAfterTransaction();
            }
        });

        return transactions;
    }

    public List<PinlessTransaction> findByGroupAndDate(Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate) {
        if (group == null || group.getId() == 0) {
            return repository.findByErrorCodeAndTransactionTimeBetween(errorCode, startDate, endDate);
        }

        return repository.findByErrorCodeAndCustomerGroupAndTransactionTimeBetween(errorCode, group, startDate, endDate);
    }

    @Override
    public Map<String, Double> getMonthTransactions(LocalDate month, String login) {
        TCustomerUsers customerUser = customerUserService.findByLogin(login);
        Assert.notNull(customerUser);

        LocalDate startDayOfMonth = DateUtil.getStartOfMonth(month);
        LocalDate endDayOfMonth = DateUtil.getEndOfMonth(month);

        List<Object[]> data = repository.getCustomerSummaryTransactionsBetweenDates(0, customerUser.getCustomer().getId(),
                DateUtil.getStartOfDay(startDayOfMonth), DateUtil.getEndOfDay(endDayOfMonth));

        return this.convertSummaryTransactionsData(data);
    }

    private Map<String, Double> convertSummaryTransactionsData(List<Object[]> data) {
        Map<String, Double> result = new HashMap<>();

        for (Object[] o : data) {

            result.put((String) o[0], (Double) o[1]);
        }

        return result;
    }
}
