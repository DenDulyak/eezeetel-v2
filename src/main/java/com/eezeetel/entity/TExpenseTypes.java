package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_expense_types")
public class TExpenseTypes implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Expense_Type_ID")
    private Byte id;

    @Column(name = "Expense_Type", nullable = false)
    private String expenseType;

    @Column(name = "IsActive", nullable = false)
    private Boolean active;

    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "expenseType", fetch = FetchType.LAZY)
    private List<TMasterExpenses> expenses;
}