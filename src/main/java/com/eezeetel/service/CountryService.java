package com.eezeetel.service;

import com.eezeetel.entity.TMasterCountries;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface CountryService {

    List<TMasterCountries> findAll();
}
