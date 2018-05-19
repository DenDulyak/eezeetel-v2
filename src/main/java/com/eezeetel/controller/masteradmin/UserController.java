package com.eezeetel.controller.masteradmin;

import com.eezeetel.bean.UserBean;
import com.eezeetel.entity.TMasterCountries;
import com.eezeetel.entity.User;
import com.eezeetel.service.CountryService;
import com.eezeetel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.security.Principal;
import java.util.List;

/**
 * Created by Denis Dulyak on 25.09.2015.
 */
@RestController
@RequestMapping("/masteradmin/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private CountryService countryService;

    @RequestMapping(value = "/countries", method = RequestMethod.GET)
    public ResponseEntity<List<TMasterCountries>> countries() {
        return ResponseEntity.ok(countryService.findAll());
    }

    @RequestMapping(value = "/find-by-type", method = RequestMethod.GET)
    public ResponseEntity<List<User>> getMobileAdmins(@RequestParam Integer typeId) {
        return ResponseEntity.ok(userService.findByUserType(typeId));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public void saveUser(HttpServletResponse response, Principal principal, @ModelAttribute UserBean bean) {
        try {
            userService.save(bean, principal.getName());
            response.sendRedirect("/masteradmin/user/type");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
