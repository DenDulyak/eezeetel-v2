package com.eezeetel.mobitopup;

import com.eezeetel.mobitopup.response.MobitopupResponse;
import com.google.gson.Gson;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;

/**
 * Created by Denis Dulyak on 21.03.2016.
 */
public class MobitopupUtil {

    private static Logger log = Logger.getLogger(MobitopupUtil.class);

    public static final String LOGIN = "3603";
    public static final String PASSWORD = "eezee321";
    public static final String PINLESS_LOGIN = "3662";
    public static final String PINLESS_PASSWORD = "eezee434";
    public static final Integer DIGICEL_JAMAICA_NETWORK_ID = 165;

    public static <T extends MobitopupResponse> T getJsonResponse(String response, Class<T> responseClass) {
        if(StringUtils.isBlank(response)) {
            return create(responseClass);
        }
        return new Gson().fromJson(response, responseClass);
    }

    public static String getHex(String key, String login, String password) {
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        assert md != null;
        byte[] digest = md.digest((login + password + key).getBytes());
        return new String(Hex.encodeHex(digest));
    }

    public static String getAuthParams(String key) {
        return "?login=" + MobitopupUtil.LOGIN + "&key=" + key + "&md5=" + getHex(key, LOGIN, PASSWORD) + "&json=1";
    }

    public static String getPinlessAuthParams(String key) {
        return "?login=" + MobitopupUtil.PINLESS_LOGIN + "&key=" + key + "&md5=" + getHex(key, PINLESS_LOGIN, PINLESS_PASSWORD) + "&json=1";
    }

    public static URL getTopupUrl(String key, String destnumber, String srcnumber, String product, String message) throws MalformedURLException {
        String url = MobitopupMethodImpl.API + MobitopupMethodImpl.TOPUP + MobitopupUtil.getAuthParams(key);
        url += "&destnumber=" + destnumber;
        url += "&srcnumber=" + srcnumber;
        url += "&product=" + product;
        if (StringUtils.isNotEmpty(message)) {
            url += "&message=" + message;
        }
        return new URL(url);
    }

    public static URL getTopupUrlV2(String key, String destnumber, String srcnumber, String product, String message) throws MalformedURLException {
        String url = MobitopupMethodImpl.API + MobitopupMethodImpl.TOPUP + MobitopupUtil.getPinlessAuthParams(key);
        url += "&destnumber=eze" + destnumber;
        url += "&srcnumber=" + srcnumber;
        url += "&product=" + product;
        if (StringUtils.isNotEmpty(message)) {
            url += "&message=" + message;
        }
        return new URL(url);
    }

    public static String sendRequest(URL url) {
        HttpURLConnection con;
        try {
            con = (HttpURLConnection) url.openConnection();
            con.setRequestProperty("User-Agent", "Mozilla/5.0");
            BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuilder builder = new StringBuilder();
            while ((inputLine = reader.readLine()) != null) {
                builder.append(inputLine);
            }
            reader.close();
            return builder.toString();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }

    public static Map<String, String> toMap(String data) {
        Map<String, String> result = new TreeMap<>();
        if (data != null && !data.isEmpty()) {
            List<String> countryList = Arrays.asList(data.split("\\|"));
            countryList.forEach(c -> {
                String[] value = c.split("-");
                result.put(value[1], value[0]);
            });
        }
        return result;
    }

    public static <T extends MobitopupResponse> T validate(T response) {
        if (!response.getError_code().equals(0)) {
            log.error("Mobitopup response error. error_code - " + response.getError_code() + ". Text - " + response.getError_text());
        }
        return response;
    }

    public static <T extends MobitopupResponse> T create(Class<T> type) {
        T response = null;
        try {
            response = type.newInstance();
            response.setError_code(10);
            response.setError_text("Default error.");
        } catch (InstantiationException | IllegalAccessException e) {
            e.printStackTrace();
        }
        return response;
    }

    public static Boolean isDigicel(String iso, String operatorCode) {
        return iso.compareToIgnoreCase("JM") == 0 && operatorCode.compareToIgnoreCase("DC") == 0;
    }

    public static Boolean isDigicel(String iso, Integer networkId) {
        return iso.compareToIgnoreCase("JM") == 0 && Objects.equals(networkId, DIGICEL_JAMAICA_NETWORK_ID);
    }

    public static BigDecimal getCustomerCommission(Boolean isDigicel) {
        return new BigDecimal(isDigicel ? 5 : 10);
    }
}
