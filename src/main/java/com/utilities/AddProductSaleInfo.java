package com.utilities;

import com.commons.DatabaseHelper;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

public class AddProductSaleInfo {
    String m_strCountry;

    public void setCountry(String strCountry) {
        this.m_strCountry = strCountry;
    }

    public boolean processData(HttpServletRequest request) {
        int nProductID = 0;
        String strNotes = null;
        String strPrintInfo = null;
        String strCreatedBy = null;
        String strNewFileName = null;

        String strFilePart = null;
        try {
            if (ServletFileUpload.isMultipartContent(request)) {
                String strDBFoloder = new String("/Product_Images/");
                String strFolder = new String(ImageUpload.m_strImageFolder);
                String strOldFolder = new String(ImageUpload.m_strImageFolderOld);

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
                            strNewFileName = fileName;
                            String contentType = item.getContentType();
                            if ((!contentType.equalsIgnoreCase("image/jpeg")) && (!contentType.equalsIgnoreCase("image/pjpeg"))) {
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
                            strFilePart = strFolder + strCurTime;
                            File uploadedFile = new File(strFilePart);
                            item.write(uploadedFile);
                        }
                    } else {
                        String strValue = item.getString();
                        if ((strValue != null) && (!strValue.isEmpty()) && (!strValue.equalsIgnoreCase("null"))) {
                            if (fieldName.equalsIgnoreCase("product_id")) {
                                nProductID = Integer.parseInt(strValue);
                            } else if (fieldName.equalsIgnoreCase("notes")) {
                                strNotes = strValue;
                            } else if (fieldName.equalsIgnoreCase("print_info")) {
                                strPrintInfo = strValue;
                            } else if (fieldName.equalsIgnoreCase("created_by")) {
                                strCreatedBy = strValue;
                            }
                        }
                    }
                }
                if ((strNewFileName == null) || (strNewFileName.isEmpty())) {
                    strDBFoloder = null;
                }
                String strQuery = "insert into t_master_productsaleinfo (Product_ID, Print_Info, Product_Image_File, IsActive, CreationTime, CreatedBy, ModifiedTime, Notes) values ("
                        + nProductID
                        + ", '"
                        + strPrintInfo
                        + "', '"
                        + strDBFoloder
                        + "', 1, now(), '"
                        + strCreatedBy
                        + "', now(), '"
                        + strNotes + "')";

                DatabaseHelper dbHelper = new DatabaseHelper();
                if (!dbHelper.executeQuery(strQuery)) {
                    throw new Exception();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
