package com.eezeetel.repository;

import com.eezeetel.entity.TBatchInformation;
import com.eezeetel.entity.TMasterProductinfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.persistence.LockModeType;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 09.12.2015.
 */
@Repository
public interface BatchRepository extends JpaRepository<TBatchInformation, Integer> {

    @Query(value = "SELECT SUM(tbi.Available_Quantity) AS availableQuantity FROM t_batch_information tbi WHERE tbi.Product_ID = ?1 AND tbi.Available_Quantity > 0 " +
            " AND tbi.Batch_Activated_By_Supplier = 1 AND tbi.Batch_Ready_To_Sell = 1 " +
            " AND tbi.IsBatchActive = 1 AND tbi.Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' ", nativeQuery = true)
    Integer getProductAvailableQuantity(Integer productId);

    List<TBatchInformation> findByProductIdAndBatchUploadStatusAndArrivalDateBetween(Integer productId, String batchUploadStatus, Date startDate, Date endDate);

    @Query(value = "SELECT * FROM t_history_batch_information thbi " +
            "WHERE thbi.Product_ID = ?1 AND thbi.Batch_Arrival_Date BETWEEN ?3 AND ?4 AND thbi.Batch_Upload_Status = ?2 ", nativeQuery = true)
    List<TBatchInformation> findByProductAndBatchUploadStatusAndArrivalDateBetweenFromHistory(Integer productId, String batchUploadStatus, Date startDate, Date endDate);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query(value = "from TBatchInformation where Product_ID = ?1 and Available_Quantity > 0 " +
            "                            and Batch_Activated_By_Supplier = 1 and Batch_Ready_To_Sell = 1 " +
            "                            and IsBatchActive = 1 and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
            "                            order by Batch_Arrival_Date, Available_Quantity ")
    List<TBatchInformation> findByProductAndReadyToSell(Integer productId);

    Page<TBatchInformation> findByAvailableQuantityGreaterThanOrderByEntryTimeDesc(Integer availableQuantity, Pageable pageable);

    @Query("select b from TBatchInformation b where b.arrivalDate between ?1 and ?2 and b.active = 0 and b.quantity > b.availableQuantity and b.availableQuantity <> 0 ")
    List<TBatchInformation> findByArrivalDateBetweenAndQuantityGreaterThanAvailableQuantity(Date start, Date end);

    @Query(value = "SELECT * FROM t_history_batch_information WHERE SequenceID = ?1 ", nativeQuery = true)
    TBatchInformation findOneFromHistory(Integer sequenceId);

    @Query(value = "SELECT * FROM t_batch_information tbi " +
            "WHERE tbi.Batch_Activated_By_Supplier = 1 " +
            "AND tbi.Batch_Ready_To_Sell = 1 " +
            "AND tbi.Product_ID = ?1 " +
            "AND tbi.Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
            "AND tbi.IsBatchActive = 0 " +
            "UNION ALL " +
            "SELECT * FROM t_history_batch_information thbi " +
            "WHERE thbi.Batch_Activated_By_Supplier = 1 " +
            "AND thbi.Batch_Ready_To_Sell = 1 " +
            "AND thbi.Product_ID = ?1 " +
            "AND thbi.Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
            "AND thbi.IsBatchActive = 0 ", nativeQuery = true)
    List<TBatchInformation> findDeactivatedBatchByProductId(Integer productId);

    @Query(value = "SELECT * FROM t_history_batch_information thbi " +
            "WHERE thbi.Product_ID = ?1 AND thbi.Batch_Arrival_Date BETWEEN ?2 AND ?3 AND thbi.Batch_Upload_Status = ?4 ", nativeQuery = true)
    List<TBatchInformation> findByProductAndBatchUploadStatusAndArrivalDateBetweenFromHistory2012(Integer productId, String batchUploadStatus, Date startDate, Date endDate);
}
