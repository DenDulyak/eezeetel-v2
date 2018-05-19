package com.eezeetel.auth;

import com.eezeetel.entity.User;
import com.eezeetel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * Created by Denis Dulyak on 31.08.2015.
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserService userService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userService.findByLogin(username);
        if (user == null || !user.getUserActiveStatus()) {
            throw new UsernameNotFoundException("User not found. Invalid username or password");
        }
        return new CustomUserDetails(user.getLogin(), user.getPassword(), AuthorityUtils.createAuthorityList(user.getUserType().getName()));
    }
}
