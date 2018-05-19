package com.eezeetel.controller.customer;

import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.bean.mobileUnlocking.MobileUnlockingBean;
import com.eezeetel.bean.mobileUnlocking.MobileUnlockingOrderBean;
import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.MobileUnlockingCustomerCommission;
import com.eezeetel.entity.TCustomerUsers;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.service.CustomerUserService;
import com.eezeetel.service.MobileUnlockingCommissionService;
import com.eezeetel.service.MobileUnlockingCustomerCommissionService;
import com.eezeetel.service.MobileUnlockingOrderService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.security.Principal;

/**
 * Created by Denis Dulyak on 04.01.2016.
 */
@RestController("customerMobileUnlockingController")
@RequestMapping(value = "/customer/mobile-unlocking")
public class MobileUnlockingController {

    @Autowired
    private MobileUnlockingCommissionService mobileUnlockingCommissionService;

    @Autowired
    private MobileUnlockingCustomerCommissionService mobileUnlockingCustomerCommissionService;

    @Autowired
    private MobileUnlockingOrderService mobileUnlockingOrderService;

    @Autowired
    private CustomerUserService customerUserService;

    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public ResponseEntity<MobileUnlockingBean> get(HttpServletRequest request, @RequestParam Integer id) {
        TCustomerUsers customerUser = customerUserService.findByLogin(request.getRemoteUser());
        TMasterCustomerinfo customer = customerUser.getCustomer();
        MobileUnlockingCommission commission = mobileUnlockingCommissionService.findByGroupAndMobileUnlocking(NumberUtils.toInt(request.getSession().getAttribute("GROUP_ID").toString()), id);
        MobileUnlockingCustomerCommission customerCommission = mobileUnlockingCustomerCommissionService.findByCustomerAndMobileUnlockingCommission(customer, commission);
        return ResponseEntity.ok(MobileUnlockingBean.toBean(commission.getMobileUnlocking(), commission, customerCommission, customer));
    }

    @RequestMapping(value = "/order", method = RequestMethod.POST)
    public ResponseEntity<ConfirmBean> order(Principal principal, @ModelAttribute MobileUnlockingOrderBean orderBean) {
        ConfirmBean bean = new ConfirmBean();
        bean.setSuccess(false);
        mobileUnlockingOrderService.createNewOrders(bean, orderBean, principal.getName());
        return ResponseEntity.ok(bean);
    }
}
