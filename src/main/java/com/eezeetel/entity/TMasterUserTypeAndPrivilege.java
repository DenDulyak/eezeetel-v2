package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "t_master_user_type_and_privilege")
public class TMasterUserTypeAndPrivilege implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "User_Type_And_Privilege_ID")
    private Short id;

    @Column(name = "User_Type_And_Privilege_Name")
    private String name;

    @Column(name = "Notes")
    private String notes;
}