package com.eezeetel.service;

import com.eezeetel.entity.Feature;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import com.eezeetel.enums.FeatureType;
import org.springframework.stereotype.Service;

import java.util.AbstractMap;
import java.util.List;

@Service
public interface CustomerService {

    TMasterCustomerinfo save(TMasterCustomerinfo customer);
    TMasterCustomerinfo findOne(Integer id);
    List<TMasterCustomerinfo> findByName(String name);
    List<TMasterCustomerinfo> findByGroupAndIntroducedBy(TMasterCustomerGroups group, User introducedBy);
    List<TMasterCustomerinfo> findAll(Boolean active);
    List<TMasterCustomerinfo> findByGroup(TMasterCustomerGroups group);
    List<AbstractMap.SimpleEntry<Integer, String>> convert(List<TMasterCustomerinfo> customers);
    List<String> getCompanyNames(List<TMasterCustomerinfo> customers);
    Boolean hasFeature(TMasterCustomerinfo customer, FeatureType type);
    List<Feature> updateCustomerFeaturesByGroup(Integer groupId, List<FeatureType> featureTypes);
}
