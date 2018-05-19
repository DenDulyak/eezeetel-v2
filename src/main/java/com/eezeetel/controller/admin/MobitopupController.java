package com.eezeetel.controller.admin;

import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.WorldTopupCustomerCommission;
import com.eezeetel.entity.WorldTopupGroupCommission;
import com.eezeetel.mobitopup.MobitopupMethodImpl;
import com.eezeetel.mobitopup.MobitopupUtil;
import com.eezeetel.mobitopup.response.Network;
import com.eezeetel.mobitopup.response.Ticket;
import com.eezeetel.service.CustomerService;
import com.eezeetel.service.PhoneTopupCountryService;
import com.eezeetel.service.WorldTopupCustomerCommissionService;
import com.eezeetel.service.WorldTopupGroupCommissionService;
import com.eezeetel.util.PriceUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.eezeetel.mobitopup.MobitopupUtil.validate;

/**
 * Created by Denis Dulyak on 20.07.2016.
 */
@RestController("adminMobitopupController")
@RequestMapping(value = "/admin/mobitopup")
public class MobitopupController {

    @Autowired
    private MobitopupMethodImpl mobitopupMethod;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private WorldTopupGroupCommissionService groupCommissionService;

    @Autowired
    private WorldTopupCustomerCommissionService customerCommissionService;

    @Autowired
    private PhoneTopupCountryService countryService;

    @RequestMapping(value = "/get-networks", method = RequestMethod.GET)
    public ResponseEntity<Network> getNetworks(@RequestParam Integer mobitopupCountryId) {
        Network response = mobitopupMethod.getNetworks(mobitopupCountryId);
        if (response != null && StringUtils.isNotEmpty(response.getNetworks())) {
            response.setNetworkList(MobitopupUtil.toMap(response.getNetworks()));
        }
        return ResponseEntity.ok(validate(response));
    }

    @RequestMapping(value = "/get-tickets", method = RequestMethod.GET)
    public ResponseEntity<Ticket> getTickets(HttpSession session, @RequestParam Integer customerId,
                                             @RequestParam Integer mobitopupCountryId, @RequestParam Integer networkId) {
        Ticket ticket = validate(mobitopupMethod.getTickets(networkId));

        try {
            Integer groupId = NumberUtils.toInt(session.getAttribute("GROUP_ID") + "");
            PhoneTopupCountry country = countryService.findByMobitopupCountryId(mobitopupCountryId);
            TMasterCustomerinfo customer = customerService.findOne(customerId);
            WorldTopupGroupCommission groupsCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, groupId);
            WorldTopupCustomerCommission customersCommission = customerCommissionService.findOrCreateByGroupCommissionAndCustomer(groupsCommission, customer);

            if (ticket.getError_code() == 0) {
                List<String> productsWithCommissions = new ArrayList<>();
                for (String product : Arrays.asList(ticket.getBuy().split(","))) {
                    String[] prices = product.split("-");
                    String destVal = prices[0];
                    BigDecimal realPrice = new BigDecimal(prices[1]);

                    BigDecimal eezeetelCommission = PriceUtil.getPercent(realPrice, new BigDecimal(groupsCommission.getPercent() + ""));
                    BigDecimal groupCommission = PriceUtil.getPercent(realPrice.add(eezeetelCommission), new BigDecimal(customersCommission.getGroupPercent() + ""));
                    BigDecimal agentCommission = PriceUtil.getPercent(realPrice.add(eezeetelCommission).add(groupCommission), new BigDecimal(customersCommission.getAgentPercent() + ""));
                    BigDecimal customerCommission = PriceUtil.getPercent(
                            realPrice.add(eezeetelCommission).add(groupCommission).add(agentCommission),
                            MobitopupUtil.getCustomerCommission(
                                    MobitopupUtil.isDigicel(country.getIso(), networkId)
                            )
                    );

                    BigDecimal retailPrice = realPrice
                            .add(eezeetelCommission)
                            .add(groupCommission)
                            .add(agentCommission)
                            .add(customerCommission);

                    productsWithCommissions.add(StringUtils.join(Arrays.asList(
                            destVal,
                            realPrice.add(eezeetelCommission),
                            groupCommission,
                            agentCommission,
                            customerCommission,
                            retailPrice), "-")
                    );
                }
                ticket.setBuy(StringUtils.join(productsWithCommissions, ","));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ResponseEntity.ok(ticket);
    }
}
