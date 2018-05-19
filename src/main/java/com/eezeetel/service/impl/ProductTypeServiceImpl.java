package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterProducttype;
import com.eezeetel.repository.ProductTypeRepository;
import com.eezeetel.service.ProductTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Denis Dulyak on 28.11.2016.
 */
@Service
public class ProductTypeServiceImpl implements ProductTypeService {

    @Autowired
    private ProductTypeRepository repository;

    @Override
    public List<TMasterProducttype> findAll() {
        return repository.findAll();
    }

    @Override
    public TMasterProducttype findInListById(Integer id, List<TMasterProducttype> types) {
        return types.stream().filter(t -> t.getId().equals(id.shortValue())).findFirst().get();
    }
}
