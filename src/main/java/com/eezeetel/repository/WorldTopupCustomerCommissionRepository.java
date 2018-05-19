package com.eezeetel.repository;

import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.WorldTopupCustomerCommission;
import com.eezeetel.entity.WorldTopupGroupCommission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 13.07.2016.
 */
@Repository
public interface WorldTopupCustomerCommissionRepository extends JpaRepository<WorldTopupCustomerCommission, Integer> {

    WorldTopupCustomerCommission findByGroupCommissionAndCustomer(WorldTopupGroupCommission groupCommission, TMasterCustomerinfo customer);
}
