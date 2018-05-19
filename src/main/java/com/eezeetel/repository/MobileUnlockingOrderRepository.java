package com.eezeetel.repository;

import com.eezeetel.entity.MobileUnlockingOrder;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import com.eezeetel.enums.OrderStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 26.01.2016.
 */
@Repository
public interface MobileUnlockingOrderRepository extends JpaRepository<MobileUnlockingOrder, Integer> {

    List<MobileUnlockingOrder> findByUser(User user);

    List<MobileUnlockingOrder> findByAssigned(User assigned);

    List<MobileUnlockingOrder> findByCustomerAndCreatedDateBetween(TMasterCustomerinfo customer, Date from, Date to);

    List<MobileUnlockingOrder> findByUserAndCreatedDateBetween(User user, Date from, Date to);

    List<MobileUnlockingOrder> findByCreatedDateBetween(Date from, Date to);

    List<MobileUnlockingOrder> findByCustomerGroupAndCreatedDateBetween(TMasterCustomerGroups group, Date from, Date to);

    Page<MobileUnlockingOrder> findByStatus(OrderStatus status, Pageable pageable);

    @Query(value = "select round(sum(t.PRICE + t.EEZEETEL_COMMISSION + t.GROUP_COMMISSION + t.AGENT_COMMISSION), 2) as totalPrice from mobile_unlocking_order t where t.CUSTOMER_ID = ?1 and t.CREATED_DATE between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select count(DISTINCT t.TRANSACTION_ID) from mobile_unlocking_order t where t.CUSTOMER_ID = ?1 and t.CREATED_DATE between ?2 and ?3 ", nativeQuery = true)
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select count(t.TRANSACTION_ID) from mobile_unlocking_order t where t.CUSTOMER_ID = ?1 and t.CREATED_DATE between ?2 and ?3 ", nativeQuery = true)
    Integer amountCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);

    @Query(value = "select round(sum(t.PRICE + t.EEZEETEL_COMMISSION), 2) as totalPrice from mobile_unlocking_order t, t_master_customerinfo c " +
            "where t.CUSTOMER_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.CREATED_DATE between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select count(DISTINCT t.TRANSACTION_ID) from mobile_unlocking_order t, t_master_customerinfo c " +
            "where t.CUSTOMER_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.CREATED_DATE between ?2 and ?3 ", nativeQuery = true)
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select count(t.TRANSACTION_ID) from mobile_unlocking_order t, t_master_customerinfo c " +
            "where t.CUSTOMER_ID = c.Customer_ID and c.Customer_Group_ID = ?1 and t.CREATED_DATE between ?2 and ?3 ", nativeQuery = true)
    Integer amountGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
}
