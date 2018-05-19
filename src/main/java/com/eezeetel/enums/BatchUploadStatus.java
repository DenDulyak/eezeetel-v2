package com.eezeetel.enums;

/**
 * Created by Denis Dulyak on 15.01.2016.
 */
public enum BatchUploadStatus {

    /*0*/DUPLICATE_BATCH("Duplicate_Batch"),
    /*1*/FAILED_BATCH_UPDATE_IN_DB("FAILED-BatchUpdateInDB"),
    /*2*/FILE_UPLOADED("FileUploaded"),
    /*3*/SUCCESS_BATCH_UPDATE_IN_DB("SUCCESS-BatchUpdateInDB");

    BatchUploadStatus(String description) { this.description = description; }

    private String description;
    public String getDescription() { return description; }
}
