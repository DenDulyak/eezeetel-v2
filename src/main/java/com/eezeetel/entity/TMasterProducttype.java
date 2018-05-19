package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_producttype")
public class TMasterProducttype implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Product_Type_ID")
    private Short id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Category_ID", nullable = false)
    private TMasterProductCategory productCategory;

    @Column(name = "Product_Type", nullable = false)
    private String productType;

    @Column(name = "Product_Type_Description")
    private String productTypeDescription;

    @Column(name = "Product_Type_Active_Status", nullable = false)
    private Boolean active;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Reserved_1")
    private Integer reserved1;

    @Column(name = "Reserved_2")
    private String reserved2;

    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TMasterProductinfo.class, mappedBy = "productType", fetch = FetchType.LAZY)
    private List<TMasterProductinfo> products;
}