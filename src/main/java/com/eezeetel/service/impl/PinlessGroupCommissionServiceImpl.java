package com.eezeetel.service.impl;

import com.eezeetel.entity.PinlessGroupCommission;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.repository.PinlessGroupCommissionRepository;
import com.eezeetel.service.GroupService;
import com.eezeetel.service.PinlessGroupCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

@Service
public class PinlessGroupCommissionServiceImpl implements PinlessGroupCommissionService {

    @Autowired
    private PinlessGroupCommissionRepository repository;

    @Autowired
    private GroupService groupService;

    @Override
    public PinlessGroupCommission findByGroupId(Integer groupId) {
        TMasterCustomerGroups group = groupService.findOne(groupId);
        Assert.notNull(group);

        PinlessGroupCommission commission = repository.findByGroup(group);
        if (commission == null) {
            commission = new PinlessGroupCommission();
            commission.setGroup(group);
            commission.setPercent(group.getId() == 1 ? 0 : 3);
            commission = repository.save(commission);
        }

        return commission;
    }

    @Override
    public PinlessGroupCommission update(Integer groupId, Integer percent) {
        PinlessGroupCommission commission = repository.findByGroup(new TMasterCustomerGroups(groupId));
        Assert.notNull(commission);
        commission.setPercent(percent);
        return repository.save(commission);
    }
}
