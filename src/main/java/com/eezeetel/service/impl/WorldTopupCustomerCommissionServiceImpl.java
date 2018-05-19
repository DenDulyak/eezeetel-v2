package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.WorldTopupCustomerCommission;
import com.eezeetel.entity.WorldTopupGroupCommission;
import com.eezeetel.repository.WorldTopupCustomerCommissionRepository;
import com.eezeetel.service.CustomerService;
import com.eezeetel.service.WorldTopupCustomerCommissionService;
import com.eezeetel.service.WorldTopupGroupCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Denis Dulyak on 13.07.2016.
 */
@Service
public class WorldTopupCustomerCommissionServiceImpl implements WorldTopupCustomerCommissionService {

    @Autowired
    private WorldTopupCustomerCommissionRepository repository;

    @Autowired
    private WorldTopupGroupCommissionService groupCommissionService;

    @Autowired
    private CustomerService customerService;

    @Override
    public WorldTopupCustomerCommission save(WorldTopupCustomerCommission commission) {
        return repository.save(commission);
    }

    @Override
    public WorldTopupCustomerCommission findByGroupCommissionAndCustomer(WorldTopupGroupCommission groupCommission, TMasterCustomerinfo customer) {
        return repository.findByGroupCommissionAndCustomer(groupCommission, customer);
    }

    @Override
    public WorldTopupCustomerCommission findOrCreateByGroupCommissionAndCustomer(WorldTopupGroupCommission groupCommission, TMasterCustomerinfo customer) {
        WorldTopupCustomerCommission customerCommission = repository.findByGroupCommissionAndCustomer(groupCommission, customer);

        if (customerCommission == null) {
            customerCommission = create(groupCommission, customer);
        }

        return customerCommission;
    }

    @Override
    public WorldTopupCustomerCommission findOrCreateByCountryIdAndGroupIdAndCustomerId(Integer countryId, Integer groupId, Integer customerId) {
        WorldTopupGroupCommission groupCommission = groupCommissionService.findOrCreateByCountryIdAndGroupId(countryId, groupId);
        WorldTopupCustomerCommission customerCommission = findByGroupCommissionAndCustomer(groupCommission, new TMasterCustomerinfo(customerId));

        if (customerCommission == null) {
            customerCommission = create(groupCommission, customerService.findOne(customerId));
        }

        return customerCommission;
    }

    @Override
    public WorldTopupCustomerCommission create(WorldTopupGroupCommission groupCommission, TMasterCustomerinfo customer) {
        WorldTopupCustomerCommission customerCommission = new WorldTopupCustomerCommission();
        customerCommission.setGroupCommission(groupCommission);
        customerCommission.setCustomer(customer);
        customerCommission.setAgentPercent(0);
        customerCommission.setGroupPercent(5);
        return save(customerCommission);
    }
}
