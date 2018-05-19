package com.eezeetel.repository;

import com.eezeetel.entity.TBatchInformation;
import com.eezeetel.entity.TCardInfo;
import com.eezeetel.entity.TMasterProductinfo;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;

import javax.persistence.LockModeType;
import java.util.List;

/**
 * Created by Denis Dulyak on 09.12.2015.
 */
public interface CardRepository extends JpaRepository<TCardInfo, Long> {

    TCardInfo findById(Long id);

    TCardInfo findByCardPin(String pin);

    List<TCardInfo> findByProductAndBatchAndTransactionIdAndIsSoldTrue(TMasterProductinfo product, TBatchInformation batch, Long transactionId);

    List<TCardInfo> findByTransactionIdAndIsSoldTrue(Long transactionId);

    List<TCardInfo> findByProductIdAndTransactionIdAndIsSoldTrue(Integer productId, Long transactionId);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    List<TCardInfo> findByBatchAndIsSoldOrderByIdAsc(TBatchInformation batch, Boolean isSold, Pageable pageable);

    @Query(value = "SELECT x.card_id as cardId FROM ( " +
            " SELECT * FROM t_card_info where Batch_Sequence_ID = ?1 " +
            " UNION ALL " +
            " SELECT * FROM t_history_card_info where Batch_Sequence_ID = ?1 " +
            ") as x ORDER BY card_id ASC LIMIT 1 ", nativeQuery = true)
    String findFirstCardIdByBatch(Integer batchId);

    @Query(value = "SELECT card_id FROM t_history_card_info_old where Batch_Sequence_ID = ?1 ORDER BY card_id ASC LIMIT 1", nativeQuery = true)
    String findFirstCardIdByBatchOld(Integer batchId);

    @Query(value = "SELECT x.card_id as cardId FROM ( " +
            " SELECT * FROM t_card_info where Batch_Sequence_ID = ?1 " +
            " UNION ALL " +
            " SELECT * FROM t_history_card_info where Batch_Sequence_ID = ?1 " +
            ") as x ORDER BY card_id DESC LIMIT 1 ", nativeQuery = true)
    String findLastCardIdByBatch(Integer batchId);

    @Query(value = "SELECT card_id FROM t_history_card_info_old where Batch_Sequence_ID = ?1 ORDER BY card_id DESC LIMIT 1", nativeQuery = true)
    String findLastCardIdByBatchOld(Integer batchId);

    /* From history */

    @Query(value = "SELECT * FROM t_history_card_info WHERE SequenceID = ?1 ", nativeQuery = true)
    TCardInfo findByIdFromHistory(Long id);

    @Query(value = "SELECT * FROM t_history_card_info WHERE card_pin = ?1 ", nativeQuery = true)
    TCardInfo findByCardPinFromHistory(String pin);

    @Query(value = "SELECT * FROM t_history_card_info WHERE Transaction_ID = ?1 AND isSold = 1", nativeQuery = true)
    List<TCardInfo> findByTransactionIdAndIsSoldTrueFromHistory(Long transactionId);

    @Query(value = "SELECT * FROM t_history_card_info WHERE Product_ID = ?1 AND Transaction_ID = ?2 AND isSold = 1", nativeQuery = true)
    List<TCardInfo> findByProductIdAndTransactionIdAndIsSoldTrueFromHistory(Integer productId, Long transactionId);

    @Query(value = "SELECT * FROM t_history_card_info_old WHERE Product_ID = ?1 AND Transaction_ID = ?2 AND isSold = 1", nativeQuery = true)
    List<TCardInfo> findByProductIdAndTransactionIdAndIsSoldTrueFromHistoryOld(Integer productId, Long transactionId);
}
