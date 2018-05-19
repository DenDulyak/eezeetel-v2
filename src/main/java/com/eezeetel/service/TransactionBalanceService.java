package com.eezeetel.service;

import com.eezeetel.entity.TTransactionBalance;
import org.springframework.stereotype.Service;

@Service
public interface TransactionBalanceService {

    TTransactionBalance save(TTransactionBalance transactionBalance);
    TTransactionBalance findOne(Long transactionId);
    TTransactionBalance findOneFromHistory(Long transactionId);
    TTransactionBalance create(Long transactionId, Float balanceBefore, Float balanceAfter);
}
