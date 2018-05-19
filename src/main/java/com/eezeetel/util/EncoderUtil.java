package com.eezeetel.util;

import org.apache.commons.codec.binary.Hex;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Created by Denis Dulyak on 07.02.2017.
 */
public class EncoderUtil {

    public static String getMD5Hex(String key) {
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        assert md != null;
        byte[] digest = md.digest(key.getBytes());
        return new String(Hex.encodeHex(digest));
    }
}
