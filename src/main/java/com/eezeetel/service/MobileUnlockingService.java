package com.eezeetel.service;

import com.eezeetel.bean.mobileUnlocking.MobileUnlockingBean;
import com.eezeetel.entity.MobileUnlocking;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface MobileUnlockingService {

    MobileUnlocking findOne(Integer id);
    List<MobileUnlocking> findAll();
    List<MobileUnlocking> findBySupplier(Integer supplierId);
    MobileUnlocking createOrUpdate(MobileUnlockingBean bean);
    MobileUnlocking setActiveStatus(Integer id, Boolean active);
}
