package com.eezeetel.service;

import com.eezeetel.entity.TCustomerGroupCommissions;
import com.eezeetel.entity.TCustomerGroupCommissionsId;
import org.springframework.stereotype.Service;

@Service
public interface CustomerGroupCommissionService {

    TCustomerGroupCommissions findById(TCustomerGroupCommissionsId id);
    TCustomerGroupCommissions findByGroupAndProduct(Integer groupId, Integer productId);
}
