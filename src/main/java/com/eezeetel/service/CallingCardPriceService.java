package com.eezeetel.service;

import com.eezeetel.bean.masteradmin.CallingCardPriceBean;
import com.eezeetel.entity.CallingCardPrice;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface CallingCardPriceService {

    CallingCardPrice findOne(Integer id);
    CallingCardPrice save(CallingCardPrice callingCardPrice);
    void delete(Integer id);
    List<CallingCardPrice> findAll();
    Page<CallingCardPrice> findAll(Pageable pageable);
    CallingCardPrice createOrUpdate(CallingCardPriceBean bean);
}
