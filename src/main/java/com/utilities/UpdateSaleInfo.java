package com.utilities;

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

public class UpdateSaleInfo {
	private String m_strCountry = "";

	public void setCountry(String strCountry) {
		this.m_strCountry = strCountry;
	}

	public boolean processData(HttpServletRequest request) {
		int nSaleInfoID = 0;
		int nProductID = 0;
		String strTollFreeNo1 = null;
		String strTollFreeNo2 = null;
		String strLocalAcessNo1 = null;
		String strLocalAcessNo2 = null;
		String strNationalAcessNo1 = null;
		String strNationalAcessNo2 = null;
		String strPayPhoneAcessNo1 = null;
		String strPayPhoneAcessNo2 = null;
		String strOtherAcessNo1 = null;
		String strOtherAcessNo2 = null;
		String strSupportNo1 = null;
		String strSupportNo2 = null;
		String strSaleRules = null;
		String strAditionalInfo = null;
		String strPrintInfo = null;
		String strNotes = null;
		String strNewFileName = null;

		String strFilePart = null;
		Session theSession = null;
		try {
			if (ServletFileUpload.isMultipartContent(request)) {
				String strDBFoloder = new String("/Product_Images/");
				//String strDBFoloder = new String("/new_images/");
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
							if ((!contentType.equalsIgnoreCase("image/jpeg")) && (!contentType.equalsIgnoreCase("image/jpg")) && (!contentType.equalsIgnoreCase("image/pjpeg"))) {
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
							if (fieldName.equalsIgnoreCase("record_id")) {
								nSaleInfoID = Integer.parseInt(strValue);
							} else if (fieldName.equalsIgnoreCase("product_id")) {
								nProductID = Integer.parseInt(strValue);
							} else if (fieldName.equalsIgnoreCase("toll_free_number_1")) {
								strTollFreeNo1 = strValue;
							} else if (fieldName.equalsIgnoreCase("toll_free_number_2")) {
								strTollFreeNo2 = strValue;
							} else if (fieldName.equalsIgnoreCase("local_access_number_1")) {
								strLocalAcessNo1 = strValue;
							} else if (fieldName.equalsIgnoreCase("local_access_number_2")) {
								strLocalAcessNo2 = strValue;
							} else if (fieldName.equalsIgnoreCase("national_access_number_1")) {
								strNationalAcessNo1 = strValue;
							} else if (fieldName.equalsIgnoreCase("national_access_number_2")) {
								strNationalAcessNo2 = strValue;
							} else if (fieldName.equalsIgnoreCase("payphone_access_number_1")) {
								strPayPhoneAcessNo1 = strValue;
							} else if (fieldName.equalsIgnoreCase("payphone_access_number_2")) {
								strPayPhoneAcessNo2 = strValue;
							} else if (fieldName.equalsIgnoreCase("other_access_number_1")) {
								strOtherAcessNo1 = strValue;
							} else if (fieldName.equalsIgnoreCase("other_access_number_2")) {
								strOtherAcessNo2 = strValue;
							} else if (fieldName.equalsIgnoreCase("customer_support_number_1")) {
								strSupportNo1 = strValue;
							} else if (fieldName.equalsIgnoreCase("customer_support_number_2")) {
								strSupportNo2 = strValue;
							} else if (fieldName.equalsIgnoreCase("sale_rules")) {
								strSaleRules = strValue;
							} else if (fieldName.equalsIgnoreCase("addtional_information")) {
								strAditionalInfo = strValue;
							} else if (fieldName.equalsIgnoreCase("print_info")) {
								strPrintInfo = strValue;
							} else if (fieldName.equalsIgnoreCase("notes")) {
								strNotes = strValue;
							}
						}
					}
				}
				String strQuery = "update t_master_productsaleinfo set Product_ID = " + nProductID
						+ ",  Toll_Free_Number_1 = '" + strTollFreeNo1 + "', Toll_Free_Number_2 = '" + strTollFreeNo2
						+ "', Local_Acess_Number_1 = '" + strLocalAcessNo1 + "', Local_Acess_Number_2 = '" + strLocalAcessNo2
						+ "', National_Acess_Number_1 = '" + strNationalAcessNo1 + "', National_Acess_Number_2 = '"
						+ strNationalAcessNo2 + "', PayPhone_Acess_Number_1 = '" + strPayPhoneAcessNo1
						+ "', PayPhone_Acess_Number_2 = '" + strPayPhoneAcessNo2 + "', Other_Acess_Number_1 = '" + strOtherAcessNo1
						+ "', Other_Acess_Number_2 = '" + strOtherAcessNo2 + "', Support_Number_1 = '" + strSupportNo1
						+ "', Support_Number_2 = '" + strSupportNo2 + "', Sale_Rules = '" + strSaleRules + "', AdditionalInfo = '"
						+ strAditionalInfo + "', Print_Info = '" + strPrintInfo + "', Notes = '" + strNotes + "'";
				theSession = HibernateUtil.openSession();
				theSession.beginTransaction();
				if ((strNewFileName != null) && (!strNewFileName.isEmpty())) {
					String strQuery1 = "select Product_Image_File from t_master_productsaleinfo where Sale_Info_ID = "
							+ nSaleInfoID;
					SQLQuery query = theSession.createSQLQuery(strQuery1);
					List listResults = query.list();
					if (listResults.size() < 0) {
						throw new Exception();
					}
					Object oneResult = listResults.get(0);
					if (oneResult == null) {
						throw new Exception();
					}
					String dbFile = oneResult.toString();
					if ((dbFile != null) && (!dbFile.isEmpty())) {
						dbFile = dbFile.substring(dbFile.lastIndexOf('/') + 1);
						String sourceFile = strFolder + dbFile;
						String destinationFile = strOldFolder + dbFile;

						File f = new File(sourceFile);
						f.renameTo(new File(destinationFile));
					}
					strQuery = strQuery + ", Product_Image_File = '" + strDBFoloder + "'";
				}
				strQuery = strQuery + " where Sale_Info_ID = " + nSaleInfoID;
				SQLQuery query1 = theSession.createSQLQuery(strQuery);
				query1.executeUpdate();

				theSession.getTransaction().commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
			theSession.getTransaction().rollback();
			return false;
		} finally {
			HibernateUtil.closeSession(theSession);
		}
		return true;
	}
}
