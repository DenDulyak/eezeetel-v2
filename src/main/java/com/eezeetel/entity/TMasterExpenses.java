package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_master_expenses")
public class TMasterExpenses implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Expense_ID")
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Expense_Type", nullable = false)
    private TExpenseTypes expenseType;

    @Column(name = "Expense_Purpose", nullable = false)
    private String expensePurpose;

    @Column(name = "Payment_Date", nullable = false)
    private Date paymentDate;

    @Column(name = "Receipt_Path")
    private String receiptPath;

    @Column(name = "Payment_Amount", nullable = false)
    private float paymentAmount;
}