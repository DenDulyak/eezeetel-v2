package com.eezeetel.repository;

import com.eezeetel.entity.TRevokedTransactions;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;

@Repository
public interface RevokedTransactionRepository extends JpaRepository<TRevokedTransactions, Integer> {

    Page<TRevokedTransactions> findByRevokedDateBetween(Date from, Date to, Pageable pageable);

    Page<TRevokedTransactions> findByRevokedDateBetweenAndSoldAgainStatus(Date from, Date to, byte soldAgainStatus, Pageable pageable);
}
