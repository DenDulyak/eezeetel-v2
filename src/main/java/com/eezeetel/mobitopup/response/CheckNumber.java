package com.eezeetel.mobitopup.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonInclude(value = JsonInclude.Include.NON_NULL)
public class CheckNumber extends MobitopupResponse {

    private String auth_key;
    private String networkid;
    private String network;
    private String networklogo;
    private String countryid;
    private String country;
    private String countryflag;
    private String tickets;
    private String localcurrency;
    private String iso;
    private String currency;
}
