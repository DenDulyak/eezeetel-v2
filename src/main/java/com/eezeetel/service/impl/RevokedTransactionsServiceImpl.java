package com.eezeetel.service.impl;

import com.eezeetel.bean.ResponseContainer;
import com.eezeetel.bean.report.RevokedTransaction;
import com.eezeetel.entity.*;
import com.eezeetel.enums.RevokedTransactionStatus;
import com.eezeetel.repository.RevokedTransactionRepository;
import com.eezeetel.service.CardService;
import com.eezeetel.service.CustomerService;
import com.eezeetel.service.RevokedTransactionsService;
import com.eezeetel.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 03.12.2015.
 */
@Service
@Transactional
public class RevokedTransactionsServiceImpl implements RevokedTransactionsService {

    @Autowired
    private RevokedTransactionRepository revokedTransactionRepository;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private CardService cardService;

    @Autowired
    private CustomerService customerService;

    @Override
    public List<TRevokedTransactions> findAll() {
        return revokedTransactionRepository.findAll(new Sort(Sort.Direction.DESC, "id"));
    }

    @Override
    public Page<TRevokedTransactions> findAll(Pageable pageable) {
        return revokedTransactionRepository.findAll(pageable);
    }

    @Override
    public TRevokedTransactions save(TRevokedTransactions revokedTransaction) {
        return revokedTransactionRepository.save(revokedTransaction);
    }

    @Override
    public ResponseContainer<List<RevokedTransaction>> getRevokedTransactions(Integer page, Date from, Date to, Integer status) {
        ResponseContainer<List<RevokedTransaction>> container = new ResponseContainer<>();

        Page<TRevokedTransactions> revokedTransactions;
        if(status < 0) {
            revokedTransactions = revokedTransactionRepository.findByRevokedDateBetween(from, to, new PageRequest(page, 20, Sort.Direction.DESC, "id"));
        } else {
            RevokedTransactionStatus revokedTransactionStatus = RevokedTransactionStatus.values()[status];
            revokedTransactions = revokedTransactionRepository.findByRevokedDateBetweenAndSoldAgainStatus(from, to, (byte) revokedTransactionStatus.ordinal(), new PageRequest(page, 20, Sort.Direction.DESC, "id"));
        }
        Long count = revokedTransactions.getTotalElements();
        container.setCount(count);
        int total = (int) Math.ceil((double) count / 20);
        int begin = Math.max(1, page - 5);
        int end = Math.min(begin + 10, total);
        container.setPage(page);
        container.setBegin(begin);
        container.setEnd(end);
        setData(container, revokedTransactions.getContent());
        return container;
    }

    private void setData(ResponseContainer<List<RevokedTransaction>> container, List<TRevokedTransactions> tRevokedTransactions) {
        List<RevokedTransaction> result = new ArrayList<>();
        for (TRevokedTransactions tRevokedTransaction : tRevokedTransactions) {
            RevokedTransaction bean = new RevokedTransaction();
            List<TTransactions> tTransactions = transactionService.findByTransactionId(tRevokedTransaction.getOriginalTransactionId());
            List<TTransactions> newTransactions = null;
            if (tTransactions.isEmpty()) {
                tTransactions = transactionService.findByTransactionIdFromHistory(tRevokedTransaction.getOriginalTransactionId());
            }
            if (!tTransactions.isEmpty()) {
                String strStatus = "Not Sold";
                String strStatus1 = "";
                String strBatchID = "";
                String strCardPin = "";
                TCardInfo cardInfo = cardService.findOne(tRevokedTransaction.getCardSequenceId());
                if (cardInfo == null) {
                    cardInfo = cardService.findByIdFromHistory(tRevokedTransaction.getCardSequenceId());
                }
                if (cardInfo != null) {
                    strBatchID = cardInfo.getCardId();
                    strCardPin = cardInfo.getCardPin();
                    newTransactions = transactionService.findByTransactionId(cardInfo.getTransactionId());
                    if (newTransactions.isEmpty()) {
                        newTransactions = transactionService.findByTransactionIdFromHistory(cardInfo.getTransactionId());
                    }
                }
                TTransactions oldTransaction = tTransactions.get(0);
                TTransactions newTransaction = null;
                if (newTransactions != null && newTransactions.size() > 0) {
                    newTransaction = newTransactions.get(0);
                    if (tRevokedTransaction.getSoldAgainStatus() == 0) {
                        tRevokedTransaction.setNewSequenceId(newTransaction.getId());
                        tRevokedTransaction.setNewTransctionId(newTransaction.getTransactionId());
                        tRevokedTransaction.setSoldAgainStatus((byte) 1);
                        strStatus = "<a href='/masteradmin/CreditThisRevokedTransaction.jsp" +
                                "?Transaction=" + tRevokedTransaction.getOriginalSequenceId() +
                                "&RevokeSequence=" + tRevokedTransaction.getId() +
                                "'>Credit This</a>";

                        strStatus1 = "<a href='/masteradmin/RejectThisRevokedTransaction.jsp" +
                                "?Transaction=" + tRevokedTransaction.getNewSequenceId() +
                                "&RevokeSequence=" + tRevokedTransaction.getId() +
                                "'>Reject This</a>";

                        save(tRevokedTransaction);
                    } else if (tRevokedTransaction.getSoldAgainStatus() == 1) {
                        strStatus = "<a href='/masteradmin/CreditThisRevokedTransaction.jsp" +
                                "?Transaction=" + tRevokedTransaction.getOriginalSequenceId() +
                                "&RevokeSequence=" + tRevokedTransaction.getId() +
                                "'>Credit This</a>";

                        strStatus1 = "<a href='/masteradmin/RejectThisRevokedTransaction.jsp" +
                                "?Transaction=" + tRevokedTransaction.getNewSequenceId() +
                                "&RevokeSequence=" + tRevokedTransaction.getId() +
                                "'>Reject This</a>";
                    }
                    if (tRevokedTransaction.getSoldAgainStatus() == 2) {
                        strStatus = "Already Credited";
                    }

                    if (tRevokedTransaction.getSoldAgainStatus() == 3) {
                        strStatus = "Rejected";
                    }
                }

                TMasterCustomerinfo oldCustInfo = customerService.findOne(oldTransaction.getCustomer().getId());
                TMasterProductinfo productInfo = oldTransaction.getProduct();
                String strProduct = productInfo.getProductName() + " - " + productInfo.getProductFaceValue();

                TMasterCustomerinfo newCustomer = null;
                if (newTransaction != null)
                    newCustomer = customerService.findOne(newTransaction.getCustomer().getId());

                String oldCustomerGroup = oldCustInfo.getGroup().getName();
                String oldCustomerName = oldCustInfo.getCompanyName();
                long oldTransactionID = oldTransaction.getTransactionId();
                Date oldDate = oldTransaction.getTransactionTime();
                float fOldSalePrice = oldTransaction.getUnitPurchasePrice();
                if (oldCustInfo.getGroup().getId() != 1)
                    fOldSalePrice = oldTransaction.getUnitGroupPrice();

                Date revokedDate = tRevokedTransaction.getRevokedDate();

                String newCustomerGroup = "";
                String newCustomerName = "";
                long newTransactionID = 0;
                Date newDate = null;

                if (newCustomer != null) {
                    newCustomerGroup = newCustomer.getGroup().getName();
                    newCustomerName = newCustomer.getCompanyName();
                    newTransactionID = newTransaction.getTransactionId();
                    newDate = newTransaction.getTransactionTime();
                }
                bean.setCustomerGroup(oldCustomerGroup);
                bean.setCustomerName(oldCustomerName);
                bean.setTransactionId(oldTransactionID);
                bean.setTransactionTime(oldDate);
                bean.setSalePrice(fOldSalePrice);
                bean.setProductName(strProduct);
                bean.setBatchId(strBatchID);
                bean.setCardPin(strCardPin);
                bean.setRevokedDate(revokedDate);
                bean.setNewCustomerGroup(newCustomerGroup);
                bean.setNewCustomerName(newCustomerName);
                bean.setNewTransactionId(newTransactionID);
                bean.setNewDate(newDate);
                bean.setCredit(strStatus);
                bean.setReject(strStatus1);
                result.add(bean);
            }
        }
        container.setData(result);
    }
}
