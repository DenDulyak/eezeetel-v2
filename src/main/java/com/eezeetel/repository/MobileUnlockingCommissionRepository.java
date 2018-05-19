package com.eezeetel.repository;

import com.eezeetel.entity.MobileUnlocking;
import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.TMasterCustomerGroups;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Created by Denis Dulyak on 17.12.2015.
 */
public interface MobileUnlockingCommissionRepository extends JpaRepository<MobileUnlockingCommission, Integer> {

    MobileUnlockingCommission findByGroupAndMobileUnlocking(TMasterCustomerGroups group, MobileUnlocking mobileUnlocking);

    List<MobileUnlockingCommission> findByGroup(TMasterCustomerGroups group);
}
