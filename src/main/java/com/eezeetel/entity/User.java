package com.eezeetel.entity;

import com.eezeetel.serializer.DateTimeSerializer;
import com.eezeetel.serializer.GroupSerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "t_master_users")
public class User implements Serializable {

    @Id
    @Column(name = "User_Login_ID")
    private String login;

    @JsonSerialize(using = GroupSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_Group_ID", nullable = false)
    private TMasterCustomerGroups group;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "User_Type_And_Privilege", nullable = false)
    private TMasterUserTypeAndPrivilege userType;

    @Column(name = "User_First_Name", nullable = false)
    private String userFirstName;

    @Column(name = "User_Last_Name", nullable = false)
    private String userLastName;

    @Column(name = "User_Middle_Name")
    private String userMiddleName;

    @Column(name = "User_Company_Name", nullable = false)
    private String userCompanyName;

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

    @Column(name = "Primary_Phone", nullable = false)
    private String primaryPhone;

    @Column(name = "Secondary_Phone")
    private String secondaryPhone;

    @Column(name = "Mobile_Phone")
    private String mobilePhone;

    @Column(name = "EMail_ID", nullable = false)
    private String emailId;

    @Column(name = "Password", nullable = false)
    private String password;

    @Column(name = "Password_2", nullable = false)
    private String password2;

    @Column(name = "User_Active_Status", nullable = false)
    private Boolean userActiveStatus;

    @Column(name = "User_Created_By", nullable = false)
    private String userCreatedBy;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "User_Creation_Time", nullable = false)
    private Date userCreationTime;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "User_Modified_Time", nullable = false)
    private Date userModifiedTime;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Reserved_2")
    private String reserved2;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TCustomerUsers.class, mappedBy = "user", fetch = FetchType.LAZY)
    private List<TCustomerUsers> customerUsers;

    public User(String login) {
        this.login = login;
    }
}