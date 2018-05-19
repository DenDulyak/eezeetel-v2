package com.eezeetel.repository;

import com.eezeetel.entity.GroupTransactionBalance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 15.09.2016.
 */
@Repository
public interface GroupTransactionBalanceRepository  extends JpaRepository<GroupTransactionBalance, Integer> {
}
