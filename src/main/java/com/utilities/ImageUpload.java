package com.utilities;

import com.commons.DatabaseHelper;
import com.eezeetel.util.HibernateUtil;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

public class ImageUpload {
    public static String m_strImageFolder = "D:\\Installations\\Tomcat\\Product_Images\\";
    //public static String m_strImageFolder = "/var/www/html/new_images/";
    public static String m_strImageFolder1 = "/home/yamuna/Data/installations/webserver/common_app_files/Product_Images/";
    public static String m_strImageFolderOld = m_strImageFolder;
    private String m_strCountry = "";

    public void setCountry(String strCountry) {
        this.m_strCountry = strCountry;
    }

    public boolean processData(HttpServletRequest request) {
        int m_nSaleInfoID = 0;
        String strFilePart = null;
        Session theSession = null;
        try {
            if (ServletFileUpload.isMultipartContent(request)) {
                String strDBFoloder = new String("/Product_Images/");
                //String strDBFoloder = new String("/new_images/");
                String strFolder = new String(m_strImageFolder);
                String strOldFolder = new String(m_strImageFolderOld);
                DiskFileItemFactory factory = new DiskFileItemFactory();

                ServletFileUpload upload = new ServletFileUpload(factory);

                List<FileItem> items = upload.parseRequest(request);
                Iterator iter = items.iterator();
                while (iter.hasNext()) {
                    FileItem item = (FileItem) iter.next();
                    String fieldName = item.getFieldName();
                    if (!item.isFormField()) {
                        String fileName = item.getName();
                        String contentType = item.getContentType();
                        if ((!contentType.equalsIgnoreCase("image/jpeg")) && (!contentType.equalsIgnoreCase("image/pjpeg"))) {
                            return false;
                        }
                        boolean isInMemory = item.isInMemory();
                        long sizeInBytes = item.getSize();
                        int nIndexFilePart = fileName.lastIndexOf('\\', fileName.length());

                        Calendar cal = Calendar.getInstance();
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy-HH-mm-ss-");
                        String strCurTime = sdf.format(cal.getTime());
                        strCurTime = strCurTime + fileName.substring(nIndexFilePart + 1);
                        strDBFoloder = strDBFoloder + strCurTime;
                        strFilePart = strFolder + strCurTime;
                        File uploadedFile = new File(strFilePart);
                        item.write(uploadedFile);
                    } else {
                        String strValue = item.getString();
                        if ((strValue != null) && (!strValue.isEmpty()) && (!strValue.equalsIgnoreCase("null"))) {
                            if (fieldName.equalsIgnoreCase("sale_info_id")) {
                                m_nSaleInfoID = Integer.parseInt(strValue);
                            }
                        }
                    }
                }
                strFilePart = strFilePart.replace('\\', '/');

                String strCurrentDir = System.getProperty("user.dir");

                theSession = HibernateUtil.openSession();
                theSession.beginTransaction();

                String strQuery = "select Product_Image_File from t_master_productsaleinfo where Sale_Info_ID = "
                        + m_nSaleInfoID;
                SQLQuery query = theSession.createSQLQuery(strQuery);
                List listResults = query.list();
                if (listResults.size() < 0) {
                    throw new Exception();
                }
                Object oneResult = listResults.get(0);
                if (oneResult == null) {
                    throw new Exception();
                }
                String dbFile = oneResult.toString();
                dbFile = dbFile.substring(dbFile.lastIndexOf('/') + 1);
                String sourceFile = strFolder + dbFile;
                String destinationFile = strOldFolder + dbFile;

                File f = new File(sourceFile);
                f.renameTo(new File(destinationFile));

                strQuery = "update t_master_productsaleinfo set Product_Image_File='" + strDBFoloder + "'"
                        + " where Sale_Info_ID = " + m_nSaleInfoID;
                query = theSession.createSQLQuery(strQuery);
                query.executeUpdate();

                theSession.getTransaction().commit();
            }
        } catch (Exception e) {
            theSession.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean uploadSupplierImage(HttpServletRequest request, boolean bIsNew) {
        String strFilePart = null;

        boolean imageUplaoded = false;
        String strSupplierName = "";
        int nSupplierTypeID = 0;
        String strSupplierContact = "";
        String strAddressLine1 = "";
        String strAddressLine2 = "";
        String strAddressLine3 = "";
        int record_id = 0;
        String strCity = "";
        String strState = "";
        String strPostalCode = "";
        String strCountry = "";
        String strPrimaryPhone = "";
        String strSecondaryPhone = "";
        String strMobilePhone = "";
        String strWebsiteAddress = "";
        String strEmailId = "";
        String strSupplierIntroducedBy = "";
        String strAdditionalNotes = "";
        short nSecondarySupplier = 0;
        String strSupplierCreatedBy = "";
        try {
            if (ServletFileUpload.isMultipartContent(request)) {
                //String strDBFoloder = new String("/Product_Images/");
                String strDBFoloder = new String("/new_images/");
                String strFolder = new String(m_strImageFolder);
                String strOldFolder = new String(m_strImageFolderOld);
                DiskFileItemFactory factory = new DiskFileItemFactory();

                ServletFileUpload upload = new ServletFileUpload(factory);

                List<FileItem> items = upload.parseRequest(request);
                Iterator iter = items.iterator();
                while (iter.hasNext()) {
                    FileItem item = (FileItem) iter.next();
                    String fieldName = item.getFieldName();
                    if (!item.isFormField()) {
                        String fileName = item.getName();
                        if ((fileName != null) && (!fileName.isEmpty())) {
                            String contentType = item.getContentType();
                            if ((!contentType.equalsIgnoreCase("image/jpeg")) && (!contentType.equalsIgnoreCase("image/pjpeg"))
                                    && (!contentType.equalsIgnoreCase("image/png"))) {
                                return false;
                            }
                            boolean isInMemory = item.isInMemory();
                            long sizeInBytes = item.getSize();
                            int nIndexFilePart = fileName.lastIndexOf('\\', fileName.length());

                            Calendar cal = Calendar.getInstance();
                            SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy-HH-mm-ss-", Locale.UK);
                            String strCurTime = sdf.format(cal.getTime());
                            strCurTime = strCurTime + fileName.substring(nIndexFilePart + 1);
                            strDBFoloder = strDBFoloder + strCurTime;
                            strFilePart = strFolder + "/" + strCurTime;
                            File uploadedFile = new File(strFilePart);
                            item.write(uploadedFile);
                            imageUplaoded = true;
                        }
                    } else {
                        String strValue = item.getString();
                        if ((strValue != null) && (!strValue.isEmpty()) && (!strValue.equalsIgnoreCase("null"))) {
                            if (fieldName.equalsIgnoreCase("supplier_name")) {
                                strSupplierName = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("supplier_type_id")) {
                                nSupplierTypeID = Integer.parseInt(strValue);
                            }
                            if (fieldName.equalsIgnoreCase("supplier_contact")) {
                                strSupplierContact = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("address_line_1")) {
                                strAddressLine1 = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("address_line_2")) {
                                strAddressLine2 = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("address_line_3")) {
                                strAddressLine3 = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("record_id")) {
                                record_id = Integer.parseInt(strValue);
                            }
                            if (fieldName.equalsIgnoreCase("city")) {
                                strCity = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("state")) {
                                strState = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("postal_code")) {
                                strPostalCode = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("country")) {
                                strCountry = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("primary_phone")) {
                                strPrimaryPhone = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("secondary_phone")) {
                                strSecondaryPhone = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("mobile_phone")) {
                                strMobilePhone = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("website_address")) {
                                strWebsiteAddress = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("email_id")) {
                                strEmailId = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("supplier_introduced_by")) {
                                strSupplierIntroducedBy = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("additional_notes")) {
                                strAdditionalNotes = strValue;
                            }
                            if (fieldName.equalsIgnoreCase("second_hand_supplier")) {
                                String strSecondarySupplier = strValue;
                                if ((strSecondarySupplier != null) && (strSecondarySupplier.equalsIgnoreCase("on"))) {
                                    nSecondarySupplier = 1;
                                }
                            }
                            if (fieldName.equalsIgnoreCase("supplier_created_by")) {
                                strSupplierCreatedBy = strValue;
                            }
                        }
                    }
                }
                String imgUpdatePath = "";
                if (imageUplaoded) {
                    imgUpdatePath = ", Supplier_Image = '" + strDBFoloder + "'";
                } else {
                    strDBFoloder = "";
                }
                String strQuery = "";
                if (bIsNew) {
                    strQuery =

                            "insert into t_master_supplierinfo (Supplier_Name, Supplier_Type_ID, Supplier_Contact, Supplier_Address_Line_1, Supplier_Address_Line_2, Supplier_Address_Line_3, Supplier_City, Supplier_State, Supplier_Postal_Code, Supplier_Country, Supplier_Primary_Phone, Supplier_Secondary_Phone, Supplier_Mobile_Phone, Supplier_Website_Address, Supplier_Email_ID, Supplier_Introduced_By, Supplier_Active_Status, Supplier_Created_By_User_ID, Supplier_Info_Modified_Time, Supplier_Info_Creation_Time, Notes, Secondary_Supplier, Supplier_Image) values ('"
                                    + strSupplierName
                                    + "', "
                                    + nSupplierTypeID
                                    + ", '"
                                    + strSupplierContact
                                    + "', '"
                                    + strAddressLine1
                                    + "', '"
                                    + strAddressLine2
                                    + "', '"
                                    + strAddressLine3
                                    + "', '"
                                    + strCity
                                    + "', '"
                                    + strState
                                    + "', '"
                                    + strPostalCode
                                    + "', '"
                                    + strCountry
                                    + "', '"
                                    + strPrimaryPhone
                                    + "', '"
                                    + strSecondaryPhone
                                    + "', '"
                                    + strMobilePhone
                                    + "', '"
                                    + strWebsiteAddress
                                    + "', '"
                                    + strEmailId
                                    + "', '"
                                    + strSupplierIntroducedBy
                                    + "', 1, '"
                                    + strSupplierCreatedBy
                                    + "', now(), now(), '"
                                    + strAdditionalNotes
                                    + "', "
                                    + nSecondarySupplier + ", '" + strDBFoloder + "')";
                } else {
                    strQuery =

                            "update t_master_supplierinfo set Supplier_Name = '" + strSupplierName + "'," + "Supplier_Type_Id = "
                                    + nSupplierTypeID + "," + "Supplier_Contact = '" + strSupplierContact + "',"
                                    + "Supplier_Address_Line_1 = '" + strAddressLine1 + "'," + "Supplier_Address_Line_2 = '"
                                    + strAddressLine2 + "'," + "Supplier_Address_Line_3 = '" + strAddressLine3 + "'," + "Supplier_City = '"
                                    + strCity + "'," + "Supplier_State = '" + strState + "'," + "Supplier_Postal_Code = '" + strPostalCode
                                    + "'," + "Supplier_Country = '" + strCountry + "'," + "Supplier_Primary_Phone = '" + strPrimaryPhone
                                    + "'," + "Supplier_Secondary_Phone = '" + strSecondaryPhone + "'," + "Supplier_Mobile_Phone = '"
                                    + strMobilePhone + "'," + "Supplier_Website_Address = '" + strWebsiteAddress + "',"
                                    + "Supplier_Email_ID = '" + strEmailId + "'," + "Supplier_Introduced_By = '" + strSupplierIntroducedBy
                                    + "'," + "Supplier_Info_Modified_Time = now()" + "," + "Notes = '" + strAdditionalNotes + "', "
                                    + "Secondary_Supplier = " + nSecondarySupplier + imgUpdatePath + " where Supplier_ID = " + record_id;
                }
                DatabaseHelper dbHelper = new DatabaseHelper();
                if (dbHelper.executeQuery(strQuery)) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
