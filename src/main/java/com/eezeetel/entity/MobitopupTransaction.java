package com.eezeetel.entity;

import com.eezeetel.mobitopup.response.Topup;
import com.eezeetel.serializer.CustomerSerializer;
import com.eezeetel.serializer.DateTimeSerializer;
import com.eezeetel.serializer.PhoneTopupCountrySerializer;
import com.eezeetel.serializer.UserSerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Denis Dulyak on 28.03.2016.
 */
@NamedNativeQueries({
        @NamedNativeQuery(
                name = "MobitopupTransaction.getSummaryTransactions",
                query = "SELECT COUNT(*) AS transactions, round(SUM(PRICE), 2) as amount FROM mobitopup_transaction WHERE TRANSACTION_TIME BETWEEN ?1 AND ?2 AND ERROR_CODE = 0",
                resultSetMapping = "getSummaryTransactionsModelMapping")
})
@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "mobitopup_transaction")
public class MobitopupTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CUSTOMER_ID", columnDefinition = "INT(10)", nullable = false)
    private TMasterCustomerinfo customer;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "USER_ID", columnDefinition = "VARCHAR(50)", nullable = false)
    private User user;

    @Column(name = "TRANSACTION_ID", nullable = false)
    private Long transactionId;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "TRANSACTION_TIME", nullable = false)
    private Date transactionTime;

    @Column(name = "ERROR_CODE")
    private Integer errorCode;

    @Column(name = "ERROR_TEXT")
    private String errorText;

    @JsonIgnore
    @Column(name = "AUTH_KEY", nullable = false)
    private String authKey;

    @Column(name = "ORDER_ID")
    private Long orderId;
    
    @Column(name = "BALANCE")
    private BigDecimal balance;

    @Column(name = "PRICE")
    private BigDecimal price;

    @Column(name = "RETAIL_PRICE")
    private BigDecimal retailPrice;

    @Column(name = "EEZEETEL_COMMISSION")
    private BigDecimal eezeetelCommission;

    @Column(name = "GROUP_COMMISSION")
    private BigDecimal groupCommission;

    @Column(name = "AGENT_COMMISSION")
    private BigDecimal agentCommission;

    @Column(name = "CUSTOMER_COMMISSION")
    private BigDecimal customerCommission;

    @Column(name = "DESTINATION_PHONE", nullable = false)
    private String destinationPhone;

    @Column(name = "REQUESTER_PHONE", nullable = false)
    private String requesterPhone;

    @Column(name = "NETWORK_ID")
    private String networkId;

    @Column(name = "NETWORK")
    private String network;

    @Column(name = "CURRENCY")
    private String currency;

    @Column(name = "LOCAL_CURRENCY")
    private String localCurrency;

    @JsonSerialize(using = PhoneTopupCountrySerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COUNTRY_ID")
    private PhoneTopupCountry country;

    @Column(name = "PRODUCT_REQUESTED", nullable = false)
    private String productRequested;

    @Column(name = "PRODUCT_SENT")
    private String productSent;

    @Column(name = "SMS_SENT")
    private String smsSent;

    @Column(name = "SENDER_SMS")
    private String senderSms;

    @Column(name = "MESSAGE")
    private String message;

    @Column(name = "POST_PROCESSING_STAGE")
    private Boolean postProcessingStage;

    @JsonIgnore
    @Column(name = "RESPONSE", columnDefinition = "TEXT")
    private String response;

    @NotFound(action = NotFoundAction.IGNORE)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TRANSACTION_ID", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private TTransactionBalance transactionBalance;

    @NotFound(action = NotFoundAction.IGNORE)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TRANSACTION_ID", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private GroupTransactionBalance groupTransactionBalance;

    @Transient
    private Topup topup;

    public MobitopupTransaction(Integer id) {
        this.id = id;
    }
}
