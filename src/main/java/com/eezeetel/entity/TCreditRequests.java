package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_credit_requests")
public class TCreditRequests implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Request_ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_ID", nullable = false)
    private TMasterCustomerinfo customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Requested_By", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Bank_ID", nullable = false)
    private TMasterBanks bank;

    // 1 - Credit, 2 - Pay Debt
    @Column(name = "Request_Type", nullable = false)
    private byte requestType;

    @Column(name = "Request_Date", nullable = false)
    private Date requestDate;

    @Column(name = "Request_Amount", nullable = false)
    private float requestAmount;

    @Column(name = "Amount_Already_Paid", nullable = false)
    private byte amountAlreadyPaid;

    @Column(name = "Payment_Type", nullable = false)
    private byte paymentType;

    @Column(name = "Payment_Date")
    private Date paymentDate;

    @Column(name = "Request_Details", nullable = false)
    private String requestDetails;

    @Column(name = "Approved_Amount")
    private Float approvedAmount;

    @Column(name = "Approved_By")
    private String approvedBy;

    @Column(name = "Approval_Date")
    private Date approvalDate;

    @Column(name = "Approver_Comments")
    private String approverComments;

    // 1 - Submitted, 2 - Approved, 3 - Partial Approved, 4 - Pending Approval, 5 - Rejected, 6 - Adjusted To Previous Debt
    @Column(name = "Request_Status", nullable = false)
    private byte requestStatus;

    @Column(name = "Credit_ID_List")
    private String creditIdList;

    // 2 - Approved, 3 - Partial Approved, 5 - Rejected
    @Column(name = "Agent_Approved", nullable = false)
    private Byte agentApproved;

    @Column(name = "Agent_Approved_Amount")
    private Float agentApprovedAmount;

    @Column(name = "Agent_Comments")
    private String agentComments;

    @Column(name = "Agent_Approved_Time")
    private Date agentApprovedTime;

    @Column(name = "Agent_Name")
    private String agentName;
}