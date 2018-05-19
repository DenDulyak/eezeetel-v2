package com.eezeetel.repository;

import com.eezeetel.entity.PinlessTransaction;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface PinlessTransactionRepository extends JpaRepository<PinlessTransaction, Integer> {

    List<PinlessTransaction> findByUserAndTransactionTimeBetweenAndErrorCode(User user, Date from, Date to, Integer errorCode);

    List<PinlessTransaction> findByCustomerAndTransactionTimeBetweenAndErrorCode(TMasterCustomerinfo customer, Date from, Date to, Integer errorCode);

    List<PinlessTransaction> findByErrorCodeAndTransactionTimeBetween(Integer errorCode, Date startDate, Date endDate);

    List<PinlessTransaction> findByErrorCodeAndCustomerGroupAndTransactionTimeBetween(Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);

    @Query(value = "SELECT t.destination_phone, sum(t.product_requested) FROM pinless_transaction as t " +
            "where t.customer_id = ?2 and t.error_code = ?1 and t.transaction_time between ?3 and ?4 " +
            "group by t.destination_phone ", nativeQuery = true)
    List<Object[]> getCustomerSummaryTransactionsBetweenDates(Integer errorCode, Integer customerId, Date startDate, Date endDate);
}
