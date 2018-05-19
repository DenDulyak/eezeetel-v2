package com.eezeetel.repository;

import com.eezeetel.entity.TMasterCustomerCredit;
import com.eezeetel.entity.TMasterCustomerinfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 11.04.2016.
 */
public interface CustomerCreditRepository extends JpaRepository<TMasterCustomerCredit, Integer> {

    @Query("select c from TMasterCustomerCredit c where c.enteredTime > ?2 and c.customer in (?1) order by c.enteredTime desc ")
    Page<TMasterCustomerCredit> findByCusomersAndEnteredTime(List<TMasterCustomerinfo> customers, Date enteredTime, Pageable pageable);

    @Query("select c from TMasterCustomerCredit c where c.enteredTime > ?2 and c.customer in (?1) and c.creditOrDebit = ?3 order by c.enteredTime desc ")
    Page<TMasterCustomerCredit> findByCusomersAndEnteredTimeAndCreditOrDebit(List<TMasterCustomerinfo> customers, Date enteredTime, byte creditOrDebit, Pageable pageable);

    @Query("select c from TMasterCustomerCredit c where c.enteredTime > ?2 and c.customer in (?1) and c.creditIdStatus = ?3 order by c.enteredTime desc ")
    Page<TMasterCustomerCredit> findByCusomersAndEnteredTimeAndCreditIdStatus(List<TMasterCustomerinfo> customers, Date enteredTime, byte creditIdStatus, Pageable pageable);

    @Query(value = "select round(sum(t.Payment_Amount), 2) from t_master_customer_credit t where t.Customer_ID = ?1 and t.Entered_Time between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcCustomerCreditAmountBetweenDates(Integer customerId, Date startDate, Date endDate);
}
