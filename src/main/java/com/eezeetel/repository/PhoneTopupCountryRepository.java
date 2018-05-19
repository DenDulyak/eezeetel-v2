package com.eezeetel.repository;

import com.eezeetel.entity.PhoneTopupCountry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PhoneTopupCountryRepository extends JpaRepository<PhoneTopupCountry, Integer> {

    PhoneTopupCountry findByName(String name);

    PhoneTopupCountry findByMobitopupCountryId(Integer mobitopupCountryId);

    PhoneTopupCountry findByIso(String iso);
}
