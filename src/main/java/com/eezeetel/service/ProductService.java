package com.eezeetel.service;

import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.bean.ProductBean;
import com.eezeetel.bean.customer.PrintSimTransaction;
import com.eezeetel.entity.TCardInfo;
import com.eezeetel.entity.TMasterProductinfo;
import com.eezeetel.entity.TSimTransactions;
import com.eezeetel.entity.TTransactions;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Service
public interface ProductService {

    TMasterProductinfo findOne(Integer id);
    List<TMasterProductinfo> findAll();
    List<TMasterProductinfo> findAllActive();
    TMasterProductinfo save(TMasterProductinfo product);
    TMasterProductinfo findByIdFromList(Integer id, List<TMasterProductinfo> products);
    List<TMasterProductinfo> findBySupplierId(Integer supplierId);
    List<ProductBean> getProductsBySupplier(Integer supplierId);
    ConfirmBean process(HttpServletRequest request, List<String> idsAndQuentity, String login);
    ConfirmBean confirm(final Long transactionId, Boolean mobile);
    Workbook getFileForBulkDownload(Long transactionId);
    String getPrintCardInfo(TCardInfo cardInfo);
    ConfirmBean getPrintTransactionInfo(Long transactionId);
    List getTransactionInfo(List<TTransactions> transactions, Long transactionId);
    PrintSimTransaction getSimTransactionInfo(TSimTransactions simTransaction);
}
