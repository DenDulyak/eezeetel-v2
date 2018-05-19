package com.eezeetel.service.impl;

import com.eezeetel.entity.TTransactionBalance;
import com.eezeetel.repository.TransactionBalanceRepository;
import com.eezeetel.service.TransactionBalanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Denis Dulyak on 17.02.2016.
 */
@Service
public class TransactionBalanceServiceImpl implements TransactionBalanceService {

    @Autowired
    private TransactionBalanceRepository repository;

    @Override
    public TTransactionBalance save(TTransactionBalance transactionBalance) {
        return repository.save(transactionBalance);
    }

    @Override
    public TTransactionBalance findOne(Long transactionId) {
        return repository.findOne(transactionId);
    }

    @Override
    public TTransactionBalance findOneFromHistory(Long transactionId) {
        return repository.findOneFromHistory(transactionId);
    }

    @Override
    public TTransactionBalance create(Long transactionId, Float balanceBefore, Float balanceAfter) {
        TTransactionBalance transactionBalance = new TTransactionBalance();
        transactionBalance.setTransactionId(transactionId);
        transactionBalance.setBalanceBeforeTransaction(balanceBefore);
        transactionBalance.setBalanceAfterTransaction(balanceAfter);
        return save(transactionBalance);
    }
}
