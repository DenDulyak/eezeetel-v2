package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_product_category")
public class TMasterProductCategory implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Product_Category_ID")
    private Integer id;

    @Column(name = "Product_Category_Name", nullable = false)
    private String name;

    @Column(name = "Product_Category_Description", nullable = false)
    private String description;

    @Column(name = "Is_Active", nullable = false)
    private Boolean active;

    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TMasterProducttype.class, mappedBy = "productCategory", fetch = FetchType.LAZY)
    private List<TMasterProducttype> productTypes;
}