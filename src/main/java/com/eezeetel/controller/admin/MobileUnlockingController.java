package com.eezeetel.controller.admin;

import com.eezeetel.bean.ResponseContainer;
import com.eezeetel.bean.admin.MobileUnlockingCustomerCommissionBean;
import com.eezeetel.entity.TMasterSupplierinfo;
import com.eezeetel.service.MobileUnlockingCustomerCommissionService;
import com.eezeetel.service.SupplierService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 22.12.2015.
 */
@RestController("adminMobileUnlockingController")
@RequestMapping("/admin/mobile-unlocking")
public class MobileUnlockingController {

    @Autowired
    private MobileUnlockingCustomerCommissionService mobileUnlockingCustomerCommissionService;

    @Autowired
    private SupplierService supplierService;

    @RequestMapping(value = "/suppliers-by-type", method = RequestMethod.GET)
    public List<TMasterSupplierinfo> getSuppliersByType(@RequestParam(value = "typeId") Integer typeId) {
        return supplierService.findByType(typeId);
    }

    @RequestMapping(value = "/customer-commissions-by-supplier", method = RequestMethod.GET)
    public List<MobileUnlockingCustomerCommissionBean> getCommissionsBySupplierAndGroup(HttpServletRequest request,
                                                                                        @RequestParam Integer supplierId,
                                                                                        @RequestParam Integer customerId) {
        return mobileUnlockingCustomerCommissionService.findOrCreateBySupplierAndCustomer(NumberUtils.toInt(request.getSession().getAttribute("GROUP_ID").toString()), supplierId, customerId)
                .stream().map(MobileUnlockingCustomerCommissionBean::toBean).collect(Collectors.toList());
    }

    @RequestMapping(value = "/customer-commissions-save", method = RequestMethod.POST)
    public List<MobileUnlockingCustomerCommissionBean> saveCustomerCommissions(@RequestParam Map<String, String> map) {
        return mobileUnlockingCustomerCommissionService.updateTable(map).stream().
                map(MobileUnlockingCustomerCommissionBean::toBean).collect(Collectors.toList());
    }

    @RequestMapping(value = "/copy-commissions-to-customer", method = RequestMethod.POST)
    public ResponseContainer<List<MobileUnlockingCustomerCommissionBean>> copyToCustomer(@RequestParam Integer customerFrom,
                                                                                         @RequestParam Integer customerTo) {
        ResponseContainer<List<MobileUnlockingCustomerCommissionBean>> container = new ResponseContainer<>();
        try {
            container.setData(mobileUnlockingCustomerCommissionService.copyCommissions(customerFrom, customerTo)
                    .stream().map(MobileUnlockingCustomerCommissionBean::toBean).collect(Collectors.toList()));
            container.setMessage("Successful");
            container.setStatus(HttpStatus.OK.value());
        } catch (Exception e) {
            container.setMessage("Error");
            container.setStatus(HttpStatus.BAD_REQUEST.value());
            e.printStackTrace();
        }
        return container;
    }
}
