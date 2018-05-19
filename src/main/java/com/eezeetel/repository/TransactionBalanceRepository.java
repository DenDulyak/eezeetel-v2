package com.eezeetel.repository;

import com.eezeetel.entity.TTransactionBalance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 17.02.2016.
 */
@Repository
public interface TransactionBalanceRepository extends JpaRepository<TTransactionBalance, Long> {

    /* From history */

    @Query(value = "SELECT * FROM t_history_transaction_balance where Transaction_ID = ?1 ", nativeQuery = true)
    TTransactionBalance findOneFromHistory(Long transactionId);
}
