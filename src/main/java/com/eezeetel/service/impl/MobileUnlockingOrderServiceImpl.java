package com.eezeetel.service.impl;

import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.bean.mobileUnlocking.MobileUnlockingOrderBean;
import com.eezeetel.entity.*;
import com.eezeetel.enums.OrderStatus;
import com.eezeetel.repository.MobileUnlockingOrderRepository;
import com.eezeetel.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 26.01.2016.
 */
@Service
public class MobileUnlockingOrderServiceImpl implements MobileUnlockingOrderService {

    @Autowired
    private MobileUnlockingOrderRepository repository;

    @Autowired
    private MobileUnlockingService mobileUnlockingService;

    @Autowired
    private MobileUnlockingCommissionService mobileUnlockingCommissionService;

    @Autowired
    private MobileUnlockingCustomerCommissionService mobileUnlockingCustomerCommissionService;

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private TransactionBalanceService transactionBalanceService;

    @Autowired
    private GroupTransactionBalanceService groupTransactionBalanceService;

    @Override
    public MobileUnlockingOrder findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public MobileUnlockingOrder save(MobileUnlockingOrder order) {
        return repository.save(order);
    }

    @Override
    @Transactional
    public Page<MobileUnlockingOrder> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public Page<MobileUnlockingOrder> findByStatus(Integer status, Pageable pageable) {
        if (status >= 0) {
            return repository.findByStatus(OrderStatus.values()[status], pageable);
        }

        return findAll(pageable);
    }

    @Override
    public List<MobileUnlockingOrder> findByUser(String user) {
        return repository.findByUser(userService.findByLogin(user));
    }

    @Override
    public List<MobileUnlockingOrder> findByAssignedUser(String login) {
        return repository.findByAssigned(userService.findByLogin(login));
    }

    @Override
    @Transactional
    public List<MobileUnlockingOrder> findByCustomerAndCreatedDateBetween(TMasterCustomerinfo customer, Date from, Date to) {
        List<MobileUnlockingOrder> orders = repository.findByCustomerAndCreatedDateBetween(customer, from, to);

        orders.forEach(o -> {
            o.getMobileUnlocking().getId();
            o.getTransactionBalance().getBalanceBeforeTransaction();
        });

        return orders;
    }

    @Override
    @Transactional
    public Map<Long, List<MobileUnlockingOrder>> findByUserAndCreatedDateBetweenGroupByTransactionId(User user, Date from, Date to) {
        List<MobileUnlockingOrder> orders = repository.findByUserAndCreatedDateBetween(user, from, to);

        orders.forEach(o -> {
            o.getMobileUnlocking().getId();
            o.getTransactionBalance().getBalanceBeforeTransaction();
        });

        return orders.stream().collect(Collectors.groupingBy(MobileUnlockingOrder::getTransactionId));
    }

    @Override
    public List<MobileUnlockingOrder> findByGroupAndDate(TMasterCustomerGroups group, Date from, Date to) {
        if (group == null || group.getId() == 0) {
            return repository.findByCreatedDateBetween(from, to);
        }

        return repository.findByCustomerGroupAndCreatedDateBetween(group, from, to);
    }

    @Override
    public BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate) {
        BigDecimal price = repository.calcCustomerPriceBetweenDates(customerId, startDate, endDate);
        return price == null ? new BigDecimal("0") : price;
    }

    @Override
    public Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate) {
        return repository.countCustomerTransactionsBetweenDates(customerId, startDate, endDate);
    }

    @Override
    public Integer amountCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate) {
        return repository.amountCustomerTransactionsBetweenDates(customerId, startDate, endDate);
    }

    @Override
    public BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate) {
        BigDecimal price = repository.calcGroupPriceBetweenDates(groupId, startDate, endDate);
        return price == null ? new BigDecimal("0") : price;
    }

    @Override
    public Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate) {
        return repository.countGroupTransactionsBetweenDates(groupId, startDate, endDate);
    }

    @Override
    public Integer amountGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate) {
        return repository.amountGroupTransactionsBetweenDates(groupId, startDate, endDate);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ConfirmBean createNewOrders(ConfirmBean bean, MobileUnlockingOrderBean orderBean, String login) {
        List<MobileUnlockingOrder> orders = new ArrayList<>();
        MobileUnlocking mobileUnlocking = mobileUnlockingService.findOne(orderBean.getMobileUnlockingId());
        TCustomerUsers customerUser = customerUserService.findByLogin(login);
        TMasterCustomerinfo customer = customerUser.getCustomer();
        User user = customerUser.getUser();
        TMasterCustomerGroups group = customer.getGroup();
        MobileUnlockingCommission commission = mobileUnlockingCommissionService.findByGroupAndMobileUnlocking(group, mobileUnlocking);
        MobileUnlockingCustomerCommission customerCommission = mobileUnlockingCustomerCommissionService.findByCustomerAndMobileUnlockingCommission(customer, commission);
        Long transactionId = transactionService.getNextTransactionId();

        BigDecimal totalTransactionPrice = new BigDecimal("0");
        BigDecimal totalCostToGroup = new BigDecimal("0");

        BigDecimal costToGroup = mobileUnlocking.getPurchasePrice().add(commission.getCommission());
        BigDecimal sellingPrice = costToGroup.add(customerCommission.getGroupCommission()).add(customerCommission.getAgentCommission());

        for (String imei : orderBean.getImeis()) {
            if (imei == null) continue;
            MobileUnlockingOrder order = new MobileUnlockingOrder();
            order.setMobileUnlocking(mobileUnlocking);
            order.setCustomer(customer);
            order.setUser(user);
            order.setTransactionId(transactionId);
            order.setImei(imei);

            totalCostToGroup = totalCostToGroup.add(costToGroup);
            totalTransactionPrice = totalTransactionPrice.add(sellingPrice);

            order.setPrice(mobileUnlocking.getPurchasePrice());
            order.setEezeetelCommission(commission.getCommission());
            order.setGroupCommission(customerCommission.getGroupCommission());
            order.setAgentCommission(customerCommission.getAgentCommission());
            order.setSellingPrice(sellingPrice);
            order.setCustomerEmail(orderBean.getCustomerEmail());
            order.setMobileNumber(orderBean.getMobileNumber());
            order.setStatus(OrderStatus.NEW_ORDER);
            order.setCreatedDate(new Date());
            order.setUpdatedDate(new Date());
            order.setNotes(orderBean.getNotes());
            order.setPostProcessingStage(false);
            orders.add(order);
        }

        if (totalTransactionPrice.floatValue() > customer.getCustomerBalance()) {
            bean.setError("Available balance " + new DecimalFormat("0.##").format((double) customer.getCustomerBalance()) + " is not enough to process the transaction.");
            return bean;
        }

        orders.forEach(this::save);

        transactionBalanceService.create(transactionId, customer.getCustomerBalance(), customer.getCustomerBalance() - totalTransactionPrice.floatValue());
        customer.setCustomerBalance(customer.getCustomerBalance() - totalTransactionPrice.floatValue());

        customerService.save(customer);

        if (group.getCheckAganinstGroupBalance()) {
            BigDecimal balanceBefore = new BigDecimal(group.getCustomerGroupBalance() + "");
            BigDecimal balanceAfter = balanceBefore.subtract(totalCostToGroup);

            groupTransactionBalanceService.create(transactionId, balanceBefore, balanceAfter);

            group.setCustomerGroupBalance(balanceAfter.floatValue());
            groupService.save(group);
        }

        bean.setProducts(orders);
        bean.setSuccess(true);

        return bean;
    }

    @Override
    public MobileUnlockingOrder editOrder(MobileUnlockingOrder orderToEdit) {
        MobileUnlockingOrder order = findOne(orderToEdit.getId());
        order.setImei(orderToEdit.getImei());
        order.setCode(orderToEdit.getCode());
        order.setCustomerEmail(orderToEdit.getCustomerEmail());
        order.setMobileNumber(orderToEdit.getMobileNumber());
        if (orderToEdit.getCode() != null) {
            order.setStatus(OrderStatus.COMPLETED);
        }
        order.setUpdatedDate(new Date());
        order.setNotes(orderToEdit.getNotes());
        return save(order);
    }

    @Override
    public MobileUnlockingOrder assign(Integer orderId, String login) {
        MobileUnlockingOrder order = findOne(orderId);
        order.setAssigned(userService.findByLogin(login));
        order.setStatus(OrderStatus.ASSIGNED);
        order.setUpdatedDate(new Date());
        return save(order);
    }

    @Override
    public MobileUnlockingOrder reject(Integer orderId) {
        MobileUnlockingOrder order = findOne(orderId);
        order.setStatus(OrderStatus.REJECTED);
        order.setUpdatedDate(new Date());
        return save(order);
    }
}
