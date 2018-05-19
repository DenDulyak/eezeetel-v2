package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterCustomerCredit;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.repository.CustomerCreditRepository;
import com.eezeetel.service.CustomerCreditService;
import com.eezeetel.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 11.04.2016.
 */
@Service
public class CustomerCreditServiceImpl implements CustomerCreditService {

    @Autowired
    private CustomerCreditRepository repository;

    @Autowired
    private CustomerService customerService;

    @Override
    @Transactional
    public Page<TMasterCustomerCredit> findByGroupAndEnteredTime(Integer groupId, Integer customerId, Date enteredTime, Integer status, PageRequest pageRequest) {
        Page<TMasterCustomerCredit> result;
        List<TMasterCustomerinfo> customers;
        if (customerId != null && customerId > 0) {
            customers = Collections.singletonList(customerService.findOne(customerId));
        } else {
            customers = customerService.findByGroup(new TMasterCustomerGroups(groupId));
        }
        if (customers.isEmpty()) {
            return null;
        }
        if (status != -1) {
            if (status == 0) {
                result = repository.findByCusomersAndEnteredTimeAndCreditOrDebit(customers, enteredTime, (byte) 2, pageRequest);
            } else {
                result = repository.findByCusomersAndEnteredTimeAndCreditIdStatus(customers, enteredTime, status.byteValue(), pageRequest);
            }
        } else {
            result = repository.findByCusomersAndEnteredTime(customers, enteredTime, pageRequest);
        }
        result.getContent().forEach(c -> c.getCustomer().getGroup().getId());
        return result;
    }

    @Override
    public BigDecimal calcCustomerCreditAmountBetweenDates(Integer customerId, Date startDate, Date endDate) {
        BigDecimal price = repository.calcCustomerCreditAmountBetweenDates(customerId, startDate, endDate);
        return price == null ? new BigDecimal("0") : price;
    }
}
