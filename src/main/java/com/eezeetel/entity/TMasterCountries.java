package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "t_master_countries")
public class TMasterCountries implements Serializable {

    @Id
    @Column(name = "Country_Name")
    private String countryName;
}