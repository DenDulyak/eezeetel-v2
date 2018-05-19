package com.eezeetel.service;

import com.eezeetel.entity.PhoneTopupCountry;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface PhoneTopupCountryService {

    PhoneTopupCountry save(PhoneTopupCountry country);
    PhoneTopupCountry findOne(Integer id);
    PhoneTopupCountry findByName(String name);
    PhoneTopupCountry findByIso(String iso);
    List<PhoneTopupCountry> findAll();
    PhoneTopupCountry findByMobitopupCountryId(Integer mobitopupCountryId);
}
