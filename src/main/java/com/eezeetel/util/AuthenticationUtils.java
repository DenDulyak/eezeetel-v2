package com.eezeetel.util;

import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Collection;

/**
 * Created by Denis Dulyak on 28.11.2016.
 */
public class AuthenticationUtils {

    public static Authentication authentication() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new InsufficientAuthenticationException("Must be a logged in user to perform this operation");
        }
        return authentication;
    }

    public static boolean hasRole(Authentication auth, String role) {
        if (auth != null) {
            Collection<? extends GrantedAuthority> grantedAuthorities = auth.getAuthorities();
            for (GrantedAuthority g : grantedAuthorities) {
                if (g.getAuthority().equalsIgnoreCase(role)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean isMasterAdmin() {
        return hasRole(authentication(), "Employee_Master_Admin");
    }

    public static boolean isAdmin() {
        return hasRole(authentication(), "Group_Admin");
    }
}
