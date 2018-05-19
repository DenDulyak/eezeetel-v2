package com.eezeetel.bean.report;

import com.eezeetel.entity.TTransactions;
import com.eezeetel.serializer.DateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class TransactionReportBean {

    private Long id;
    private Long transactionId;
    @JsonSerialize(using = DateSerializer.class)
    private Date transactionTime;
    private Integer quantity;
    private BigDecimal balanceBefore;
    private BigDecimal balanceAfter;
    private BigDecimal costPrice;
    private List<String> cardIds;

    public TransactionReportBean(TTransactions transaction) {
        this.id = transaction.getId();
        this.transactionId = transaction.getTransactionId();
        this.transactionTime = transaction.getTransactionTime();
        this.quantity = transaction.getQuantity();
        if(transaction.getTransactionBalance() != null) {
            this.balanceBefore = new BigDecimal(transaction.getTransactionBalance().getBalanceBeforeTransaction() + "");
            this.balanceAfter = new BigDecimal(transaction.getTransactionBalance().getBalanceAfterTransaction() + "");
            this.costPrice = this.balanceBefore.subtract(this.balanceAfter);
        }
    }
}
