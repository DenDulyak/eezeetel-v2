package com.eezeetel.controller.mobileadmin;

import com.eezeetel.bean.mobileUnlocking.MobileUnlockingBean;
import com.eezeetel.entity.MobileUnlocking;
import com.eezeetel.entity.TMasterSupplierinfo;
import com.eezeetel.service.MobileUnlockingService;
import com.eezeetel.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Created by Denis Dulyak on 22.06.2016.
 */
@RestController("mobileadminMobileUnlockingController")
@RequestMapping("/mobileadmin/mobile-unlocking")
public class MobileUnlockingController {

    @Autowired
    private MobileUnlockingService mobileUnlockingService;

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

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public void save(HttpServletResponse response, @ModelAttribute MobileUnlockingBean bean) {
        try {
            mobileUnlockingService.createOrUpdate(bean);
            response.sendRedirect("/mobileadmin/mobile-unlocking");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
