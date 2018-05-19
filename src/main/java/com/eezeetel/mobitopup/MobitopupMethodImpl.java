package com.eezeetel.mobitopup;

import com.eezeetel.mobitopup.response.*;
import org.springframework.stereotype.Service;

import java.net.URL;

/**
 * Created by Denis Dulyak on 21.03.2016.
 */
@Service
public class MobitopupMethodImpl implements MobitopupMethod {

    public static final String API = "https://resellers.mobitopup.com/api";
    public static final String BALANCE = "/balance";
    public static final String COUNTRIES = "/getcountries";
    public static final String NETWORKS = "/getnetworks/xxx";
    public static final String TICKETS = "/gettickets/xxx";
    public static final String CHECK_NUMBER = "/checknumber";
    public static final String TOPUP = "/topup";
    public static final String OTTXBALANCE = "/ottxbalance";

    @Override
    public Balance getBalance() {
        Balance response = MobitopupUtil.create(Balance.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + BALANCE + MobitopupUtil.getAuthParams(key));
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), Balance.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public Country getCountries() {
        Country response = MobitopupUtil.create(Country.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + COUNTRIES + MobitopupUtil.getAuthParams(key) + "&type=0");
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), Country.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public Network getNetworks(Integer countryId) {
        Network response = MobitopupUtil.create(Network.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + NETWORKS.replace("xxx", countryId + "") + MobitopupUtil.getAuthParams(key) + "&type=0");
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), Network.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public Ticket getTickets(Integer networkId) {
        Ticket response = MobitopupUtil.create(Ticket.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + TICKETS.replace("xxx", networkId + "") + MobitopupUtil.getAuthParams(key) + "&type=0");
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), Ticket.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public CheckNumber checkNumber(String number) {
        CheckNumber response = MobitopupUtil.create(CheckNumber.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + CHECK_NUMBER + MobitopupUtil.getAuthParams(key) + "&number=" + number);
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), CheckNumber.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public Topup topup(String destnumber, String srcnumber, String product, String message) {
        Topup response = MobitopupUtil.create(Topup.class);
        try {
            String key = System.currentTimeMillis() + "";
            String respons = MobitopupUtil.sendRequest(MobitopupUtil.getTopupUrl(key, destnumber, srcnumber, product, message));
            response = MobitopupUtil.getJsonResponse(respons, Topup.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public Balance ottxBalance(String number) {
        Balance response = MobitopupUtil.create(Balance.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + OTTXBALANCE + MobitopupUtil.getAuthParams(key) + "&destnumber=eze" + number);
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), Balance.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public CheckNumber checkNumberV2(String number) {
        CheckNumber response = MobitopupUtil.create(CheckNumber.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + CHECK_NUMBER + MobitopupUtil.getAuthParams(key) + "&number=eze" + number);
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), CheckNumber.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    public Balance getPinlessBalance() {
        Balance response = MobitopupUtil.create(Balance.class);
        try {
            String key = System.currentTimeMillis() + "";
            URL url = new URL(API + BALANCE + MobitopupUtil.getPinlessAuthParams(key));
            response = MobitopupUtil.getJsonResponse(MobitopupUtil.sendRequest(url), Balance.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }
}
