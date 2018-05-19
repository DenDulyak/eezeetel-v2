package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterCustomerGroupCredit;
import com.eezeetel.repository.GroupCreditRepository;
import com.eezeetel.service.GroupCreditService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Denis Dulyak on 18.04.2016.
 */
@Service
public class GroupCreditServiceImpl implements GroupCreditService {

    @Autowired
    private GroupCreditRepository repository;

    @Override
    public TMasterCustomerGroupCredit findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public TMasterCustomerGroupCredit save(TMasterCustomerGroupCredit credit) {
        return repository.save(credit);
    }

    @Override
    public BigDecimal calcGroupCreditAmountBetweenDates(Integer groupId, Date startDate, Date endDate) {
        BigDecimal amount = repository.calcGroupCreditAmountBetweenDates(groupId, startDate, endDate);
        return amount == null ? new BigDecimal("0") : amount;
    }
}
