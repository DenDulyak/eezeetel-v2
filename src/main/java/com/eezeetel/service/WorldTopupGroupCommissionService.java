package com.eezeetel.service;

import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.WorldTopupGroupCommission;
import org.springframework.stereotype.Service;

@Service
public interface WorldTopupGroupCommissionService {

    WorldTopupGroupCommission findOrCreateByCountryIdAndGroupId(Integer countryId, Integer groupId);
    WorldTopupGroupCommission findOrCreateByCountryAndGroupId(PhoneTopupCountry country, Integer groupId);
    WorldTopupGroupCommission create(PhoneTopupCountry country, TMasterCustomerGroups group);
    WorldTopupGroupCommission save(WorldTopupGroupCommission commission);
}
