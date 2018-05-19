package com.eezeetel.service.impl;

import com.ding.DingMain;
import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.WorldTopupCustomerCommission;
import com.eezeetel.entity.WorldTopupGroupCommission;
import com.eezeetel.service.*;
import com.eezeetel.util.PriceUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Denis Dulyak on 23.08.2016.
 */
@Service
public class DingServiceImpl implements DingService {

    public static final Integer DENOMINATIONS = 12;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private PhoneTopupCountryService countryService;

    @Autowired
    private WorldTopupGroupCommissionService groupCommissionService;

    @Autowired
    private WorldTopupCustomerCommissionService customerCommissionService;

    /* For Master Admin */
    @Override
    public List<DingMain.AmountsAndCommission> getTickets(String iso, Integer groupId) {
        List<DingMain.AmountsAndCommission> tickets = new ArrayList<>();

        PhoneTopupCountry country = countryService.findByIso(iso);
        WorldTopupGroupCommission topupGroupCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, groupId);

        DingMain dingMain = new DingMain(1, "");
        List<DingMain.ProductDetails> productDetails = dingMain.getProductsByCountryISO(iso);

        if (productDetails.isEmpty()) {
            return tickets;
        }

        DingMain.ProductDetails productDetail = productDetails.get(0);
        float startVal = (float) Math.ceil(productDetail.m_fMinValue);
        if (startVal < 5)
            startVal = 5;
        float endVal = (float) Math.floor(productDetail.m_fMaxValue);
        float denomination = startVal;

        if (startVal > 0.5 && endVal > 0.5) {
            for (int j = 0; j < DENOMINATIONS && denomination <= endVal; j++) {

                DingMain.AmountsAndCommission amountsAndCommission = new DingMain.AmountsAndCommission();
                amountsAndCommission.m_fDenomination = denomination;

                BigDecimal ticket = new BigDecimal(denomination + "");
                BigDecimal groupCommission = PriceUtil.getPercent(new BigDecimal(denomination + ""), new BigDecimal(topupGroupCommission.getPercent() + ""));

                amountsAndCommission.m_fEezeeTelPrice = ticket.subtract(groupCommission).floatValue();
                amountsAndCommission.m_fGroupPrice = amountsAndCommission.m_fEezeeTelPrice + groupCommission.floatValue();
                amountsAndCommission.m_fAgentPrice = 0.0f;
                amountsAndCommission.m_fCustomerPrice = 0.0f;
                amountsAndCommission.m_fSuggestedRetailPrice = 0.0f;

                tickets.add(amountsAndCommission);
                denomination += DingMain.TICKETS_INCREMENT;
            }
        }

        return tickets;
    }

    /* For Admin */
    @Override
    public List<DingMain.AmountsAndCommission> getTickets(String iso, Integer groupId, Integer customerId) {
        List<DingMain.AmountsAndCommission> tickets = new ArrayList<>();

        PhoneTopupCountry country = countryService.findByIso(iso);
        TMasterCustomerinfo customer = customerService.findOne(customerId);
        WorldTopupGroupCommission topupGroupCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, groupId);
        WorldTopupCustomerCommission topupCustomerCommission = customerCommissionService.findOrCreateByGroupCommissionAndCustomer(topupGroupCommission, customer);

        DingMain dingMain = new DingMain(1, "");
        List<DingMain.ProductDetails> productDetails = dingMain.getProductsByCountryISO(iso);

        if (productDetails.isEmpty()) {
            return tickets;
        }

        DingMain.ProductDetails productDetail = productDetails.get(0);
        float startVal = (float) Math.ceil(productDetail.m_fMinValue);
        if (startVal < 5)
            startVal = 5;
        float endVal = (float) Math.floor(productDetail.m_fMaxValue);
        float denomination = startVal;

        if (startVal > 0.5 && endVal > 0.5) {
            DingMain.PhoneNumberDetails numberDetail = new DingMain.PhoneNumberDetails();
            numberDetail.strCountryCode = productDetail.m_strCountryCode;
            numberDetail.strOperatorID = productDetail.m_strOperatorCode;

            for (int j = 0; j < DENOMINATIONS && denomination <= endVal; j++) {

                DingMain.AmountsAndCommission amountsAndCommission = new DingMain.AmountsAndCommission();
                amountsAndCommission.m_fDenomination = denomination;

                BigDecimal ticket = new BigDecimal(denomination + "");

                BigDecimal eezeetelCommission = PriceUtil.getPercent(ticket, new BigDecimal(topupGroupCommission.getPercent() + ""));
                BigDecimal groupCommission = PriceUtil.getPercent(ticket, new BigDecimal(topupCustomerCommission.getGroupPercent() + ""));
                BigDecimal agentCommission = PriceUtil.getPercent(ticket, new BigDecimal(topupCustomerCommission.getAgentPercent() + ""));

                amountsAndCommission.m_fSuggestedRetailPrice = ticket.floatValue();
                //amountsAndCommission.m_fCustomerPrice = ticket.floatValue();
                amountsAndCommission.m_fAgentPrice = agentCommission.floatValue();
                amountsAndCommission.m_fGroupPrice = groupCommission.floatValue();
                //amountsAndCommission.m_fEezeeTelPrice = ticket.subtract(agentCommission).subtract(groupCommission).subtract(groupCommission).floatValue();
                //amountsAndCommission.m_fDenomination = amountsAndCommission.m_fEezeeTelPrice;
                //dingMain.GetDestinationTopupAmount(numberDetail, amountsAndCommission, amountsAndCommission.m_fDenomination);

                tickets.add(amountsAndCommission);
                denomination += DingMain.TICKETS_INCREMENT;
            }
        }

        return tickets;
    }

    @Override
    public List<DingMain.AmountsAndCommission> getTicketsByOperator(Integer countryId, String operatorCode, Integer groupId) {
        List<DingMain.AmountsAndCommission> tickets = new ArrayList<>();

        PhoneTopupCountry country = countryService.findOne(countryId);
        WorldTopupGroupCommission topupGroupCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, groupId);

        DingMain dingMain = new DingMain(1, "");
        List<DingMain.ProductDetails> productsByIso = dingMain.getProductsByCountryISO(country.getIso());

        if (productsByIso.isEmpty()) {
            return tickets;
        }

        List<DingMain.ProductDetails> productDetails = new ArrayList<>();
        for (DingMain.ProductDetails productDetail : productsByIso) {
            if (productDetail.m_strOperatorCode.equals(operatorCode)) {
                productDetails.add(productDetail);
            }
        }

        DingMain.ProductDetails productDetail = productDetails.get(0);

        if (productDetail.m_Denominations.isEmpty()) {
            return tickets;
        }

        for (Float denomination : productDetail.m_Denominations) {
            DingMain.AmountsAndCommission amountsAndCommission = new DingMain.AmountsAndCommission();
            amountsAndCommission.m_fDenomination = denomination;

            BigDecimal ticket = new BigDecimal(denomination + "");
            BigDecimal groupCommission = PriceUtil.getPercent(new BigDecimal(denomination + ""), new BigDecimal(topupGroupCommission.getPercent() + ""));

            amountsAndCommission.m_fEezeeTelPrice = ticket.floatValue();
            amountsAndCommission.m_fGroupPrice = amountsAndCommission.m_fEezeeTelPrice + groupCommission.floatValue();
            amountsAndCommission.m_fAgentPrice = 0.0f;
            amountsAndCommission.m_fCustomerPrice = 0.0f;
            amountsAndCommission.m_fSuggestedRetailPrice = 0.0f;

            tickets.add(amountsAndCommission);
        }

        return tickets;
    }
}
