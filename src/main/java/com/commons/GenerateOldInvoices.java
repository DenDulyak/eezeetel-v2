package com.commons;

import com.eezeetel.entity.*;
import com.eezeetel.util.HibernateUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class GenerateOldInvoices {
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
    public String m_strAgentName = "";
    private String m_strCountry = "";

    public void setCountry(String strCountry) {
        this.m_strCountry = strCountry;
    }

    public GenerateOldInvoices() {
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

        this.m_strInvoiceReport = "";
        this.m_nCustomerTotalCards = 0;
        this.m_fCustomerTotal = 0.0F;
        this.m_fCustomerTotalCommission = 0.0F;
    }

    public void setDuration(int nStartYear, int nStartMonth, int nEndYear, int nEndMonth) {
        this.m_nStartYear = nStartYear;
        this.m_nStartMonth = nStartMonth;
        this.m_nEndYear = nEndYear;
        this.m_nEndMonth = nEndMonth;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MMM-dd", Locale.ENGLISH);

        Calendar startCal = Calendar.getInstance(Locale.ENGLISH);
        startCal.set(this.m_nStartYear, this.m_nStartMonth, 1, 0, 0, 0);
        this.m_strDurationBegin = ("'" + sdf.format(startCal.getTime()) + "'");
        this.m_strDisplayDurationBegin = df.format(startCal.getTime());

        Calendar endCal = Calendar.getInstance(Locale.ENGLISH);
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
        this.m_fCustomerTotal = 0.0F;
        this.m_fCustomerTotalCommission = 0.0F;
        this.m_strAgentName = "";

        DecimalFormat ff = new DecimalFormat("0.00");
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            String strQuery = "from TMasterCustomerinfo where Customer_ID = " + this.m_nCustomerID;
            Query query = theSession.createQuery(strQuery);
            List custList = query.list();
            if (custList.size() < 0) {
                this.m_nCustomerID = 0;
                return;
            }
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
            User introducedBy = custInfo.getIntroducedBy();
            this.m_strAgentName = introducedBy.getUserFirstName();

            String strInvoiceReport = "";
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = PrepareInvoiceHeader(custInfo, false);
            }
            String strFileName = "Unknown.html";
            if (this.m_bGenerateHTMLFiles) {
                strFileName = this.m_strCustomers + custInfo.getCompanyName() + ".html";
            }
            System.out.println("===== 154 ===== > " +this.m_strDurationBegin);
            strQuery = "from TReportCustomerProfit where Begin_Date = " + this.m_strDurationBegin + " and Customer_ID = "
                    + custInfo.getId() + "order by product.productName";
            System.out.println("===== 157 ===== > " +strQuery);
            Query query2 = theSession.createQuery(strQuery);
            List invoiceReport = query2.list();

            int nSubTotalCards = 0;
            float fSubTotal = 0.0F;
            float fSubCommission = 0.0F;
            String strReportRows = "";

            int nSequence = 0;
            for (int i = 0; i < invoiceReport.size(); i++) {
                TReportCustomerProfit custProfit = (TReportCustomerProfit) invoiceReport.get(i);

                String strProductName = "";
                float fFaceValue = 0.0F;
                custProfit.getProduct();

                TMasterProductinfo prodInfo = custProfit.getProduct();
                TMasterSupplierinfo supInfo = prodInfo.getSupplier();
                TMasterSuppliertype supType = supInfo.getSupplierType();
                if (supInfo.getId() == 15 || supInfo.getId() == 56) {
                    nSequence++;
                    strProductName = prodInfo.getProductName();
                    fFaceValue = prodInfo.getProductFaceValue();

                    Float fCostToCustomer = custProfit.getCostToCustomer();
                    Float fCustomerCommission = (custProfit.getRetailCost() * custProfit.getQuantity()) - fCostToCustomer;

                    strReportRows = strReportRows + "<tr bgcolor=E1E1E1>";
                    strReportRows = strReportRows + "<td align=left>" + nSequence + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + strProductName + " - " + ff.format(fFaceValue) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(custProfit.getRetailCost()) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + custProfit.getQuantity() + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fCostToCustomer) + "</td>";
                    /*strReportRows = strReportRows + "<td align=left>" + ff.format(fCustomerCommission) + "</td>";*/

                    strReportRows = strReportRows + "</tr>";

                    nSubTotalCards += custProfit.getQuantity();
                    fSubTotal += fCostToCustomer;
                    fSubCommission += fCustomerCommission;

                    this.m_nCustomerTotalCards += custProfit.getQuantity();
                    this.m_fCustomerTotal += fCostToCustomer;
                    this.m_fCustomerTotalCommission += fCustomerCommission;
                }
            }
            if (nSubTotalCards > 0) {
                strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
                strReportRows = strReportRows + "<tr bgcolor=E1E1E1><td></td><td> </td><td align=center><b>Sub Total</b></td>";
                strReportRows = strReportRows + "<td align=left><b>" + nSubTotalCards + "</b></td>";

                strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubTotal) + "</b></td>";
                /*strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";*/

                strReportRows = strReportRows + "</tr>";
                strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
            }
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = strInvoiceReport + strReportRows;
            }
            nSubTotalCards = 0;
            fSubTotal = 0.0F;
            fSubCommission = 0.0F;
            strReportRows = "";
            for (int i = 0; i < invoiceReport.size(); i++) {
                TReportCustomerProfit custProfit = (TReportCustomerProfit) invoiceReport.get(i);

                String strProductName = "";
                float fFaceValue = 0.0F;
                custProfit.getProduct();

                TMasterProductinfo prodInfo = custProfit.getProduct();
                TMasterSupplierinfo supInfo = prodInfo.getSupplier();
                TMasterSuppliertype supType = supInfo.getSupplierType();
                if (supType.getId() == 16) {
                    nSequence++;
                    strProductName = prodInfo.getProductName();
                    fFaceValue = prodInfo.getProductFaceValue();

                    Float fCostToCustomer = custProfit.getCostToCustomer();
                    Float fCustomerCommission = (custProfit.getRetailCost() * custProfit.getQuantity()) - fCostToCustomer;

                    strReportRows = strReportRows + "<tr bgcolor=969696>";
                    strReportRows = strReportRows + "<td align=left>" + nSequence + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + strProductName + " - " + ff.format(fFaceValue) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(custProfit.getRetailCost()) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + custProfit.getQuantity() + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + ff.format(fCostToCustomer) + "</td>";
/*                    strReportRows = strReportRows + "<td align=left>" + ff.format(fCustomerCommission) + "</td>";*/

                    strReportRows = strReportRows + "</tr>";

                    nSubTotalCards += custProfit.getQuantity();
                    fSubTotal += fCostToCustomer;
                    fSubCommission += fCustomerCommission;

                    this.m_nCustomerTotalCards += custProfit.getQuantity();
                    this.m_fCustomerTotal += fCostToCustomer;
                    this.m_fCustomerTotalCommission += fCustomerCommission;
                }
            }
            if (nSubTotalCards > 0) {
                strReportRows += "<tr><td></td></tr><tr><td></td><td></td></tr>";
                strReportRows += "<tr bgcolor=969696><td></td><td></td><td align=center><b>Sub Total</b></td>";
                strReportRows += "<td align=left><b>" + nSubTotalCards + "</b></td>";

                strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubTotal) + "</b></td>";
                /*strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";*/

                strReportRows = strReportRows + "</tr>";
                strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
            }
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = strInvoiceReport + strReportRows;
            }
            nSubTotalCards = 0;
            fSubTotal = 0.0F;
            fSubCommission = 0.0F;
            strReportRows = "";
            for (int i = 0; i < invoiceReport.size(); i++) {
                TReportCustomerProfit custProfit = (TReportCustomerProfit) invoiceReport.get(i);

                String strProductName = "";
                float fFaceValue = 0.0F;

                TMasterProductinfo prodInfo = custProfit.getProduct();
                TMasterSupplierinfo supInfo = prodInfo.getSupplier();
                TMasterSuppliertype supType = supInfo.getSupplierType();
                if (supInfo.getId() != 15 && supInfo.getId() != 37 && supType.getId() != 16 && supType.getId() != 17 && supInfo.getId() != 60 && supInfo.getId() != 56) {
                    nSequence++;
                    strProductName = prodInfo.getProductName();
                    fFaceValue = prodInfo.getProductFaceValue();

                    Float fCostToCustomer = custProfit.getCostToCustomer();
                    Float fCustomerCommission = custProfit.getRetailCost() * custProfit.getQuantity() - fCostToCustomer;

                    strReportRows += "<tr bgcolor=B4FFFF>";
                    strReportRows += "<td align=left>" + nSequence + "</td>";
                    strReportRows += "<td align=left>" + strProductName + " - " + ff.format(fFaceValue) + "</td>";
                    strReportRows += "<td align=left>" + ff.format(custProfit.getRetailCost()) + "</td>";
                    strReportRows += "<td align=left>" + custProfit.getQuantity() + "</td>";
                    strReportRows += "<td align=left>" + ff.format(fCostToCustomer) + "</td>";
                    /*strReportRows += "<td align=left>" + ff.format(fCustomerCommission) + "</td>";*/
                    strReportRows += "</tr>";

                    nSubTotalCards += custProfit.getQuantity();
                    fSubTotal += fCostToCustomer;
                    fSubCommission += fCustomerCommission;

                    this.m_nCustomerTotalCards += custProfit.getQuantity();
                    this.m_fCustomerTotal += fCostToCustomer;
                    this.m_fCustomerTotalCommission += fCustomerCommission;
                }
            }

            BigDecimal vatSales = null;
            if (nSubTotalCards > 0) {
                strReportRows += "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
                strReportRows += "<tr bgcolor=B4FFFF><td></td><td> </td><td align=center><b>Sub Total</b></td>";
                strReportRows += "<td align=left><b>" + nSubTotalCards + "</b></td>";
                strReportRows += "<td align=left><b>" + ff.format(fSubTotal) + "</b></td>";
                /*strReportRows += "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";*/
                strReportRows += "</tr>";

                strReportRows += "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";

                vatSales = new BigDecimal(fSubTotal).setScale(2, BigDecimal.ROUND_HALF_UP);
            }
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = strInvoiceReport + strReportRows;
            }
            nSubTotalCards = 0;
            fSubTotal = 0.0F;
            fSubCommission = 0.0F;
            strReportRows = "";

            List<TReportCustomerProfit> mobileTopups = new ArrayList<>();

            for(Object o : invoiceReport) {
                TReportCustomerProfit custProfit = (TReportCustomerProfit) o;
                Integer supplierId = custProfit.getProduct().getSupplier().getId();
                if(supplierId == 37 || supplierId == 60) {
                    mobileTopups.add(custProfit);
                }
            }

            if(!mobileTopups.isEmpty()) {
                nSequence++;
                String strProductName = "Mobile Topup";
                Float totalCostToCustomer = 0f;
                Float totalCustomerCommission = 0f;
                Integer quantity = 0;
                Float retailCost = 0f;

                for(TReportCustomerProfit custProfit: mobileTopups) {
                    Float fCostToCustomer = custProfit.getCostToCustomer();
                    Float fCustomerCommission = (custProfit.getRetailCost() * custProfit.getQuantity()) - fCostToCustomer;
                    totalCostToCustomer += fCostToCustomer;
                    totalCustomerCommission += fCustomerCommission;
                    quantity += custProfit.getQuantity();
                    retailCost += custProfit.getRetailCost();
                }

                strReportRows += "<tr bgcolor=FFFFAA>";
                strReportRows += "<td align=left>" + nSequence + "</td>";
                strReportRows += "<td align=left>" + strProductName + "</td>";
                strReportRows += "<td align=left>" + ff.format(retailCost) + "</td>";
                strReportRows += "<td align=left>" + quantity + "</td>";
                strReportRows += "<td align=left>" + ff.format(totalCostToCustomer) + "</td>";
                /*strReportRows += "<td align=left>" + ff.format(totalCustomerCommission) + "</td>";*/
                strReportRows = strReportRows + "</tr>";

                nSubTotalCards += quantity;
                fSubTotal += totalCostToCustomer;
                fSubCommission += totalCustomerCommission;

                this.m_nCustomerTotalCards += quantity;
                this.m_fCustomerTotal += totalCostToCustomer;
                this.m_fCustomerTotalCommission += totalCustomerCommission;
            }
            BigDecimal mobileTopup = null;
            if (nSubTotalCards > 0) {
                strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
                strReportRows = strReportRows + "<tr bgcolor=FFFFAA><td></td><td> </td><td align=center><b>Sub Total</b></td>";
                strReportRows = strReportRows + "<td align=left><b>" + nSubTotalCards + "</b></td>";
                strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubTotal) + "</b></td>";
                /*strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";*/

                strReportRows = strReportRows + "</tr>";
                strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";

                mobileTopup = new BigDecimal(fSubTotal).setScale(2, BigDecimal.ROUND_HALF_UP);
            }
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = strInvoiceReport + strReportRows;
            }
            strReportRows = "";
            strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
            strReportRows = strReportRows + "<tr bgcolor=80FF80><td></td><td> </td><td align=center><b>Grand Total</b></td>";
            strReportRows = strReportRows + "<td align=left><b>" + this.m_nCustomerTotalCards + "</b></td>";
            strReportRows = strReportRows + "<td align=left><b>" + ff.format(this.m_fCustomerTotal) + "</b></td>";
            /*strReportRows = strReportRows + "<td align=left><b>" + ff.format(this.m_fCustomerTotalCommission) + "</b></td>";*/

            strReportRows = strReportRows + "</tr>";

            if(vatSales != null) {
                BigDecimal percent = vatSales.divide(new BigDecimal("120"), RoundingMode.HALF_EVEN);
                BigDecimal vat = percent.multiply(new BigDecimal("20"));
                strReportRows += "<tr><td></td><td></td><td align=center>Non VAT Sales</td><td>" + new BigDecimal(this.m_fCustomerTotal + "").subtract(vatSales) + "</td></tr>";
                strReportRows += "<tr><td></td><td></td><td align=center>Net Amount</td><td>" + vatSales.subtract(vat) + "</td></tr>";
                strReportRows += "<tr><td></td><td></td><td align=center>VAT</td><td>" + vat + "</td></tr>";
                strReportRows += "<tr><td></td><td></td><td align=center>VAT Sales</td><td>" + vatSales + "</td></tr>";
                strReportRows += "<tr><td></td><td></td><td align=center>Grand Total</td><td>" + ff.format(this.m_fCustomerTotal) + "</td></tr>";
            }

            strReportRows = strReportRows + "</table>";
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = strInvoiceReport + strReportRows;
            }
            this.m_nCustomerID = 0;
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
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        this.m_nCustomerID = 0;
    }

    public void createSIMInvoiceReport() {
        if (this.m_nCustomerID <= 0) {
            return;
        }
        this.m_strInvoiceReport = "";
        this.m_nCustomerTotalCards = 0;
        this.m_fCustomerTotal = 0.0F;
        this.m_fCustomerTotalCommission = 0.0F;
        this.m_strAgentName = "";

        DecimalFormat ff = new DecimalFormat("0.00");
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            String strQuery = "from TMasterCustomerinfo where Customer_ID = " + this.m_nCustomerID;
            Query query = theSession.createQuery(strQuery);
            List custList = query.list();
            if (custList.size() < 0) {
                this.m_nCustomerID = 0;
                return;
            }
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
            User introducedBy = custInfo.getIntroducedBy();
            this.m_strAgentName = introducedBy.getUserFirstName();

            String strInvoiceReport = "";
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = PrepareInvoiceHeader(custInfo, true);
            }
            String strFileName = "Unknown.html";
            if (this.m_bGenerateHTMLFiles) {
                strFileName = this.m_strCustomers + custInfo.getCompanyName() + ".html";
            }
            strQuery = "from TReportCustomerProfit where Begin_Date = " + this.m_strDurationBegin + " and Customer_ID = "
                    + custInfo.getId();

            Query query2 = theSession.createQuery(strQuery);
            List invoiceReport = query2.list();

            int nSubTotalCards = 0;
            float fSubTotal = 0.0F;
            float fSubCommission = 0.0F;
            String strReportRows = "";

            int nSequence = 0;
            for (int i = 0; i < invoiceReport.size(); i++) {
                TReportCustomerProfit custProfit = (TReportCustomerProfit) invoiceReport.get(i);

                String strProductName = "";
                float fFaceValue = 0.0F;
                custProfit.getProduct();

                TMasterProductinfo prodInfo = custProfit.getProduct();
                TMasterSupplierinfo supInfo = prodInfo.getSupplier();
                TMasterSuppliertype supType = supInfo.getSupplierType();
                if (supType.getId() == 17) {
                    nSequence++;
                    strProductName = prodInfo.getProductName();
                    fFaceValue = prodInfo.getProductFaceValue();

                    Float fCostToCustomer = custProfit.getCostToCustomer();
                    Float fCustomerCommission = fCostToCustomer;

                    strReportRows = strReportRows + "<tr bgcolor=E1E1E1>";
                    strReportRows = strReportRows + "<td align=left>" + nSequence + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + strProductName + " - " + ff.format(fFaceValue) + "</td>";
                    strReportRows = strReportRows + "<td align=left>" + custProfit.getQuantity() + "</td>";
                    /*strReportRows = strReportRows + "<td align=left>" + ff.format(fCustomerCommission) + "</td>";*/

                    strReportRows = strReportRows + "</tr>";

                    nSubTotalCards += custProfit.getQuantity();
                    fSubTotal += fCostToCustomer;
                    fSubCommission += fCustomerCommission;

                    this.m_nCustomerTotalCards += custProfit.getQuantity();
                    this.m_fCustomerTotal += fCostToCustomer;
                    this.m_fCustomerTotalCommission += fCustomerCommission;
                }
            }
            if (nSubTotalCards > 0) {
                strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
                strReportRows = strReportRows + "<tr bgcolor=E1E1E1><td></td><td align=center><b>Sub Total</b></td>";
                strReportRows = strReportRows + "<td align=left><b>" + nSubTotalCards + "</b></td>";
                /*strReportRows = strReportRows + "<td align=left><b>" + ff.format(fSubCommission) + "</b></td>";*/
                strReportRows = strReportRows + "</tr>";
                strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
            }
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = strInvoiceReport + strReportRows;
            }
            strReportRows = "";
            strReportRows = strReportRows + "<tr><td> </td></tr><tr><td> </td><td> </td></tr>";
            strReportRows = strReportRows + "<tr bgcolor=80FF80><td></td><td align=center><b>Grand Total</b></td>";
            strReportRows = strReportRows + "<td align=left><b>" + this.m_nCustomerTotalCards + "</b></td>";
            /*strReportRows = strReportRows + "<td align=left><b>" + ff.format(this.m_fCustomerTotalCommission) + "</b></td>";*/

            strReportRows = strReportRows + "</tr>";
            strReportRows = strReportRows + "</table>";
            if (this.m_bGenerateHTMLOutput) {
                strInvoiceReport = strInvoiceReport + strReportRows;
            }
            this.m_nCustomerID = 0;
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
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        this.m_nCustomerID = 0;
    }

    private String PrepareInvoiceHeader(TMasterCustomerinfo custInfo, boolean isSimReport) {
        TMasterCustomerGroups custGroup = custInfo.getGroup();
        String strInvoiceHeader = "";
        String strSIMReport = "";
        if (isSimReport) {
            strSIMReport = "SIM ";
        }
        if (this.m_bGenerateHTMLFiles) {
            strInvoiceHeader = "<html> <body>";
        }
        strInvoiceHeader = strInvoiceHeader + "<table width=100%>";
        strInvoiceHeader = strInvoiceHeader + "<tr>";
        strInvoiceHeader = strInvoiceHeader + "<td align=left>";
        strInvoiceHeader = strInvoiceHeader + "<font size=5><b>" + custInfo.getCompanyName() + "</b></font>";
        strInvoiceHeader = strInvoiceHeader + "</td>";
        strInvoiceHeader = strInvoiceHeader + "<td align=right>";
        strInvoiceHeader = strInvoiceHeader + "<font size=5><b>" + "ESSYCALL" + "</b></font>";
        //strInvoiceHeader = strInvoiceHeader + "<font size=5><b>" + custGroup.getName() + "</b></font>";
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
        strInvoiceHeader = strInvoiceHeader + "<font size=2><b>e-Mail: " + custGroup.getGroupEmailId() + "</b></font>";
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
        strInvoiceHeader = strInvoiceHeader + "<u><center><H3>" + strSIMReport + "Monthly Sales Report From "
                + this.m_strDisplayDurationBegin + " To " + this.m_strDisplayDurationEnd + "</H3></center></u>";
        strInvoiceHeader = strInvoiceHeader + "<BR>";
        strInvoiceHeader = strInvoiceHeader + "<table width=100%>";
        strInvoiceHeader = strInvoiceHeader + "<tr>";
        strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Serial Number</b></td>";
        strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Product</b></td>";
        if (!isSimReport) {
            strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Retail Price</b></td>";
        }
        strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Quantity</b></td>";
        if (!isSimReport) {
            strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Amount</b></td>";
        }
        /*strInvoiceHeader = strInvoiceHeader + "<td align=left><b>Commission</b></td>";*/

        strInvoiceHeader = strInvoiceHeader + "</tr>";
        strInvoiceHeader = strInvoiceHeader + "<tr><td></td></tr>";

        return strInvoiceHeader;
    }
}
