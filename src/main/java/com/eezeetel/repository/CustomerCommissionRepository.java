package com.eezeetel.repository;

import com.eezeetel.entity.TCustomerCommission;
import com.eezeetel.entity.TCustomerCommissionId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 17.02.2016.
 */
@Repository
public interface CustomerCommissionRepository extends JpaRepository<TCustomerCommission, Integer> {

    TCustomerCommission findById(TCustomerCommissionId id);
}
