package com.ding;

import com.eezeetel.ding.v2.EDTSManagerStub;
import com.eezeetel.ding.v2.EDTSManagerStub.*;
import com.eezeetel.entity.TCustomerCommission;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import com.eezeetel.mobitopup.MobitopupUtil;
import com.eezeetel.service.DingTransactionService;
import com.eezeetel.util.HibernateUtil;
import com.google.common.base.CharMatcher;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.FileWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

//import org.apache.axis2.AxisFault;

public class DingMain {
    private static Logger m_logger = Logger.getLogger(DingMain.class);
    public static final int Ding_SupplierID = 60; // change this
    public static final int Ding_ProductType = 16; // change this
    public static final int Ding_International_Mobile_Topup_Product_ID = 390; // change
    // this
    private final int Ding_DefaultPercentage = 7;
    public static final int TICKETS_INCREMENT = 5;
    private static final String m_strUserName = "6b854b3d-27aa-46a3-b474-49f40675ce14";
    private static final String m_strPassword = "bI7ecPZ31ba003asg4TLGqK5D3JaFbcYw/T2ipD8BfeBj5rCjGgNg8XgWF0m7TltSEKfH6yJZeCHZ/7fiq8HImrgMf9f5c5v4a+D+ggD02Y=";
    private int m_nCustomerID;
    private long m_nTransactionID;
    private String m_strUserID;
    public static int m_nMessageID = 1;

    private static List<ProductDetails> g_prodList;
    private static String g_jsonString = "";

    static {
        g_prodList = new ArrayList<>();
        DingMain dingService = new DingMain(1, "");
        dingService.ReadAvailableProducrts();
    }

    public static void main(String[] args) {
        DingMain dingService = new DingMain(31, "");
//		dingService.GetDetailsForPhoneNumber("18765529052");
        PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("18764459922", "DC", "JM");

        //PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("18765529052", null, null);
        //PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("254712319900", null, null);
        //PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("919581491391", "VF", "IN");
        //PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("923217629207", "UF", "PK");
        //PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("920000000000", "UF", "PK");
        //PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("919866629822", "AI", "IN");
        //PhoneNumberDetails details = dingService.GetDetailsForPhoneNumber("910000000000", "VF", "IN");
        //9581491391
        System.out.println(details.strOperator + " - " + details.strOperatorID);
        System.out.println("************");
        for (int i = 0; details.operatorsList != null && i < details.operatorsList.size(); i++) {
            OperatorDetails od = (OperatorDetails) details.operatorsList.get(i);
            System.out.println(od.strOperator + " - " + od.strOperatorCode);
        }

        for (int j = 0; j < details.Amounts.size(); j++) {
            System.out.println(details.Amounts.get(j).m_fDestinationValueWithTax);
            System.out.println(details.Amounts.get(j).m_fSuggestedRetailPrice);
            System.out.println(details.Amounts.get(j).m_fDenomination);
        }
    }

    public List<ProductDetails> getProductDetails() {
        return g_prodList;
    }

    public String GetOperator(String country_code, String op_id) {

        if (country_code == null || op_id == null) return "";

        for (ProductDetails p : g_prodList) {
            if (p.m_strCountryCode.compareToIgnoreCase(country_code) == 0
                    && p.m_strOperatorCode.compareToIgnoreCase(op_id) == 0) {
                return p.m_strOperator;
            }
        }
        return "";
    }

    public String GetCountry(String country_code) {
        if (country_code == null) return "";

        for (int i = 0; i < g_prodList.size(); i++) {
            ProductDetails p = g_prodList.get(i);
            if (p.m_strCountryCode.compareToIgnoreCase(country_code) == 0)
                return p.m_strCountry;
        }
        return "";
    }

    public String GetCountryFromTelephoneCode(String telephonecode) {
        if (telephonecode == null) return "";

        for (int i = 0; i < g_prodList.size(); i++) {
            ProductDetails p = g_prodList.get(i);
            if (p.m_strTelehoneCode.compareToIgnoreCase(telephonecode) == 0)
                return p.m_strCountryCode;
        }
        return "";
    }

    public String GetCustomerCareNumber(String country, String country_code,
                                        String op_id, String operator) {
        for (int i = 0; i < g_prodList.size(); i++) {
            ProductDetails p = g_prodList.get(i);
            if (p.m_strCountryCode.compareToIgnoreCase(country_code) == 0
                    && p.m_strOperatorCode.compareToIgnoreCase(op_id) == 0
                    && p.m_strOperator.compareToIgnoreCase(operator) == 0)
                return p.m_strCustomerCareNumber;
        }
        return "";
    }

    public void GetProductNames() {
        int nMessageID = DingMain.getMessageID();

        try {
            EDTSManagerStub theStub = new EDTSManagerStub();
            EDTSManagerStub.AuthenticationToken authToken = new EDTSManagerStub.AuthenticationToken();
            authToken.setAuthenticationID(m_strUserName);
            authToken.setAuthenticationPassword(m_strPassword);

            EDTSManagerStub.GetProductListRequest prodListReq = new EDTSManagerStub.GetProductListRequest();
            prodListReq.setAuthenticationToken(authToken);
            prodListReq.setMessageID(nMessageID);

            EDTSManagerStub.GetProductListRequestE theReq = new EDTSManagerStub.GetProductListRequestE();
            theReq.setGetProductListRequest(prodListReq);
            EDTSManagerStub.GetProductListResult result = theStub.getProductList(theReq);
            EDTSManagerStub.GetProductListResponse res = result.getGetProductListResult();

            if (res.getMessageID() == nMessageID) {
                EDTSManagerStub.ArrayOfProduct prodList = res.getProducts();
                EDTSManagerStub.Product[] products = prodList.getProduct();
                for (int i = 0; i < products.length; i++) {
                    Product p = products[i];
                    ProductDetails prod = new ProductDetails();
                    String phoneMask = p.getPhoneNumberMask();
                    if (phoneMask == null)
                        continue;

                    prod.m_strTelehoneCode = new String();
                    int nMobileNumberDigits = 0;
                    for (int j = 0; j < phoneMask.length(); j++) {
                        char c = phoneMask.charAt(j);
                        if (c <= 57 && c >= 48)
                            prod.m_strTelehoneCode += c;

                        if (c == 'x' || c == 'X')
                            nMobileNumberDigits++;
                    }

                    prod.m_bUse = true;
                    if (prod.m_strTelehoneCode.length() > 4)
                        prod.m_bUse = false;

                    prod.m_nCountryCodeLength = prod.m_strTelehoneCode.length();

                    prod.m_strCountryCode = p.getCountryCode();
                    prod.m_strCountry = products[i].getCountryName()
                            .replaceAll("[0-9]", "");
                    prod.m_strOperatorCode = products[i].getOperatorCode();
                    prod.m_strOperator = products[i].getOperatorName();
                    prod.m_strCustomerCareNumber = products[i]
                            .getCustomerCareNumber();
                    prod.m_strCurrencyCode = products[i].getCommercialCode();
                    prod.m_strLogoUri = products[i].getLogoUrl();
                    prod.m_strTelehoneMask = p.getPhoneNumberMask();
                    prod.m_strCountryISO = products[i].getCountryISO();
                    prod.m_isSupported = IsCountrySupported(prod.m_strCountryISO);
                    prod.m_nDigitsAllowed = nMobileNumberDigits;

                    MinMaxValueRange valRange = products[i].getMinMaxValueRange();
                    if (valRange != null) {
                        prod.m_fMinValue = (float) valRange.getMinValue();
                        prod.m_fMaxValue = (float) valRange.getMaxValue();
                    } else {
                        prod.m_fMinValue = 0.0f;
                        prod.m_fMaxValue = 0.0f;
                    }

                    prod.m_nTotalDenominations = 0;
                    prod.m_Denominations = new ArrayList<Float>();
                    Denomination dens = products[i].getDenominations();
                    if (dens != null) {
                        ArrayOfDouble densArray = dens.getDenominations();
                        double[] finalDens = densArray.get_double();
                        prod.m_nTotalDenominations = dens.getNumberOfDenominations();
                        for (int j = 0; j < dens.getNumberOfDenominations(); j++) {
                            prod.m_Denominations.add((float) finalDens[j]);
                        }
                    }

                    g_prodList.add(prod);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Collections.sort(g_prodList);
    }

    public void DetermingUsage() // country code with less number of digits is
    // used if more than one is available
    {
        for (int i = 0; i < g_prodList.size(); i++) {
            ProductDetails prod = g_prodList.get(i);
            for (int j = i + 1; j < g_prodList.size(); j++) {
                ProductDetails prodNext = g_prodList.get(j);
                if (prod.m_strCountry.compareToIgnoreCase(prodNext.m_strCountry) == 0) {
                    if (prod.m_nCountryCodeLength > prodNext.m_nCountryCodeLength) {
                        prod.m_bUse = false;
                        prod = prodNext;
                    }
                }
            }
        }
    }

    public PhoneNumberDetails GetDetailsForPhoneNumber(String strPhoneNumber, String operatorCode, String countryCode) {
        int nMessageID = DingMain.getMessageID();
        PhoneNumberDetails phoneNumberDetails = new PhoneNumberDetails();
        phoneNumberDetails.success = false;
        phoneNumberDetails.isRangeOperator = false;
        try {
            EDTSManagerStub theStub = new EDTSManagerStub();
            EDTSManagerStub.AuthenticationToken authToken = new EDTSManagerStub.AuthenticationToken();
            authToken.setAuthenticationID(m_strUserName);
            authToken.setAuthenticationPassword(m_strPassword);

            String strOperatorCode = "EO";
            if (operatorCode != null && !operatorCode.isEmpty())
                strOperatorCode = operatorCode;

            String strCountryCode = "EO";
            if (countryCode != null && !countryCode.isEmpty())
                strCountryCode = countryCode;

            EDTSManagerStub.ValidatePhoneAccountRequest validatePhoneReq = new EDTSManagerStub.ValidatePhoneAccountRequest();
            validatePhoneReq.setAuthenticationToken(authToken);
            validatePhoneReq.setMessageID(nMessageID);
            validatePhoneReq.setCountryCode(strCountryCode);
            validatePhoneReq.setOperatorCode(strOperatorCode);
            validatePhoneReq.setAmount(0);
            validatePhoneReq.setPhoneNumber(strPhoneNumber);

            EDTSManagerStub.ValidatePhoneAccountRequestE theReq = new EDTSManagerStub.ValidatePhoneAccountRequestE();
            theReq.setValidatePhoneAccountRequest(validatePhoneReq);
            EDTSManagerStub.ValidatePhoneAccountResult result = theStub.validatePhoneAccount(theReq);
            EDTSManagerStub.ValidatePhoneAccountResponse res = result.getValidatePhoneAccountResult();
            if (res != null && res.getMessageID() == nMessageID) {
                phoneNumberDetails.strSendersNumber = "";
                phoneNumberDetails.strReceiversNumber = strPhoneNumber;
                phoneNumberDetails.strCountry = res.getCountryName();
                phoneNumberDetails.strCountryCode = res.getCountryCode();
                phoneNumberDetails.strOperator = res.getOperatorName();
                phoneNumberDetails.strOperatorID = res.getOperatorCode();
                phoneNumberDetails.Amounts = new ArrayList<>();
            }

            ValidatePhoneAccountStatus status = res.getValidatePhoneAccountStatus();
            if (status.getStatusID() == 666 || status.getStatusID() == 1)
                phoneNumberDetails.success = true;

            boolean isDigicel = MobitopupUtil.isDigicel(strCountryCode, strOperatorCode);

            int nDens = 0;
            ArrayOfDouble dens = null;
            double[] finalDenominations = null;
            Denomination den = res.getDenominations();
            if (den != null) {
                nDens = den.getNumberOfDenominations();
                dens = den.getDenominations();
                finalDenominations = dens.get_double();

                for (int i = 0; i < nDens; i++) {
                    AmountsAndCommission oneAdmountAndCommission = new AmountsAndCommission();
                    oneAdmountAndCommission.m_fDenomination = (float) finalDenominations[i];
                    GetCommissions(oneAdmountAndCommission, false, isDigicel);
                    GetDestinationTopupAmount(phoneNumberDetails, oneAdmountAndCommission, oneAdmountAndCommission.m_fDenomination);
                    phoneNumberDetails.Amounts.add(oneAdmountAndCommission);
                }
            } else {
                if (phoneNumberDetails.success) {
                    if (phoneNumberDetails.strOperatorID == null)
                        phoneNumberDetails.strOperatorID = strOperatorCode;

                    if (phoneNumberDetails.strCountryCode == null)
                        phoneNumberDetails.strCountryCode = strCountryCode;

                    for (int i = 0; i < g_prodList.size(); i++) {
                        ProductDetails prodDetails = g_prodList.get(i);
                        if (prodDetails.m_strCountryCode.compareToIgnoreCase(phoneNumberDetails.strCountryCode) == 0 &&
                                prodDetails.m_strOperatorCode.compareToIgnoreCase(phoneNumberDetails.strOperatorID) == 0) {
                            if (prodDetails.m_nTotalDenominations > 0) {
                                for (int j = 0; j < prodDetails.m_nTotalDenominations; j++) {
                                    AmountsAndCommission oneAdmountAndCommission = new AmountsAndCommission();
                                    oneAdmountAndCommission.m_fDenomination = (float) (prodDetails.m_Denominations.get(j));
                                    GetCommissions(oneAdmountAndCommission, false, isDigicel);
                                    GetDestinationTopupAmount(phoneNumberDetails, oneAdmountAndCommission, oneAdmountAndCommission.m_fDenomination);
                                    phoneNumberDetails.Amounts.add(oneAdmountAndCommission);
                                }
                            } else {
                                phoneNumberDetails.isRangeOperator = true;

                                nDens = 12;
                                float fStartVal = (float) Math.ceil(prodDetails.m_fMinValue);
                                if (fStartVal < 5)
                                    fStartVal = 5;
                                float fEndVal = (float) Math.floor(prodDetails.m_fMaxValue);
                                float fDenomination = fStartVal;

                                if (fStartVal > 0.5 && fEndVal > 0.5) {
                                    for (int j = 0; j < nDens && fDenomination <= fEndVal; j++) {

                                        AmountsAndCommission oneAdmountAndCommission = new AmountsAndCommission();
                                        oneAdmountAndCommission.m_fDenomination = fDenomination;
                                        GetCommissions(oneAdmountAndCommission, true, isDigicel);
                                        GetDestinationTopupAmount(phoneNumberDetails, oneAdmountAndCommission, oneAdmountAndCommission.m_fDenomination);
                                        phoneNumberDetails.Amounts.add(oneAdmountAndCommission);
                                        fDenomination += TICKETS_INCREMENT;
                                    }
                                }
                            }

                            break;
                        }
                    }
                }
            }

            if (phoneNumberDetails.success) {
                if (phoneNumberDetails.strCountry == null
                        || phoneNumberDetails.strCountry.isEmpty()
                        || phoneNumberDetails.strCountry.compareToIgnoreCase("null") == 0) {
                    phoneNumberDetails.strCountry = GetCountry(phoneNumberDetails.strCountryCode);
                }

                if (phoneNumberDetails.strOperator == null
                        || phoneNumberDetails.strOperator.isEmpty()
                        || phoneNumberDetails.strOperator.compareToIgnoreCase("null") == 0) {
                    phoneNumberDetails.strOperator = GetOperator(phoneNumberDetails.strCountryCode,
                            phoneNumberDetails.strOperatorID);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return phoneNumberDetails;
    }

    public void GetDestinationTopupAmount(PhoneNumberDetails phoneDetails,
                                          AmountsAndCommission amountsAndCommissions, float fTopupAmount) {
        int nMessageID = DingMain.getMessageID();
        try {
            EDTSManagerStub theStub = new EDTSManagerStub();
            EDTSManagerStub.AuthenticationToken authToken = new EDTSManagerStub.AuthenticationToken();
            authToken.setAuthenticationID(m_strUserName);
            authToken.setAuthenticationPassword(m_strPassword);

            EDTSManagerStub.GetTargetTopUpAmountRequest targetAmountReq = new EDTSManagerStub.GetTargetTopUpAmountRequest();
            targetAmountReq.setAuthenticationToken(authToken);
            targetAmountReq.setMessageID(nMessageID);
            targetAmountReq.setCountryCode(phoneDetails.strCountryCode);
            targetAmountReq.setOperatorCode(phoneDetails.strOperatorID);
            targetAmountReq.setAmount(fTopupAmount);

            EDTSManagerStub.GetTargetTopUpAmountRequestE theReq = new EDTSManagerStub.GetTargetTopUpAmountRequestE();
            theReq.setGetTargetTopUpAmountRequest(targetAmountReq);
            GetTargetTopUpAmountResult result = theStub.getTargetTopUpAmount(theReq);
            GetTargetTopUpAmountResponse res = result.getGetTargetTopUpAmountResult();
            if (res.getMessageID() == nMessageID) {
                amountsAndCommissions.m_fDestinationValueWithTax = (float) res.getAmount();
                amountsAndCommissions.m_fDestinationValueWithOutTax = res.getAmountExcludingTax();
                amountsAndCommissions.m_fDestinationTax = (float) res.getTaxAmount();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public float GetBalance() {
        int nMessageID = DingMain.getMessageID();

        try {
            EDTSManagerStub theStub = new EDTSManagerStub();
            EDTSManagerStub.AuthenticationToken authToken = new EDTSManagerStub.AuthenticationToken();
            authToken.setAuthenticationID(m_strUserName);
            authToken.setAuthenticationPassword(m_strPassword);

            EDTSManagerStub.GetBalanceRequest getBalanceReq = new EDTSManagerStub.GetBalanceRequest();
            getBalanceReq.setAuthenticationToken(authToken);
            getBalanceReq.setMessageID(nMessageID);

            EDTSManagerStub.GetBalanceRequestE theReq = new EDTSManagerStub.GetBalanceRequestE();
            theReq.setGetBalanceRequest(getBalanceReq);
            GetBalanceResult result = theStub.getBalance(theReq);
            EDTSManagerStub.GetBalanceResponse res = result
                    .getGetBalanceResult();
            if (res.getMessageID() == nMessageID) {
                BigDecimal resBalance = res.getBalance();
                return resBalance.floatValue();
            }
        } catch (Exception e) {
            m_logger.error("Ding - " + e.getMessage());
        }

        return 0;
    }

    public boolean IsCountrySupported(String countriCode) {
        int nMessageID = DingMain.getMessageID();

        try {
            EDTSManagerStub theStub = new EDTSManagerStub();
            EDTSManagerStub.AuthenticationToken authToken = new EDTSManagerStub.AuthenticationToken();
            authToken.setAuthenticationID(m_strUserName);
            authToken.setAuthenticationPassword(m_strPassword);

            IsCountrySupportedByEzeOperatorRequest countrySupportReq1 = new IsCountrySupportedByEzeOperatorRequest();
            countrySupportReq1.setAuthenticationToken(authToken);
            countrySupportReq1.setMessageId(nMessageID);
            countrySupportReq1.setCountryIso(countriCode);
            EDTSManagerStub.RequestE req = new EDTSManagerStub.RequestE();
            req.setRequest(countrySupportReq1);

            EDTSManagerStub.IsCountrySupportedByEzeOperatorResult result = theStub
                    .isCountrySupportedByEzeOperator(req);
            IsCountrySupportedByEzeOperatorResponse res = result
                    .getIsCountrySupportedByEzeOperatorResult();
            if (res.getMessageId() == nMessageID) {
                return res.getCountryIsSupported();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public DingMain(int nCustomerID, String strUserID) {
        m_nCustomerID = nCustomerID;
        m_strUserID = strUserID;
    }

    public static synchronized int getMessageID() {
        if (m_nMessageID > (Integer.MAX_VALUE - 10))
            m_nMessageID = 1;

        return m_nMessageID++;
    }

    private void GetCommissions(AmountsAndCommission amountsAndCommission, boolean isRangeOperator, boolean isDigicel) {
        Session theSession = null;
        try {

            float fEezeetelCommission = 0;
            float fAgentCommission = 0;
            float fGroupCommission = 0;
            float fCustomerCommission = 0;

            theSession = HibernateUtil.openSession();
            String strQuery = "from TMasterCustomerinfo where Customer_ID = " + m_nCustomerID;

            Query query = theSession.createQuery(strQuery);
            List custList = query.list();

            int nCustomerGroupID = 1;
            boolean agentExist = false;
            if (custList != null && custList.size() > 0) {
                TMasterCustomerinfo customer = (TMasterCustomerinfo) custList.get(0);
                nCustomerGroupID = customer.getGroup().getId();
                User introducedBy = customer.getIntroducedBy();
                if (introducedBy.getUserType().getId() == 6
                        && introducedBy.getLogin().compareToIgnoreCase("First") != 0)
                    agentExist = true;

                strQuery = "from TCustomerCommission where Customer_ID = " + m_nCustomerID + " and " +
                        "Product_ID = " + Ding_International_Mobile_Topup_Product_ID;

                List custCommission = theSession.createQuery(strQuery).list();
                if (custCommission != null && custCommission.size() > 0) {
                    TCustomerCommission custCom = (TCustomerCommission) custCommission.get(0);
                }

                strQuery = "from TCustomerGroupCommissions where Customer_Group_ID = " + nCustomerGroupID + " and " +
                        "Product_ID = " + Ding_International_Mobile_Topup_Product_ID;

                List groupCommission = theSession.createQuery(strQuery).list();
            }

            fCustomerCommission = MobitopupUtil.getCustomerCommission(isDigicel).floatValue();
            if (nCustomerGroupID == 1) {
                fEezeetelCommission = 0;
                fGroupCommission = (isDigicel) ? 0 : 5;
                fAgentCommission = 0;
                if (agentExist) {
                    fGroupCommission = (isDigicel) ? 0 : 3;
                    fAgentCommission = (isDigicel) ? 2 : 3;
                }
            } else {
                fEezeetelCommission = (isDigicel) ? 0 : 3;
                fGroupCommission = 2;
                fAgentCommission = 0;
            }

            fEezeetelCommission = amountsAndCommission.m_fDenomination * fEezeetelCommission / 100;
            fGroupCommission = amountsAndCommission.m_fDenomination * fGroupCommission / 100;
            fAgentCommission = amountsAndCommission.m_fDenomination * fAgentCommission / 100;
            fCustomerCommission = amountsAndCommission.m_fDenomination * fCustomerCommission / 100;

            amountsAndCommission.m_fEezeeTelPrice = amountsAndCommission.m_fDenomination;
            amountsAndCommission.m_fGroupPrice = amountsAndCommission.m_fEezeeTelPrice + fEezeetelCommission;
            amountsAndCommission.m_fAgentPrice = amountsAndCommission.m_fGroupPrice + fGroupCommission;
            amountsAndCommission.m_fCustomerPrice = amountsAndCommission.m_fAgentPrice + fAgentCommission;
            amountsAndCommission.m_fSuggestedRetailPrice = amountsAndCommission.m_fCustomerPrice + fCustomerCommission;

            if (isRangeOperator) {
                amountsAndCommission.m_fSuggestedRetailPrice = amountsAndCommission.m_fDenomination;
                amountsAndCommission.m_fCustomerPrice = amountsAndCommission.m_fSuggestedRetailPrice - fCustomerCommission;
                amountsAndCommission.m_fAgentPrice = amountsAndCommission.m_fCustomerPrice - fAgentCommission;
                amountsAndCommission.m_fGroupPrice = amountsAndCommission.m_fAgentPrice - fGroupCommission;
                amountsAndCommission.m_fEezeeTelPrice = amountsAndCommission.m_fGroupPrice - fEezeetelCommission;
                amountsAndCommission.m_fDenomination = amountsAndCommission.m_fEezeeTelPrice;

                if (isDigicel) {
                    if (nCustomerGroupID == 1) {
                        amountsAndCommission.m_fGroupPrice = amountsAndCommission.m_fSuggestedRetailPrice;
                        amountsAndCommission.m_fEezeeTelPrice = amountsAndCommission.m_fSuggestedRetailPrice;
                    } else
                        amountsAndCommission.m_fEezeeTelPrice = amountsAndCommission.m_fSuggestedRetailPrice;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    }

    public TopupResponse PerformTopUpOperation(String strDestPhone, String senderPhone,
                                               String strCountryCode, String strOperatorID, String smsText,
                                               float fTopupAmount, boolean isRangeOperator, ServletContext sc) {
        AmountsAndCommission oneAdmountAndCommission = new AmountsAndCommission();
        oneAdmountAndCommission.m_fDenomination = fTopupAmount;
        oneAdmountAndCommission.m_fSuggestedRetailPrice = fTopupAmount;

        boolean isDigicel = false;
        if (strCountryCode.compareToIgnoreCase("JM") == 0 && strOperatorID.compareToIgnoreCase("DC") == 0) {
            isDigicel = true;
        }

        GetCommissions(oneAdmountAndCommission, isRangeOperator, isDigicel);

        float fCostToCustomer = oneAdmountAndCommission.m_fCustomerPrice;
        float fCostToAgent = oneAdmountAndCommission.m_fAgentPrice;
        float fCostToGroup = oneAdmountAndCommission.m_fGroupPrice;

        // get destination value again

        PhoneNumberDetails phoneNumberDetails = new PhoneNumberDetails();
        phoneNumberDetails.strCountryCode = strCountryCode;
        phoneNumberDetails.strOperatorID = strOperatorID;

        float fFinalTopupAmount = oneAdmountAndCommission.m_fDenomination;
        if (isRangeOperator)
            fFinalTopupAmount = oneAdmountAndCommission.m_fSuggestedRetailPrice;

        GetDestinationTopupAmount(phoneNumberDetails, oneAdmountAndCommission, fFinalTopupAmount);

        int nMessageID = DingMain.getMessageID();
        int smsMessageID = DingMain.getMessageID();
        TopupResponse topuRes = new TopupResponse();
        topuRes.success = false;
        topuRes.m_strSender = CharMatcher.DIGIT.retainFrom(senderPhone == null ? "" : senderPhone);

        TMasterCustomerinfo customer = null;
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            String strQuery = "from TMasterCustomerinfo where Customer_ID = " + m_nCustomerID;

            customer = (TMasterCustomerinfo) theSession.createQuery(strQuery).uniqueResult();
        } finally {
            HibernateUtil.closeSession(theSession);
        }

        try {
            EDTSManagerStub theStub = new EDTSManagerStub();
            EDTSManagerStub.AuthenticationToken authToken = new EDTSManagerStub.AuthenticationToken();
            authToken.setAuthenticationID(m_strUserName);
            authToken.setAuthenticationPassword(m_strPassword);

            SendSMSRequest smsReq = new SendSMSRequest();
            smsReq.setAuthenticationToken(authToken);
            smsReq.setCountryCode(strCountryCode);
            smsReq.setMessageFrom("EezeeTel");
            smsReq.setMessagePhoneNumber(strDestPhone);
            smsReq.setMessageID(smsMessageID);
            smsReq.setOperatorCode(strOperatorID);
            smsReq.setMessageText(smsText);

            EDTSManagerStub.TopUpPhoneAccountRequest topupReq = new EDTSManagerStub.TopUpPhoneAccountRequest();
            topupReq.setAuthenticationToken(authToken);
            topupReq.setMessageID(nMessageID);
            topupReq.setCountryCode(strCountryCode);
            topupReq.setOperatorCode(strOperatorID);
            topupReq.setPhoneNumber(strDestPhone);
            if (isDigicel)
                topupReq.setAmount(oneAdmountAndCommission.m_fSuggestedRetailPrice);
            else
                topupReq.setAmount(oneAdmountAndCommission.m_fDenomination);
            topupReq.setComment("Thank you from EezeeTel");
            topupReq.setSMSRequest(smsReq);

            EDTSManagerStub.TopUpPhoneAccountRequestE theReq = new EDTSManagerStub.TopUpPhoneAccountRequestE();
            theReq.setTopUpPhoneAccountRequest(topupReq);
            TopUpPhoneAccountResult result = theStub.topUpPhoneAccount(theReq);
            TopUpPhoneAccountResponse res = result.getTopUpPhoneAccountResult();
            TopUpPhoneAccountAmountSent amtSent = res.getTopUpPhoneAccountAmountSent();

            if (res.getMessageID() == nMessageID) {
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                TopUpPhoneAccountStatus status = res.getTopUpPhoneAccountStatus();
                status.getConfirmationID();

                topuRes.m_nErrorCode = status.getStatusID();
                topuRes.m_strErrorText = status.getStatusDescription() == null ? "" : status.getStatusDescription();
                if (topuRes.m_nErrorCode == 1) {
                    topuRes.success = true;
                    topuRes.m_strCompany = customer != null ? customer.getCompanyName() : "";
                    topuRes.m_eezeeTelTransactionID = "";
                    topuRes.m_dingTransactionID = status.getConfirmationID() + "";
                    topuRes.m_strTime = sdf.format(cal.getTime());
                    topuRes.m_strReceiver = strDestPhone;
                    topuRes.m_strCountry = res.getCountryName();
                    topuRes.m_strCountryCode = strCountryCode;
                    topuRes.m_strOperatorCode = strOperatorID;
                    topuRes.m_strOperator = res.getOperatorName();

                    if (topuRes.m_strOperator == null
                            || topuRes.m_strOperator.isEmpty()
                            || topuRes.m_strOperator.compareToIgnoreCase("null") == 0) {
                        topuRes.m_strOperator = GetOperator(strCountryCode, strOperatorID);
                    }

                    if (topuRes.m_strCountry == null
                            || topuRes.m_strCountry.isEmpty()
                            || topuRes.m_strCountry.compareToIgnoreCase("null") == 0) {
                        topuRes.m_strCountry = GetCountry(strCountryCode);
                    }

                    topuRes.m_fCostToCustomer = fCostToCustomer;
                    topuRes.m_fCostToAgent = fCostToAgent;
                    topuRes.m_fCostToGroup = fCostToGroup;
                    topuRes.m_fCostToEezeeTel = oneAdmountAndCommission.m_fEezeeTelPrice;
                    topuRes.m_fDestTopupValue = amtSent.getAmount();
                    topuRes.m_fDestTax = amtSent.getTaxAmount();
                    topuRes.m_fDestTopupValueAfterTax = amtSent.getAmountExcludingTax();
                    topuRes.m_strCustomerCare = res.getCustomerCareNumber();
                    if (topuRes.m_strCustomerCare == null
                            || topuRes.m_strCustomerCare.isEmpty()
                            || topuRes.m_strCustomerCare.compareToIgnoreCase("null") == 0) {
                        topuRes.m_strCustomerCare = GetCustomerCareNumber(
                                topuRes.m_strCountry, strCountryCode,
                                strOperatorID, topuRes.m_strOperator);
                    }

                    topuRes.m_strSMSSent = (smsText.isEmpty() ? "NO" : "YES");
                    topuRes.m_strSMSString = smsText;
                    topuRes.m_fEezeeTelBalance = GetBalance();
                    topuRes.m_fRetailPrice = oneAdmountAndCommission.m_fSuggestedRetailPrice;
                    topuRes.m_strCurrencyCode = amtSent.getCurrencyCode();

                    InsertRecord(topuRes, sc);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return topuRes;
    }

    private void InsertRecord(TopupResponse topuRes, ServletContext sc) {
        String strTheTransaction = "CONFIRM :: DING-TransactionID = " + topuRes.m_dingTransactionID;
        strTheTransaction += ", CustomerID = " + m_nCustomerID;
        strTheTransaction += ", CustomerPrice = " + topuRes.m_fCostToCustomer;
        m_logger.info(strTheTransaction);

        WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(sc);
        DingTransactionService dingTransactionService = context.getBean(DingTransactionService.class);

        try {
            dingTransactionService.create(topuRes, m_nCustomerID, m_strUserID);
        } catch (Exception e) {
            m_logger.info("FAILED TO LOG INTO THE DATABASE");
            m_logger.info("topuRes = " + topuRes);
            e.printStackTrace();
        }
    }

    public String GetJSONProductNames() {
        HashMap<String, String> dup = new HashMap<String, String>();

        String jsonArray = "[\n";
        boolean bFirstONe = true;

        for (int i = 0; i < g_prodList.size(); i++) {
            ProductDetails p = g_prodList.get(i);

            if (!dup.containsKey(p.m_strCountry)) {
                if (p.m_bUse && p.m_isSupported) {
                    dup.put(p.m_strCountry, p.m_strTelehoneCode);

                    if (!bFirstONe)
                        jsonArray += ",\n";
                    bFirstONe = false;

                    jsonArray += "{";
                    jsonArray += "\"country\": \"" + p.m_strCountry + "\", ";
                    jsonArray += "\"code\": " + p.m_strTelehoneCode + ", ";
                    jsonArray += "\"maxlength\" :" + p.m_nDigitsAllowed;
                    jsonArray += "}";
                }
            }
        }

        jsonArray += "\n]";

        return jsonArray;
    }

    public List<OperatorDetails> GetOperatorList(String countryISDCode) {
        List<OperatorDetails> opDetails = new ArrayList<OperatorDetails>();

        for (int i = 0; i < g_prodList.size(); i++) {
            ProductDetails prodDetails = g_prodList.get(i);
            if (countryISDCode != null && countryISDCode.compareToIgnoreCase(prodDetails.m_strTelehoneCode) == 0) {
                if (!prodDetails.m_isSupported) {
                    OperatorDetails oneDetail = new OperatorDetails();
                    oneDetail.strOperator = prodDetails.m_strOperator;
                    oneDetail.strOperatorCode = prodDetails.m_strOperatorCode;
                    oneDetail.strCountryCode = prodDetails.m_strCountryCode;
                    opDetails.add(oneDetail);
                }
            }
        }

        return opDetails;
    }

    public List<OperatorDetails> getOperators(String iso) {
        List<OperatorDetails> opDetails = new ArrayList<OperatorDetails>();

        for (int i = 0; i < g_prodList.size(); i++) {
            ProductDetails prodDetails = g_prodList.get(i);
            if (iso.compareToIgnoreCase(prodDetails.m_strCountryISO) == 0) {
                OperatorDetails oneDetail = new OperatorDetails();
                oneDetail.strOperator = prodDetails.m_strOperator;
                oneDetail.strOperatorCode = prodDetails.m_strOperatorCode;
                oneDetail.strCountryCode = prodDetails.m_strCountryCode;
                opDetails.add(oneDetail);
            }
        }

        return opDetails;
    }

    public List<ProductDetails> getProductsByCountryISO(String iso) {
        List<ProductDetails> detailses = new ArrayList<>();

        for(ProductDetails detail: g_prodList) {
            if(Objects.equals(detail.m_strCountryISO, iso)) {
                detailses.add(detail);
            }
        }

        return detailses;
    }

    public List<ProductDetails> getProductsByOperatorCode(String operatorCode) {
        List<ProductDetails> details = new ArrayList<>();

        for(ProductDetails detail: g_prodList) {
            if(Objects.equals(detail.m_strOperatorCode, operatorCode)) {
                details.add(detail);
            }
        }

        return details;
    }

    public static class AmountsAndCommission {
        public double m_fDestinationValueWithOutTax;
        public float m_fDenomination;
        public float m_fDestinationValueWithTax;
        public float m_fDestinationTax;
        public float m_fSuggestedRetailPrice;
        public float m_fCustomerPrice;
        public float m_fAgentPrice;
        public float m_fGroupPrice;
        public float m_fEezeeTelPrice;
    }

    public static class OperatorDetails {
        public String strOperator;
        public String strOperatorCode;
        public String strCountryCode;
    }

    public static class PhoneNumberDetails {
        public boolean isRangeOperator;
        public boolean success;
        public String strSendersNumber;
        public String strReceiversNumber;
        public String strCountry;
        public String strCountryCode;
        public String strOperator;
        public String strOperatorID;
        public boolean isSupported;
        public List<OperatorDetails> operatorsList;
        public List<AmountsAndCommission> Amounts;
    }

    public static class TopupResponse {
        public boolean success;
        public String m_strCompany;
        public String m_eezeeTelTransactionID;
        public String m_dingTransactionID;
        public String m_strTime;
        public String m_strSender;
        public String m_strReceiver;
        public String m_strCountry;
        public String m_strCountryCode;
        public String m_strOperator;
        public String m_strOperatorCode;
        public float m_fCostToCustomer;
        public float m_fCostToEezeeTel;
        public double m_fDestTopupValue;
        public double m_fDestTax;
        public double m_fDestTopupValueAfterTax;
        public String m_strCustomerCare;
        public int m_nErrorCode;
        public String m_strErrorText;
        public String m_strSMSSent;
        public String m_strSMSString;
        public float m_fEezeeTelBalance;
        public float m_fCostToAgent;
        public float m_fCostToGroup;
        public float m_fRetailPrice;
        public String m_strCurrencyCode;
    }

    public static class ProductDetails implements Comparable {
        public String m_strCountryCode;
        public String m_strCountry;
        public String m_strOperatorCode;
        public String m_strOperator;
        public String m_strCustomerCareNumber;
        public String m_strLogoUri;
        public String m_strCurrencyCode;
        public String m_strTelehoneCode;
        public String m_strTelehoneMask;
        public String m_strCountryISO;
        public Boolean m_isSupported;
        public Integer m_nDigitsAllowed;
        public Boolean m_bUse;
        private Integer m_nCountryCodeLength;
        public Float m_fMinValue;
        public Float m_fMaxValue;
        public Integer m_nTotalDenominations;
        public List<Float> m_Denominations;

        @Override
        public int compareTo(Object o) {
            return m_strCountry.compareToIgnoreCase(((ProductDetails) o).m_strCountry);
        }
    }

    public void ReadAvailableProducrts() {
        SAXReader reader = new SAXReader();
        Document document;
        try {
            ClassLoader classLoader = this.getClass().getClassLoader();
            document = reader.read(classLoader.getResourceAsStream("AvailableProducts.xml"));
            List list = document.selectNodes("//OneRecord");
            for (int i = 0; i < list.size(); i++) {
                ProductDetails prod = new ProductDetails();

                Element oneElement = (Element) list.get(i);
                prod.m_strCountry = oneElement.selectSingleNode("Country").getText();
                prod.m_strCountryCode = oneElement.selectSingleNode("CountryCode").getText();
                prod.m_strOperator = oneElement.selectSingleNode("Operator").getText();
                prod.m_strOperatorCode = oneElement.selectSingleNode("OperatorCode").getText();
                prod.m_strCurrencyCode = oneElement.selectSingleNode("CurrencyCode").getText();
                prod.m_strCustomerCareNumber = oneElement.selectSingleNode("CustomerCareNumber").getText();
                prod.m_strLogoUri = oneElement.selectSingleNode("LogoURI").getText();
                prod.m_strTelehoneCode = oneElement.selectSingleNode("TelephoneCode").getText();
                prod.m_strTelehoneMask = oneElement.selectSingleNode("TelephoneMask").getText();
                prod.m_strCountryISO = oneElement.selectSingleNode("CountryCodeISO").getText();
                prod.m_isSupported = Boolean.parseBoolean(oneElement.selectSingleNode("IsSupported").getText());
                prod.m_bUse = Boolean.parseBoolean(oneElement.selectSingleNode("Use").getText());
                prod.m_nDigitsAllowed = Integer.parseInt(oneElement.selectSingleNode("DigitsAllowed").getText());
                prod.m_nCountryCodeLength = Integer.parseInt(oneElement.selectSingleNode("CountryCodeLength").getText());
                prod.m_fMinValue = Float.parseFloat(oneElement.selectSingleNode("MinValue").getText());
                prod.m_fMaxValue = Float.parseFloat(oneElement.selectSingleNode("MaxValue").getText());
                prod.m_nTotalDenominations = Integer.parseInt(oneElement.selectSingleNode("TotalDenominations").getText());
                prod.m_Denominations = new ArrayList<Float>();
                for (int j = 0; j < prod.m_nTotalDenominations; j++) {
                    Element denElement = (Element) oneElement.selectSingleNode("Denominations");
                    prod.m_Denominations.add(Float.parseFloat(denElement.selectSingleNode("Denominations_" + (j + 1)).getText()));
                }

                g_prodList.add(prod);
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void GenerateXMLFile(String strFile) {
        DocumentBuilderFactory docFactory = DocumentBuilderFactory
                .newInstance();

        try {
            Document doc = DocumentHelper.createDocument();
            Element rootEle = doc.addElement("root");

            List<DingMain.ProductDetails> prods = g_prodList;
            for (int i = 0; i < prods.size(); i++) {

                DingMain.ProductDetails oneProduct = prods.get(i);
                Element oneRecord = rootEle.addElement("OneRecord");

                oneRecord.addElement("Country").setText(oneProduct.m_strCountry == null ? "" : oneProduct.m_strCountry);
                oneRecord.addElement("CountryCode").setText(oneProduct.m_strCountryCode == null ? "" : oneProduct.m_strCountryCode);
                oneRecord.addElement("Operator").setText(oneProduct.m_strOperator == null ? "" : oneProduct.m_strOperator);
                oneRecord.addElement("OperatorCode").setText(oneProduct.m_strOperatorCode == null ? "" : oneProduct.m_strOperatorCode);
                oneRecord.addElement("CurrencyCode").setText(oneProduct.m_strCurrencyCode == null ? "" : oneProduct.m_strCurrencyCode);
                oneRecord.addElement("CustomerCareNumber").setText(oneProduct.m_strCustomerCareNumber == null ? "" : oneProduct.m_strCustomerCareNumber);
                oneRecord.addElement("LogoURI").setText(oneProduct.m_strLogoUri == null ? "" : oneProduct.m_strLogoUri);
                oneRecord.addElement("TelephoneCode").setText(oneProduct.m_strTelehoneCode == null ? "" : oneProduct.m_strTelehoneCode);
                oneRecord.addElement("TelephoneMask").setText(oneProduct.m_strTelehoneMask == null ? "" : oneProduct.m_strTelehoneMask);
                oneRecord.addElement("IsSupported").setText(oneProduct.m_isSupported == null ? "false" : oneProduct.m_isSupported.toString());
                oneRecord.addElement("DigitsAllowed").setText(oneProduct.m_nDigitsAllowed == null ? "10" : oneProduct.m_nDigitsAllowed.toString());
                oneRecord.addElement("Use").setText(oneProduct.m_bUse == null ? "false" : oneProduct.m_bUse.toString());
                oneRecord.addElement("CountryCodeLength").setText(oneProduct.m_nCountryCodeLength == null ? "4" : oneProduct.m_nCountryCodeLength.toString());
                oneRecord.addElement("CountryCodeISO").setText(oneProduct.m_strCountryISO == null ? "" : oneProduct.m_strCountryISO);
                oneRecord.addElement("MinValue").setText(oneProduct.m_fMinValue == null ? "" : oneProduct.m_fMinValue.toString());
                oneRecord.addElement("MaxValue").setText(oneProduct.m_fMaxValue == null ? "" : oneProduct.m_fMaxValue.toString());
                oneRecord.addElement("TotalDenominations").setText(oneProduct.m_nTotalDenominations == null ? "" : oneProduct.m_nTotalDenominations.toString());
                Element denominationsElement = oneRecord.addElement("Denominations");
                for (int j = 0; j < oneProduct.m_Denominations.size(); j++)
                    denominationsElement.addElement("Denominations_" + (j + 1)).setText(oneProduct.m_Denominations.get(j).toString());
            }

            // Pretty print the document to System.out
            OutputFormat format = OutputFormat.createPrettyPrint();
            XMLWriter writer = new XMLWriter(new FileWriter(strFile), format);
            writer.write(doc);
            writer.close();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
