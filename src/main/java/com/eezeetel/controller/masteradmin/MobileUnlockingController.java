package com.eezeetel.controller.masteradmin;

import com.eezeetel.bean.mobileUnlocking.MobileUnlockingBean;
import com.eezeetel.entity.MobileUnlocking;
import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.TMasterSupplierinfo;
import com.eezeetel.service.MobileUnlockingCommissionService;
import com.eezeetel.service.MobileUnlockingService;
import com.eezeetel.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Created by Denis Dulyak on 15.12.2015.
 */
@RestController
@RequestMapping("/masteradmin/mobile-unlocking")
public class MobileUnlockingController {

    @Autowired
    private MobileUnlockingService mobileUnlockingService;

    @Autowired
    private MobileUnlockingCommissionService mobileUnlockingCommissionService;

    @Autowired
    private SupplierService supplierService;

    @RequestMapping(value = "/suppliers-by-type", method = RequestMethod.GET)
    public ResponseEntity<List<TMasterSupplierinfo>> getSuppliersByType(@RequestParam Integer typeId) {
        return ResponseEntity.ok(supplierService.findByType(typeId));
    }

    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public ResponseEntity<MobileUnlockingBean> getMobileUnlocking(@RequestParam Integer id) {
        return ResponseEntity.ok(MobileUnlockingBean.toBean(mobileUnlockingService.findOne(id)));
    }

    @RequestMapping(value = "/active", method = RequestMethod.POST)
    public ResponseEntity<MobileUnlocking> active(@RequestParam Integer id, @RequestParam Boolean active) {
        return ResponseEntity.ok(mobileUnlockingService.setActiveStatus(id, active));
    }

    @RequestMapping(value = "/commissions-by-supplier-and-group", method = RequestMethod.GET)
    public ResponseEntity<List<MobileUnlockingCommission>> getCommissionsBySupplierAndGroup(@RequestParam Integer groupId, @RequestParam Integer supplierId) {
        return ResponseEntity.ok(mobileUnlockingCommissionService.findOrCreateByGroupAndSupplier(groupId, supplierId));
    }

    @RequestMapping(value = "/commission-save", method = RequestMethod.POST)
    public ResponseEntity<MobileUnlockingCommission> commisionSave(@RequestParam Integer id, @RequestParam BigDecimal commission) {
        return ResponseEntity.ok(mobileUnlockingCommissionService.updateCommision(id, commission));
    }

    @RequestMapping(value = "/commission-save-all", method = RequestMethod.POST)
    public ResponseEntity<List<MobileUnlockingCommission>> commisionSaveAll(@RequestParam Map<String, String> map) {
        return ResponseEntity.ok(mobileUnlockingCommissionService.updateTable(map));
    }

    @RequestMapping(value = "/copy-to-group", method = RequestMethod.POST)
    public ResponseEntity<Boolean> copy(@RequestParam Integer groupFrom, @RequestParam Integer groupTo) {
        return ResponseEntity.ok(mobileUnlockingCommissionService.copyCommisionsFromOneGroupToAnother(groupFrom, groupTo));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public void save(HttpServletResponse response, @ModelAttribute MobileUnlockingBean bean) {
        try {
            mobileUnlockingService.createOrUpdate(bean);
            response.sendRedirect("/masteradmin/mobile-unlocking");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}