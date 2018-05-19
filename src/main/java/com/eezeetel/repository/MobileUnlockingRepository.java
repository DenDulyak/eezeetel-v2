package com.eezeetel.repository;

import com.eezeetel.entity.MobileUnlocking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MobileUnlockingRepository extends JpaRepository<MobileUnlocking, Integer> {

    List<MobileUnlocking> findBySupplierId(Integer supplierId);
}
