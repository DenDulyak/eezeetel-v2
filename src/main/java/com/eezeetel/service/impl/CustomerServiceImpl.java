package com.eezeetel.service.impl;

import com.eezeetel.entity.Feature;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import com.eezeetel.enums.FeatureType;
import com.eezeetel.repository.CustomerRepository;
import com.eezeetel.service.CustomerService;
import com.eezeetel.service.FeatureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.AbstractMap;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 21.09.2015.
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerRepository repository;

    @Autowired
    private FeatureService featureService;

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public TMasterCustomerinfo save(TMasterCustomerinfo customer) {
        return repository.save(customer);
    }

    @Override
    public TMasterCustomerinfo findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public List<TMasterCustomerinfo> findByName(String name) {
        return repository.findByCompanyName(name);
    }

    @Override
    public List<TMasterCustomerinfo> findByGroupAndIntroducedBy(TMasterCustomerGroups group, User introducedBy) {
        return repository.findByGroupAndIntroducedByAndActiveTrue(group, introducedBy);
    }

    @Override
    public List<TMasterCustomerinfo> findAll(Boolean active) {
        return active ? repository.findByActiveTrue() : repository.findAll();
    }

    @Override
    public List<TMasterCustomerinfo> findByGroup(TMasterCustomerGroups group) {
        return repository.findByGroup(group);
    }

    @Override
    public List<AbstractMap.SimpleEntry<Integer, String>> convert(List<TMasterCustomerinfo> customers) {
        return customers.stream().map(c -> new AbstractMap.SimpleEntry<>(c.getId(), c.getCompanyName())).collect(Collectors.toList());
    }

    @Override
    public List<String> getCompanyNames(List<TMasterCustomerinfo> customers) {
        return customers.stream().map(TMasterCustomerinfo::getCompanyName).collect(Collectors.toList());
    }

    @Override
    public Boolean hasFeature(TMasterCustomerinfo customer, FeatureType type) {
        return customer.getFeatures().stream().anyMatch(f -> f.getFeatureType().equals(type));
    }

    @Override
    public List<Feature> updateCustomerFeaturesByGroup(Integer groupId, List<FeatureType> featureTypes) {
        List<TMasterCustomerinfo> customers = this.findByGroup(new TMasterCustomerGroups(groupId));
        List<Feature> features = Collections.emptyList();
        if (!customers.isEmpty()) {
            if (!featureTypes.isEmpty()) {
                features = featureService.findByFeatureTypes(featureTypes);
            }
            for (TMasterCustomerinfo customer : customers) {
                customer.setFeatures(features);
            }
            repository.save(customers);
        }
        return features;
    }
}
