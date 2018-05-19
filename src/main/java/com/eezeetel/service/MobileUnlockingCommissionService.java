package com.eezeetel.service;

import com.eezeetel.entity.MobileUnlocking;
import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.TMasterCustomerGroups;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
public interface MobileUnlockingCommissionService {

    MobileUnlockingCommission save(MobileUnlockingCommission commission);
    MobileUnlockingCommission findByGroupAndMobileUnlocking(TMasterCustomerGroups group, MobileUnlocking mobileUnlocking);
    MobileUnlockingCommission findByGroupAndMobileUnlocking(Integer groupId, Integer mobileUnlockingId);
    List<MobileUnlockingCommission> findOrCreateByGroupAndSupplier(Integer groupId, Integer supplierId);
    MobileUnlockingCommission updateCommision(Integer commissionId, BigDecimal commission);
    List<MobileUnlockingCommission> updateTable(Map<String, String> map);
    Boolean copyCommisionsFromOneGroupToAnother(Integer groupFrom, Integer groupTo);
}
