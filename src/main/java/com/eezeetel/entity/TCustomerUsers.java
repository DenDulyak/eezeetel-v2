package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "t_customer_users")
public class TCustomerUsers implements Serializable {

    @EmbeddedId
    private TCustomerUsersId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_ID", insertable = false, updatable = false)
    private TMasterCustomerinfo customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "User_Login_ID", insertable = false, updatable = false)
    private User user;

    @Column(name = "Description")
    private String description;
}