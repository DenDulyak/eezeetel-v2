package com.eezeetel.mobitopup;

import com.eezeetel.mobitopup.response.*;
import org.springframework.stereotype.Service;

@Service
public interface MobitopupMethod {

    Balance getBalance();

    Country getCountries();

    Network getNetworks(Integer countryId);

    Ticket getTickets(Integer networkId);

    CheckNumber checkNumber(String number);

    Topup topup(String destnumber, String srcnumber, String product, String message);

    Balance ottxBalance(String number);

    CheckNumber checkNumberV2(String number);

    Balance getPinlessBalance();
}
