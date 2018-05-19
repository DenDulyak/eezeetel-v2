package com.eezeetel.service;

import com.eezeetel.entity.Feature;
import com.eezeetel.enums.FeatureType;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FeatureService {

    Feature findOne(Integer id);
    List<Feature> findAll();
    Feature save(Feature feature);
    Feature findByFeatureType(FeatureType featureType);
    List<Feature> findByFeatureTypes(List<FeatureType> featureTypes);
}
