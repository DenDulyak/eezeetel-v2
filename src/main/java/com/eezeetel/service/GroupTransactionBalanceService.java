package com.eezeetel.service;

import com.eezeetel.entity.GroupTransactionBalance;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public interface GroupTransactionBalanceService {

    GroupTransactionBalance save(GroupTransactionBalance balance);
    GroupTransactionBalance create(Long transactionId, BigDecimal balanceBefore, BigDecimal balanceAfter);
}
