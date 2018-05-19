package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterExpenses;
import com.eezeetel.repository.ExpenseRepository;
import com.eezeetel.service.ExpenseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ExpenseServiceImpl implements ExpenseService {

    @Autowired
    private ExpenseRepository repository;

    @Override
    public TMasterExpenses save(TMasterExpenses expense) {
        return repository.save(expense);
    }
}
