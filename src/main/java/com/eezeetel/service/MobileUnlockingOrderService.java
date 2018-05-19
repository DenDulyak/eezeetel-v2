package com.eezeetel.service;

import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.bean.mobileUnlocking.MobileUnlockingOrderBean;
import com.eezeetel.entity.MobileUnlockingOrder;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public interface MobileUnlockingOrderService {

    MobileUnlockingOrder findOne(Integer id);
    MobileUnlockingOrder save(MobileUnlockingOrder order);
    Page<MobileUnlockingOrder> findAll(Pageable pageable);
    Page<MobileUnlockingOrder> findByStatus(Integer status, Pageable pageable);
    List<MobileUnlockingOrder> findByUser(String user);
    List<MobileUnlockingOrder> findByAssignedUser(String login);
    List<MobileUnlockingOrder> findByCustomerAndCreatedDateBetween(TMasterCustomerinfo customer, Date from, Date to);
    Map<Long, List<MobileUnlockingOrder>> findByUserAndCreatedDateBetweenGroupByTransactionId(User user, Date from, Date to);
    List<MobileUnlockingOrder> findByGroupAndDate(TMasterCustomerGroups group, Date from, Date to);
    BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate);
    Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);
    Integer amountCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate);
    BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer amountGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate);
    ConfirmBean createNewOrders(ConfirmBean bean, MobileUnlockingOrderBean orderBean, String login);
    MobileUnlockingOrder editOrder(MobileUnlockingOrder orderToEdit);
    MobileUnlockingOrder assign(Integer orderId, String login);
    MobileUnlockingOrder reject(Integer orderId);
}
