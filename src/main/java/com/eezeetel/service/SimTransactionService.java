package com.eezeetel.service;

import com.eezeetel.entity.TSimTransactions;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface SimTransactionService {

    List<TSimTransactions> findByTransactionId(Long transactionId);
}
