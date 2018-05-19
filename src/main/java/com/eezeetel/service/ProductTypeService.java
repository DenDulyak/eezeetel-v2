package com.eezeetel.service;

import com.eezeetel.entity.TMasterProducttype;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface ProductTypeService {

    List<TMasterProducttype> findAll();
    TMasterProducttype findInListById(Integer id, List<TMasterProducttype> types);
}
