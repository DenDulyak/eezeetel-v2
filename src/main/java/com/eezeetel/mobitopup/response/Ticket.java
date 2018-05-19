package com.eezeetel.mobitopup.response;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Denis Dulyak on 25.03.2016.
 */
@Getter
@Setter
public class Ticket extends MobitopupResponse {

    private String network;
    private String networklogo;
    private String local_currency;
    private String currency;
    private String tickets;
    private String buy;
}
