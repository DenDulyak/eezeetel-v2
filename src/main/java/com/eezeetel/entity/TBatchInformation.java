package com.eezeetel.entity;

import com.eezeetel.serializer.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "t_batch_information")
public class TBatchInformation implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "SequenceID")
    private Integer sequenceId;

    @JsonSerialize(using = ProductSaleSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Sale_Info_ID", nullable = false)
    private TMasterProductsaleinfo productsaleinfo;

    @JsonSerialize(using = ProductSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Product_ID", nullable = false)
    private TMasterProductinfo product;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Batch_Created_By", nullable = false)
    private User user;

    @JsonSerialize(using = SupplierSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Supplier_ID", nullable = false)
    private TMasterSupplierinfo supplier;

    @Column(name = "Batch_ID", nullable = false)
    private String batchId;

    @Column(name = "Quantity", nullable = false)
    private int quantity;

    @Column(name = "Available_Quantity", nullable = false)
    private int availableQuantity;

    @Column(name = "Unit_Purchase_Price", nullable = false)
    private float unitPurchasePrice;

    @JsonSerialize(using = DateSerializer.class)
    @Column(name = "Batch_Arrival_Date", nullable = false)
    private Date arrivalDate;

    @JsonSerialize(using = DateSerializer.class)
    @Column(name = "Batch_Expiry_Date", nullable = false)
    private Date expiryDate;

    @JsonSerialize(using = DateSerializer.class)
    @Column(name = "Batch_Entry_Time", nullable = false)
    private Date entryTime;

    @Column(name = "Batch_Activated_By_Supplier", nullable = false, columnDefinition = "TINYINT(3)")
    private Boolean batchActivatedBySupplier;

    @Column(name = "Batch_Ready_To_Sell", nullable = false, columnDefinition = "TINYINT(3)")
    private Boolean batchReadyToSell;

    @Column(name = "IsBatchActive", nullable = false, columnDefinition = "TINYINT(3)")
    private Boolean active;

    @Column(name = "Additional_Info")
    private String additionalInfo;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Batch_File_Path", nullable = false)
    private String batchFilePath;

    @Column(name = "Batch_Upload_Status")
    private String batchUploadStatus;

    @JsonSerialize(using = DateSerializer.class)
    @Column(name = "LastModifiedTime", nullable = false)
    private Date lastModifiedTime;

    @Column(name = "Reserved_1")
    private Integer reserved1;

    @Column(name = "Reserved_2")
    private String reserved2;

    @Column(name = "Probable_Sale_Price")
    private Float probableSalePrice;

    @Column(name = "Batch_Cost", nullable = false)
    private float batchCost;

    @Column(name = "Paid_To_Supplier", nullable = false, columnDefinition = "TINYINT(3)")
    private Boolean paidToSupplier;

    @Column(name = "Payment_Date_To_Supplier")
    private Date paymentDateToSupplier;

    @Column(name = "Last_Touch_Time")
    private Date lastTouchTime;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "batch", fetch = FetchType.LAZY)
    private List<TSimCardsInfo> simCards;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "batch", fetch = FetchType.LAZY)
    private List<TCardInfo> cards;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "batch", fetch = FetchType.LAZY)
    private List<TTransactions> transactions;

    @Transient
    private String startBatchNumber;

    @Transient
    private String endBatchNumber;

    public TBatchInformation(Integer id) {
        this.sequenceId = id;
    }
}