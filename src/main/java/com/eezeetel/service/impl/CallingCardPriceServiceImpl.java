package com.eezeetel.service.impl;

import com.eezeetel.bean.masteradmin.CallingCardPriceBean;
import com.eezeetel.entity.CallingCardPrice;
import com.eezeetel.repository.CallingCardPriceRepositoy;
import com.eezeetel.service.CallingCardPriceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class CallingCardPriceServiceImpl implements CallingCardPriceService {

    @Autowired
    private CallingCardPriceRepositoy repositoy;

    @Override
    public CallingCardPrice findOne(Integer id) {
        return repositoy.findOne(id);
    }

    @Override
    public CallingCardPrice save(CallingCardPrice callingCardPrice) {
        return repositoy.save(callingCardPrice);
    }

    @Override
    public void delete(Integer id) {
        repositoy.delete(id);
    }

    @Override
    public List<CallingCardPrice> findAll() {
        return repositoy.findAll();
    }

    @Override
    public Page<CallingCardPrice> findAll(Pageable pageable) {
        return repositoy.findAll(pageable);
    }

    @Override
    public CallingCardPrice createOrUpdate(CallingCardPriceBean bean) {
        CallingCardPrice callingCardPrice;
        if (bean.getId() == null) {
            callingCardPrice = new CallingCardPrice();
            callingCardPrice.setActive(Boolean.TRUE);
            callingCardPrice.setCreatedDate(new Date());
        } else {
            callingCardPrice = findOne(bean.getId());
        }
        callingCardPrice.setCountry(bean.getCountry());
        callingCardPrice.setLandlinePrice(bean.getLandlinePrice());
        callingCardPrice.setMobilePrice(bean.getMobilePrice());
        callingCardPrice.setUpdatedDate(new Date());
        return save(callingCardPrice);
    }
}
