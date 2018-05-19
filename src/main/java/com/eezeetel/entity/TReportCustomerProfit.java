package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_report_customer_profit")
public class TReportCustomerProfit implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Product_ID", nullable = false)
    private TMasterProductinfo product;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_ID", nullable = false)
    private TMasterCustomerinfo customer;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_Group_ID", nullable = false)
    private TMasterCustomerGroups group;

    @Column(name = "Begin_Date", nullable = false)
    private Date beginDate;

    @Column(name = "End_Date", nullable = false)
    private Date endDate;

    @Column(name = "Agent_ID", nullable = false)
    private String agentId;

    @Column(name = "Quantity", nullable = false)
    private int quantity;

    @Column(name = "Retail_Cost", nullable = false)
    private float retailCost;

    @Column(name = "Cost_To_Customer", nullable = false)
    private float costToCustomer;

    @Column(name = "Cost_To_Agent", nullable = false)
    private float costToAgent;

    @Column(name = "Cost_To_Group", nullable = false)
    private float costToGroup;

    @Column(name = "Batch_Cost", nullable = false)
    private float batchCost;

    @Column(name = "Batch_Original_Cost", nullable = false)
    private float batchOriginalCost;

    @Column(name = "Customer_VAT", nullable = false)
    private float customerVat;

    @Column(name = "Agent_VAT", nullable = false)
    private float agentVat;

    @Column(name = "Group_VAT", nullable = false)
    private float groupVat;

    @Column(name = "EezeeTel_VAT", nullable = false)
    private float eezeeTelVat;
}