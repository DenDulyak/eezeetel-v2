package com.eezeetel.auth;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Created by Denis Dulyak on 13.04.2016.
 */
@Service
public class CustomLogoutHandler implements LogoutHandler {

    @Override
    public void logout(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) {
        HttpSession session = httpServletRequest.getSession();
        if (session != null) {
            List<CustomUserDetails> users = (List<CustomUserDetails>) session.getAttribute("users");
            if (users != null && !users.isEmpty()) {
                users.removeIf(u -> u.getUsername().equals(authentication.getName()));
                // not done
            }
        }
    }
}
