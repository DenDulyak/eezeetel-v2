package com.eezeetel.controller.customer;

import com.eezeetel.bean.mobileUnlocking.MobileUnlockingServiceBean;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.TMasterSupplierinfo;
import com.eezeetel.service.CustomerUserService;
import com.eezeetel.service.MobileUnlockingCustomerCommissionService;
import com.eezeetel.service.SupplierService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 08.09.2015.
 */
@RestController
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private SupplierService supplierService;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private MobileUnlockingCustomerCommissionService mobileUnlockingCustomerCommissionService;

    @RequestMapping(value = "/suppliers-by-type", method = RequestMethod.GET)
    public List<MobileUnlockingServiceBean> productsBySupplier(HttpServletRequest request, @RequestParam Integer typeId) {
        List<TMasterSupplierinfo> suppliers = supplierService.findByType(typeId);
        TMasterCustomerinfo customer = customerUserService.findByLogin(request.getRemoteUser()).getCustomer();
        Integer groupId = NumberUtils.toInt(request.getSession().getAttribute("GROUP_ID").toString());
        return suppliers
                .stream()
                .map(supplier ->
                                MobileUnlockingServiceBean.toBean(
                                        supplier,
                                        mobileUnlockingCustomerCommissionService.findOrCreateBySupplierAndCustomer(groupId, supplier.getId(), customer)
                                )
                ).collect(Collectors.toList());
    }

    @RequestMapping(value = "/get-balance", method = RequestMethod.GET)
    public ResponseEntity<Float> getBalance(HttpServletRequest request) {
        return ResponseEntity.ok(customerUserService.findByLogin(request.getRemoteUser()).getCustomer().getCustomerBalance());
    }
}
