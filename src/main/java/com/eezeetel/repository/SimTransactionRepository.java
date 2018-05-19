package com.eezeetel.repository;

import com.eezeetel.entity.TSimTransactions;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Created by Denis Dulyak on 12.05.2016.
 */
public interface SimTransactionRepository extends JpaRepository<TSimTransactions, Integer> {

    List<TSimTransactions> findByTransactionId(Long transactionId);
}
