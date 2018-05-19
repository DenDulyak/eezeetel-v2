package com.eezeetel.service.impl;

import com.eezeetel.entity.PinlessCustomerCommission;
import com.eezeetel.entity.PinlessGroupCommission;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.repository.PinlessCustomerCommissionRepository;
import com.eezeetel.service.CustomerService;
import com.eezeetel.service.PinlessCustomerCommissionService;
import com.eezeetel.service.PinlessGroupCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

import static org.springframework.util.Assert.notNull;

@Service
public class PinlessCustomerCommissionServiceImpl implements PinlessCustomerCommissionService {

    @Autowired
    private PinlessCustomerCommissionRepository repository;

    @Autowired
    private PinlessGroupCommissionService groupCommissionService;

    @Autowired
    private CustomerService customerService;

    @Override
    public PinlessCustomerCommission findByCustomerId(Integer groupId, Integer customerId) {
        PinlessCustomerCommission commission = repository.findByCustomerId(customerId);

        if (commission == null) {
            PinlessGroupCommission group = groupCommissionService.findByGroupId(groupId);
            notNull(group);

            TMasterCustomerinfo customer = customerService.findOne(customerId);
            notNull(customer);

            commission = new PinlessCustomerCommission();
            commission.setGroupCommission(group);
            commission.setCustomer(customer);
            commission.setGroupPercent(15);
            commission.setAgentPercent(0);
            commission = repository.save(commission);
        }

        return commission;
    }

    @Override
    public PinlessCustomerCommission update(Integer customerId, Integer groupPercent, Integer agentPercent) {
        notNull(customerId);
        notNull(groupPercent);
        notNull(agentPercent);

        PinlessCustomerCommission commission = repository.findByCustomerId(customerId);
        notNull(commission);

        commission.setGroupPercent(groupPercent);
        commission.setAgentPercent(agentPercent);

        return repository.save(commission);
    }

    @Override
    public void copy(Integer customerIdFrom, Integer customerIdTo, boolean groupCommission, boolean agentCommission) {
        notNull(customerIdFrom);
        notNull(customerIdTo);
        PinlessCustomerCommission commissionFrom = repository.findByCustomerId(customerIdFrom);
        notNull(commissionFrom);
        if (customerIdTo == 0) {
            List<TMasterCustomerinfo> customers = customerService.findByGroupAndIntroducedBy(commissionFrom.getCustomer().getGroup(), commissionFrom.getCustomer().getIntroducedBy());
            for (TMasterCustomerinfo customer : customers) {
                PinlessCustomerCommission commissionTo = findByCustomerId(commissionFrom.getCustomer().getGroup().getId(), customer.getId());
                copy(commissionFrom, commissionTo, groupCommission, agentCommission);
            }
        } else {
            PinlessCustomerCommission commissionTo = findByCustomerId(commissionFrom.getCustomer().getGroup().getId(), customerIdTo);
            copy(commissionFrom, commissionTo, groupCommission, agentCommission);
        }
    }

    private void copy(PinlessCustomerCommission commissionFrom, PinlessCustomerCommission commissionTo, boolean groupCommission, boolean agentCommission) {
        if(Objects.equals(commissionFrom.getId(), commissionTo.getId())) {
            return;
        }
        if (groupCommission) {
            commissionTo.setGroupPercent(commissionFrom.getGroupPercent());
        }
        if (agentCommission) {
            commissionTo.setAgentPercent(commissionFrom.getAgentPercent());
        }
        repository.save(commissionTo);
    }
}
