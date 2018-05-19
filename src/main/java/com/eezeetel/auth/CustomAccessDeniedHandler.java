package com.eezeetel.auth;

import com.eezeetel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Created by Denis Dulyak on 13.04.2016.
 */
@Service
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    @Autowired
    private UserService userService;

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException e) throws IOException, ServletException {
        HttpSession session = request.getSession();
        if (session == null) {
            response.sendRedirect("/");
            return;
        }

        List<CustomUserDetails> users = (List<CustomUserDetails>) session.getAttribute("users");
        if (users == null || users.isEmpty()) {
            response.sendRedirect("/");
            return;
        }

        Boolean access = Boolean.FALSE;
        String uri = request.getRequestURI();
        for (CustomUserDetails userDetails : users) {
            if (uri.startsWith("/masteradmin") && userDetails.isMasterAdmin()) {
                access = Boolean.TRUE;
            } else if (uri.startsWith("/admin") && userDetails.isAdmin()) {
                access = Boolean.TRUE;
            } else if (uri.startsWith("/mobileadmin") && userDetails.isMobileAdmin()) {
                access = Boolean.TRUE;
            } else if (uri.startsWith("/customer") && !userDetails.isMasterAdmin() && !userDetails.isAdmin() && !userDetails.isMobileAdmin()) {
                userService.addUserDataToSession(userDetails.getUsername(), session, Boolean.FALSE);
                access = Boolean.TRUE;
            }
            if (access) {
                authenticateUser(userDetails);
                request.getRequestDispatcher(uri).forward(request, response);
                break;
            }
        }

        if (!access) {
            response.sendRedirect("/");
        }
    }

    private void authenticateUser(CustomUserDetails userDetails) {
        Authentication auth = new UsernamePasswordAuthenticationToken(userDetails.getUsername(), userDetails.getPassword(), userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(auth);
    }
}
