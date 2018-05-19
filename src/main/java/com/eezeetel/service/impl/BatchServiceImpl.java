package com.eezeetel.service.impl;

import com.eezeetel.bean.masteradmin.BatchInfoBean;
import com.eezeetel.entity.TBatchInformation;
import com.eezeetel.enums.BatchUploadStatus;
import com.eezeetel.repository.BatchRepository;
import com.eezeetel.service.BatchService;
import com.eezeetel.service.CardService;
import com.eezeetel.service.TransactionService;
import com.eezeetel.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class BatchServiceImpl implements BatchService {

    @Autowired
    private BatchRepository repository;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private CardService cardService;

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public TBatchInformation save(TBatchInformation batch) {
        return repository.save(batch);
    }

    @Override
    public Integer getProductAvailableQuantity(Integer productId) {
        Integer availableQuantity = repository.getProductAvailableQuantity(productId);
        return availableQuantity == null ? 0 : availableQuantity;
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public List<TBatchInformation> findByProductAndReadyToSell(Integer productId) {
        return repository.findByProductAndReadyToSell(productId);
    }

    @Override
    public List<TBatchInformation> findByArrivalDateBetweenAndQuantityGreaterThanAvailableQuantity(LocalDate start, LocalDate end) {
        return repository.findByArrivalDateBetweenAndQuantityGreaterThanAvailableQuantity(DateUtil.getStartOfDay(start), DateUtil.getEndOfDay(end));
    }

    @Override
    public List<TBatchInformation> getBatchForRetuneCardsStock(LocalDate start, LocalDate end) {
        List<TBatchInformation> batchs = findByArrivalDateBetweenAndQuantityGreaterThanAvailableQuantity(start, end);
        batchs.forEach(b -> {
            b.getSupplier().getId();
            b.getProduct().getId();
            if (!b.getCards().isEmpty()) {
                Collections.sort(b.getCards(), (c1, c2) -> c1.getCardId().compareTo(c2.getCardId()));
                b.setStartBatchNumber(b.getCards().get(0).getCardId());
                b.setEndBatchNumber(b.getCards().get(b.getCards().size() - 1).getCardId());
            }
            if (!b.getSimCards().isEmpty()) {
                Collections.sort(b.getSimCards(), (c1, c2) -> c1.getSimCardId().compareTo(c2.getSimCardId()));
                b.setStartBatchNumber(b.getSimCards().get(0).getSimCardId());
                b.setEndBatchNumber(b.getSimCards().get(b.getCards().size() - 1).getSimCardId());
            }
        });
        return batchs;
    }

    @Override
    @Transactional
    public Page<TBatchInformation> findByAvailableQuantityGreaterThanOrderByEntryTimeDesc(Integer availableQuantity, Pageable pageable) {
        Page<TBatchInformation> batchInformations = repository.findByAvailableQuantityGreaterThanOrderByEntryTimeDesc(availableQuantity, pageable);
        batchInformations.getContent().forEach(b -> {
            if (!b.getCards().isEmpty()) {
                Collections.sort(b.getCards(), (c1, c2) -> c1.getCardId().compareTo(c2.getCardId()));
            }
            if (!b.getSimCards().isEmpty()) {
                Collections.sort(b.getSimCards(), (c1, c2) -> c1.getSimCardId().compareTo(c2.getSimCardId()));
            }
            b.getUser().getLogin();
            b.getSupplier().getId();
            b.getProduct().getId();
            b.getProductsaleinfo().getId();
        });
        return batchInformations;
    }

    @Override
    public List<BatchInfoBean> findByProductBetweenDates(Integer productId, LocalDate startDate, LocalDate endDate) {
        List<BatchInfoBean> beans = new ArrayList<>();
        Date from = DateUtil.getStartOfDay(startDate);
        Date to = DateUtil.getStartOfDay(endDate);

        List<TBatchInformation> batches = repository.findByProductIdAndBatchUploadStatusAndArrivalDateBetween(productId, BatchUploadStatus.SUCCESS_BATCH_UPDATE_IN_DB.getDescription(), from, to);
        List<TBatchInformation> historyBatches = repository.findByProductAndBatchUploadStatusAndArrivalDateBetweenFromHistory(productId, BatchUploadStatus.SUCCESS_BATCH_UPDATE_IN_DB.getDescription(), from, to);
        batches.addAll(historyBatches);

        for (TBatchInformation batch : batches) {
            BatchInfoBean bean = new BatchInfoBean();
            bean.setId(batch.getSequenceId());
            bean.setProductName(batch.getProduct().getProductName());
            bean.setFaceValue(batch.getProduct().getProductFaceValue());
            bean.setBeginningQuantity(batch.getQuantity());
            bean.setAvailableQuantity(batch.getAvailableQuantity());
            bean.setArrivalDate(batch.getArrivalDate());
            bean.setExpiryDate(batch.getExpiryDate());
            bean.setFirstCardId(cardService.findFirstCardIdByBatch(batch.getSequenceId()));
            bean.setLastCardId(cardService.findLastCardIdByBatch(batch.getSequenceId()));
            beans.add(bean);
        }

        Map<Integer, Map.Entry<Integer, Integer>> sales = transactionService.getSummarySalesAndTransactionsByBatchIds(batches.stream().map(TBatchInformation::getSequenceId).collect(Collectors.toList()));
        for (BatchInfoBean bean : beans) {
            Map.Entry<Integer, Integer> summary = sales.get(bean.getId());
            if (summary != null) {
                bean.setSales(summary.getKey());
                bean.setTransactions(summary.getValue());
            }
        }

        Collections.sort(beans, (a, b) -> b.getId().compareTo(a.getId()));
        return beans;
    }
}
