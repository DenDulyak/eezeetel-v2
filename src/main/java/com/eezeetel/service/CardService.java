package com.eezeetel.service;

import com.eezeetel.entity.TBatchInformation;
import com.eezeetel.entity.TCardInfo;
import com.eezeetel.entity.TMasterProductinfo;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface CardService {

    TCardInfo findOne(Long id);
    TCardInfo save(TCardInfo cardInfo);
    List<TCardInfo> save(List<TCardInfo> cards);
    List<TCardInfo> findByTransactionIdAndSold(Long transactionId);
    List<TCardInfo> findByProductIdAndTransactionIdAndSold(Integer productId, Long transactionId);
    List<TCardInfo> findByBatchAndIsSoldOrderByIdAsc(TBatchInformation batch, Boolean isSold, Pageable pageable);
    TCardInfo findByCardPin(String pin);
    String findFirstCardIdByBatch(Integer batchId);
    String findLastCardIdByBatch(Integer batchId);
    TCardInfo findByIdFromHistory(Long sequenceId);
    List<TCardInfo> findByProductAndBatchAndtransactionIdAndIsSoldTrue(TMasterProductinfo product, TBatchInformation batch, Long transactionId);
    List<TCardInfo> findByProductAndBatchAndtransactionIdAndIsSoldTrueFromHistory(TMasterProductinfo product, TBatchInformation batch, Long transactionId);
}
