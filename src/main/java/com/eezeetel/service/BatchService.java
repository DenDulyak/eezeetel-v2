package com.eezeetel.service;

import com.eezeetel.bean.masteradmin.BatchInfoBean;
import com.eezeetel.entity.TBatchInformation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public interface BatchService {

    TBatchInformation save(TBatchInformation batch);
    Integer getProductAvailableQuantity(Integer productId);
    List<TBatchInformation> findByProductAndReadyToSell(Integer productId);
    List<TBatchInformation> findByArrivalDateBetweenAndQuantityGreaterThanAvailableQuantity(LocalDate start, LocalDate end);
    List<TBatchInformation> getBatchForRetuneCardsStock(LocalDate start, LocalDate end);
    Page<TBatchInformation> findByAvailableQuantityGreaterThanOrderByEntryTimeDesc(Integer availableQuantity, Pageable pageable);
    List<BatchInfoBean> findByProductBetweenDates(Integer productId, LocalDate startDate, LocalDate endDate);
}
