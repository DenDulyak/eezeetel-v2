package com.eezeetel.enums;

/**
 * Created by Denis Dulyak on 22.09.2015.
 */
public enum GroupStyle {

    /*0*/DEFAULT("ProductStyles.css"),
    /*1*/GSM("ProductStylesGSM.css"),
    /*2*/KAS("ProductStylesKAS.css"),
    /*3*/YMT("ProductStylesYMT.css");

    GroupStyle(String description) { this.description = description; }

    private String description;
    public String getDescription() { return description; }
}
