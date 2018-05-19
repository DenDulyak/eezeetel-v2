package com.eezeetel.service.impl;

import com.eezeetel.entity.TBatchInformation;
import com.eezeetel.entity.TCardInfo;
import com.eezeetel.entity.TMasterProductinfo;
import com.eezeetel.repository.CardRepository;
import com.eezeetel.service.CardService;
import com.eezeetel.util.HibernateUtil;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CardServiceImpl implements CardService {

    @Autowired
    private CardRepository cardRepository;

    @Override
    public TCardInfo save(TCardInfo cardInfo) {
        return cardRepository.save(cardInfo);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public List<TCardInfo> save(List<TCardInfo> cards) {
        return cardRepository.save(cards);
    }

    @Override
    public TCardInfo findOne(Long id) {
        return cardRepository.findById(id);
    }

    @Override
    public List<TCardInfo> findByTransactionIdAndSold(Long transactionId) {
        List<TCardInfo> cards = cardRepository.findByTransactionIdAndIsSoldTrue(transactionId);
        if (cards.isEmpty()) {
            cards = cardRepository.findByTransactionIdAndIsSoldTrueFromHistory(transactionId);
        }
        return cards;
    }

    @Override
    public List<TCardInfo> findByProductIdAndTransactionIdAndSold(Integer productId, Long transactionId) {
        List<TCardInfo> cards = cardRepository.findByProductIdAndTransactionIdAndIsSoldTrue(productId, transactionId);
        if (cards.isEmpty()) {
            cards = cardRepository.findByProductIdAndTransactionIdAndIsSoldTrueFromHistory(productId, transactionId);
        }
        if (cards.isEmpty()) {
            cards = cardRepository.findByProductIdAndTransactionIdAndIsSoldTrueFromHistoryOld(productId, transactionId);
        }
        return cards;
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public List<TCardInfo> findByBatchAndIsSoldOrderByIdAsc(TBatchInformation batch, Boolean isSold, Pageable pageable) {
        return cardRepository.findByBatchAndIsSoldOrderByIdAsc(batch, isSold, pageable);
    }

    @Override
    public TCardInfo findByCardPin(String pin) {
        TCardInfo card = cardRepository.findByCardPin(pin);
        if (card == null) {
            card = cardRepository.findByCardPinFromHistory(pin);
        }
        return card;
    }

    @Override
    public String findFirstCardIdByBatch(Integer batchId) {
        String cardId = cardRepository.findFirstCardIdByBatch(batchId);
        if (cardId == null) {
            cardId = cardRepository.findFirstCardIdByBatchOld(batchId);
        }
        return cardId;
    }

    @Override
    public String findLastCardIdByBatch(Integer batchId) {
        String cardId = cardRepository.findLastCardIdByBatch(batchId);
        if (cardId == null) {
            cardId = cardRepository.findLastCardIdByBatchOld(batchId);
        }
        return cardId;
    }

    @Override
    public TCardInfo findByIdFromHistory(Long sequenceId) {
        return cardRepository.findByIdFromHistory(sequenceId);
    }

    @Override
    public List<TCardInfo> findByProductAndBatchAndtransactionIdAndIsSoldTrue(TMasterProductinfo product, TBatchInformation batch, Long transactionId) {
        return cardRepository.findByProductAndBatchAndTransactionIdAndIsSoldTrue(product, batch, transactionId);
    }

    @Override
    public List<TCardInfo> findByProductAndBatchAndtransactionIdAndIsSoldTrueFromHistory(TMasterProductinfo product, TBatchInformation batch, Long transactionId) {
        List<TCardInfo> result = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT * FROM t_history_card_info WHERE Product_ID = :productId AND Batch_Sequence_ID = :batchId AND Transaction_ID =:transactionId AND IsSold = 1 ";
            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.addEntity(TCardInfo.class);
            sqlQuery.setParameter("productId", product.getId());
            sqlQuery.setParameter("batchId", batch.getSequenceId());
            sqlQuery.setParameter("transactionId", transactionId);
            result = sqlQuery.list();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return result;
    }
}
