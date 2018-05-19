package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Getter
@Setter
@Embeddable
public class TCustomerUsersId implements Serializable {

    @Column(name = "Customer_ID")
    private int customerId;

    @Column(name = "User_Login_ID")
    private String userLoginId;
}