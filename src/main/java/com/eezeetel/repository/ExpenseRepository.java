package com.eezeetel.repository;

import com.eezeetel.entity.TMasterExpenses;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Created by Denis Dulyak on 13.01.2016.
 */
public interface ExpenseRepository extends JpaRepository<TMasterExpenses, Integer> {
}
