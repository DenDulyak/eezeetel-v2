package com.eezeetel.service.impl;

import com.eezeetel.api.responses.Product;
import com.eezeetel.entity.TMasterSupplierinfo;
import com.eezeetel.repository.SupplierRepository;
import com.eezeetel.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 08.09.2015.
 */
@Service
public class SupplierServiceImpl implements SupplierService {

    @Autowired
    private SupplierRepository repository;

    @Override
    public TMasterSupplierinfo findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public List<TMasterSupplierinfo> findByType(Integer typeId) {
        return repository.findByType(typeId);
    }

    @Override
    public List<TMasterSupplierinfo> findAll() {
        return repository.findAll();
    }

    @Override
    public List<TMasterSupplierinfo> findActiveAndOrderByName() {
        return repository.findByActiveTrueOrderBySupplierNameAsc();
    }

    @Override
    public TMasterSupplierinfo findInListById(Integer id, List<TMasterSupplierinfo> suppliers) {
        return suppliers.stream().filter(s -> s.getId().equals(id)).findFirst().get();
    }

    @Override
    public List<Product> getProducts() {
        List<Product> products = repository.findByTypes(Arrays.asList(8, 9, 10, 12))
                .stream().map(Product::new).collect(Collectors.toList());
        products.sort((p1, p2) -> p1.getName().compareTo(p2.getName()));
        return products;
    }
}
