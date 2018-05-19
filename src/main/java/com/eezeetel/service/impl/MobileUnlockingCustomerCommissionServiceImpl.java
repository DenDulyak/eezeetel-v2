package com.eezeetel.service.impl;

import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.MobileUnlockingCustomerCommission;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.repository.MobileUnlockingCustomerCommissionRepository;
import com.eezeetel.service.CustomerService;
import com.eezeetel.service.MobileUnlockingCommissionService;
import com.eezeetel.service.MobileUnlockingCustomerCommissionService;
import com.eezeetel.util.PriceUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Denis Dulyak on 23.12.2015.
 */
@Service
public class MobileUnlockingCustomerCommissionServiceImpl implements MobileUnlockingCustomerCommissionService {

    @Autowired
    private MobileUnlockingCustomerCommissionRepository repository;

    @Autowired
    private MobileUnlockingCommissionService mobileUnlockingCommissionService;

    @Autowired
    private CustomerService customerService;

    @Override
    public MobileUnlockingCustomerCommission save(MobileUnlockingCustomerCommission commission) {
        return repository.save(commission);
    }

    @Override
    public MobileUnlockingCustomerCommission findByCustomerAndMobileUnlockingCommission(TMasterCustomerinfo customer, MobileUnlockingCommission commission) {
        return repository.findByCustomerAndMobileUnlockingCommission(customer, commission);
    }

    @Override
    public List<MobileUnlockingCustomerCommission> findOrCreateBySupplierAndCustomer(Integer groupId, Integer supplierId, Integer customerId) {
        return findOrCreateBySupplierAndCustomer(groupId, supplierId, customerService.findOne(customerId));
    }

    @Override
    public List<MobileUnlockingCustomerCommission> findOrCreateBySupplierAndCustomer(Integer groupId, Integer supplierId, TMasterCustomerinfo customer) {
        List<MobileUnlockingCustomerCommission> result = new ArrayList<>();
        List<MobileUnlockingCommission> mobileUnlockingCommissions = mobileUnlockingCommissionService.findOrCreateByGroupAndSupplier(groupId, supplierId);

        for (MobileUnlockingCommission mobileUnlockingCommission : mobileUnlockingCommissions) {
            MobileUnlockingCustomerCommission customerCommission = findByCustomerAndMobileUnlockingCommission(customer, mobileUnlockingCommission);
            if (customerCommission == null) {
                customerCommission = new MobileUnlockingCustomerCommission();
                customerCommission.setCustomer(customer);
                customerCommission.setMobileUnlockingCommission(mobileUnlockingCommission);
                BigDecimal commissions = PriceUtil.getPercent(mobileUnlockingCommission.getMobileUnlocking().getPurchasePrice(), PriceUtil.TEN);
                customerCommission.setGroupCommission(commissions);
                customerCommission.setAgentCommission(commissions);
                customerCommission = repository.save(customerCommission);
            }
            result.add(customerCommission);
        }

        return result;
    }

    @Override
    public MobileUnlockingCustomerCommission updateCustomerCommission(Integer customerCommissionId, BigDecimal eezeetelCommission, BigDecimal agentCommission) {
        MobileUnlockingCustomerCommission customerCommission = repository.findOne(customerCommissionId);
        customerCommission.setGroupCommission(eezeetelCommission);
        customerCommission.setAgentCommission(agentCommission);
        customerCommission.setUpdatedDate(new Date());
        return save(customerCommission);
    }

    @Override
    public List<MobileUnlockingCustomerCommission> updateTable(Map<String, String> map) {
        List<MobileUnlockingCustomerCommission> result = new ArrayList<>();
        for (Map.Entry<String, String> entry : map.entrySet()) {
            Integer customerCommissionId = Integer.parseInt(entry.getKey());
            String[] values = (entry.getValue().isEmpty() ? "0_0" : entry.getValue()).split("_");
            result.add(updateCustomerCommission(customerCommissionId, new BigDecimal(values[0]), new BigDecimal(values[1])));
        }
        return result;
    }

    @Override
    public List<MobileUnlockingCustomerCommission> copyCommissions(Integer customerFrom, Integer customerTo) {
        List<MobileUnlockingCustomerCommission> commissions = new ArrayList<>();
        TMasterCustomerinfo fromCustomer = customerService.findOne(customerFrom);
        List<MobileUnlockingCustomerCommission> commissionsFrom = repository.findByCustomer(fromCustomer);
        List<TMasterCustomerinfo> toCustomers;
        if (customerTo == 0) {
            toCustomers = customerService.findByGroupAndIntroducedBy(fromCustomer.getGroup(), fromCustomer.getIntroducedBy());
        } else {
            toCustomers = new ArrayList<>();
            toCustomers.add(customerService.findOne(customerTo));
        }
        for (TMasterCustomerinfo toCustomer : toCustomers) {
            commissions.addAll(copyCommissionsToCustomer(commissionsFrom, toCustomer));
        }
        return commissions;
    }

    @Override
    public List<MobileUnlockingCustomerCommission> copyCommissionsToCustomer(List<MobileUnlockingCustomerCommission> commissionsFrom, TMasterCustomerinfo toCustomer) {
        List<MobileUnlockingCustomerCommission> commissions = new ArrayList<>();
        for (MobileUnlockingCustomerCommission commissionFrom : commissionsFrom) {
            MobileUnlockingCustomerCommission commissionTo = findByCustomerAndMobileUnlockingCommission(toCustomer, commissionFrom.getMobileUnlockingCommission());
            if (commissionTo == null) {
                commissionTo = new MobileUnlockingCustomerCommission();
                commissionTo.setCustomer(toCustomer);
                commissionTo.setMobileUnlockingCommission(commissionFrom.getMobileUnlockingCommission());
                commissionTo.setCreatedDate(new Date());
            }
            commissionTo.setGroupCommission(commissionFrom.getGroupCommission());
            commissionTo.setAgentCommission(commissionFrom.getAgentCommission());
            commissionTo.setUpdatedDate(new Date());
            commissions.add(save(commissionTo));
        }
        return commissions;
    }
}
