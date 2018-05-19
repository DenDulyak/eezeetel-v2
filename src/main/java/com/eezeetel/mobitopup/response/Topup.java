package com.eezeetel.mobitopup.response;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 25.03.2016.
 */
@Getter
@Setter
public class Topup extends MobitopupResponse {

    @JsonIgnore
    private String auth_key;
    private Long order_id;
    private String sms_sent;
    private String sender_sms;
    private String product_requested;
    private String product_sent;
    @JsonIgnore
    private String balance;
    @JsonIgnore
    private String price;
    private String country;
    private String pin_based;
    private String pin_code;
    private String pin_valid;
    private String pin_ivr;
    private String pin_serial;
    private String pin_value;
    private String pin_opt1;
    private String pin_opt2;
    private String pin_opt3;
}
