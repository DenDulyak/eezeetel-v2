package com.eezeetel.entity;

import com.eezeetel.bean.report.WorldMobileTopupSummary;
import com.eezeetel.serializer.CustomerSerializer;
import com.eezeetel.serializer.DateTimeSerializer;
import com.eezeetel.serializer.UserSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@NamedNativeQueries({
        @NamedNativeQuery(
                name = "TDingTransactions.getSummaryTransactions",
                query = "SELECT count(*) as transactions, round(sum(Product_Sent), 2) as amount FROM t_ding_transactions where Transaction_Time between ?1 and ?2 and Error_Code = 1",
                resultSetMapping = "getSummaryTransactionsModelMapping")
})
@SqlResultSetMappings({
        @SqlResultSetMapping(name = "getSummaryTransactionsModelMapping", classes = {
                @ConstructorResult(targetClass = WorldMobileTopupSummary.class,
                        columns = {
                                @ColumnResult(name = "transactions", type = Integer.class),
                                @ColumnResult(name = "amount", type = BigDecimal.class)
                        })
        }),
})
@Getter
@Setter
@Entity
@Table(name = "t_ding_transactions")
public class TDingTransactions implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Long id;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "User_ID", nullable = false)
    private User user;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_ID", nullable = false)
    private TMasterCustomerinfo customer;

    @Column(name = "Transaction_ID", nullable = false)
    private long transactionId;

    @Column(name = "Ding_Transaction_ID", nullable = false)
    private long dingTransactionId;

    @Column(name = "Error_Code", nullable = false)
    private int errorCode;

    @Column(name = "Error_Text", nullable = false)
    private String errorText;

    @Column(name = "Requester_Phone")
    private String requesterPhone;

    @Column(name = "Destination_Phone", nullable = false)
    private String destinationPhone;

    @Column(name = "Originating_Currency")
    private String originatingCurrency;

    @Column(name = "Destination_Currency")
    private String destinationCurrency;

    @Column(name = "Destination_Country")
    private String destinationCountry;

    @Column(name = "Destination_Country_ID")
    private String destinationCountryId;

    @Column(name = "Destination_Operator")
    private String destinationOperator;

    @Column(name = "Destination_Operator_ID")
    private String destinationOperatorId;

    @Column(name = "Operator_Reference_Info")
    private String operatorReferenceInfo;

    @Column(name = "SMS_Sent", nullable = false)
    private String smsSent;

    @Column(name = "SMS_Text")
    private String smsText;

    @Column(name = "Authentication_Key")
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

    @Column(name = "Wholesale_Price")
    private Float wholesalePrice;

    @Column(name = "Retail_Price")
    private Float retailPrice;

    @Column(name = "EezeeTel_Balance", nullable = false)
    private float eezeeTelBalance;

    @JsonSerialize(using = DateTimeSerializer.class)
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

    @NotFound(action = NotFoundAction.IGNORE)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Transaction_ID", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private TTransactionBalance transactionBalance;

    @NotFound(action = NotFoundAction.IGNORE)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Transaction_ID", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private GroupTransactionBalance groupTransactionBalance;
}