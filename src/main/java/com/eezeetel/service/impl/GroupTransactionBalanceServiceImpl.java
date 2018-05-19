package com.eezeetel.service.impl;

import com.eezeetel.entity.GroupTransactionBalance;
import com.eezeetel.repository.GroupTransactionBalanceRepository;
import com.eezeetel.service.GroupTransactionBalanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 15.09.2016.
 */
@Service
public class GroupTransactionBalanceServiceImpl implements GroupTransactionBalanceService {

    @Autowired
    private GroupTransactionBalanceRepository repository;

    @Override
    public GroupTransactionBalance save(GroupTransactionBalance balance) {
        return repository.save(balance);
    }

    @Override
    public GroupTransactionBalance create(Long transactionId, BigDecimal balanceBefore, BigDecimal balanceAfter) {
        GroupTransactionBalance groupTransactionBalance = new GroupTransactionBalance();
        groupTransactionBalance.setTransactionId(transactionId);
        groupTransactionBalance.setBalanceBefore(balanceBefore);
        groupTransactionBalance.setBalanceAfter(balanceAfter);
        return save(groupTransactionBalance);
    }
}
