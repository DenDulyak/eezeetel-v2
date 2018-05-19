package com.eezeetel.entity;

import com.eezeetel.serializer.CustomerTypeSerializer;
import com.eezeetel.serializer.DateTimeSerializer;
import com.eezeetel.serializer.GroupSerializer;
import com.eezeetel.serializer.UserSerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_customerinfo")
public class TMasterCustomerinfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Customer_ID")
    private Integer id;

    @JsonSerialize(using = CustomerTypeSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_Type_ID", nullable = false)
    private TMasterCustomertype customerType;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Created_By_User_ID", nullable = false)
    private User createdBy;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_Introduced_By", nullable = false)
    private User introducedBy;

    @JsonSerialize(using = GroupSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_Group_ID")
    private TMasterCustomerGroups group;

    @Column(name = "Customer_Company_Name", nullable = false)
    private String companyName;

    @Column(name = "First_Name", nullable = false)
    private String firstName;

    @Column(name = "Last_Name", nullable = false)
    private String lastName;

    @Column(name = "Middle_Name")
    private String middleName;

    @Column(name = "Address_Line_1")
    private String addressLine1;

    @Column(name = "Address_Line_2")
    private String addressLine2;

    @Column(name = "Address_Line_3")
    private String addressLine3;

    @Column(name = "City")
    private String city;

    @Column(name = "State")
    private String state;

    @Column(name = "Postal_Code")
    private String postalCode;

    @Column(name = "Country")
    private String country;

    @Column(name = "Primary_Phone")
    private String primaryPhone;

    @Column(name = "Secondary_Phone")
    private String secondaryPhone;

    @Column(name = "Mobile_Phone")
    private String mobilePhone;

    @Column(name = "Website_Address")
    private String websiteAddress;

    @Column(name = "Email_ID")
    private String emailId;

    @Column(name = "Customer_Balance", nullable = false)
    private float customerBalance;

    @Column(name = "Active_Status", nullable = false)
    private Boolean active;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "Last_Modified_Time", nullable = false)
    private Date lastModifiedTime;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "Creation_Time", nullable = false)
    private Date creationTime;

    @Column(name = "Notes")
    private String notes;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "Login_Start_Time", nullable = false)
    @Temporal(TemporalType.TIME)
    private Date loginStartTime;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "Login_End_Time", nullable = false)
    @Temporal(TemporalType.TIME)
    private Date loginEndTime;

    @Column(name = "Customer_Feature_ID")
    private Integer customerFeatureId;

    @Column(name = "Special_Printer_Customer", nullable = false)
    private byte specialPrinterCustomer;

    @Column(name = "Allow_Credit", nullable = false)
    private byte allowCredit;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "customer", fetch = FetchType.LAZY)
    private List<TCustomerUsers> customerUsers;

    @JsonIgnore
    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JoinTable(name = "customer_feature",
            joinColumns = @JoinColumn(name = "CUSTOMER_ID", columnDefinition = "INT(10) UNSIGNED"),
            inverseJoinColumns = @JoinColumn(name = "FEATURE_ID"))
    private List<Feature> features;

    public TMasterCustomerinfo() {
    }

    public TMasterCustomerinfo(Integer id) {
        this.id = id;
    }
}