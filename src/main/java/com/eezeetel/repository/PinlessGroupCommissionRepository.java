package com.eezeetel.repository;

import com.eezeetel.entity.PinlessGroupCommission;
import com.eezeetel.entity.TMasterCustomerGroups;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PinlessGroupCommissionRepository extends JpaRepository<PinlessGroupCommission, Integer> {

    PinlessGroupCommission findByGroup(TMasterCustomerGroups group);
}
