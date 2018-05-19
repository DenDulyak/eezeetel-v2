package com.eezeetel.repository;

import com.eezeetel.bean.report.WorldMobileTopupSummary;
import com.eezeetel.entity.MobitopupTransaction;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Repository
public interface MobitopupTransactionRepository extends JpaRepository<MobitopupTransaction, Integer> {

    MobitopupTransaction findByTransactionId(Long transactionId);

    @Query("select mt from MobitopupTransaction mt where mt.customer = ?1 and mt.errorCode = ?2 and mt.requesterPhone = ?3 " +
            "group by mt.destinationPhone, mt.productRequested order by mt.transactionTime desc")
    List<MobitopupTransaction> findByRequesterPhone(TMasterCustomerinfo customer, Integer errorCode, String requesterPhone);

    List<MobitopupTransaction> findByUserAndTransactionTimeBetweenAndErrorCode(User user, Date from, Date to, Integer errorCode);

    List<MobitopupTransaction> findByCustomerAndTransactionTimeBetweenAndErrorCode(TMasterCustomerinfo customer, Date from, Date to, Integer errorCode);

    List<MobitopupTransaction> findByErrorCodeAndTransactionTimeBetween(Integer errorCode, Date startDate, Date endDate);

    List<MobitopupTransaction> findByErrorCodeAndCustomerAndTransactionTimeBetween(Integer errorCode, TMasterCustomerinfo customer, Date startDate, Date endDate);

    List<MobitopupTransaction> findByErrorCodeAndCustomerGroupAndTransactionTimeBetween(Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);

    List<WorldMobileTopupSummary> getSummaryTransactions(Date startDate, Date endDate);

    Page<MobitopupTransaction> findByErrorCode(Integer errorCode, Pageable pageable);

    @Query(value = "select round(sum(t.PRICE + t.EEZEETEL_COMMISSION + t.GROUP_COMMISSION + t.AGENT_COMMISSION), 2) as totalPrice from mobitopup_transaction t " +
            "where t.CUSTOMER_ID = ?1 and t.ERROR_CODE = 0 and t.TRANSACTION_TIME between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select round(sum(t.PRICE + t.EEZEETEL_COMMISSION), 2) as totalPrice from mobitopup_transaction t, t_master_customerinfo c " +
            "where t.CUSTOMER_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.ERROR_CODE = 0 and t.TRANSACTION_TIME between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select count(t.TRANSACTION_ID) from mobitopup_transaction t where t.CUSTOMER_ID = ?1 and t.ERROR_CODE = 0 and t.TRANSACTION_TIME between ?2 and ?3 ", nativeQuery = true)
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select count(t.TRANSACTION_ID) from mobitopup_transaction t, t_master_customerinfo c " +
            "where t.CUSTOMER_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.ERROR_CODE = 0 and t.TRANSACTION_TIME between ?2 and ?3 ", nativeQuery = true)
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
}
