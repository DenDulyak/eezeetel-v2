package com.eezeetel.repository;

import com.eezeetel.entity.TMasterCustomerGroupCredit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Denis Dulyak on 18.04.2016.
 */
@Repository
public interface GroupCreditRepository extends JpaRepository<TMasterCustomerGroupCredit, Integer> {

    @Query(value = "select round(sum(t.Payment_Amount), 2) from t_master_customer_group_credit t where t.Customer_Group_ID = ?1 and t.Entered_Time between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcGroupCreditAmountBetweenDates(Integer groupId, Date startDate, Date endDate);
}
