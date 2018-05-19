package com.eezeetel.service.impl;

import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.repository.PhoneTopupCountryRepository;
import com.eezeetel.service.PhoneTopupCountryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PhoneTopupCountryServiceImpl implements PhoneTopupCountryService {

    @Autowired
    private PhoneTopupCountryRepository repository;

    @Override
    public PhoneTopupCountry save(PhoneTopupCountry country) {
        return repository.save(country);
    }

    @Override
    public PhoneTopupCountry findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public PhoneTopupCountry findByName(String name) {
        return repository.findByName(name);
    }

    @Override
    public PhoneTopupCountry findByIso(String iso) {
        return repository.findByIso(iso);
    }

    @Override
    public List<PhoneTopupCountry> findAll() {
        return repository.findAll(new Sort(Sort.Direction.ASC, "name"));
    }

    @Override
    public PhoneTopupCountry findByMobitopupCountryId(Integer mobitopupCountryId) {
        return repository.findByMobitopupCountryId(mobitopupCountryId);
    }
}
