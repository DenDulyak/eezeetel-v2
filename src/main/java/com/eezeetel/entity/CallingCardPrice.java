package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

/**
 * Created by Denis Dulyak on 07.03.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "calling_card_price")
public class CallingCardPrice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "COUNTRY", nullable = false)
    private String country;

    @Column(name = "LANDLINE_PRICE", nullable = false)
    private String landlinePrice;

    @Column(name = "MOBILE_PRICE", nullable = false)
    private String mobilePrice;

    @Column(name = "CREATED_DATE", nullable = false)
    private Date createdDate;

    @Column(name = "UPDATED_DATE")
    private Date updatedDate;

    @Column(name = "ACTIVE", nullable = false)
    private Boolean active;
}
