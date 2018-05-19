package com.eezeetel.repository.custom;

import com.eezeetel.bean.products.ProductSaleInfo;
import com.eezeetel.bean.report.CustomerBalanceReportBean;
import com.eezeetel.bean.report.DetailSales;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 06.01.2017.
 */
@Repository
public interface ReportRepository {

    List<CustomerBalanceReportBean> getCustomerBalanceReport(LocalDate startDate, LocalDate endDate);
    List<CustomerBalanceReportBean> getCustomerBalanceReportByGroupId(Integer groupId, LocalDate startDate, LocalDate endDate);
    List<ProductSaleInfo> getProductSaleInfos(List<Integer> productIds, Date from, Date to);
    List<DetailSales> getProductDetailSaleInfos(Integer productId, Date from, Date to);
}
