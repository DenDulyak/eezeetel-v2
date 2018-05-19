package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_response_3r")
public class TResponse3r implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "SequenceID")
    private Long id;

    @Column(name = "Auto_Batch_Number", nullable = false)
    private long autoBatchNumber;

    @Column(name = "Supplier_Name", nullable = false)
    private String supplierName;

    @Column(name = "Product_Code", nullable = false)
    private String productCode;

    @Column(name = "Product_Name", nullable = false)
    private String productName;

    @Column(name = "Requested_Quantity", nullable = false)
    private short requestedQuantity;

    @Column(name = "Product_Value", nullable = false)
    private String productValue;

    @Column(name = "Purchase_Date", nullable = false)
    private Date purchaseDate;

    @Column(name = "Response_Text", nullable = false)
    private String responseText;
}