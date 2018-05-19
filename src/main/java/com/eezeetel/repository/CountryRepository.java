package com.eezeetel.repository;

import com.eezeetel.entity.TMasterCountries;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Created by Denis Dulyak on 16.12.2015.
 */
public interface CountryRepository extends JpaRepository<TMasterCountries, Integer> {
}
