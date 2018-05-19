package com.eezeetel.auth;

import com.eezeetel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Denis Dulyak on 02.09.2015.
 */
@Service
public class CustomAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Autowired
    private UserService userService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        clearAuthSessionAttributes(request.getSession());
        CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();
        HttpSession session = request.getSession();
        List<CustomUserDetails> users = (List<CustomUserDetails>) session.getAttribute("users");
        if (users == null) {
            users = new ArrayList<>();
        }
        users.add(customUserDetails);
        session.setAttribute("users", users);
        Boolean hasAccessToSite = true;
        if (customUserDetails.isMasterAdmin()) {
            getRedirectStrategy().sendRedirect(request, response, "/masteradmin/MasterInformation.jsp");
        } else if (customUserDetails.isAdmin()) {
            getRedirectStrategy().sendRedirect(request, response, "/admin");
        } else if (customUserDetails.isMobileAdmin()) {
            getRedirectStrategy().sendRedirect(request, response, "/mobileadmin");
        } else {
            hasAccessToSite = userService.hasAccessToSite(customUserDetails.getUsername(), request.getServerName());
            if (hasAccessToSite) {
                getRedirectStrategy().sendRedirect(request, response, "/customer/products");
            } else {
                new SecurityContextLogoutHandler().logout(request, null, null);
                getRedirectStrategy().sendRedirect(request, response, "/?failed=1");
            }
        }
        if (hasAccessToSite) {
            userService.addUserDataToSession(customUserDetails.getUsername(), session, Boolean.TRUE);
        }
    }

    private void clearAuthSessionAttributes(HttpSession session) {
        if (session != null) {
            session.removeAttribute("SPRING_SECURITY_LAST_EXCEPTION");
            session.removeAttribute("GROUP_ID");
            session.removeAttribute("USER_ID");
            session.removeAttribute("STYLE");
        }
    }
}
