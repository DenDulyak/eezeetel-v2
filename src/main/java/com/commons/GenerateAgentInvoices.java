package com.commons;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import com.eezeetel.util.HibernateUtil;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.TReportGroupProfit;

public class GenerateAgentInvoices {
	private int m_nStartYear = 0;
	private int m_nStartMonth = 0;
	private int m_nEndYear = 0;
	private int m_nEndMonth = 0;
	private int m_nGroupID = 0;
	private String m_strAgent = "";
	private String m_strDurationBegin = "";
	public String m_strDisplayDurationBegin = "";
	private String m_strDurationEnd = "";
	public String m_strDisplayDurationEnd = "";
	public String m_strInvoiceReport = "";
	public String m_strInActiveCustomersReport = "";
	private String m_strCountry;

	public void setCountry(String strCountry) {
		this.m_strCountry = strCountry;
	}

	public GenerateAgentInvoices() {
		this.m_nStartYear = 2009;
		this.m_nStartMonth = 1;
		this.m_nEndYear = 2009;
		this.m_nEndMonth = 1;
		this.m_nGroupID = 0;
		this.m_strAgent = "";
		this.m_strDurationBegin = "";
		this.m_strDisplayDurationBegin = "";
		this.m_strDurationEnd = "";
		this.m_strDisplayDurationEnd = "";

		this.m_strInvoiceReport = "";
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

	public void setGroupAndAgentID(int nGroupID, String strAgent) {
		this.m_strAgent = strAgent;
		this.m_nGroupID = nGroupID;
	}

	public void createInvoice() {
		if (this.m_nGroupID <= 0) {
			return;
		}
		if (this.m_strAgent.isEmpty()) {
			return;
		}
		DecimalFormat ff = new DecimalFormat("0.00");
		Session theSession = null;
		try {
			theSession = HibernateUtil.openSession();
			theSession.beginTransaction();

			String strQuery = "from TReportGroupProfit where Begin_Date = " + this.m_strDurationBegin
					+ " and Customer_Group_ID = " + this.m_nGroupID + " and Agent_ID = '" + this.m_strAgent
					+ "' order by Agent_ID, Customer_ID";
			Query sqlQuery = theSession.createQuery(strQuery);
			List<TReportGroupProfit> invoiceReport = sqlQuery.list();
			if (invoiceReport.size() <= 0) {
				theSession.getTransaction().commit();
				return;
			}
			int nAgentTotalCards = 0;
			float fAgentTotalAmount = 0.0F;
			float fAgentTotalVAT = 0.0F;
			float fAgentTotalCustomerCommission = 0.0F;
			float fAgentTotalAgentCommission = 0.0F;

			String strReportRows = "";

			strReportRows = strReportRows + "<tr>";
			strReportRows = strReportRows + "<td align=center> Number </td>";
			strReportRows = strReportRows + "<td align=center> Customer </td>";
			strReportRows = strReportRows + "<td align=center> Transactions </td>";
			strReportRows = strReportRows + "<td align=center> Transaction Amount </td>";
			strReportRows = strReportRows + "<td align=center> VAT</td>";
			strReportRows = strReportRows + "<td align=center> Customer Commission </td>";
			strReportRows = strReportRows + "<td align=center> Profit </td>";
			strReportRows = strReportRows + "</tr>";
			for (int i = 0; i < invoiceReport.size(); i++) {
				TReportGroupProfit grpProfit = (TReportGroupProfit) invoiceReport.get(i);
				TMasterCustomerinfo custInfo = grpProfit.getCustomer();

				int oneLineCards = grpProfit.getTotalCards() + grpProfit.getTotalLocalMobileTransactions()
						+ grpProfit.getTotalWorldMobileTransactions();

				strReportRows = strReportRows + "<tr>";
				strReportRows = strReportRows + "<td align=left>" + (i + 1) + "</td>";
				strReportRows = strReportRows + "<td align=left>" + custInfo.getCompanyName() + "</td>";
				strReportRows = strReportRows + "<td align=left>" + oneLineCards + "</td>";
				strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getTotalAmount()) + "</td>";
				strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getAgentVat()) + "</td>";
				strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getCustomerCommission()) + "</td>";
				strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getAgentCommission()) + "</td>";
				strReportRows = strReportRows + "</tr>";

				nAgentTotalCards += oneLineCards;
				fAgentTotalAmount += grpProfit.getTotalAmount();
				fAgentTotalVAT += grpProfit.getAgentVat();
				fAgentTotalCustomerCommission += grpProfit.getCustomerCommission();
				fAgentTotalAgentCommission += grpProfit.getAgentCommission();
			}
			strReportRows = strReportRows + "<tr bgcolor=yellow>";
			strReportRows = strReportRows + "<td align=left> </td>";
			strReportRows = strReportRows + "<td align=right> Total </td>";
			strReportRows = strReportRows + "<td align=left>" + nAgentTotalCards + "</td>";
			strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalAmount) + "</td>";
			strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalVAT) + "</td>";
			strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalCustomerCommission) + "</td>";
			strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalAgentCommission) + "</td>";
			strReportRows = strReportRows + "</tr>";

			this.m_strInvoiceReport = strReportRows;

			SimpleDateFormat sf = new SimpleDateFormat("yyyy-MMM-dd");

			strReportRows = "<tr bgcolor=gray><td colspan=7>Inactive Customer List</td></tr>";

			strReportRows = strReportRows
					+ "<tr bgcolor=gray><td>Number</td><td>Customer</td><td>Contact Person</td><td>Primary Phone</td><td>Secondary Phone</td><td>Mobile Phone</td><td>Customer Since</td></tr>";

			strQuery = "select * from t_master_customerinfo where Customer_ID not in (select Customer_ID from t_report_group_profit where Begin_Date = "
					+ this.m_strDurationBegin
					+ " and Customer_Group_ID = "
					+ this.m_nGroupID
					+ " and Agent_ID = '"
					+ this.m_strAgent
					+ "') and Customer_Group_ID = "
					+ this.m_nGroupID
					+ " and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295) "
					+ " and Customer_Introduced_By = '"
					+ this.m_strAgent
					+ "' and Creation_Time <= "
					+ this.m_strDurationBegin
					+ " and Active_Status = 1 order by Customer_Introduced_By, Customer_Company_Name";

			SQLQuery theSqlQuery = theSession.createSQLQuery(strQuery);
			theSqlQuery.addEntity(TMasterCustomerinfo.class);
			List inActiveCustomers = theSqlQuery.list();
			for (int i = 0; i < inActiveCustomers.size(); i++) {
				TMasterCustomerinfo custInfo = (TMasterCustomerinfo) inActiveCustomers.get(i);

				strReportRows = strReportRows + "<tr bgcolor=gray>";
				strReportRows = strReportRows + "<td align=left>" + (i + 1) + "</td>";
				strReportRows = strReportRows + "<td align=left>" + custInfo.getCompanyName() + "</td>";
				strReportRows = strReportRows + "<td align=left>" + custInfo.getFirstName() + "</td>";
				strReportRows = strReportRows + "<td align=left>" + custInfo.getPrimaryPhone() + "</td>";
				strReportRows = strReportRows + "<td align=left>" + custInfo.getSecondaryPhone() + "</td>";
				strReportRows = strReportRows + "<td align=left>" + custInfo.getMobilePhone() + "</td>";
				strReportRows = strReportRows + "<td align=left>" + sf.format(custInfo.getCreationTime()) + "</td>";
			}
			this.m_strInActiveCustomersReport = strReportRows;

			theSession.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			this.m_nGroupID = 0;
			theSession.getTransaction().rollback();
		} finally {
			HibernateUtil.closeSession(theSession);
		}
		this.m_nGroupID = 0;
		this.m_strAgent = "";
	}
}
