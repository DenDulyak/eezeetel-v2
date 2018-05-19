package com.eezeetel.service.impl;

import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.WorldTopupGroupCommission;
import com.eezeetel.repository.WorldTopupGroupCommissionRepository;
import com.eezeetel.service.GroupService;
import com.eezeetel.service.PhoneTopupCountryService;
import com.eezeetel.service.WorldTopupGroupCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Denis Dulyak on 09.06.2016.
 */
@Service
public class WorldTopupGroupCommissionServiceImpl implements WorldTopupGroupCommissionService {

    @Autowired
    private WorldTopupGroupCommissionRepository repository;

    @Autowired
    private PhoneTopupCountryService countryService;

    @Autowired
    private GroupService groupService;

    @Override
    public WorldTopupGroupCommission findOrCreateByCountryIdAndGroupId(Integer countryId, Integer groupId) {
        WorldTopupGroupCommission commission = repository.findByCountryAndGroup(new PhoneTopupCountry(countryId), new TMasterCustomerGroups(groupId));
        if (commission == null) {
            commission = create(countryService.findOne(countryId), groupService.findOne(groupId));
        }
        return commission;
    }

    @Override
    public WorldTopupGroupCommission findOrCreateByCountryAndGroupId(PhoneTopupCountry country, Integer groupId) {
        WorldTopupGroupCommission commission = repository.findByCountryAndGroup(country, new TMasterCustomerGroups(groupId));
        if (commission == null) {
            commission = create(country, groupService.findOne(groupId));
        }
        return commission;
    }

    @Override
    public WorldTopupGroupCommission create(PhoneTopupCountry country, TMasterCustomerGroups group) {
        WorldTopupGroupCommission commission = new WorldTopupGroupCommission();
        commission.setCountry(country);
        commission.setGroup(group);
        if (group.getId().equals(1)) {
            commission.setPercent(0);
        } else {
            commission.setPercent(3);
        }
        return save(commission);
    }

    @Override
    public WorldTopupGroupCommission save(WorldTopupGroupCommission commission) {
        return repository.save(commission);
    }
}
