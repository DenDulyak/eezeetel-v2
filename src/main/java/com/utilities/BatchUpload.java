package com.utilities;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.hibernate.Query;
import org.hibernate.Session;

import com.commons.DatabaseHelper;
import com.eezeetel.util.HibernateUtil;
import com.eezeetel.entity.TMasterProductinfo;

public class BatchUpload {

    public boolean processData(HttpServletRequest request) {
        int m_nSupplierID = 0;
        int m_nProductID = 0;
        int m_nSaleInfoID = 0;
        String m_strBatchID = "";
        int m_nQuantity = 0;
        float m_fUnitPurchasePrice = 0.0F;
        float m_fProbableSalePrice = 0.0F;
        String strArrivalDate = "";
        String strExpiryDate = "";
        Date m_dtArrivalDate = null;
        Date m_dtExpiryDate = null;
        String m_strArrivalDate = null;
        String m_strExpiryDate = null;
        boolean m_bBatchActivatedBySupplier = false;
        boolean m_bBatchReadyToSell = false;
        String m_strBatchCreatedBy = null;
        String strAdditionalInfo = "";
        String strNotes = "";
        String strFilePart = null;
        String m_strPaymentDate = "";
        int m_nPaidToSupplier = 0;
        float m_fPaymentToSupplier = 0.0F;
        Date m_dtPaymentDate = null;
        int nMaxTopups = 0;
        try {
            if (ServletFileUpload.isMultipartContent(request)) {
                String strFolder = FileUtils.getTempDirectoryPath() + "/Generic_App_Uploads/";
                File folder = new File(strFolder);
                if (!folder.exists()) folder.mkdir();

                DiskFileItemFactory factory = new DiskFileItemFactory();

                ServletFileUpload upload = new ServletFileUpload(factory);

                List<FileItem> items = upload.parseRequest(request);
                Iterator iter = items.iterator();
                while (iter.hasNext()) {
                    FileItem item = (FileItem) iter.next();
                    String fieldName = item.getFieldName();
                    if (!item.isFormField()) {
                        String fileName = item.getName();
                        if ((fileName == null) || (fileName.isEmpty())) {
                            return false;
                        }
                        String contentType = item.getContentType();
                        if (!contentType.equalsIgnoreCase("text/plain")) {
                            return false;
                        }
                        boolean isInMemory = item.isInMemory();
                        long sizeInBytes = item.getSize();
                        int nIndexFilePart = fileName.lastIndexOf('/', fileName.length());

                        Calendar cal = Calendar.getInstance();
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy-HH-mm-ss-", Locale.ENGLISH);
                        String strCurTime = sdf.format(cal.getTime());
                        strCurTime = strCurTime + fileName.substring(nIndexFilePart + 1);
                        strFilePart = strFolder + strCurTime;
                        File uploadedFile = new File(strFilePart);
                        item.write(uploadedFile);
                    } else {
                        String strValue = item.getString();
                        if ((strValue != null) && (!strValue.isEmpty()) && (!strValue.equalsIgnoreCase("null"))) {
                            if (fieldName.equalsIgnoreCase("batch_supplied_by")) {
                                m_nSupplierID = Integer.parseInt(strValue);
                            } else if (fieldName.equalsIgnoreCase("product_name")) {
                                m_nProductID = Integer.parseInt(strValue);
                            } else if (fieldName.equalsIgnoreCase("product_sale_id")) {
                                m_nSaleInfoID = Integer.parseInt(strValue);
                            } else if (fieldName.equalsIgnoreCase("batch_id")) {
                                m_strBatchID = strValue;
                            } else if (fieldName.equalsIgnoreCase("quantity")) {
                                m_nQuantity = Integer.parseInt(strValue);
                            } else if (fieldName.equalsIgnoreCase("unit_purchase_price")) {
                                m_fUnitPurchasePrice = Float.parseFloat(strValue);
                            } else if (fieldName.equalsIgnoreCase("probable_sale_price")) {
                                m_fProbableSalePrice = Float.parseFloat(strValue);
                            } else if (fieldName.equalsIgnoreCase("batch_arrival_date")) {
                                SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
                                m_dtArrivalDate = dt.parse(strValue);
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                m_strArrivalDate = sdf.format(m_dtArrivalDate);
                            } else if (fieldName.equalsIgnoreCase("batch_expiry_date")) {
                                SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
                                m_dtExpiryDate = dt.parse(strValue);
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                m_strExpiryDate = sdf.format(m_dtExpiryDate);
                            } else if (fieldName.equalsIgnoreCase("batch_activiated_by_supplier")) {
                                m_bBatchActivatedBySupplier = false;
                                if (strValue.equalsIgnoreCase("on")) {
                                    m_bBatchActivatedBySupplier = true;
                                }
                            } else if (fieldName.equalsIgnoreCase("batch_ready_to_sell")) {
                                m_bBatchReadyToSell = false;
                                if (strValue.equalsIgnoreCase("on")) {
                                    m_bBatchReadyToSell = true;
                                }
                            } else if (fieldName.equalsIgnoreCase("batch_created_by")) {
                                m_strBatchCreatedBy = strValue;
                            } else if (fieldName.equalsIgnoreCase("additional_info")) {
                                strAdditionalInfo = strValue;
                            } else if (fieldName.equalsIgnoreCase("notes")) {
                                strNotes = strValue;
                            } else if (fieldName.equalsIgnoreCase("batch_payment_date")) {
                                SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
                                m_dtPaymentDate = dt.parse(strValue);
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                m_strPaymentDate = sdf.format(m_dtPaymentDate);
                            } else if (fieldName.equalsIgnoreCase("paid_to_supplier")) {
                                if (strValue.equalsIgnoreCase("on")) {
                                    m_nPaidToSupplier = 1;
                                }
                            } else if (fieldName.equalsIgnoreCase("batch_cost")) {
                                m_fPaymentToSupplier = Float.parseFloat(strValue);
                            } else if (fieldName.equalsIgnoreCase("max_topus")) {
                                nMaxTopups = Integer.parseInt(strValue);
                            }
                        }
                    }
                }
            }
            if (m_nPaidToSupplier != 1) {
                m_strPaymentDate = "";
            }
            strFilePart = strFilePart.replace('\\', '/');

            String strQuery = "insert into t_batch_information (Batch_ID, Supplier_ID, Product_ID, Sale_Info_ID, Quantity, Available_Quantity, Unit_Purchase_Price, Probable_Sale_Price, Batch_Arrival_Date, Batch_Expiry_Date,Batch_Entry_Time, Batch_Created_By, Batch_Activated_By_Supplier,Batch_Ready_To_Sell, IsBatchActive, Additional_Info, Notes,Batch_File_Path, Batch_Upload_Status, LastModifiedTime, Batch_Cost, Paid_To_Supplier, Payment_Date_To_Supplier) values('"
                +
                m_strBatchID
                + "',"
                + m_nSupplierID
                + ","
                + m_nProductID
                + ","
                + m_nSaleInfoID
                + ","
                + m_nQuantity
                + ","
                + m_nQuantity
                + ","
                + m_fUnitPurchasePrice
                + ","
                + m_fProbableSalePrice
                + ",'"
                + m_strArrivalDate
                + "', '"
                + m_strExpiryDate
                + "', now(), '"
                + m_strBatchCreatedBy
                + "',"
                + m_bBatchActivatedBySupplier
                + ","
                + m_bBatchReadyToSell
                + ", 0, '"
                + strAdditionalInfo
                + "', '"
                + strNotes
                + "', '"
                + strFilePart
                + "', 'FileUploaded', now(), " + m_fPaymentToSupplier + ", " + m_nPaidToSupplier;
            if ((m_strPaymentDate != null) && (!m_strPaymentDate.isEmpty())) {
                strQuery = strQuery + ", '" + m_strPaymentDate + "')";
            } else {
                strQuery = strQuery + ", null)";
            }
            DatabaseHelper dbHelper = new DatabaseHelper();
            int nSequenceID = dbHelper.insertAndGetBatchSequenceID(strQuery);

            Session theSession = null;
            if (nSequenceID > 0) {
                strQuery = "from TMasterProductinfo where Product_ID = " + m_nProductID;
                List prodList = null;
                try {
                    theSession = HibernateUtil.openSession();
                    Query query = theSession.createQuery(strQuery);
                    prodList = query.list();
                    boolean bSIMCards = false;
                    if (((prodList != null ? 1 : 0) & (prodList.size() > 0 ? 1 : 0)) != 0) {
                        TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);
                        if (prodInfo.getProductType().getId() == 17) {
                            bSIMCards = true;
                        }
                    }
                    if (!bSIMCards) {
                        BatchProcessing batchProcessing = new BatchProcessing(strFilePart);
                        batchProcessing.setSequenceID(nSequenceID);
                        batchProcessing.setBatchID(m_strBatchID);
                        batchProcessing.setProductID(m_nProductID);
                        new Thread(batchProcessing).start();
                    } else if (bSIMCards) {
                        SIMBatchProcessing simBatchProcessing = new SIMBatchProcessing(strFilePart);
                        simBatchProcessing.setSequenceID(nSequenceID);
                        simBatchProcessing.setBatchID(m_strBatchID);
                        simBatchProcessing.setProductID(m_nProductID);
                        simBatchProcessing.setMaxTopups(nMaxTopups);
                        new Thread(simBatchProcessing).start();
                    }
                } finally {
                    HibernateUtil.closeSession(theSession);
                }
            } else {
                throw new Exception();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
