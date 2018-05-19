package com.eezeetel.service;

import com.eezeetel.entity.TCustomerCommission;
import com.eezeetel.entity.TCustomerCommissionId;
import org.springframework.stereotype.Service;

@Service
public interface CustomerCommissionService {

    TCustomerCommission findById(TCustomerCommissionId id);
    TCustomerCommission findByCustomerAndProduct(Integer customerId, Integer productId);
}
