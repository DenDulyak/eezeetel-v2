package com.eezeetel.entity;

import com.eezeetel.serializer.DateTimeSerializer;
import com.eezeetel.serializer.GroupSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_messages")
public class TMessages implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Integer id;

    @Column(name = "Date_Entered", nullable = false)
    private Date dateEntered;

    @Column(name = "Message", nullable = false)
    private String message;

    @JsonSerialize(using = GroupSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Target_Group")
    private TMasterCustomerGroups group;

    @Column(name = "Target_Customer_List")
    private String targetCustomerList;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "Expiry_Date")
    private Date expiryDate;

    @Column(name = "Is_Active", nullable = false)
    private Boolean active;
}