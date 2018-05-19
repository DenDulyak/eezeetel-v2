package com.eezeetel.repository;

import com.eezeetel.entity.Feature;
import com.eezeetel.enums.FeatureType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Created by Denis Dulyak on 18.01.2016.
 */
public interface FeatureRepository extends JpaRepository<Feature, Integer> {

    List<Feature> findByFeatureTypeIn(List<FeatureType> featureTypes);

    Feature findByFeatureType(FeatureType featureType);
}
