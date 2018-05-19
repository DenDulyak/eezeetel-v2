package com.eezeetel.enums;

public enum SettingType {

    /*0*/DIGICEL_JAMAICA_RETURN_PERCENT("10");

    SettingType(String defaultVal) {
        this.defaultVal = defaultVal;
    }

    private String defaultVal;

    public String getDefaultVal() {
        return defaultVal;
    }
}
