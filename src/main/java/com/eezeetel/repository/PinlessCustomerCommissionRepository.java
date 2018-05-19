package com.eezeetel.repository;

import com.eezeetel.entity.PinlessCustomerCommission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PinlessCustomerCommissionRepository extends JpaRepository<PinlessCustomerCommission, Integer> {

    PinlessCustomerCommission findByCustomerId(Integer customerId);
}
