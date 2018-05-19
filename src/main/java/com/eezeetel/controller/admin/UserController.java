package com.eezeetel.controller.admin;

import com.eezeetel.entity.User;
import com.eezeetel.service.UserService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 24.12.2015.
 */
@RestController("adminUserController")
@RequestMapping("/admin/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/find-agents", method = RequestMethod.GET)
    public Map<String, String> findAgents(HttpServletRequest request) {
        List<User> users = userService.findAgentsByUserAndGroup(request.getRemoteUser(), NumberUtils.toInt(request.getSession().getAttribute("GROUP_ID").toString()));
        return users.stream().collect(Collectors.toMap(User::getLogin, User::getUserFirstName));
    }
}
