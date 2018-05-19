package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.MobitopupTransaction;
import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.entity.WorldTopupGroupCommission;
import com.eezeetel.mobitopup.MobitopupMethod;
import com.eezeetel.mobitopup.MobitopupUtil;
import com.eezeetel.mobitopup.response.MobitopupResponse;
import com.eezeetel.mobitopup.response.Network;
import com.eezeetel.mobitopup.response.Ticket;
import com.eezeetel.service.MobitopupTransactionService;
import com.eezeetel.service.PhoneTopupCountryService;
import com.eezeetel.service.WorldTopupGroupCommissionService;
import com.eezeetel.util.PriceUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.eezeetel.mobitopup.MobitopupUtil.validate;

@RestController("masterAdminMobitopupController")
@RequestMapping(value = "/masteradmin/mobitopup")
public class MobitopupController {

    @Autowired
    private MobitopupMethod mobitopupMethod;

    @Autowired
    private MobitopupTransactionService service;

    @Autowired
    private WorldTopupGroupCommissionService groupCommissionService;

    @Autowired
    private PhoneTopupCountryService countryService;

    @RequestMapping(value = "/get-balance", method = RequestMethod.GET)
    public ResponseEntity<MobitopupResponse> getBalance() {
        return ResponseEntity.ok(validate(mobitopupMethod.getBalance()));
    }

    @RequestMapping(value = "/get-networks", method = RequestMethod.GET)
    public ResponseEntity<Network> getNetworks(@RequestParam Integer mobitopupCountryId) {
        Network response = mobitopupMethod.getNetworks(mobitopupCountryId);
        if (StringUtils.isNotEmpty(response.getNetworks())) {
            response.setNetworkList(MobitopupUtil.toMap(response.getNetworks()));
        }
        return ResponseEntity.ok(validate(response));
    }

    @RequestMapping(value = "/get-tickets", method = RequestMethod.GET)
    public ResponseEntity<Ticket> getTickets(@RequestParam Integer groupId, @RequestParam Integer mobitopupCountryId, @RequestParam Integer networkId) {
        Ticket ticket = validate(mobitopupMethod.getTickets(networkId));

        try {
            PhoneTopupCountry country = countryService.findByMobitopupCountryId(mobitopupCountryId);
            WorldTopupGroupCommission groupCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, groupId);

            if (ticket.getError_code() == 0) {
                List<String> productsWithCommissions = new ArrayList<>();
                for (String product : Arrays.asList(ticket.getBuy().split(","))) {
                    String[] prices = product.split("-");
                    String destVal = prices[0];
                    BigDecimal realPrice = new BigDecimal(prices[1]);
                    BigDecimal priceWithCommission = PriceUtil.addPercentage(realPrice, new BigDecimal(groupCommission.getPercent() + ""));
                    productsWithCommissions.add(StringUtils.join(Arrays.asList(destVal, realPrice, priceWithCommission, priceWithCommission.subtract(realPrice)), "-"));
                }
                ticket.setBuy(StringUtils.join(productsWithCommissions, ","));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ResponseEntity.ok(ticket);
    }

    @RequestMapping(value = "/find", method = RequestMethod.GET)
    public ResponseEntity<Page<MobitopupTransaction>> find(Pageable pageable) {
        return ResponseEntity.ok(service.findAll(pageable));
    }
}
