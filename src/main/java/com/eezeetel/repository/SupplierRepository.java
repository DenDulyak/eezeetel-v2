package com.eezeetel.repository;

import com.eezeetel.entity.TMasterSupplierinfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * Created by Denis Dulyak on 15.12.2015.
 */
public interface SupplierRepository extends JpaRepository<TMasterSupplierinfo, Integer> {

    @Query(value = "select * from t_master_supplierinfo where Supplier_Type_ID = ?1 and Supplier_Active_Status = 1 ", nativeQuery = true)
    List<TMasterSupplierinfo> findByType(Integer typeId);

    @Query(value = "select * from t_master_supplierinfo where Supplier_Type_ID in (?1) and Supplier_Active_Status = 1 and Secondary_Supplier = 0 order by Supplier_Name ", nativeQuery = true)
    List<TMasterSupplierinfo> findByTypes(List<Integer> typeIds);

    List<TMasterSupplierinfo> findByActiveTrueOrderBySupplierNameAsc();
}
