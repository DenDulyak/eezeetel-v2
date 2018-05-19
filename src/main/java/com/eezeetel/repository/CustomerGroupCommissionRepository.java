package com.eezeetel.repository;

import com.eezeetel.entity.TCustomerGroupCommissions;
import com.eezeetel.entity.TCustomerGroupCommissionsId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 17.02.2016.
 */
@Repository
public interface CustomerGroupCommissionRepository extends JpaRepository<TCustomerGroupCommissions, Integer> {

    TCustomerGroupCommissions findById(TCustomerGroupCommissionsId id);
}
