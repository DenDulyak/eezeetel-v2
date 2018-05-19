package com.eezeetel.controller.mobcustomer;

import com.eezeetel.api.responses.TouchAPIResponse;
import com.eezeetel.bean.*;
import com.eezeetel.bean.report.BalanceReportBean;
import com.eezeetel.controller.mobcustomer.feign.FeignAPI;
import com.eezeetel.controller.mobcustomer.feign.gson.GsonDecoder;
import com.eezeetel.controller.mobcustomer.feign.gson.GsonEncoder;
import com.eezeetel.controller.mobcustomer.util.FeignUtil;
import com.eezeetel.entity.*;
import com.eezeetel.enums.TransactionType;
import com.eezeetel.repository.UserRepository;
import com.eezeetel.service.CustomerUserService;
import com.eezeetel.service.ProductService;
import com.eezeetel.service.ReportService;
import com.eezeetel.bean.report.*;
import com.eezeetel.util.HibernateUtil;
import com.google.common.util.concurrent.AtomicDouble;
import feign.Feign;
import lombok.extern.log4j.Log4j;
import org.apache.commons.codec.binary.StringUtils;
import org.apache.commons.codec.digest.HmacUtils;
import org.apache.commons.lang.math.NumberUtils;

import org.apache.tomcat.util.codec.binary.Base64;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.*;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.net.ssl.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.Temporal;
import java.time.temporal.TemporalAdjuster;
import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;


import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Log4j
@RestController
@RequestMapping("/api/mob/customer")
public class MProductController {
    private final ProductService productService;
    private final UserRepository userRepository;
    private final CustomerUserService customerUserService;
    private final ReportService reportService;

    @Autowired
    public MProductController(ProductService productService,
                              UserRepository userRepository,
                              CustomerUserService customerUserService,
                              ReportService reportService) {
        this.productService = productService;
        this.userRepository = userRepository;
        this.customerUserService = customerUserService;
        this.reportService = reportService;
    }

    static {
        disableSslVerification();
    }

    private static void disableSslVerification() {
        try {
            TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }

                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                }

                public void checkServerTrusted(X509Certificate[] certs, String authType) {
                }
            }
            };

            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

            HostnameVerifier allHostsValid = new HostnameVerifier() {
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            };

            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (KeyManagementException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/products-by-supplier/{supplierId}", method = RequestMethod.GET)
    public ResponseEntity<List<ProductBean>> productsBySupplier(@PathVariable Integer supplierId) {
        List<ProductBean> products = productService.getProductsBySupplier(supplierId);
        products.forEach(p -> {
            String img = p.getImg();
            if (img != null && img.contains("Product_Images")) {
                p.setImg(img.replace("Product_Images", "images"));
            }
        });
        return ResponseEntity.ok(products);
    }

    @RequestMapping(value = "/process", method = RequestMethod.POST)
    public ResponseEntity<ConfirmBean> process(HttpServletRequest request, @RequestParam String products, @RequestParam String login) {
        return ResponseEntity.ok(productService.process(request, Arrays.asList(products.split("-")), login));
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ResponseEntity<String> login(@RequestParam String login, @RequestParam String pssw) {
        User user = userRepository.findByLogin(login);
        if (user.getPassword().equals(pssw) || user.getPassword2().equals(pssw)) {
            return ResponseEntity.ok("Success");
        } else return ResponseEntity.ok("Fail");
    }

    @RequestMapping(value = "/confirm", method = RequestMethod.POST)
    public ResponseEntity<ConfirmBean> confirm(HttpSession session, @RequestParam Long id) {
        ConfirmBean bean = new ConfirmBean();
        bean.setSuccess(false);
        Object transaction = session.getAttribute("TRANSACTION_ID");
        if (id != null) {
            Long transactionId = id;//NumberUtils.toLong(transaction.toString());
            log.info("===> Transaction ID: " + transactionId);
            session.removeAttribute("TRANSACTION_ID");
            if (transactionId != 0L) {
                bean = productService.confirm(transactionId, true);
            }
        } else {
            bean.setMessage("Transaction not found.");
            log.info("Transaction not found.");
        }
        return ResponseEntity.ok(bean);
    }

    @RequestMapping(value = "/monthly-invoice1", method = RequestMethod.GET)
    @ResponseBody
    public InvoiceReportBean monthlyInvoiceReport(HttpServletRequest request, Model model,
                                       @RequestParam(required = true) String date,
                                       @RequestParam(required = true) String login) {
        InvoiceReportBean response = new InvoiceReportBean();
        TCustomerUsers customerUser = customerUserService.findByLogin(login);
        TMasterCustomerinfo customer = customerUser.getCustomer();

        putNavAttributes(request, model, customer);
        Session theSession = null;
        List<InvoiceTransactionBean> iTransaction = new ArrayList<>();
        try{
            theSession = HibernateUtil.openSession();
            User theUser = customerUser.getUser();

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MMM-dd", Locale.ENGLISH);

            Calendar startCal = Calendar.getInstance(Locale.ENGLISH);
            startCal.set(2009, 1, 1, 0, 0, 0);

            String strQuery = "from TMasterCustomerinfo where Customer_ID = " + customer.getId();
            Query query = theSession.createQuery(strQuery);
            List custList = query.list();

            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
            strQuery = "from TReportCustomerProfit where Begin_Date = " + "'"+ date +"'"  + " and Customer_ID = "
                    + custInfo.getId() + "order by product.productName";

            Query query2 = theSession.createQuery(strQuery);
            List invoiceReport = query2.list();
            int nSubTotalCards = 0;
            float fSubTotal = 0.0F;

            float gTotal = 0.0F;
            Total subTotal = new Total();
            Total grandTotal = new Total();
            BigDecimal vatSales = null;
            for (int i = 0; i < invoiceReport.size(); i++) {

                TReportCustomerProfit custProfit = (TReportCustomerProfit) invoiceReport.get(i);
                InvoiceTransactionBean transaction = new InvoiceTransactionBean();
                transaction.setSerialNumber(i);
                transaction.setProductType(custProfit.getProduct().getSupplier().getSupplierName());
                transaction.setProduct(custProfit.getProduct().getProductName());
                transaction.setQuantity(custProfit.getQuantity());
                transaction.setRetail_price(custProfit.getRetailCost());
                transaction.setAmount(custProfit.getCostToCustomer());
                gTotal += custProfit.getCostToCustomer();

                nSubTotalCards += custProfit.getQuantity();
                Float fCostToCustomer = custProfit.getCostToCustomer();
                fSubTotal += fCostToCustomer;

                iTransaction.add(transaction);
                vatSales = new BigDecimal(fSubTotal).setScale(2, BigDecimal.ROUND_HALF_UP);
            }

            BigDecimal percent = vatSales.divide(new BigDecimal("120"), RoundingMode.HALF_EVEN);
            BigDecimal vat = percent.multiply(new BigDecimal("20"));

            subTotal.setQuantity(nSubTotalCards);
            subTotal.setAmount(fSubTotal);
            grandTotal.setAmount(gTotal);

            response.setSubTotal(subTotal);
            response.setGrandTotal(grandTotal);
            response.setVat(vat);
            //response.setNetVatSales(vatSales.subtract(vat));
            //response.setNonVatSales(new BigDecimal(fSubTotal).subtract(vatSales));
            response.setTransactions(iTransaction);
            return response;


        } catch (Exception e) {
            e.printStackTrace();
            return response;
        } finally {
            HibernateUtil.closeSession(theSession);
        }



    }


    public void putNavAttributes(HttpServletRequest request, Model model, TMasterCustomerinfo customer) {
        model.addAttribute("style", request.getSession().getAttribute("STYLE"));
        if(customer == null) {
            model.addAttribute("customerInfo", new TMasterCustomerinfo());
            model.addAttribute("customerBalance", "0.00");
            model.addAttribute("balanceStyle", "topmenu_balance_less");
            return;
        }

        model.addAttribute("customerInfo", customer);
        Float customerBalance = customer.getCustomerBalance();
        model.addAttribute("customerBalance", new DecimalFormat("0.00").format((double) customerBalance));
        model.addAttribute("balanceStyle", customerBalance < 50.0 ? "topmenu_balance_less" : "topmenu_balance_normal");

        // cancel unconfirmed transactions
        Object transaction = request.getSession().getAttribute("TRANSACTION_ID");
        if (transaction != null) {
            Long transactionId = NumberUtils.toLong(transaction.toString());
            /*if (transactionId != 0L) {
                processTransaction.cancel(transactionId);
            }*/
            request.getSession().removeAttribute("TRANSACTION_ID");
        }
    }

    @RequestMapping(value = "/get-balance", method = RequestMethod.GET)
    public ResponseEntity<Float> getBalance(@RequestParam String login) {
        return ResponseEntity.ok(customerUserService.findByLogin(login).getCustomer().getCustomerBalance());
    }

    @RequestMapping(value = "/daily-customers-transactions", method = RequestMethod.GET)
    public List<BalanceReportBean> dailyCustomersTransactions(@RequestParam String login,
                                                              @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        List<BalanceReportBean> response = new ArrayList<>();
        List<BalanceReportBean> report = reportService.dailyCustomersTransactions(NumberUtils.toInt(userRepository.findByLogin(login).getGroup().getId() + ""), date, "all");
        report.forEach(el -> {
            if (el.getCustomer() != null && el.getCustomer().equals(login)) {
                response.add(el);
            }
        });
        response.sort((t1, t2) -> t2.getTransactionId().compareTo(t1.getTransactionId()));
        return response;
    }

    @RequestMapping(value = "/monthly-invoice", method = RequestMethod.GET)
    public InvoiceReportBean montlyCustomersTransactions(@RequestParam String login,
                                                               @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
                                                               @RequestParam(required = false, defaultValue = "1") Integer monthsCount) {

        InvoiceReportBean resp = new InvoiceReportBean();
        System.out.println("=== date ===> " + date.plusMonths(1).toString());
        List<InvoiceTransactionBean> transactions = new ArrayList<>();
        List<BalanceReportBean> report = reportService.monthlyCustomersTransactions(NumberUtils.toInt(userRepository.findByLogin(login).getGroup().getId() + ""), date.plusMonths(1), monthsCount, "all");
        Total gTotal = new Total();

        AtomicInteger subQuantity = new AtomicInteger(1);
        AtomicDouble subAmount = new AtomicDouble(0);
        AtomicDouble fSubTotal = new AtomicDouble(0);
        report.forEach(el -> {
            if (el.getCustomer() != null && el.getCustomer().equals(login)) {

                InvoiceTransactionBean transactionBean = new InvoiceTransactionBean();
                transactionBean.setSerialNumber(Integer.valueOf(el.getTransactionId().intValue()));
                transactionBean.setProduct(el.getProductName());
                transactionBean.setProductType(el.getProductType());
                transactionBean.setQuantity(el.getQuantity());
                transactionBean.setProductType(el.getProductName());
                transactionBean.setRetail_price(el.getRetailPrice().floatValue());
                transactionBean.setAmount((el.getPurchasePrice().multiply(new BigDecimal(el.getQuantity()))).floatValue());
                fSubTotal.getAndAdd(el.getCostToCustomer().doubleValue());
                subQuantity.getAndAdd(el.getQuantity().intValue());
                subAmount.getAndAdd(el.getRetailPrice().doubleValue());
                transactions.add(transactionBean);
            }
        });




        gTotal.setAmount(subAmount.floatValue());
        gTotal.setQuantity(subQuantity.get());

        BigDecimal vatSales = new BigDecimal(subAmount.floatValue()).setScale(2, BigDecimal.ROUND_HALF_UP);


        BigDecimal percent = vatSales.divide(new BigDecimal("120"), RoundingMode.HALF_EVEN);
        BigDecimal vat = percent.multiply(new BigDecimal("20"));

        resp.setVat(vat);
        resp.setGrandTotal(gTotal);
        resp.setTransactions(transactions);

        return resp;
    }

    @RequestMapping(value = "/touch-recharge", method = RequestMethod.GET, produces = "application/json")
    public TouchAPIResponse getRechargeFromTouchAPI(HttpSession session,
                                                    @RequestParam(required = false, defaultValue = "lidacall") String userName,
                                                    @RequestParam(required = false, defaultValue = "1285638015") Long providerStamp,
                                                    @RequestParam(required = false, defaultValue = "oa$fh*884DFkjhg$!&") String hashingKey,
                                                    @RequestParam Long subno,
                                                    @RequestParam Long voucherNumber,
                                                    @RequestParam(required = false, defaultValue = "2") Long requestId) {
        Long stamp = Instant.now().getEpochSecond() - providerStamp;
        String hash = generateHash(hashingKey, stamp, userName, subno, voucherNumber, requestId);
        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();

        body.add("voucherNumber", Long.toString(voucherNumber));
        body.add("requestId", Long.toString(requestId));

        final HttpHeaders headers = new HttpHeaders();
        headers.add("userName", userName);
        headers.add("stamp", Long.toString(stamp));
        headers.add("hash", hash);

        HttpEntity<?> httpEntity = new HttpEntity<Object>(body, headers);
        ResponseEntity<String> response;
        try {
            response = restTemplate.exchange("https://212.98.134.199:8519/recharge/v1/voucher/" + String.valueOf(subno), HttpMethod.POST, httpEntity, String.class);
            return TouchAPIResponse.builder()
                    .code(response.getStatusCode().value())
                    .msg(response.getBody())
                    .build();

        } catch (Exception e) {
            return new TouchAPIResponse().builder().code(404).msg(e.getMessage()).build();
        }
    }

    private String generateHash(String hashingKey,
                                long stamp,
                                String userName,
                                long subno,
                                long voucherNumber,
                                long requestId) {
        return Base64.encodeBase64String(
                HmacUtils.hmacMd5(
                        HmacUtils.hmacMd5(
                                hashingKey,
                                Long.toString(stamp / 5)
                        ),
                        StringUtils.getBytesUtf8(
                                String.join(
                                        "",
                                        "recharge",
                                        userName,
                                        String.valueOf(stamp),
                                        String.valueOf(subno),
                                        String.valueOf(voucherNumber),
                                        String.valueOf(requestId)
                                )
                        )
                )
        );
    }
}