package com.eezeetel.repository;

import com.eezeetel.bean.report.WorldMobileTopupSummary;
import com.eezeetel.entity.TDingTransactions;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Repository
public interface DingTransactionRepository extends JpaRepository<TDingTransactions, Long> {

    TDingTransactions findByTransactionId(Long transactionId);

    @Query("select dt from TDingTransactions dt where dt.customer = ?1 and dt.errorCode = ?2 and dt.requesterPhone = ?3 " +
            "group by dt.destinationPhone, dt.productRequested order by dt.transactionTime desc")
    List<TDingTransactions> findByRequesterPhone(TMasterCustomerinfo customer, Integer errorCode, String requesterPhone);

    List<TDingTransactions> findByCustomerAndErrorCodeAndDestinationPhoneOrderByTransactionTimeDesc(TMasterCustomerinfo customer, Integer errorCode, String destinationPhone);

    List<TDingTransactions> findByErrorCodeAndTransactionTimeBetween(int errorCode, Date startDate, Date endDate);

    List<TDingTransactions> findByErrorCodeAndCustomerGroupAndTransactionTimeBetween(int errorCode, TMasterCustomerGroups group, Date startDate, Date endDate);

    List<TDingTransactions> findByErrorCodeAndCustomerAndTransactionTimeBetween(int errorCode, TMasterCustomerinfo customer, Date startDate, Date endDate);

    List<TDingTransactions> findByTransactionTimeBetweenAndDestinationCountryIdAndDestinationOperatorId(Date startDate, Date endDate, String destinationCountryId, String destinationOperatorId);

    List<WorldMobileTopupSummary> getSummaryTransactions(Date startDate, Date endDate);

    @Query(value = "select round(sum(t.Cost_To_Customer), 2) from t_ding_transactions t where t.Customer_ID = ?1 and t.Error_Code = 1 and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select round(sum(t.Cost_To_Group), 2) from t_ding_transactions t, t_master_customerinfo c " +
            "where t.Customer_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.Error_Code = 1 and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select count(DISTINCT t.Transaction_ID) as transactions from t_ding_transactions t where t.Customer_ID = ?1 and t.Error_Code = 1 and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select count(DISTINCT t.Transaction_ID) as transactions from t_ding_transactions t, t_master_customerinfo c " +
            "where t.Customer_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.Error_Code = 1 and t.Transaction_Time between ?2 and ?3 ", nativeQuery = true)
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
}
