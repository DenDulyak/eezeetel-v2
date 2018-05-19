package com.eezeetel.service.impl;

import com.eezeetel.entity.MobileUnlocking;
import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.repository.MobileUnlockingCommissionRepository;
import com.eezeetel.service.GroupService;
import com.eezeetel.service.MobileUnlockingCommissionService;
import com.eezeetel.service.MobileUnlockingService;
import com.eezeetel.util.PriceUtil;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Denis Dulyak on 17.12.2015.
 */
@Log4j
@Service
public class MobileUnlockingCommissionServiceImpl implements MobileUnlockingCommissionService {

    @Autowired
    private MobileUnlockingCommissionRepository repository;

    @Autowired
    private MobileUnlockingService mobileUnlockingService;

    @Autowired
    private GroupService groupService;

    @Override
    public MobileUnlockingCommission save(MobileUnlockingCommission commission) {
        return repository.save(commission);
    }

    @Override
    public MobileUnlockingCommission findByGroupAndMobileUnlocking(TMasterCustomerGroups group, MobileUnlocking mobileUnlocking) {
        return repository.findByGroupAndMobileUnlocking(group, mobileUnlocking);
    }

    @Override
    public MobileUnlockingCommission findByGroupAndMobileUnlocking(Integer groupId, Integer mobileUnlockingId) {
        return repository.findByGroupAndMobileUnlocking(groupService.findOne(groupId), mobileUnlockingService.findOne(mobileUnlockingId));
    }

    @Override
    public List<MobileUnlockingCommission> findOrCreateByGroupAndSupplier(Integer groupId, Integer supplierId) {
        List<MobileUnlockingCommission> result = new ArrayList<>();
        TMasterCustomerGroups group = groupService.findOne(groupId);
        if (group == null) {
            log.info("Group not found. GroupId: " + groupId);
            return result;
        }

        List<MobileUnlocking> mobileUnlockings = mobileUnlockingService.findBySupplier(supplierId);
        for (MobileUnlocking mobileUnlocking : mobileUnlockings) {
            MobileUnlockingCommission commission = findByGroupAndMobileUnlocking(group, mobileUnlocking);
            if (commission == null) {
                commission = new MobileUnlockingCommission();
                commission.setGroup(group);
                commission.setMobileUnlocking(mobileUnlocking);
                commission.setCommission(PriceUtil.getPercent(mobileUnlocking.getPurchasePrice(), PriceUtil.TEN));
                commission = save(commission);
            }
            result.add(commission);
        }

        return result;
    }

    @Override
    public MobileUnlockingCommission updateCommision(Integer commissionId, BigDecimal commission) {
        MobileUnlockingCommission mobileUnlockingCommission = repository.findOne(commissionId);
        mobileUnlockingCommission.setCommission(commission);
        mobileUnlockingCommission.setUpdatedDate(new Date());
        return save(mobileUnlockingCommission);
    }

    @Override
    public List<MobileUnlockingCommission> updateTable(Map<String, String> map) {
        List<MobileUnlockingCommission> result = new ArrayList<>();
        for (Map.Entry<String, String> entry : map.entrySet()) {
            Integer commissionId = Integer.parseInt(entry.getKey());
            BigDecimal commission = new BigDecimal(entry.getValue().isEmpty() ? "0" : entry.getValue());
            result.add(updateCommision(commissionId, commission));
        }
        return result;
    }

    @Override
    public Boolean copyCommisionsFromOneGroupToAnother(Integer groupFrom, Integer groupTo) {
        Boolean result = false;
        try {
            List<MobileUnlockingCommission> fromCommissions = repository.findByGroup(groupService.findOne(groupFrom));
            TMasterCustomerGroups group = groupService.findOne(groupTo);
            for (MobileUnlockingCommission fromCommission : fromCommissions) {
                MobileUnlockingCommission toCommission = repository.findByGroupAndMobileUnlocking(group, fromCommission.getMobileUnlocking());
                if (toCommission == null) {
                    toCommission = new MobileUnlockingCommission();
                    toCommission.setGroup(group);
                    toCommission.setMobileUnlocking(fromCommission.getMobileUnlocking());
                }
                toCommission.setCommission(fromCommission.getCommission());
                save(toCommission);
            }
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
