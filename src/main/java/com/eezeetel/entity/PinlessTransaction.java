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

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "pinless_transaction")
public class PinlessTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", columnDefinition = "INT(10)", nullable = false)
    private TMasterCustomerinfo customer;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", columnDefinition = "VARCHAR(50)", nullable = false)
    private User user;

    @Column(name = "transaction_id", nullable = false)
    private Long transactionId;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "transaction_time", nullable = false)
    private Date transactionTime;

    @Column(name = "error_code")
    private Integer errorCode;

    @Column(name = "error_text")
    private String errorText;

    @JsonIgnore
    @Column(name = "auth_key", nullable = false)
    private String authKey;

    @Column(name = "order_id")
    private Long orderId;

    @Column(name = "balance")
    private BigDecimal balance;

    @Column(name = "price")
    private BigDecimal price;

    @Column(name = "retail_price")
    private BigDecimal retailPrice;

    @Column(name = "eezeetel_commission")
    private BigDecimal eezeetelCommission;

    @Column(name = "group_commission")
    private BigDecimal groupCommission;

    @Column(name = "agent_commission")
    private BigDecimal agentCommission;

    @Column(name = "customer_commission")
    private BigDecimal customerCommission;

    @Column(name = "destination_phone", nullable = false)
    private String destinationPhone;

    @Column(name = "requester_phone", nullable = false)
    private String requesterPhone;

    @Column(name = "network_id")
    private String networkId;

    @Column(name = "network")
    private String network;

    @Column(name = "currency")
    private String currency;

    @Column(name = "local_currency")
    private String localCurrency;

    @JsonSerialize(using = PhoneTopupCountrySerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "country_id")
    private PhoneTopupCountry country;

    @Column(name = "product_requested", nullable = false)
    private String productRequested;

    @Column(name = "product_sent")
    private String productSent;

    @Column(name = "sms_sent")
    private String smsSent;

    @Column(name = "sender_sms")
    private String senderSms;

    @Column(name = "message")
    private String message;

    @Column(name = "post_processing_stage")
    private Boolean postProcessingStage;

    @JsonIgnore
    @Column(name = "response", columnDefinition = "TEXT")
    private String response;

    @NotFound(action = NotFoundAction.IGNORE)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transaction_id", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private TTransactionBalance transactionBalance;

    @NotFound(action = NotFoundAction.IGNORE)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transaction_id", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private GroupTransactionBalance groupTransactionBalance;

    @Transient
    private Topup topup;

    public PinlessTransaction(Integer id) {
        this.id = id;
    }
}
