package com.eezeetel.entity;

import com.eezeetel.enums.FeatureType;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

/**
 * Created by Denis Dulyak on 18.01.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "feature")
public class Feature {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "TITLE", nullable = false)
    private String title;

    @Column(name = "FEATURE_TYPE", nullable = false)
    @Enumerated(EnumType.ORDINAL)
    private FeatureType featureType;

    @Column(name = "ACTIVE", nullable = false)
    private Boolean active;
}
