package com.utilities;

import com.eezeetel.entity.TExpenseTypes;
import com.eezeetel.entity.TMasterExpenses;
import com.eezeetel.util.HibernateUtil;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.hibernate.Session;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class ExpenseUpload {
	private String m_strCountry = "";
	public String m_strExpenseFoloder = "";

	public void setCountry(String strCountry) {
		this.m_strCountry = strCountry;
	}

	public boolean processData(HttpServletRequest request) {
		String strPurpose = "";
		String strAmount = "";
		String strTheYear = "";
		String strTheMonth = "";
		String strTheDay = "";
		String strFilePart = "";

		float fAmount = 0.0F;
		byte btype = 0;
		Date m_dtPaymentDate = null;
		Session theSession = null;

		String strDBFoloder = "";
		try {
			if (ServletFileUpload.isMultipartContent(request)) {
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
							boolean isInMemory = item.isInMemory();
							long sizeInBytes = item.getSize();
							int nIndexFilePart = fileName.lastIndexOf('/', fileName.length());

							Calendar cal = Calendar.getInstance();
							SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy-HH-mm-ss-");
							String strCurTime = sdf.format(cal.getTime());
							strCurTime = strCurTime + fileName.substring(nIndexFilePart + 1);
							strDBFoloder = strDBFoloder + "/Expenses/" + strCurTime;
							strFilePart = this.m_strExpenseFoloder + "/" + strCurTime;
							File uploadedFile = new File(strFilePart);
							item.write(uploadedFile);
						}
					} else {
						String strValue = item.getString();
						if ((strValue != null) && (!strValue.isEmpty()) && (!strValue.equalsIgnoreCase("null"))) {
							if (fieldName.equalsIgnoreCase("expense_purpose")) {
								strPurpose = strValue;
							} else if (fieldName.equalsIgnoreCase("expense_amount")) {
								fAmount = Float.parseFloat(strValue);
							} else if (fieldName.equalsIgnoreCase("the_year")) {
								strTheYear = strValue;
							} else if (fieldName.equalsIgnoreCase("the_month")) {
								strTheMonth = strValue;
							} else if (fieldName.equalsIgnoreCase("the_day")) {
								strTheDay = strValue;
							} else if (fieldName.equalsIgnoreCase("expense_type")) {
								btype = Byte.parseByte(strValue);
							}
						}
					}
				}
				Calendar cal = Calendar.getInstance();
				cal.set(1, Integer.parseInt(strTheYear));
				cal.set(2, Integer.parseInt(strTheMonth));
				cal.set(5, Integer.parseInt(strTheDay));
				cal.set(11, 0);
				cal.set(12, 0);
				cal.set(13, 0);
				m_dtPaymentDate = cal.getTime();
			}
			strDBFoloder = strDBFoloder.replace('\\', '/');

			TMasterExpenses theExpense = new TMasterExpenses();
			theExpense.setId(Integer.valueOf(0));
			theExpense.setExpensePurpose(strPurpose);
			TExpenseTypes expenseType = new TExpenseTypes();
			expenseType.setId(Byte.valueOf(btype));
			theExpense.setExpenseType(expenseType);
			theExpense.setPaymentAmount(fAmount);
			theExpense.setPaymentDate(m_dtPaymentDate);
			theExpense.setReceiptPath(strDBFoloder);

			theSession = HibernateUtil.openSession();
			theSession.beginTransaction();

			theSession.save(theExpense);

			theSession.getTransaction().commit();
		} catch (Exception e) {
			if (theSession != null) {
				theSession.getTransaction().rollback();
			}
			e.printStackTrace();
			return false;
		} finally {
			HibernateUtil.closeSession(theSession);
		}
		return true;
	}
}
