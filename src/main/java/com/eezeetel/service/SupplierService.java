package com.eezeetel.service;

import com.eezeetel.api.responses.Product;
import com.eezeetel.entity.TMasterSupplierinfo;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface SupplierService {

    TMasterSupplierinfo findOne(Integer id);
    List<TMasterSupplierinfo> findAll();
    List<TMasterSupplierinfo> findByType(Integer typeId);
    List<TMasterSupplierinfo> findActiveAndOrderByName();
    TMasterSupplierinfo findInListById(Integer id, List<TMasterSupplierinfo> suppliers);
    List<Product> getProducts();
}
