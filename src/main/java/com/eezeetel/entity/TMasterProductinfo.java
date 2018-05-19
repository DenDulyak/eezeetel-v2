package com.eezeetel.entity;

import com.eezeetel.serializer.ProductTypeSerializer;
import com.eezeetel.serializer.UserSerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_productinfo")
public class TMasterProductinfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Product_ID")
    private Integer id;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Product_Created_By", nullable = false)
    private User user;

    @JsonSerialize(using = ProductTypeSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Product_Type_ID", nullable = false)
    private TMasterProducttype productType;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Supplier_ID", nullable = false)
    private TMasterSupplierinfo supplier;

    @Column(name = "Product_Name", nullable = false)
    private String productName;

    @Column(name = "Product_Face_Value", nullable = false)
    private float productFaceValue;

    @Column(name = "COST_PRICE")
    private BigDecimal costPrice;

    @Column(name = "Product_Description")
    private String productDescription;

    @Column(name = "Product_Active_Status", nullable = false)
    private Boolean active;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "Product_Creation_Time", nullable = false)
    private Date productCreationTime;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Caliculate_VAT", nullable = false)
    private short calculateVat;

    @Column(name = "Reserved_1")
    private Integer reserved1;

    @Column(name = "Reserved_2")
    private String reserved2;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TMasterProductsaleinfo.class, mappedBy = "product", fetch = FetchType.LAZY)
    private List<TMasterProductsaleinfo> productsaleinfos;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TBatchInformation.class, mappedBy = "product", fetch = FetchType.LAZY)
    private List<TBatchInformation> batches;

    public TMasterProductinfo() {
    }

    public TMasterProductinfo(Integer id) {
        this.id = id;
    }
}