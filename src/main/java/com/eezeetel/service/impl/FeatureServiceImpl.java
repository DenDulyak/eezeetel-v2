package com.eezeetel.service.impl;

import com.eezeetel.entity.Feature;
import com.eezeetel.enums.FeatureType;
import com.eezeetel.repository.FeatureRepository;
import com.eezeetel.service.FeatureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Denis Dulyak on 18.01.2016.
 */
@Service
public class FeatureServiceImpl implements FeatureService {

    @Autowired
    private FeatureRepository featureRepository;

    @Override
    public Feature findOne(Integer id) {
        return featureRepository.findOne(id);
    }

    @Override
    public List<Feature> findAll() {
        return featureRepository.findAll();
    }

    @Override
    public Feature save(Feature feature) {
        return featureRepository.save(feature);
    }

    @Override
    public Feature findByFeatureType(FeatureType featureType) {
        return featureRepository.findByFeatureType(featureType);
    }

    @Override
    public List<Feature> findByFeatureTypes(List<FeatureType> featureTypes) {
        return featureRepository.findByFeatureTypeIn(featureTypes);
    }
}
