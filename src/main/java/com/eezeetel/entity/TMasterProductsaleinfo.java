package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_productsaleinfo")
public class TMasterProductsaleinfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Sale_Info_ID")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Product_ID", nullable = false)
    private TMasterProductinfo product;

    @Column(name = "Toll_Free_Number_1")
    private String tollFreeNumber1;

    @Column(name = "Toll_Free_Number_2")
    private String tollFreeNumber2;

    @Column(name = "Local_Acess_Number_1")
    private String localAcessNumber1;

    @Column(name = "Local_Acess_Number_2")
    private String localAcessNumber2;

    @Column(name = "National_Acess_Number_1")
    private String nationalAcessNumber1;

    @Column(name = "National_Acess_Number_2")
    private String nationalAcessNumber2;

    @Column(name = "PayPhone_Acess_Number_1")
    private String payPhoneAcessNumber1;

    @Column(name = "PayPhone_Acess_Number_2")
    private String payPhoneAcessNumber2;

    @Column(name = "Other_Acess_Number_1")
    private String otherAcessNumber1;

    @Column(name = "Other_Acess_Number_2")
    private String otherAcessNumber2;

    @Column(name = "Support_Number_1")
    private String supportNumber1;

    @Column(name = "Support_Number_2")
    private String supportNumber2;

    @Column(name = "Sale_Rules")
    private String saleRules;

    @Column(name = "AdditionalInfo")
    private String additionalInfo;

    @Column(name = "Product_Image_File")
    private String productImageFile;

    @Column(name = "IsActive", nullable = false)
    private Boolean active;

    @Column(name = "CreationTime", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;

    @Column(name = "CreatedBy", nullable = false)
    private String createdBy;

    @Column(name = "ModifiedTime", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedTime;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Print_Info")
    private String printInfo;

    @Column(name = "Reserved_1")
    private Integer reserved1;

    @Column(name = "Reserved_2")
    private String reserved2;

    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TBatchInformation.class, mappedBy = "productsaleinfo", fetch = FetchType.LAZY)
    private List<TBatchInformation> batchInformations;
}