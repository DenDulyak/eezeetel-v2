package com.eezeetel.controller.mobileadmin;

import com.eezeetel.service.GroupService;
import com.eezeetel.service.MobileUnlockingOrderService;
import com.eezeetel.service.MobileUnlockingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by Denis Dulyak on 28.01.2016.
 */
@Controller("mobileAdminViewController")
@RequestMapping("/mobileadmin")
public class ViewController {

    @Autowired
    private MobileUnlockingService mobileUnlockingService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private MobileUnlockingOrderService mobileUnlockingOrderService;

    @RequestMapping(method = RequestMethod.GET)
    public String main(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "mobileadmin/main";
    }

    @RequestMapping(value = "/orders", method = RequestMethod.GET)
    public String orders(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        model.addAttribute("orders", mobileUnlockingOrderService.findByAssignedUser(request.getRemoteUser()));
        return "mobileadmin/orders";
    }

    @RequestMapping(value = "/mobile-unlocking", method = RequestMethod.GET)
    public String mobileUnlocking(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        model.addAttribute("mobileUnlockings", mobileUnlockingService.findAll());
        return "mobileadmin/MobileUnlocking";
    }

    @RequestMapping(value = "/customers", method = RequestMethod.GET)
    public String customers(HttpServletRequest request, Model model) {
        model.addAttribute("groups", groupService.findAll());
        putNavAttributes(request, model);
        return "mobileadmin/customers/messageToCustomers";
    }

    public void putNavAttributes(HttpServletRequest request, Model model) {
        model.addAttribute("userName", request.getRemoteUser());
    }
}
