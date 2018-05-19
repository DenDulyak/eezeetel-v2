package com.commons;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.StandardBasicTypes;

import com.eezeetel.util.HibernateUtil;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.TReportGroupProfit;

public class GenerateGroupInvoices {
    private int m_nStartYear = 0;
    private int m_nStartMonth = 0;
    private int m_nEndYear = 0;
    private int m_nEndMonth = 0;
    private int m_nGroupID = 0;
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

    public GenerateGroupInvoices() {
        this.m_nStartYear = 2009;
        this.m_nStartMonth = 1;
        this.m_nEndYear = 2009;
        this.m_nEndMonth = 1;
        this.m_nGroupID = 0;
        this.m_strDurationBegin = "";
        this.m_strDisplayDurationBegin = "";
        this.m_strDurationEnd = "";
        this.m_strDisplayDurationEnd = "";
        this.m_strInActiveCustomersReport = "";
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

    public void setGroupID(int nGroupID) {
        this.m_nGroupID = nGroupID;
    }

    public void createInvoice() {
        if (this.m_nGroupID <= 0) {
            return;
        }
        DecimalFormat ff = new DecimalFormat("0.00");
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            String strQuery = "from TReportGroupProfit where Begin_Date = " + this.m_strDurationBegin
                    + " and Customer_Group_ID = " + this.m_nGroupID + " order by Agent_ID, Customer_ID";

            Query sqlQuery = theSession.createQuery(strQuery);
            List invoiceReport = sqlQuery.list();

            int nGroupTotalCards = 0;
            float fGroupTotalAmount = 0.0F;
            float fGroupTotalSaleAmount = 0.0F;
            float fGroupTotalVAT = 0.0F;
            float fGroupTotalNonVAT = 0.0F;
            float fGroupTotalCustomerCommission = 0.0F;
            float fGroupTotalAgentCommission = 0.0F;
            float fGroupTotalProfit = 0.0F;

            int nAgentTotalCards = 0;
            float fAgentTotalSaleAmount = 0.0F;
            float fAgentTotalAmount = 0.0F;
            float fAgentTotalVAT = 0.0F;
            float fAgentTotalNonVAT = 0.0F;
            float fAgentTotalCustomerCommission = 0.0F;
            float fAgentTotalAgentCommission = 0.0F;
            float fAgentTotalProfit = 0.0F;

            String strPreviousAgent = "";
            String strReportRows = "";

            strReportRows = strReportRows + "<tr>";
            strReportRows = strReportRows + "<td align=center> Number </td>";
            strReportRows = strReportRows + "<td align=center> Customer </td>";
            strReportRows = strReportRows + "<td align=center> Introduced By </td>";
            strReportRows = strReportRows + "<td align=center> Transactions </td>";
            strReportRows = strReportRows + "<td align=center> Purchase Amount </td>";
            strReportRows = strReportRows + "<td align=center> Sale Amount </td>";
            strReportRows = strReportRows + "<td align=center> VAT</td>";
            strReportRows = strReportRows + "<td align=center> Customer Commission </td>";
            strReportRows = strReportRows + "<td align=center> Agent Commission </td>";
            strReportRows = strReportRows + "<td align=center> Profit </td>";
            strReportRows = strReportRows + "</tr>";
            for (int i = 0; i < invoiceReport.size(); i++) {
                TReportGroupProfit grpProfit = (TReportGroupProfit) invoiceReport.get(i);
                TMasterCustomerinfo custInfo = grpProfit.getCustomer();
                if (strPreviousAgent.isEmpty()) {
                    strPreviousAgent = custInfo.getIntroducedBy().getUserFirstName();
                }
                if (strPreviousAgent.compareToIgnoreCase(custInfo.getIntroducedBy().getUserFirstName()) != 0) {
                    strReportRows = strReportRows + "<tr bgcolor=yellow>";
                    strReportRows = strReportRows + "<td align=left> </td>";
                    strReportRows = strReportRows + "<td align=left> </td>";
                    strReportRows = strReportRows + "<td align=left>" + strPreviousAgent + " Total </td>";
                    strReportRows = strReportRows + "<td align=left>" + nAgentTotalCards + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalAmount) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalSaleAmount) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalVAT) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalNonVAT) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalCustomerCommission) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalAgentCommission) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalProfit) + "</td>";
                    strReportRows = strReportRows + "</tr>";

                    nAgentTotalCards = 0;
                    fAgentTotalAmount = 0.0F;
                    fAgentTotalSaleAmount = 0.0F;
                    fAgentTotalVAT = 0.0F;
                    fAgentTotalNonVAT = 0.0F;
                    fAgentTotalCustomerCommission = 0.0F;
                    fAgentTotalAgentCommission = 0.0F;
                    fAgentTotalProfit = 0.0F;
                }
                strPreviousAgent = custInfo.getIntroducedBy().getUserFirstName();

                int oneLineCards = grpProfit.getTotalCards() + grpProfit.getTotalLocalMobileTransactions()
                        + grpProfit.getTotalWorldMobileTransactions();
                float oneLineProfit = grpProfit.getProfitFromCallingCards() + grpProfit.getProfitFromLocalMobile()
                        + grpProfit.getProfitFromWorldMobile();

                strReportRows = strReportRows + "<tr>";
                strReportRows = strReportRows + "<td align=left>" + (i + 1) + "</td>";
                strReportRows = strReportRows + "<td align=left>" + custInfo.getCompanyName() + "</td>";
                strReportRows = strReportRows + "<td align=left>" + strPreviousAgent + "</td>";
                strReportRows = strReportRows + "<td align=left>" + oneLineCards + "</td>";
                strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getTotalAmount()) + "</td>";
                strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getTotalAmount() + oneLineProfit)
                        + "</td>";
                strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getGroupVat()) + "</td>";
                strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getCustomerCommission()) + "</td>";
                strReportRows = strReportRows + "<td align=left>" + ff.format(grpProfit.getAgentCommission()) + "</td>";
                strReportRows = strReportRows + "<td align=left>" + ff.format(oneLineProfit) + "</td>";
                strReportRows = strReportRows + "</tr>";

                nAgentTotalCards += oneLineCards;
                fAgentTotalAmount += grpProfit.getTotalAmount();
                fAgentTotalSaleAmount += grpProfit.getTotalAmount() + oneLineProfit;
                fAgentTotalVAT += grpProfit.getGroupVat();
                fAgentTotalCustomerCommission += grpProfit.getCustomerCommission();
                fAgentTotalAgentCommission += grpProfit.getAgentCommission();
                fAgentTotalProfit += oneLineProfit;

                nGroupTotalCards += oneLineCards;
                fGroupTotalAmount += grpProfit.getTotalAmount();
                fGroupTotalSaleAmount += grpProfit.getTotalAmount() + oneLineProfit;
                fGroupTotalVAT += grpProfit.getGroupVat();
                fGroupTotalCustomerCommission += grpProfit.getCustomerCommission();
                fGroupTotalAgentCommission += grpProfit.getAgentCommission();
                fGroupTotalProfit += oneLineProfit;
            }
            strReportRows = strReportRows + "<tr bgcolor=yellow>";
            strReportRows = strReportRows + "<td align=left> </td>";
            strReportRows = strReportRows + "<td align=left> </td>";
            strReportRows = strReportRows + "<td align=left>" + strPreviousAgent + " Total </td>";
            strReportRows = strReportRows + "<td align=left>" + nAgentTotalCards + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalAmount) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalSaleAmount + fAgentTotalProfit)
                    + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalVAT) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalNonVAT) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalCustomerCommission) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalAgentCommission) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fAgentTotalProfit) + "</td>";
            strReportRows = strReportRows + "</tr>";

            strReportRows = strReportRows + "<tr bgcolor=green>";
            strReportRows = strReportRows + "<td align=left> </td>";
            strReportRows = strReportRows + "<td align=left> </td>";
            strReportRows = strReportRows + "<td align=left> Total </td>";
            strReportRows = strReportRows + "<td align=left>" + nGroupTotalCards + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalAmount) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalAmount + fGroupTotalProfit) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalVAT) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalNonVAT) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalCustomerCommission) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalAgentCommission) + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalProfit) + "</td>";
            strReportRows = strReportRows + "</tr>";

            this.m_strInvoiceReport = strReportRows;

            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MMM-dd");

            strReportRows = "<tr bgcolor=gray><td colspan=8>Inactive Customer List</td></tr>";
            strReportRows = strReportRows
                    + "<tr bgcolor=gray><td>Number</td><td>Customer</td><td>Agent</td><td>Contact Person</td><td>Primary Phone</td><td>Secondary Phone</td><td>Mobile Phone</td><td>Customer Since</td></tr>";

            strQuery = "select * from t_master_customerinfo where Customer_ID not in (select Customer_ID from t_report_group_profit where Begin_Date = "
                    + this.m_strDurationBegin
                    + " and Customer_Group_ID = "
                    + this.m_nGroupID
                    + ") and Customer_Group_ID = "
                    + this.m_nGroupID
                    + " and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)"
                    + " and Creation_Time <= "
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
                strReportRows = strReportRows + "<td align=left>"
                        + custInfo.getIntroducedBy().getUserFirstName() + "</td>";
                strReportRows = strReportRows + "<td align=left>" + custInfo.getFirstName() + "</td>";
                strReportRows = strReportRows + "<td align=left>" + custInfo.getPrimaryPhone() + "</td>";
                strReportRows = strReportRows + "<td align=left>" + custInfo.getSecondaryPhone() + "</td>";
                strReportRows = strReportRows + "<td align=left>" + custInfo.getMobilePhone() + "</td>";
                strReportRows = strReportRows + "<td align=left>" + sf.format(custInfo.getCreationTime()) + "</td>";
            }
            this.m_strInActiveCustomersReport = strReportRows;
        } catch (Exception e) {
            this.m_nGroupID = 0;
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        this.m_nGroupID = 0;
    }

    public void createProductSalesInvoice() {
        if (this.m_nGroupID <= 0) {
            return;
        }
        DecimalFormat ff = new DecimalFormat("0.00");
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            String strQuery = "select Product_Name, Product_Face_Value, sum(Quantity) as Quantity,  sum(Cost_To_Group) as Purchase_Price  from t_report_customer_profit t1, t_master_productinfo t2  where t1.Product_ID = t2.Product_ID and Begin_Date = "
                    +

                    this.m_strDurationBegin
                    + " and Customer_Group_ID = "
                    + this.m_nGroupID
                    + " group by t1.Product_ID order by Product_Name, Product_Face_Value";

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Product_Name", StandardBasicTypes.STRING);
            sqlQuery.addScalar("Product_Face_Value", StandardBasicTypes.FLOAT);
            sqlQuery.addScalar("Quantity", StandardBasicTypes.INTEGER);
            sqlQuery.addScalar("Purchase_Price", StandardBasicTypes.FLOAT);
            List invoiceReport = sqlQuery.list();

            int nGroupTotalCardsSold = 0;
            float fGroupTotalAmountPurchased = 0.0F;

            String strReportRows = "";

            strReportRows = strReportRows + "<tr>";
            strReportRows = strReportRows + "<td align=center> Number </td>";
            strReportRows = strReportRows + "<td align=center> Product</td>";
            strReportRows = strReportRows + "<td align=center> Face Value</td>";
            strReportRows = strReportRows + "<td align=center> Quantity Sold </td>";
            strReportRows = strReportRows + "<td align=center> Purchase Amount </td>";
            strReportRows = strReportRows + "</tr>";
            for (int i = 0; i < invoiceReport.size(); i++) {
                Object[] oneRecord = (Object[]) invoiceReport.get(i);

                String strProductName = (String) oneRecord[0];
                float fFaceValue = ((Float) oneRecord[1]).floatValue();
                int nQuantity = ((Integer) oneRecord[2]).intValue();
                float fPurchaseAmount = ((Float) oneRecord[3]).floatValue();

                String strFaceValue = "";
                strFaceValue = ff.format(fFaceValue);

                strReportRows = strReportRows + "<tr>";
                strReportRows = strReportRows + "<td align=left>" + (i + 1) + "</td>";
                strReportRows = strReportRows + "<td align=left>" + strProductName + "</td>";
                strReportRows = strReportRows + "<td align=left>" + strFaceValue + "</td>";
                strReportRows = strReportRows + "<td align=left>" + nQuantity + "</td>";
                strReportRows = strReportRows + "<td align=left>" + ff.format(fPurchaseAmount) + "</td>";
                strReportRows = strReportRows + "</tr>";

                nGroupTotalCardsSold += nQuantity;
                fGroupTotalAmountPurchased += fPurchaseAmount;
            }
            strReportRows = strReportRows + "<tr bgcolor=yellow>";
            strReportRows = strReportRows + "<td align=left> </td>";
            strReportRows = strReportRows + "<td align=left> </td>";
            strReportRows = strReportRows + "<td align=left>Total</td>";
            strReportRows = strReportRows + "<td align=left>" + nGroupTotalCardsSold + "</td>";
            strReportRows = strReportRows + "<td align=left>" + ff.format(fGroupTotalAmountPurchased) + "</td>";
            strReportRows = strReportRows + "</tr>";

            this.m_strInvoiceReport = strReportRows;
        } catch (Exception e) {
            this.m_nGroupID = 0;
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        this.m_nGroupID = 0;
    }
}
