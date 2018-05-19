package com.transferto;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.StandardBasicTypes;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import com.eezeetel.util.HibernateUtil;
import com.eezeetel.entity.TCustomerCommission;
import com.eezeetel.entity.TCustomerGroupCommissions;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.TTransactionBalance;

public class TransferToServiceMain {

    private static Logger m_logger = Logger.getLogger(TransferToServiceMain.class);
    public static final int TransferTo_SupplierID = 37;
    public static final int TransferTo_ProductType = 16;
    public static final int TransferTo_International_Mobile_Topup_Product_ID = 303;
    private final int TransferTo_DefaultPercentage = 7;
    private final String m_strUserName = "eezeetel";
    private final String m_strPassword = "IEIBDkikey";
    private final String m_strURL = "https://fm.transfer-to.com/cgi-bin/shop/topup";
    private final String m_TransferTo_Test_Number = "628123456770";
    private static DocumentBuilderFactory g_docBuildFactory;
    private static DocumentBuilder g_docBuilder;
    private boolean m_bUseTestURL;
    private int m_nCustomerID;
    private long m_nTransactionID;
    private String m_strUserID;
    private final String m_oldstrURL = "http://fm.transfer-to.com/cgi-bin/billing/3bill";
    private final String m_strOldPassword = "38eex9mhv";

    static {
        try {
            g_docBuildFactory = DocumentBuilderFactory.newInstance();
            g_docBuilder = g_docBuildFactory.newDocumentBuilder();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        TransferToServiceMain transferToService = new TransferToServiceMain(28, "eeztel");
        Object localObject;
        if (args.length == 0) {
            transferToService.getClass();
            transferToService.getClass();
            localObject = transferToService.PerformTopUpOperation("628123456770", "628123456770", "1310", "This is SMS text",
                    "50000", 0.0525F);

        } else {
            transferToService.getClass();
            localObject = transferToService.PerformMSISDNInfo("628123456770", null);
        }
    }

    public TransferToServiceMain(int nCustomerID, String strUserID) {
        this.m_nCustomerID = nCustomerID;
        this.m_strUserID = strUserID;
    }

    private String getKey() {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String theKey = sdf.format(cal.getTime());
        theKey = theKey + this.m_nCustomerID;
        return theKey;
    }

    private String makeupRequest() {
        String generalRequestString = "";
        String strDigestKey = getKey();
        if (strDigestKey == null) return generalRequestString;
        String digestedPassword = getKeyedDigest("eezeetel", "IEIBDkikey", strDigestKey);
        if (digestedPassword == null) {
            return null;
        }
        generalRequestString = generalRequestString + "<login>eezeetel</login>";
        generalRequestString = generalRequestString + "<key>" + strDigestKey + "</key>";
        generalRequestString = generalRequestString + "<md5>" + digestedPassword + "</md5>";
        return generalRequestString;
    }

    public PinLessTopupResponse PerformTopUpOperation(String strSenderPhoneNumber, String strTelephoneNumber,
                                                      String strOperatorID, String strSMSString, String strProduct, float fCostToCustomer) {
        try {
            String requestPart = makeupRequest();
            if (requestPart == null) return null;
            String requestString = "<xml>";
            requestString = requestString + requestPart;
            requestString = requestString + "<action>topup</action>";
            requestString = requestString + "<msisdn>" + strSenderPhoneNumber + "</msisdn>";
            requestString = requestString + "<destination_msisdn>" + strTelephoneNumber + "</destination_msisdn>";
            if ((strOperatorID != null) && (!strOperatorID.isEmpty()))
                requestString = requestString + "<operatorid>" + strOperatorID + "</operatorid>";
            if ((strSMSString != null) && (!strSMSString.isEmpty()))
                requestString = requestString + "<sms>" + strSMSString + "</sms>";
            requestString = requestString + "<product>" + strProduct + "</product>";
            requestString = requestString + "</xml>";

            URL theURL = new URL("https://fm.transfer-to.com/cgi-bin/shop/topup");
            HttpURLConnection theConnection = (HttpURLConnection) theURL.openConnection();
            theConnection.setDoOutput(true);
            theConnection.setDoInput(true);
            theConnection.setRequestProperty("Content-Type", "text/xml");

            OutputStreamWriter contentWriter = new OutputStreamWriter(theConnection.getOutputStream());
            contentWriter.write(requestString);
            contentWriter.flush();
            contentWriter.close();
            PinLessTopupResponse theResponse = handlePinLessTopupResponse(theConnection, fCostToCustomer);
            theConnection = null;
            theURL = null;
            return theResponse;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public MSISDNResponse PerformMSISDNInfo(String strTelephoneNumber, String strOperatorID) {
        if ((strTelephoneNumber == null) || (strTelephoneNumber.isEmpty()))
            return null;
        try {
            String requestPart = makeupRequest();
            if (requestPart == null) return null;
            String requestString = "<xml>";
            requestString = requestString + requestPart;
            requestString = requestString + "<action>msisdn_info</action>";
            requestString = requestString + "<destination_msisdn>" + strTelephoneNumber + "</destination_msisdn>";
            if ((strOperatorID != null) && (!strOperatorID.isEmpty()))
                requestString = requestString + "<operatorid>" + strOperatorID + "</operatorid>";
            requestString = requestString + "</xml>";

            URL theURL = new URL("https://fm.transfer-to.com/cgi-bin/shop/topup");
            HttpURLConnection theConnection = (HttpURLConnection) theURL.openConnection();
            theConnection.setDoOutput(true);
            theConnection.setDoInput(true);
            theConnection.setRequestProperty("Content-Type", "text/xml");

            OutputStreamWriter contentWriter = new OutputStreamWriter(theConnection.getOutputStream());
            contentWriter.write(requestString);
            contentWriter.flush();
            contentWriter.close();
            MSISDNResponse theResponse = handleMSISDNInfoResponse(theConnection);
            theConnection = null;
            theURL = null;
            return theResponse;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private MSISDNResponse handleMSISDNInfoResponse(HttpURLConnection theConnection) {
        ByteArrayInputStream inStream = null;
        try {
            String strResult = "";

            BufferedReader contentReader = new BufferedReader(new InputStreamReader(theConnection.getInputStream()));

            String strLine = "";
            while ((strLine = contentReader.readLine()) != null) {
                strResult = strResult + strLine;
            }

            contentReader.close();

            inStream = new ByteArrayInputStream(strResult.getBytes());

            Document doc = g_docBuilder.parse(inStream);
            if (CheckReponse(doc)) {
                MSISDNResponse objMSISDNResponse = new MSISDNResponse();
                objMSISDNResponse.m_priceMap = new HashMap();

                NodeList nList = doc.getElementsByTagName("error_code");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    String strErrorCode = nList.item(0).getNodeValue();
                    if ((strErrorCode != null) && (!strErrorCode.isEmpty())) {
                        objMSISDNResponse.m_nErrorCode = Integer.parseInt(strErrorCode);
                    }
                }
                nList = doc.getElementsByTagName("error_txt");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strErrorText = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("destination_msisdn");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strDestinationNumber = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("country");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strCountry = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("countryid");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strCountryID = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("destination_currency");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strCurrency = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("operator");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strOperator = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("operatorid");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strOperatorID = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("product_list");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strProductList = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("retail_price_list");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strRetailPriceList = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("wholesale_price_list");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objMSISDNResponse.m_strWholeSalePriceList = nList.item(0).getNodeValue();
                }
                if ((objMSISDNResponse.m_strWholeSalePriceList != null) && (!objMSISDNResponse.m_strWholeSalePriceList.isEmpty()) && (objMSISDNResponse.m_strRetailPriceList != null)
                        && (!objMSISDNResponse.m_strRetailPriceList.isEmpty()) && (objMSISDNResponse.m_strProductList != null) && (!objMSISDNResponse.m_strProductList.isEmpty())) {
                    StringTokenizer st1 = new StringTokenizer(objMSISDNResponse.m_strProductList, ",", false);
                    StringTokenizer st2 = new StringTokenizer(objMSISDNResponse.m_strWholeSalePriceList, ",", false);
                    StringTokenizer st3 = new StringTokenizer(objMSISDNResponse.m_strRetailPriceList, ",", false);

                    while (st1.hasMoreTokens()) {
                        String strProduct = st1.nextToken();
                        String wholeSalePrice = "";
                        String retailPrice = "";
                        if (st2.hasMoreTokens()) wholeSalePrice = st2.nextToken();
                        if (st3.hasMoreTokens()) {
                            retailPrice = st3.nextToken();
                        }
                        MSISDNResponse tmp810_808 = objMSISDNResponse;
                        tmp810_808.getClass();
                        MSISDNResponse.PriceMapObject objProductPrice = new MSISDNResponse.PriceMapObject();
                        objProductPrice.m_fWholeSalePrice = 0.0F;
                        objProductPrice.m_fRetailPrice = 0.0F;
                        objProductPrice.m_fCostToCustomer = 0.0F;
                        objProductPrice.m_fRetailPrice = 0.0F;
                        objProductPrice.m_fSuggestedRetailprice = 0.0F;
                        objProductPrice.m_strProduct = "";

                        if ((strProduct != null) && (!strProduct.isEmpty())) {
                            objProductPrice.m_strProduct = strProduct;
                            if ((wholeSalePrice != null) && (!wholeSalePrice.isEmpty())) {
                                objProductPrice.m_fWholeSalePrice = Float.parseFloat(wholeSalePrice);
                            }
                            if ((retailPrice != null) && (!retailPrice.isEmpty())) {
                                objProductPrice.m_fRetailPrice = Float.parseFloat(retailPrice);
                            }
                        }
                        if ((objProductPrice.m_fWholeSalePrice > 0.0F) && (objProductPrice.m_fRetailPrice > 0.0F)) {
                            if ((strProduct != null) && (!strProduct.isEmpty())) {
                                Float fProduct = Float.valueOf(Float.parseFloat(strProduct));
                                objMSISDNResponse.m_priceMap.put(fProduct, objProductPrice);
                            }
                        }
                    }
                    GetCustomerPrice(objMSISDNResponse.m_priceMap);
                }
                inStream.close();
                return objMSISDNResponse;
            }

            inStream.close();
            return null;
        } catch (Exception e) {
            try {
                if (inStream != null) {
                    inStream.close();
                }
            } catch (Exception localException1) {
                localException1.printStackTrace();
            }
            e.printStackTrace();
        }
        return null;
    }

    private void GetCustomerPrice(Map prodMap) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            Iterator it = prodMap.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry prodPair = (Map.Entry) it.next();
                MSISDNResponse.PriceMapObject objProductSpec = (MSISDNResponse.PriceMapObject) prodPair.getValue();

                String strQuery = "from TCustomerCommission where Customer_ID = " + this.m_nCustomerID +
                        " and Product_ID = " + 303;
                Query query = theSession.createQuery(strQuery);
                List lstCommission = query.list();

                float commAmount = 0.0F;
                float fEezeetelCommission = 7.0F;
                float fAgentCommission = 0.0F;
                float fGroupCommission = 0.0F;

                if ((lstCommission != null) && (lstCommission.size() > 0)) {
                    TCustomerCommission custComm = (TCustomerCommission) lstCommission.get(0);
                    fGroupCommission = custComm.getCommission();
                    fAgentCommission = custComm.getAgentCommission();
                }

                strQuery = "from TMasterCustomerinfo where Customer_ID = " + this.m_nCustomerID
                        + " and Active_Status = 1";
                query = theSession.createQuery(strQuery);
                List lstCustomer = query.list();
                if (lstCustomer.size() > 0) {
                    TMasterCustomerinfo custInfo = (TMasterCustomerinfo) lstCustomer.get(0);
                    TMasterCustomerGroups custGroup = custInfo.getGroup();

                    strQuery = "from TCustomerGroupCommissions where Customer_Group_ID = "
                            + custGroup.getId() + " and Product_ID = " + 303;
                    query = theSession.createQuery(strQuery);
                    List lstGrpCommission = query.list();

                    if (lstGrpCommission.size() > 0) {
                        TCustomerGroupCommissions custGrpComm = (TCustomerGroupCommissions) lstGrpCommission.get(0);
                        fEezeetelCommission = custGrpComm.getCommission();
                    }
                }

                if (fEezeetelCommission <= 7.0F) {
                    fEezeetelCommission = 7.0F;
                }
                commAmount = objProductSpec.m_fWholeSalePrice
                        * (fEezeetelCommission + fGroupCommission + fAgentCommission) / 100.0F;

                if (commAmount > 0.0F) {
                    objProductSpec.m_fCostToCustomer = (objProductSpec.m_fWholeSalePrice + commAmount);
                    objProductSpec.m_fSuggestedRetailprice = objProductSpec.m_fCostToCustomer;
                    objProductSpec.m_fSuggestedRetailprice += objProductSpec.m_fRetailPrice
                            - objProductSpec.m_fWholeSalePrice;
                } else {
                    it.remove();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    }

    private boolean addMobileTopupTransaction(PinLessTopupResponse refPinLessTopupResponse) {
        Session theSession = null;
        String strTransactionQuery = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Calendar cal = Calendar.getInstance();
            refPinLessTopupResponse.m_strTransactionTime = sdf.format(cal.getTime());
            if (refPinLessTopupResponse.m_strDestinationNumber.compareToIgnoreCase("628123456770") == 0) {
                return true;
            }
            String strTheTransaction = "CONFIRM :: TT-TransactionID = "
                    + refPinLessTopupResponse.m_nTransferToTransactionID;
            strTheTransaction = strTheTransaction + ", CustomerID = " + this.m_nCustomerID;
            strTheTransaction = strTheTransaction + ", CustomerPrice = "
                    + refPinLessTopupResponse.m_fCostToCustomer;

            m_logger.setLevel(Level.INFO);
            m_logger.info(strTheTransaction);

            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String strQuery = "from TMasterCustomerinfo where Customer_ID = " + this.m_nCustomerID;
            Query query = theSession.createQuery(strQuery);
            List custList = query.list();
            if (custList.size() <= 0) throw new Exception("Can not find Customer Information");
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
            TMasterCustomerGroups custGroup = custInfo.getGroup();

            strQuery = "from TCustomerCommission where Customer_ID = " + this.m_nCustomerID + " and Product_ID = " + 303;

            query = theSession.createQuery(strQuery);
            List lstCommission = query.list();
            DecimalFormat df = new DecimalFormat("0.00");
            float commAmount = 0.0F;
            float fEezeetelCommission = 7.0F;
            float fAgentCommission = 0.0F;
            float fGroupCommission = 0.0F;
            if ((lstCommission != null) && (lstCommission.size() > 0)) {
                TCustomerCommission custComm = (TCustomerCommission) lstCommission.get(0);
                fGroupCommission = custComm.getCommission();
                fAgentCommission = custComm.getAgentCommission();
            }

            strQuery = "from TCustomerGroupCommissions where Customer_Group_ID = " + custGroup.getId() + " and Product_ID = " + 303;
            query = theSession.createQuery(strQuery);
            List listGroupComm = query.list();
            if (listGroupComm.size() > 0) {
                TCustomerGroupCommissions custGrpComm = (TCustomerGroupCommissions) listGroupComm.get(0);
                fEezeetelCommission = custGrpComm.getCommission();
            }

            if (fEezeetelCommission <= 7.0F) {
                fEezeetelCommission = 7.0F;
            }
            commAmount = refPinLessTopupResponse.m_fWholeSalePrice * fEezeetelCommission / 100.0F;
            float fCostToGroup = refPinLessTopupResponse.m_fWholeSalePrice + commAmount;

            commAmount = refPinLessTopupResponse.m_fWholeSalePrice * (fEezeetelCommission + fGroupCommission) / 100.0F;

            float fCostToAgent = refPinLessTopupResponse.m_fWholeSalePrice + commAmount;

            strQuery = "call SP_GetTransactionID()";
            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("cur_transaction_id", StandardBasicTypes.BIG_INTEGER);
            List transaction = sqlQuery.list();
            refPinLessTopupResponse.m_nEezeeTelTransactionID = Long.parseLong(String.valueOf(transaction.get(0)));
            refPinLessTopupResponse._m_strCompanyName = custInfo.getCompanyName();

            if (refPinLessTopupResponse.m_fRetailPrice <= refPinLessTopupResponse.m_fCostToCustomer) {
                refPinLessTopupResponse.m_fRetailPrice = (refPinLessTopupResponse.m_fCostToCustomer + 0.5F);
            }
            strTransactionQuery = "insert into t_transferto_transactions(Transaction_ID, TransferTo_Transaction_ID, Error_Code, Error_Text, Requester_Phone, Destination_Phone, Originating_Currency, Destination_Currency, Destination_Country, Destination_Country_ID, Destination_Operator, Destination_Operator_ID, Operator_Reference_Info, SMS_Sent, SMS_Text,  Authentication_Key, CID1, CID2, CID3, Product_Requested, Product_Sent, Wholesale_Price,  Retail_Price, EezeeTel_Balance, Customer_ID, User_ID, Transaction_Time,  Transaction_Status, Cost_To_Customer, Cost_To_Agent, Cost_To_Group, Cost_To_EezeeTel) values ("
                    + refPinLessTopupResponse.m_nEezeeTelTransactionID
                    + ", "
                    + refPinLessTopupResponse.m_nTransferToTransactionID
                    + ", "
                    + refPinLessTopupResponse.m_nErrorCode
                    + ", '"
                    + refPinLessTopupResponse.m_strErrorText
                    + "', '"
                    + refPinLessTopupResponse.m_strRequesterNumber
                    + "', '"
                    + refPinLessTopupResponse.m_strDestinationNumber
                    + "', '"
                    + refPinLessTopupResponse.m_strOriginatingCurrency
                    + "', '"
                    + refPinLessTopupResponse.m_strDestinationCurrency
                    + "', '"
                    + refPinLessTopupResponse.m_strDestinationCountry
                    + "', '"
                    + refPinLessTopupResponse.m_strDestinationCountryID
                    + "', '"
                    + refPinLessTopupResponse.m_strDestinationOperator
                    + "', '"
                    + refPinLessTopupResponse.m_strDestinationOperatorID
                    + "', '"
                    + refPinLessTopupResponse.m_strOperatorReferenceInfo
                    + "', '"
                    + refPinLessTopupResponse.m_strSMSSent
                    + "', '"
                    + refPinLessTopupResponse.m_strSMSString
                    + "', '"
                    + refPinLessTopupResponse.m_strAuthenticationKey
                    + "', '"
                    + refPinLessTopupResponse.m_strCID1
                    + "', '"
                    + refPinLessTopupResponse.m_strCID2
                    + "', '"
                    + refPinLessTopupResponse.m_strCID3
                    + "', "
                    + refPinLessTopupResponse.m_fProductRequested
                    + ", "
                    + refPinLessTopupResponse.m_fProductSent
                    + ", "
                    + refPinLessTopupResponse.m_fWholeSalePrice
                    + ", "
                    + refPinLessTopupResponse.m_fRetailPrice
                    + ", "
                    + refPinLessTopupResponse.m_fBalanceAfterThisTransaction
                    + ", "
                    + this.m_nCustomerID
                    + ", '"
                    + this.m_strUserID
                    + "', '"
                    + refPinLessTopupResponse.m_strTransactionTime
                    + "', 1, "
                    + df.format(refPinLessTopupResponse.m_fCostToCustomer)
                    + ", "
                    + df.format(fCostToAgent)
                    + ", "
                    + df.format(fCostToGroup) + ", " + refPinLessTopupResponse.m_fWholeSalePrice + ")";

            sqlQuery = theSession.createSQLQuery(strTransactionQuery);
            sqlQuery.executeUpdate();

            TTransactionBalance transactionBalance = new TTransactionBalance();
            transactionBalance.setTransactionId(refPinLessTopupResponse.m_nEezeeTelTransactionID);
            transactionBalance.setBalanceBeforeTransaction(custInfo.getCustomerBalance());
            transactionBalance.setBalanceAfterTransaction(custInfo.getCustomerBalance()
                    - refPinLessTopupResponse.m_fCostToCustomer);

            custInfo.setCustomerBalance(custInfo.getCustomerBalance() - refPinLessTopupResponse.m_fCostToCustomer);
            theSession.save(transactionBalance);
            theSession.save(custInfo);

            if (custGroup.getCheckAganinstGroupBalance()) {
                custGroup.setCustomerGroupBalance(custGroup.getCustomerGroupBalance() - fCostToGroup);
                theSession.save(custGroup);
            }
            theSession.getTransaction().commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
            if ((strTransactionQuery != null) && (!strTransactionQuery.isEmpty())) {
                try {
                    FileOutputStream fos = new FileOutputStream("DB_Failed_Transfer_To_Transactions.txt");
                    fos.write(strTransactionQuery.getBytes());
                    fos.close();
                } catch (Exception e1) {
                    e1.printStackTrace();
                    System.out.println(strTransactionQuery);
                }
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return false;
    }

    private PinLessTopupResponse handlePinLessTopupResponse(HttpURLConnection theConnection,
                                                            float fCostToCustomer) {
        ByteArrayInputStream inStream = null;
        try {
            String strResult = "";
            BufferedReader contentReader = new BufferedReader(new InputStreamReader(theConnection.getInputStream()));

            String strLine = "";
            while ((strLine = contentReader.readLine()) != null) {
                strResult = strResult + strLine;
            }
            contentReader.close();

            inStream = new ByteArrayInputStream(strResult.getBytes());
            Document doc = g_docBuilder.parse(inStream);
            if (CheckReponse(doc)) {
                PinLessTopupResponse objPinLessResponse = new PinLessTopupResponse();
                objPinLessResponse.m_fCostToCustomer = fCostToCustomer;

                NodeList nList = doc.getElementsByTagName("error_code");

                if ((nList != null) && (nList.getLength() >= 1)) {
                    String strErrorCode = nList.item(0).getNodeValue();
                    if ((strErrorCode != null) && (!strErrorCode.isEmpty())) {
                        objPinLessResponse.m_nErrorCode = Integer.parseInt(strErrorCode);
                    }
                }
                nList = doc.getElementsByTagName("error_txt");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strErrorText = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("msisdn");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strRequesterNumber = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("destination_msisdn");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strDestinationNumber = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("originating_currency");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strOriginatingCurrency = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("destination_currency");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strDestinationCurrency = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("country");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strDestinationCountry = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("countryid");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strDestinationCountryID = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("operator");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strDestinationOperator = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("operatorid");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strDestinationOperatorID = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("reference_operator");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strOperatorReferenceInfo = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("sms_sent");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strSMSSent = nList.item(0).getNodeValue();
                    if ((objPinLessResponse.m_strSMSSent != null) && (objPinLessResponse.m_strSMSSent.isEmpty())) {
                        if (objPinLessResponse.m_strSMSSent.compareToIgnoreCase("yes") != 0) {
                            objPinLessResponse.m_strSMSSent = "no";
                        }
                    }
                }
                nList = doc.getElementsByTagName("sms");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strSMSString = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("authentication_key");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strAuthenticationKey = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("cid1");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strCID1 = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("cid2");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strCID2 = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("cid3");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_strCID3 = nList.item(0).getNodeValue();
                }
                nList = doc.getElementsByTagName("product_requested");
                objPinLessResponse.m_fProductRequested = 0.0F;
                if ((nList != null) && (nList.getLength() >= 1)) {
                    String strProductRequested = nList.item(0).getNodeValue();
                    if ((strProductRequested != null) && (!strProductRequested.isEmpty())) {
                        objPinLessResponse.m_fProductRequested = Float.parseFloat(strProductRequested);
                    }
                }
                nList = doc.getElementsByTagName("actual_product_sent");
                objPinLessResponse.m_fProductSent = 0.0F;
                if ((nList != null) && (nList.getLength() >= 1)) {
                    String strProductSent = nList.item(0).getNodeValue();
                    if ((strProductSent != null) && (!strProductSent.isEmpty())) {
                        objPinLessResponse.m_fProductSent = Float.parseFloat(strProductSent);
                    }
                }
                nList = doc.getElementsByTagName("wholesale_price");
                objPinLessResponse.m_fWholeSalePrice = 0.0F;
                if ((nList != null) && (nList.getLength() >= 1)) {
                    String strWholesalePrice = nList.item(0).getNodeValue();
                    if ((strWholesalePrice != null) && (!strWholesalePrice.isEmpty())) {
                        objPinLessResponse.m_fWholeSalePrice = Float.parseFloat(strWholesalePrice);
                    }
                }
                nList = doc.getElementsByTagName("retail_price");
                objPinLessResponse.m_fRetailPrice = 0.0F;
                if ((nList != null) && (nList.getLength() >= 1)) {
                    String strRetailPrice = nList.item(0).getNodeValue();
                    if ((strRetailPrice != null) && (!strRetailPrice.isEmpty())) {
                        objPinLessResponse.m_fRetailPrice = Float.parseFloat(strRetailPrice);
                    }
                }
                nList = doc.getElementsByTagName("balance");
                objPinLessResponse.m_fBalanceAfterThisTransaction = 0.0F;
                if ((nList != null) && (nList.getLength() >= 1)) {
                    String strBalance = nList.item(0).getNodeValue();
                    if ((strBalance != null) && (!strBalance.isEmpty())) {
                        objPinLessResponse.m_fBalanceAfterThisTransaction = Float.parseFloat(strBalance);
                    }
                }
                nList = doc.getElementsByTagName("transactionid");
                if ((nList != null) && (nList.getLength() >= 1)) {
                    objPinLessResponse.m_nTransferToTransactionID = 0L;
                    String strTransactionID = nList.item(0).getNodeValue();
                    if ((strTransactionID != null) && (!strTransactionID.isEmpty())) {
                        objPinLessResponse.m_nTransferToTransactionID = Integer.parseInt(strTransactionID);
                    }
                }
                addMobileTopupTransaction(objPinLessResponse);
                return objPinLessResponse;
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private boolean CheckReponse(Document doc) {
        try {
            if (doc == null) return false;
            NodeList nList = doc.getElementsByTagName("error_code");
            if ((nList != null) && (nList.getLength() >= 1)) {
                Node nErrorNode = nList.item(0);
                if (nErrorNode != null) {
                    String strValue = nErrorNode.getNodeValue();
                    if ((strValue != null) && (Integer.parseInt(strValue) == 0)) {
                        return true;
                    }
                }
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private final String getKeyedDigest(String login, String password, String key) {
        try {
            String temp = login + password + key;
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            byte[] bytes = md5.digest(temp.getBytes());
            return byteToHex(bytes);
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Could not get Keyed Digest");
        }
        return null;
    }

    private final String byteToHex(byte[] bits) {
        if (bits == null) {
            return null;
        }

        StringBuffer hex = new StringBuffer(bits.length * 2);

        for (int i = 0; i < bits.length; i++) {
            if ((bits[i] & 0xFF) < 16) {
                hex.append("0");
            }
            hex.append(Integer.toString(bits[i] & 0xFF, 16));
        }
        return hex.toString();
    }
}