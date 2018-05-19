package com.eezeetel.service;

import com.eezeetel.bean.ResponseContainer;
import com.eezeetel.bean.report.RevokedTransaction;
import com.eezeetel.entity.TRevokedTransactions;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public interface RevokedTransactionsService {

    List<TRevokedTransactions> findAll();
    Page<TRevokedTransactions> findAll(Pageable pageable);
    TRevokedTransactions save(TRevokedTransactions revokedTransaction);
    ResponseContainer<List<RevokedTransaction>> getRevokedTransactions(Integer page, Date from, Date to, Integer status);
}
