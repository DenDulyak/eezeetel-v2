package com.eezeetel.service;

import com.eezeetel.entity.TMasterExpenses;
import org.springframework.stereotype.Service;

@Service
public interface ExpenseService {

    TMasterExpenses save(TMasterExpenses expense);
}
