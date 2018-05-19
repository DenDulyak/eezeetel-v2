package com.eezeetel.auth;

import org.apache.catalina.realm.JDBCRealm;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * Created by Denis Dulyak on 03.09.2015.
 */
@Service
public class CustomPasswordEncoder implements PasswordEncoder {

    @Override
    public String encode(CharSequence charSequence) {
        return JDBCRealm.Digest(charSequence.toString(), "MD5", "utf8");
    }

    @Override
    public boolean matches(CharSequence charSequence, String s) {
        return JDBCRealm.Digest(charSequence.toString(), "MD5", "utf8").equals(s);
    }
}
