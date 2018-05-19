package com.eezeetel.repository;

import com.eezeetel.entity.TMasterProductinfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Denis Dulyak on 10.12.2015.
 */
@Repository
public interface ProductRepository extends JpaRepository<TMasterProductinfo, Integer> {

    List<TMasterProductinfo> findBySupplierIdAndActiveTrue(Integer supplierId);

    List<TMasterProductinfo> findByActiveTrue();
}
