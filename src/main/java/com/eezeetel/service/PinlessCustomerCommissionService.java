package com.eezeetel.service;

import com.eezeetel.entity.PinlessCustomerCommission;
import org.springframework.stereotype.Service;

@Service
public interface PinlessCustomerCommissionService {

    PinlessCustomerCommission findByCustomerId(Integer groupId, Integer customerId);
    PinlessCustomerCommission update(Integer customerId, Integer groupPercent, Integer agentPercent);
    void copy(Integer customerIdFrom, Integer customerIdTo, boolean copyGroupCommission, boolean copyAgentCommission);
}
