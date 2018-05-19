package com.eezeetel.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

/**
 * Created by Denis Dulyak on 07.04.2016.
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "phone_topup_country")
public class PhoneTopupCountry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "NAME", nullable = false)
    private String name;

    @Column(name = "ISO", nullable = false, unique = true)
    private String iso;

    @Column(name = "PHONE_CODE", nullable = false)
    private String phoneCode;

    @Column(name = "AVAILABLE_IN_DING", nullable = false)
    private Boolean availableInDing;

    @Column(name = "AVAILABLE_IN_MOBITOPUP", nullable = false)
    private Boolean availableInMobitopup;

    @Column(name = "MOBITOPUP_COUNTRY_ID", unique = true)
    private Integer mobitopupCountryId;

    public PhoneTopupCountry(Integer id) {
        this.id = id;
    }
}