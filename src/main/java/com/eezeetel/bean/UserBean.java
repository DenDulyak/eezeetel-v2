package com.eezeetel.bean;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 25.09.2015.
 */
@Getter
@Setter
public class UserBean {

    private String login;
    private String firstName;
    private String lastName;
    private String middleName;
    private String company;
    private String addressLine1;
    private String addressLine2;
    private String addressLine3;
    private String city;
    private String state;
    private String postalCode;
    private String country;
    private String primaryPhone;
    private String secondaryPhone;
    private String mobilePhone;
    private String email;
    private Integer type;
    private String password1;
    private String password2;
    private Integer group;
}
