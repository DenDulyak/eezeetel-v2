package com.eezeetel.api.services;

import com.eezeetel.api.responses.BalanceResponse;
import com.eezeetel.api.responses.Product;
import com.eezeetel.api.responses.ProductResponse;
import com.eezeetel.api.responses.PurchaseResporse;
import org.springframework.stereotype.Service;

@Service
public interface ApiService {

    BalanceResponse getBalance(String login, Long key, String md5);

    ProductResponse<Product> getSuppliers(String login, Long key, String md5);

    ProductResponse<Product> getProducts(String login, Long key, String md5, Integer supplierId);

    PurchaseResporse purchase(String login, Long key, String md5, Integer productId);

    PurchaseResporse purchasetest(String login, Long key, String md5, Integer productId);
}
