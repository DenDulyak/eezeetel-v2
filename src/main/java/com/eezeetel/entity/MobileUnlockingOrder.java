package com.eezeetel.entity;

import com.eezeetel.enums.OrderStatus;
import com.eezeetel.serializer.CustomerSerializer;
import com.eezeetel.serializer.DateTimeSerializer;
import com.eezeetel.serializer.MobileUnlockingSerializer;
import com.eezeetel.serializer.UserSerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Denis Dulyak on 26.01.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "mobile_unlocking_order")
public class MobileUnlockingOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @JsonSerialize(using = MobileUnlockingSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MOBILE_UNLOCKING_ID", nullable = false)
    private MobileUnlocking mobileUnlocking;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CUSTOMER_ID", columnDefinition = "INT(10)", nullable = false)
    private TMasterCustomerinfo customer;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USER_ID", columnDefinition = "VARCHAR(50)", nullable = false)
    private User user;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ASSIGNED_ID", columnDefinition = "VARCHAR(50)")
    private User assigned;

    @Column(name = "TRANSACTION_ID", nullable = false)
    private Long transactionId;

    @Column(name = "IMEI", nullable = false)
    private String imei;

    @Column(name = "CODE")
    private String code;

    @Column(name = "PRICE", nullable = false)
    private BigDecimal price;

    @Column(name = "EEZEETEL_COMMISSION", nullable = false)
    private BigDecimal eezeetelCommission;

    @Column(name = "GROUP_COMMISSION", nullable = false)
    private BigDecimal groupCommission;

    @Column(name = "AGENT_COMMISSION", nullable = false)
    private BigDecimal agentCommission;

    @Column(name = "SELLING_PRICE", nullable = false)
    private BigDecimal sellingPrice;

    @Column(name = "CUSTOMER_EMAIL")
    private String customerEmail;

    @Column(name = "MOBILE_NUMBER")
    private String mobileNumber;

    @Column(name = "STATUS", nullable = false)
    @Enumerated(EnumType.ORDINAL)
    private OrderStatus status;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "CREATED_DATE", nullable = false)
    private Date createdDate;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "UPDATED_DATE")
    private Date updatedDate;

    @Column(name = "NOTES")
    private String notes;

    @Column(name = "POST_PROCESSING_STAGE")
    private Boolean postProcessingStage;

    @JsonIgnore
    @NotFound(action = NotFoundAction.IGNORE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TRANSACTION_ID", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private TTransactionBalance transactionBalance;
}
