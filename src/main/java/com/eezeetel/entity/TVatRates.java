package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "t_vat_rates")
public class TVatRates implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Byte id;

    @Column(name = "Country", nullable = false)
    private String country;

    @Column(name = "Vat_Rate", nullable = false)
    private float vatRate;
}