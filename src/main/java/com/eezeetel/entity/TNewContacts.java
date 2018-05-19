package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_new_contacts")
public class TNewContacts implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Addressed_By", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Group_ID", nullable = false)
    private TMasterCustomerGroups group;

    @Column(name = "Contact_Name")
    private String contactName;

    @Column(name = "Contact_Business_Name")
    private String contactBusinessName;

    @Column(name = "Referred_By")
    private String referredBy;

    @Column(name = "Contact_Number")
    private String contactNumber;

    @Column(name = "Contact_Email")
    private String contactEmail;

    @Column(name = "Additional_Notes")
    private String additionalNotes;

    @Column(name = "Contact_Time", nullable = false)
    private Date contactTime;

    @Column(name = "Addressed", nullable = false)
    private byte addressed;

    @Column(name = "Time_Addressed")
    private Date timeAddressed;

    @Column(name = "Remote_Address", nullable = false)
    private String remoteAddress;

    @Column(name = "Comments")
    private String comments;
}