package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_transferto_transactions")
public class TTransfertoTransactions implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "User_ID", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_ID", nullable = false)
    private TMasterCustomerinfo customer;

    @Column(name = "Transaction_ID", nullable = false)
    private long transactionId;

    @Column(name = "TransferTo_Transaction_ID", nullable = false)
    private long transferToTransactionId;

    @Column(name = "Error_Code", nullable = false)
    private int errorCode;

    @Column(name = "Error_Text", nullable = false)
    private String errorText;

    @Column(name = "Requester_Phone", nullable = false)
    private String requesterPhone;

    @Column(name = "Destination_Phone", nullable = false)
    private String destinationPhone;

    @Column(name = "Originating_Currency", nullable = false)
    private String originatingCurrency;

    @Column(name = "Destination_Currency", nullable = false)
    private String destinationCurrency;

    @Column(name = "Destination_Country", nullable = false)
    private String destinationCountry;

    @Column(name = "Destination_Country_ID", nullable = false)
    private String destinationCountryId;

    @Column(name = "Destination_Operator", nullable = false)
    private String destinationOperator;

    @Column(name = "Destination_Operator_ID", nullable = false)
    private String destinationOperatorId;

    @Column(name = "Operator_Reference_Info", nullable = false)
    private String operatorReferenceInfo;

    @Column(name = "SMS_Sent", nullable = false)
    private String smsSent;

    @Column(name = "SMS_Text")
    private String smsText;

    @Column(name = "Authentication_Key", nullable = false)
    private String authenticationKey;

    @Column(name = "CID1")
    private String cid1;

    @Column(name = "CID2")
    private String cid2;

    @Column(name = "CID3")
    private String cid3;

    @Column(name = "Product_Requested", nullable = false)
    private float productRequested;

    @Column(name = "Product_Sent", nullable = false)
    private float productSent;

    @Column(name = "Wholesale_Price", nullable = false)
    private float wholesalePrice;

    @Column(name = "Retail_Price", nullable = false)
    private float retailPrice;

    @Column(name = "EezeeTel_Balance", nullable = false)
    private float eezeeTelBalance;

    @Column(name = "Transaction_Time", nullable = false)
    private Date transactionTime;

    @Column(name = "Transaction_Status", nullable = false)
    private byte transactionStatus;

    @Column(name = "Cost_To_Customer", nullable = false)
    private float costToCustomer;

    @Column(name = "Cost_To_Agent", nullable = false)
    private float costToAgent;

    @Column(name = "Cost_To_EezeeTel", nullable = false)
    private float costToEezeeTel;

    @Column(name = "Cost_To_Group", nullable = false)
    private float costToGroup;

    @Column(name = "Post_Processing_Stage", nullable = false)
    private byte postProcessingStage;
}