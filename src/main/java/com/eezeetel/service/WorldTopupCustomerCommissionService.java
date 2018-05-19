package com.eezeetel.service;

import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.WorldTopupCustomerCommission;
import com.eezeetel.entity.WorldTopupGroupCommission;
import org.springframework.stereotype.Service;

@Service
public interface WorldTopupCustomerCommissionService {

    WorldTopupCustomerCommission save(WorldTopupCustomerCommission commission);
    WorldTopupCustomerCommission findByGroupCommissionAndCustomer(WorldTopupGroupCommission groupCommission, TMasterCustomerinfo customer);
    WorldTopupCustomerCommission findOrCreateByGroupCommissionAndCustomer(WorldTopupGroupCommission groupCommission, TMasterCustomerinfo customer);
    WorldTopupCustomerCommission findOrCreateByCountryIdAndGroupIdAndCustomerId(Integer countryId, Integer groupId, Integer customerId);
    WorldTopupCustomerCommission create(WorldTopupGroupCommission groupCommission, TMasterCustomerinfo customer);
}
