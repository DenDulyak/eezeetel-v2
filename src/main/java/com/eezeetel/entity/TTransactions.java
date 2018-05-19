package com.eezeetel.entity;

import com.eezeetel.bean.report.CountReportBean;
import com.eezeetel.serializer.*;
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
                name = "TTransactions.countCustomerTransactionsBetweenDates",
                query = "select count(DISTINCT t.Transaction_ID) as transactions, " +
                        "round(sum(t.Unit_Purchase_Price), 2) as price, " +
                        "sum(t.Quantity) as quantity " +
                        "from t_transactions t where t.Customer_ID = ?1 and t.committed in (1,3) and t.Transaction_Time between ?2 and ?3 ",
                resultSetMapping = "transactionsBetweenDatesModelMapping")
})
@SqlResultSetMappings({
        @SqlResultSetMapping(name = "transactionsBetweenDatesModelMapping", classes = {
                @ConstructorResult(targetClass = CountReportBean.class,
                        columns = {
                                @ColumnResult(name = "transactions", type = Integer.class),
                                @ColumnResult(name = "quantity", type = Integer.class),
                                @ColumnResult(name = "price", type = BigDecimal.class)
                        })
        }),
})
@Getter
@Setter
@Entity
@Table(name = "t_transactions")
public class TTransactions implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Long id;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "User_ID", nullable = false)
    private User user;

    @JsonSerialize(using = ProductSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Product_ID", nullable = false)
    private TMasterProductinfo product;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_ID", nullable = false)
    private TMasterCustomerinfo customer;

    @JsonSerialize(using = BatchSerializer.class)
    @NotFound(action = NotFoundAction.IGNORE)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Batch_Sequence_ID", nullable = false)
    private TBatchInformation batch;

    @Column(name = "Transaction_ID", nullable = false)
    private long transactionId;

    @Column(name = "Quantity", nullable = false)
    private int quantity;

    @Column(name = "Unit_Purchase_Price", nullable = false)
    private float unitPurchasePrice;

    @Column(name = "Secondary_Transaction_Price", nullable = false)
    private float secondaryTransactionPrice;

    @Column(name = "Committed", nullable = false)
    private byte committed;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "Transaction_Time", nullable = false)
    private Date transactionTime;

    @Column(name = "Unit_Group_Price", nullable = false)
    private float unitGroupPrice;

    @Column(name = "Batch_Unit_Price", nullable = false)
    private float batchUnitPrice;

    @Column(name = "Post_Processing_Stage", nullable = false)
    private Boolean postProcessingStage = false;

    @NotFound(action = NotFoundAction.IGNORE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Transaction_ID", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private TTransactionBalance transactionBalance;

    @NotFound(action = NotFoundAction.IGNORE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Transaction_ID", insertable = false, updatable = false, foreignKey = @ForeignKey(value = ConstraintMode.NO_CONSTRAINT))
    private GroupTransactionBalance groupTransactionBalance;
}