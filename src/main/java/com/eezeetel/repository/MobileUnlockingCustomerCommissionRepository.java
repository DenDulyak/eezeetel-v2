package com.eezeetel.repository;

import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.MobileUnlockingCustomerCommission;
import com.eezeetel.entity.TMasterCustomerinfo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Created by Denis Dulyak on 23.12.2015.
 */
public interface MobileUnlockingCustomerCommissionRepository extends JpaRepository<MobileUnlockingCustomerCommission, Integer> {

    List<MobileUnlockingCustomerCommission> findByCustomer(TMasterCustomerinfo customer);

    MobileUnlockingCustomerCommission findByCustomerAndMobileUnlockingCommission(TMasterCustomerinfo customer, MobileUnlockingCommission commission);
}
