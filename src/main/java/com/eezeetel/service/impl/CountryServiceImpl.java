package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterCountries;
import com.eezeetel.repository.CountryRepository;
import com.eezeetel.service.CountryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CountryServiceImpl implements CountryService {

    @Autowired
    private CountryRepository repository;

    @Override
    public List<TMasterCountries> findAll() {
        return repository.findAll();
    }
}
