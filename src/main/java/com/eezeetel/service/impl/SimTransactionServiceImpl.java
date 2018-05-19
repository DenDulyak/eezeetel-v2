package com.eezeetel.service.impl;

import com.eezeetel.entity.TSimTransactions;
import com.eezeetel.repository.SimTransactionRepository;
import com.eezeetel.service.SimTransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

/**
 * Created by Denis Dulyak on 12.05.2016.
 */
@Service
public class SimTransactionServiceImpl implements SimTransactionService {

    @Autowired
    private SimTransactionRepository repository;

    @Override
    @Transactional
    public List<TSimTransactions> findByTransactionId(Long transactionId) {
        List<TSimTransactions> transactions = repository.findByTransactionId(transactionId);
        transactions.forEach(t -> t.getSimCard().getProduct().getId());
        return transactions;
    }
}
