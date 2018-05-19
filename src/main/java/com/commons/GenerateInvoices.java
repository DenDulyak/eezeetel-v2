package com.commons;

import com.eezeetel.entity.*;
import com.eezeetel.util.HibernateUtil;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.StandardBasicTypes;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

public class GenerateInvoices {
	private int m_nStartYear = 0;
	private int m_nStartMonth = 0;
	private int m_nEndYear = 0;
	private int m_nEndMonth = 0;
	private String m_strRootFolder = "";
	private boolean m_bGenerateHTMLOutput = false;
	private boolean m_bGenerateHTMLFiles = false;
	private int m_nCustomerID = 0;
	private String m_strDurationBegin = "";
	public String m_strDisplayDurationBegin = "";
	private String m_strDurationEnd = "";
	public String m_strDisplayDurationEnd = "";
	private String m_strCustomers = "";
	private String m_strAgents = "";
	private String m_strGroups = "";
	public String m_strInvoiceReport = "";
	public int m_nCustomerTotalCards = 0;
	public float m_fCustomerTotal = 0.0F;
	public float m_fCustomerTotalCommission = 0.0F;
	public float m_fAgentTotalCommission = 0.0F;
	public float m_fGroupTotalCommission = 0.0F;
	public float m_fCustomerTotalNonVAT = 0.0F;
	public float m_fCustomerTotalVAT = 0.0F;
	public String m_strAgentName = "";
	private boolean m_bGenerateGroupInvoices = false;
	private boolean m_bGenerateAgentInvoices = false;
	private String m_strCountry;

	public void setCountry(String strCountry) {
		this.m_strCountry = strCountry;
	}

	public String getCountry() {
		return this.m_strCountry;
	}

	public GenerateInvoices() {
		this.m_nStartYear = 2009;
		this.m_nStartMonth = 1;
		this.m_nEndYear = 2009;
		this.m_nEndMonth = 1;
		this.m_bGenerateHTMLOutput = false;
		this.m_bGenerateHTMLFiles = false;
		this.m_nCustomerID = 0;
		this.m_strRootFolder = "./Invoices/";
		this.m_strDurationBegin = "";
		this.m_strDisplayDurationBegin = "";
		this.m_strDurationEnd = "";
		this.m_strDisplayDurationEnd = "";
		this.m_strCustomers = "";
		this.m_strAgents = "";
		this.m_strGroups = "";
		this.m_strAgentName = "";

		this.m_strInvoiceReport = "";
		this.m_nCustomerTotalCards = 0;
		this.m_fCustomerTotalNonVAT = 0.0F;
		this.m_fCustomerTotalVAT = 0.0F;
		this.m_fCustomerTotal = 0.0F;
		this.m_fCustomerTotalCommission = 0.0F;
		this.m_fAgentTotalCommission = 0.0F;
		this.m_fGroupTotalCommission = 0.0F;
		this.m_bGenerateGroupInvoices = false;
	}

	public void setDuration(int nStartYear, int nStartMonth, int nEndYear, int nEndMonth) {
		this.m_nStartYear = nStartYear;
		this.m_nStartMonth = nStartMonth;
		this.m_nEndYear = nEndYear;
		this.m_nEndMonth = nEndMonth;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MMM-dd");

		Calendar startCal = Calendar.getInstance();
		startCal.set(this.m_nStartYear, this.m_nStartMonth, 1, 0, 0, 0);
		this.m_strDurationBegin = ("'" + sdf.format(startCal.getTime()) + "'");
		this.m_strDisplayDurationBegin = df.format(startCal.getTime());

		Calendar endCal = Calendar.getInstance();
		endCal.set(this.m_nEndYear, this.m_nEndMonth, 1, 0, 0, 0);
		int nMaxDay = endCal.getActualMaximum(5);
		endCal.set(this.m_nEndYear, this.m_nEndMonth, nMaxDay, 23, 59, 59);

		this.m_strDurationEnd = ("'" + sdf.format(endCal.getTime()) + "'");
		this.m_strDisplayDurationEnd = df.format(endCal.getTime());
	}

	public void setGenerateHTMLOutput(boolean bValue) {
		this.m_bGenerateHTMLOutput = bValue;
	}

	public void setCustomerID(int nCustomerID) {
		this.m_nCustomerID = nCustomerID;
		this.m_strAgentName = "";
	}

	public void setGenerateGroupInvoices(boolean bValue) {
		this.m_bGenerateGroupInvoices = bValue;
	}

	public void setGenerateAgentInvoices(boolean bValue) {
		this.m_bGenerateAgentInvoices = bValue;
	}

	public void setRootFolder(String strRootFolder) {
		this.m_strRootFolder = strRootFolder;
		this.m_bGenerateHTMLFiles = true;
		this.m_bGenerateHTMLOutput = true;

		Calendar startCal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd__HH_mm_ss");
		String strDirName = sdf.format(startCal.getTime());

		this.m_strCustomers = (this.m_strRootFolder + strDirName + "\\Customers\\");
		this.m_strAgents = (this.m_strRootFolder + strDirName + "\\Agents\\");
		this.m_strGroups = (this.m_strRootFolder + strDirName + "\\Groups\\");

		File customersFolder = new File(this.m_strCustomers);
		customersFolder.mkdirs();
		File groupsFolder = new File(this.m_strGroups);
		groupsFolder.mkdirs();
		File agentsFolder = new File(this.m_strAgents);
		agentsFolder.mkdirs();
	}

	public void createInvoice() {
		if (this.m_nCustomerID <= 0) {
			return;
		}
		this.m_strInvoiceReport = "";
		this.m_nCustomerTotalCards = 0;
		this.m_fCustomerTotalNonVAT = 0.0F;
		this.m_fCustomerTotalVAT = 0.0F;
		this.m_fCustomerTotal = 0.0F;
		this.m_fCustomerTotalCommission = 0.0F;
		this.m_fAgentTotalCommission = 0.0F;
		this.m_fGroupTotalCommission = 0.0F;
		this.m_strAgentName = "";

		DecimalFormat ff = new DecimalFormat("0.00");
		Session theSession = null;
		try {
			theSession = HibernateUtil.openSession();
			theSession.beginTransaction();

			String strQuery = "from TMasterCustomerinfo where Customer_ID = " + this.m_nCustomerID;
			Query query = theSession.createQuery(strQuery);
			List custList = query.list();
			if (custList.size() < 0) {
				theSession.getTransaction().commit();
				this.m_nCustomerID = 0;
				return;
			}
			TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
			User introducedBy = custInfo.getIntroducedBy();
			this.m_strAgentName = introducedBy.getUserFirstName();

			String strInvoiceReport = "";
			if (this.m_bGenerateHTMLOutput) {
				strInvoiceReport = PrepareInvoiceHeader(custInfo);
			}
			String strFileName = "Unknown.html";
			if (this.m_bGenerateHTMLFiles) {
				if (this.m_bGenerateGroupInvoices) {
					strFileName = this.m_strGroups + custInfo.getCompanyName() + ".html";
				} else if (this.m_bGenerateAgentInvoices) {
					strFileName = this.m_strAgents + custInfo.getCompanyName() + ".html";
				} else {
					strFileName = this.m_strCustomers + custInfo.getCompanyName() + ".html";
				}
			}
			strQuery = "call SP_Customer_Invoice_Report(" + custInfo.getId() + "," + this.m_strDurationBegin + ","
					+ this.m_strDurationEnd + ")";

			SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
			sqlQuery.addScalar("Product_ID", StandardBasicTypes.INTEGER);
			sqlQuery.addScalar("Probable_Sale_Price", StandardBasicTypes.FLOAT);
			sqlQuery.addScalar("Total_Amount", StandardBasicTypes.FLOAT);
			sqlQuery.addScalar("Total_Second_Amount", StandardBasicTypes.FLOAT);
			sqlQuery.addScalar("Total_Group_Amount", StandardBasicTypes.FLOAT);
			sqlQuery.addScalar("Total_Transactions", StandardBasicTypes.INTEGER);
			sqlQuery.addScalar("Total_Cards", StandardBasicTypes.INTEGER);

			List invoiceReport = sqlQuery.list();

			int nSubTotalCards = 0;
			float fSubTotalNonVAT = 0.0F;
			float fSubTotalVAT = 0.0F;
			float fSubTotal = 0.0F;
			float fSubCommission = 0.0F;
			float fSubAgentCommission = 0.0F;
			float fSubGroupCommission = 0.0F;
			String strReportRows = "";

			int nSequence = 0;
			for (int i = 0; i < invoiceReport.size(); i++) {
				Object[] oneRecord = (Object[]) invoiceReport.get(i);
				if (oneRecord.length > 0) {
					Integer nProductID = (Integer) oneRecord[0];
					Float fProbableSalePrice = (Float) oneRecord[1];
					Float fTotalAmount = (Float) oneRecord[2];
					Float fSecondaryTotalAmount = (Float) oneRecord[3];
					Float fGroupTotalAmount = (Float) oneRecord[4];
					Integer nTransactions = (Integer) oneRecord[5];
					Integer nCards = (Integer) oneRecord[6];
					if (fProbableSalePrice == null) {
						fProbableSalePrice = Float.valueOf(0.0F);
					}
					if (fTotalAmount == null) {
						fTotalAmount = Float.valueOf(0.0F);
					}
					if (fSecondaryTotalAmount == null) {
						fSecondaryTotalAmount = Float.valueOf(0.0F);
					}
					if (fGroupTotalAmount == null) {
						fGroupTotalAmount = Float.valueOf(0.0F);
					}
					if (nTransactions == null) {
						nTransactions = Integer.valueOf(0);
					}
					if (nCards == null) {
						nCards = Integer.valueOf(0);
					}
					String strProductName = "";
					float fFaceValue = 0.0F;

					strQuery = "from TMasterProductinfo where Product_ID = " + nProductID;
					query = theSession.createQuery(strQuery);
					List productList = query.list();
					if (productList.size() > 0) {
						TMasterProductinfo prodInfo = (TMasterProductinfo) productList.get(0);
						TMasterSupplierinfo supInfo = prodInfo.getSupplier();
						if (supInfo.getId().intValue() == 15) {
							nSequence++;
							strProductName = prodInfo.getProductName();
							fFaceValue = prodInfo.getProductFaceValue();
						}
					} else {
						Float fNonVATAmount = Float.valueOf(fTotalAmount.floatValue());
						Float fVATAmount = Float.valueOf(0.0F);
						Float fCommissionAmount = Float.valueOf(fProbableSalePrice.floatValue() * nCards.intValue()
								- fTotalAmount.floatValue());

						strReportRows = strReportRows + "<tr bgcolor=E1E1E1>";
						strReportRows = strReportRows + "<td align=left>" + nSequence + "</td>";
						strReportRows = strReportRows + "<td align=left>" + strProductName + " - " + ff.format(fFaceValue)
								+ "</td>";
						strReportRows = strReportRows + "<td align=left>" + ff.format(fProbableSalePrice) + "</td>";
						strReportRows = strReportRows + "<td align=left>" + nCards + "</td>";
						strReportRows = strReportRows + "<td align=left>" + ff.format(fTotalAmount) + "</td>";
						strReportRows = strReportRows + "<td align=left>" + ff.format(fCommissionAmount) + "</td>";
						if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
							strReportRows = strReportRows + "<td align=left>"
									+ ff.format(fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue()) + "</td>";
						}
						if (this.m_bGenerateGroupInvoices) {
							strReportRows = strReportRows + "<td align=left>"
									+ ff.format(fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue()) + "</td>";
						}
						strReportRows = strReportRows + "</tr>";

						nSubTotalCards += nCards.intValue();
						fSubTotalNonVAT += fNonVATAmount.floatValue();
						fSubTotalVAT += fVATAmount.floatValue();
						fSubTotal += fTotalAmount.floatValue();
						fSubCommission += fCommissionAmount.floatValue();
						fSubAgentCommission += fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue();
						fSubGroupCommission += fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue();

						this.m_nCustomerTotalCards += nCards.intValue();
						this.m_fCustomerTotalNonVAT += fNonVATAmount.floatValue();
						this.m_fCustomerTotalVAT += fVATAmount.floatValue();
						this.m_fCustomerTotal += fTotalAmount.floatValue();
						this.m_fCustomerTotalCommission += fCommissionAmount.floatValue();
						this.m_fAgentTotalCommission += fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue();
						this.m_fGroupTotalCommission += fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue();
					}
				}
			}
			if (nSubTotalCards > 0) {
				strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
				strReportRows = strReportRows + "<tr bgcolor=E1E1E1><td></td><td> </td><td align=center><b>Sub Total</b></td>";
				strReportRows = strReportRows + "<td align=left><b>" + nSubTotalCards + "</b></td>";

				strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubTotal) + "</b></td>";
				strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";
				if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
					strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubAgentCommission) + "</b></td>";
				}
				if (this.m_bGenerateGroupInvoices) {
					strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubGroupCommission) + "</b></td>";
				}
				strReportRows = strReportRows + "</tr>";
				strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
			}
			if (this.m_bGenerateHTMLOutput) {
				strInvoiceReport = strInvoiceReport + strReportRows;
			}
			nSubTotalCards = 0;
			fSubTotalNonVAT = 0.0F;
			fSubTotalVAT = 0.0F;
			fSubTotal = 0.0F;
			fSubCommission = 0.0F;
			fSubAgentCommission = 0.0F;
			strReportRows = "";
			for (int i = 0; i < invoiceReport.size(); i++) {
				Object[] oneRecord = (Object[]) invoiceReport.get(i);
				if (oneRecord.length > 0) {
					Integer nProductID = (Integer) oneRecord[0];
					Float fProbableSalePrice = (Float) oneRecord[1];
					Float fTotalAmount = (Float) oneRecord[2];
					Float fSecondaryTotalAmount = (Float) oneRecord[3];
					Float fGroupTotalAmount = (Float) oneRecord[4];
					Integer nTransactions = (Integer) oneRecord[5];
					Integer nCards = (Integer) oneRecord[6];
					if (fProbableSalePrice == null) {
						fProbableSalePrice = Float.valueOf(0.0F);
					}
					if (fTotalAmount == null) {
						fTotalAmount = Float.valueOf(0.0F);
					}
					if (fSecondaryTotalAmount == null) {
						fSecondaryTotalAmount = Float.valueOf(0.0F);
					}
					if (fGroupTotalAmount == null) {
						fGroupTotalAmount = Float.valueOf(0.0F);
					}
					if (nTransactions == null) {
						nTransactions = Integer.valueOf(0);
					}
					if (nCards == null) {
						nCards = Integer.valueOf(0);
					}
					String strProductName = "";
					float fFaceValue = 0.0F;

					strQuery = "from TMasterProductinfo where Product_ID = " + nProductID;
					query = theSession.createQuery(strQuery);
					List productList = query.list();
					if (productList.size() > 0) {
						TMasterProductinfo prodInfo = (TMasterProductinfo) productList.get(0);
						TMasterSupplierinfo supInfo = prodInfo.getSupplier();
						if (supInfo.getId().intValue() != 15) {
							nSequence++;
							strProductName = prodInfo.getProductName();
							fFaceValue = prodInfo.getProductFaceValue();
						}
					} else {
						Float fNonVATAmount = Float.valueOf(fTotalAmount.floatValue() / 1.2F);
						Float fVATAmount = Float.valueOf(fTotalAmount.floatValue() - fNonVATAmount.floatValue());
						Float fCommissionAmount = Float.valueOf(fProbableSalePrice.floatValue() * nCards.intValue()
								- fTotalAmount.floatValue());

						strReportRows = strReportRows + "<tr bgcolor=B4FFFF>";
						strReportRows = strReportRows + "<td align=left>" + nSequence + "</td>";
						strReportRows = strReportRows + "<td align=left>" + strProductName + " - " + ff.format(fFaceValue)
								+ "</td>";
						strReportRows = strReportRows + "<td align=left>" + ff.format(fProbableSalePrice) + "</td>";
						strReportRows = strReportRows + "<td align=left>" + nCards + "</td>";
						strReportRows = strReportRows + "<td align=left>" + ff.format(fTotalAmount) + "</td>";
						strReportRows = strReportRows + "<td align=left>" + ff.format(fCommissionAmount) + "</td>";
						if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
							strReportRows = strReportRows + "<td align=left>"
									+ ff.format(fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue()) + "</td>";
						}
						if (this.m_bGenerateGroupInvoices) {
							strReportRows = strReportRows + "<td align=left>"
									+ ff.format(fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue()) + "</td>";
						}
						strReportRows = strReportRows + "</tr>";

						nSubTotalCards += nCards.intValue();
						fSubTotalNonVAT += fNonVATAmount.floatValue();
						fSubTotalVAT += fVATAmount.floatValue();
						fSubTotal += fTotalAmount.floatValue();
						fSubCommission += fCommissionAmount.floatValue();
						fSubAgentCommission += fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue();
						fSubGroupCommission += fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue();

						this.m_nCustomerTotalCards += nCards.intValue();
						this.m_fCustomerTotalNonVAT += fNonVATAmount.floatValue();
						this.m_fCustomerTotalVAT += fVATAmount.floatValue();
						this.m_fCustomerTotal += fTotalAmount.floatValue();
						this.m_fCustomerTotalCommission += fCommissionAmount.floatValue();
						this.m_fAgentTotalCommission += fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue();
						this.m_fGroupTotalCommission += fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue();
					}
				}
			}
			if (nSubTotalCards > 0) {
				strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
				strReportRows = strReportRows + "<tr bgcolor=B4FFFF><td></td><td> </td><td align=center><b>Sub Total</b></td>";
				strReportRows = strReportRows + "<td align=left><b>" + nSubTotalCards + "</b></td>";

				strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubTotal) + "</b></td>";
				strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";
				if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
					strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubAgentCommission) + "</b></td>";
				}
				if (this.m_bGenerateGroupInvoices) {
					strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubGroupCommission) + "</b></td>";
				}
				strReportRows = strReportRows + "</tr>";
				strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
			}
			if (this.m_bGenerateHTMLOutput) {
				strInvoiceReport = strInvoiceReport + strReportRows;
			}
			nSubTotalCards = 0;
			fSubTotalNonVAT = 0.0F;
			fSubTotalVAT = 0.0F;
			fSubTotal = 0.0F;
			fSubCommission = 0.0F;
			fSubAgentCommission = 0.0F;
			strReportRows = "";

			strQuery = "call SP_Customer_AIT_Invoice_Report(" + custInfo.getId() + "," + this.m_strDurationBegin
					+ "," + this.m_strDurationEnd + ")";

			sqlQuery = theSession.createSQLQuery(strQuery);

			sqlQuery.addScalar("IsHistory", StandardBasicTypes.INTEGER);
			sqlQuery.addScalar("Probable_Sale_Price", StandardBasicTypes.FLOAT);
			sqlQuery.addScalar("Transaction_Amount", StandardBasicTypes.FLOAT);
			sqlQuery.addScalar("CostToAgent", StandardBasicTypes.FLOAT);
			sqlQuery.addScalar("CostToGroup", StandardBasicTypes.FLOAT);

			invoiceReport = sqlQuery.list();
			for (int i = 0; i < invoiceReport.size(); i++) {
				Object[] oneRecord = (Object[]) invoiceReport.get(i);
				if (oneRecord.length > 0) {
					Integer nIsHistory = (Integer) oneRecord[0];
					Float fProbableSalePrice = (Float) oneRecord[1];
					Float fTotalAmount = (Float) oneRecord[2];
					Float fSecondaryTotalAmount = (Float) oneRecord[3];
					Float fGroupTotalAmount = (Float) oneRecord[4];
					if (fProbableSalePrice == null) {
						fProbableSalePrice = Float.valueOf(0.0F);
					}
					if (fTotalAmount == null) {
						fTotalAmount = Float.valueOf(0.0F);
					}
					if (fSecondaryTotalAmount == null) {
						fSecondaryTotalAmount = Float.valueOf(0.0F);
					}
					if (fGroupTotalAmount == null) {
						fGroupTotalAmount = Float.valueOf(0.0F);
					}
					String strProductName = "Mobile Topup";

					Float fNonVATAmount = Float.valueOf(fTotalAmount.floatValue() / 1.2F);
					Float fVATAmount = Float.valueOf(0.0F);
					Float fCommissionAmount = Float.valueOf(fProbableSalePrice.floatValue() - fTotalAmount.floatValue());

					strReportRows = strReportRows + "<tr bgcolor=FFFFAA>";
					strReportRows = strReportRows + "<td align=left>" + nSequence + "</td>";
					strReportRows = strReportRows + "<td align=left>" + strProductName + "</td>";
					strReportRows = strReportRows + "<td align=left>" + ff.format(fProbableSalePrice) + "</td>";
					strReportRows = strReportRows + "<td align=left>1</td>";
					strReportRows = strReportRows + "<td align=left>" + ff.format(fTotalAmount) + "</td>";
					strReportRows = strReportRows + "<td align=left>" + ff.format(fCommissionAmount) + "</td>";
					if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
						strReportRows = strReportRows + "<td align=left>"
								+ ff.format(fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue()) + "</td>";
					}
					if (this.m_bGenerateGroupInvoices) {
						strReportRows = strReportRows + "<td align=left>"
								+ ff.format(fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue()) + "</td>";
					}
					strReportRows = strReportRows + "</tr>";

					nSequence++;

					nSubTotalCards++;
					fSubTotalNonVAT += fNonVATAmount.floatValue();
					fSubTotalVAT += fVATAmount.floatValue();
					fSubTotal += fTotalAmount.floatValue();
					fSubCommission += fCommissionAmount.floatValue();
					fSubAgentCommission += fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue();
					fSubGroupCommission += fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue();

					this.m_nCustomerTotalCards += 1;
					this.m_fCustomerTotalNonVAT += fNonVATAmount.floatValue();
					this.m_fCustomerTotalVAT += fVATAmount.floatValue();
					this.m_fCustomerTotal += fTotalAmount.floatValue();
					this.m_fCustomerTotalCommission += fCommissionAmount.floatValue();
					this.m_fAgentTotalCommission += fTotalAmount.floatValue() - fSecondaryTotalAmount.floatValue();
					this.m_fGroupTotalCommission += fSecondaryTotalAmount.floatValue() - fGroupTotalAmount.floatValue();
				}
			}
			if (nSubTotalCards > 0) {
				strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
				strReportRows = strReportRows + "<tr bgcolor=FFFFAA><td></td><td> </td><td align=center><b>Sub Total</b></td>";
				strReportRows = strReportRows + "<td align=left><b>" + nSubTotalCards + "</b></td>";

				strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubTotal) + "</b></td>";
				strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";
				if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
					strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubAgentCommission) + "</b></td>";
				}
				if (this.m_bGenerateGroupInvoices) {
					strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubGroupCommission) + "</b></td>";
				}
				strReportRows = strReportRows + "</tr>";
				strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
			}
			if (this.m_bGenerateHTMLOutput) {
				strInvoiceReport = strInvoiceReport + strReportRows;
			}
			strReportRows = "";
			strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
			strReportRows = strReportRows + "<tr bgcolor=80FF80><td></td><td> </td><td align=center><b>Grand Total</b></td>";
			strReportRows = strReportRows + "<td align=left><b>" + this.m_nCustomerTotalCards + "</b></td>";
			strReportRows = strReportRows + "<td align=left><b>" + ff.format(this.m_fCustomerTotal) + "</b></td>";
			strReportRows = strReportRows + "<td align=left><b>" + ff.format(this.m_fCustomerTotalCommission) + "</b></td>";
			if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
				strReportRows = strReportRows + "<td align=left><b>" + ff.format(this.m_fAgentTotalCommission) + "</b></td>";
			}
			if (this.m_bGenerateGroupInvoices) {
				strReportRows = strReportRows + "<td align=left><b>" + ff.format(this.m_fGroupTotalCommission) + "</b></td>";
			}
			strReportRows = strReportRows + "</tr>";
			strReportRows = strReportRows + "</table>";
			if (this.m_bGenerateHTMLOutput) {
				strInvoiceReport = strInvoiceReport + strReportRows;
			}
			this.m_nCustomerID = 0;
			theSession.getTransaction().commit();
			if (this.m_bGenerateHTMLFiles) {
				strInvoiceReport = strInvoiceReport + "</body> </html>";

				File file = new File(strFileName);
				BufferedWriter writer = new BufferedWriter(new FileWriter(file));
				writer.write(strInvoiceReport);
				writer.close();
			} else if (this.m_bGenerateHTMLOutput) {
				this.m_strInvoiceReport = strInvoiceReport;
			}
		} catch (Exception e) {
			e.printStackTrace();
			this.m_nCustomerID = 0;
			theSession.getTransaction().rollback();
		} finally {
			HibernateUtil.closeSession(theSession);
		}
		this.m_nCustomerID = 0;
	}

	private String PrepareInvoiceHeader(TMasterCustomerinfo custInfo) {
		TMasterCustomerGroups custGroup = custInfo.getGroup();
		String strInvoiceHeader = "";
		if (this.m_bGenerateHTMLFiles) {
			strInvoiceHeader = "<html> <body>";
		}
		strInvoiceHeader = strInvoiceHeader + "<table width=100%>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "<font size=5><b>" + custInfo.getCompanyName() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=5><b>" + custGroup.getName() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>" + custInfo.getAddressLine1() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>" + custGroup.getGroupAddress() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>" + custInfo.getCity() + ", " + custInfo.getCountry()
				+ "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>" + custGroup.getGroupCity() + " - "
				+ custGroup.getGroupPinCode() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>LONDON, United Kingdom</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>Phone: " + custGroup.getGroupPhone() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>e-Mail: " + custGroup.getGroupEmailId() + "/b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>Company Reg. " + custGroup.getCompanyRegNo() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=right>";
		strInvoiceHeader = strInvoiceHeader + "<font size=2><b>VAT Reg. " + custGroup.getVatRegNo() + "</b></font>";
		strInvoiceHeader = strInvoiceHeader + "</td>";
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "</table>";
		strInvoiceHeader = strInvoiceHeader + "<BR>";
		strInvoiceHeader = strInvoiceHeader + "<u><center><H3>Commission Report From " + this.m_strDisplayDurationBegin
				+ " To " + this.m_strDisplayDurationEnd + "</H3></center></u>";
		strInvoiceHeader = strInvoiceHeader + "<BR>";
		strInvoiceHeader = strInvoiceHeader + "<table width=100%>";
		strInvoiceHeader = strInvoiceHeader + "<tr>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Serial Number</b></td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Product</b></td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Retail Price</b></td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Quantity</b></td>";
		strInvoiceHeader = strInvoiceHeader + "<!-- <td align=left>Amount</td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left>VAT</td> -->";
		strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Amount</b></td>";
		strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Commission</b></td>";
		if ((this.m_bGenerateAgentInvoices) || (this.m_bGenerateGroupInvoices)) {
			strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Agent Commission</b></td>";
		}
		if (this.m_bGenerateGroupInvoices) {
			strInvoiceHeader = strInvoiceHeader + "<td align=left><b>" + custGroup.getName()
					+ " Commission </b></td>";
		}
		strInvoiceHeader = strInvoiceHeader + "</tr>";
		strInvoiceHeader = strInvoiceHeader + "<tr><td></td></tr>";

		return strInvoiceHeader;
	}

	public static void main(String[] args) throws ParseException {
		if (args.length < 4) {
			System.out.println("Usage : GenerateInvoices <Start year> <Start Month (0 - 11) <End Year> <End Month (0 - 11)>");
			return;
		}
		String strStartYear = args[0];
		String strStartMonth = args[1];
		String strEndYear = args[2];
		String strEndMonth = args[3];

		int nStartYear = 0;
		int nStartMonth = -1;
		int nEndYear = 0;
		int nEndMonth = -1;
		try {
			nStartYear = Integer.parseInt(strStartYear);
			nStartMonth = Integer.parseInt(strStartMonth);
			nEndYear = Integer.parseInt(strEndYear);
			nEndMonth = Integer.parseInt(strEndMonth);

			Calendar startCal = Calendar.getInstance();
			startCal.set(nStartYear, nStartMonth, 1, 0, 0, 0);

			Calendar endCal = Calendar.getInstance();
			endCal.set(nEndYear, nEndMonth, 25, 0, 0, 0);

			long nDays = (endCal.getTime().getTime() - startCal.getTime().getTime()) / 86400000L;
			if (nDays < 20L) {
				System.out.println("Invalid input.  Please run again with proper input");
				return;
			}
		} catch (Exception e) {
			System.out.println("Invalid input.  Please run again with proper input");
			return;
		}
		if ((nStartYear <= 0) || (nStartMonth < 0) || (nEndYear <= 0) || (nEndMonth < 0)) {
			System.out.println("Invalid input.  Please run again with proper input");
			return;
		}
		GenerateInvoices invoiceGen = new GenerateInvoices();
		invoiceGen.setCountry(invoiceGen.getCountry());
		invoiceGen.setDuration(nStartYear, nStartMonth, nEndYear, nEndMonth);
		invoiceGen.setGenerateHTMLOutput(true);
		invoiceGen.setRootFolder("./Invoices/");

		Session theSession = null;
		try {
			theSession = HibernateUtil.openSession();

			String strQuery = "from TMasterCustomerinfo order by Customer_Group_ID, Customer_Company_Name";
			Query query = theSession.createQuery(strQuery);
			List custList = query.list();
			if (custList.size() < 0) {
				return;
			}
			for (int nCustomer = 0; nCustomer < 1; nCustomer++) {
				TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(nCustomer);
				if (custInfo.getId().intValue() != 28) {
					invoiceGen.setCustomerID(custInfo.getId().intValue());
					invoiceGen.createInvoice();
				}
			}
			invoiceGen.setGenerateGroupInvoices(true);
			for (int nCustomer = 0; nCustomer < 1; nCustomer++) {
				TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(nCustomer);
				invoiceGen.setCustomerID(custInfo.getId().intValue());
				invoiceGen.createInvoice();
			}
			invoiceGen.setGenerateGroupInvoices(false);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			HibernateUtil.closeSession(theSession);
		}
	}
}
