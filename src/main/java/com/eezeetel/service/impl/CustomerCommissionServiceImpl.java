package com.eezeetel.service.impl;

import com.eezeetel.entity.TCustomerCommission;
import com.eezeetel.entity.TCustomerCommissionId;
import com.eezeetel.repository.CustomerCommissionRepository;
import com.eezeetel.service.CustomerCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CustomerCommissionServiceImpl implements CustomerCommissionService {

    @Autowired
    private CustomerCommissionRepository repository;

    @Override
    public TCustomerCommission findById(TCustomerCommissionId id) {
        return repository.findById(id);
    }

    @Override
    public TCustomerCommission findByCustomerAndProduct(Integer customerId, Integer productId) {
        return findById(new TCustomerCommissionId(customerId, productId));
    }
}
