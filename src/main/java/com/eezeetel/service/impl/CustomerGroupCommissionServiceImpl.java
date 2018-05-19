package com.eezeetel.service.impl;

import com.eezeetel.entity.TCustomerGroupCommissions;
import com.eezeetel.entity.TCustomerGroupCommissionsId;
import com.eezeetel.repository.CustomerGroupCommissionRepository;
import com.eezeetel.service.CustomerGroupCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CustomerGroupCommissionServiceImpl implements CustomerGroupCommissionService {

    @Autowired
    private CustomerGroupCommissionRepository repository;

    @Override
    public TCustomerGroupCommissions findById(TCustomerGroupCommissionsId id) {
        return repository.findById(id);
    }

    @Override
    public TCustomerGroupCommissions findByGroupAndProduct(Integer groupId, Integer productId) {
        return findById(new TCustomerGroupCommissionsId(groupId, productId));
    }
}
