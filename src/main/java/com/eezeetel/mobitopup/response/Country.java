package com.eezeetel.mobitopup.response;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;

/**
 * Created by Denis Dulyak on 25.03.2016.
 */
@Getter
@Setter
public class Country extends MobitopupResponse {

    @JsonIgnore
    private String countries;
    private Map<String, String> countryList;
}
