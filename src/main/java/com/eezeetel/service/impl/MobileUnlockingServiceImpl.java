package com.eezeetel.service.impl;

import com.eezeetel.bean.mobileUnlocking.MobileUnlockingBean;
import com.eezeetel.entity.MobileUnlocking;
import com.eezeetel.repository.MobileUnlockingRepository;
import com.eezeetel.service.MobileUnlockingService;
import com.eezeetel.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.List;

/**
 * Created by Denis Dulyak on 15.12.2015.
 */
@Service
public class MobileUnlockingServiceImpl implements MobileUnlockingService {

    @Autowired
    private MobileUnlockingRepository mobileUnlockingRepository;

    @Autowired
    private SupplierService supplierService;

    @Override
    public MobileUnlocking findOne(Integer id) {
        return mobileUnlockingRepository.findOne(id);
    }

    @Override
    public List<MobileUnlocking> findAll() {
        return mobileUnlockingRepository.findAll();
    }

    @Override
    public List<MobileUnlocking> findBySupplier(Integer supplierId) {
        return mobileUnlockingRepository.findBySupplierId(supplierId);
    }

    @Override
    public MobileUnlocking createOrUpdate(MobileUnlockingBean bean) {
        MobileUnlocking mobileUnlocking;
        if (bean.getId() != null) {
            mobileUnlocking = mobileUnlockingRepository.findOne(bean.getId());
        } else {
            mobileUnlocking = new MobileUnlocking();
            mobileUnlocking.setActive(Boolean.TRUE);
        }
        mobileUnlocking.setTitle(bean.getTitle());
        mobileUnlocking.setSupplier(supplierService.findOne(bean.getSupplierId()));
        mobileUnlocking.setDeliveryTime(bean.getDeliveryTime());
        mobileUnlocking.setPurchasePrice(bean.getPurchasePrice());
        mobileUnlocking.setTransactionCondition(bean.getTransactionCondition());
        mobileUnlocking.setNotes(bean.getNotes());
        return mobileUnlockingRepository.save(mobileUnlocking);
    }

    @Override
    public MobileUnlocking setActiveStatus(Integer id, Boolean active) {
        MobileUnlocking mobileUnlocking = mobileUnlockingRepository.findOne(id);
        if (mobileUnlocking == null) {
            throw new EntityNotFoundException("Mobile Unlocking not found by id - " + id);
        }
        mobileUnlocking.setActive(active);
        return mobileUnlockingRepository.save(mobileUnlocking);
    }
}
