package com.eezeetel.enums;

/**
 * Created by Denis Dulyak on 27.01.2016.
 */
public enum OrderStatus {

    /*0*/NEW_ORDER("New Order"),
    /*1*/ASSIGNED("Assigned"),
    /*2*/COMPLETED("Completed"),
    /*3*/REJECTED("Rejected");

    OrderStatus(String description) { this.description = description; }

    private String description;
    public String getDescription() { return description; }
}
