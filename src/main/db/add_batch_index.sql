ALTER TABLE t_history_transactions ADD INDEX `FK_history_transaction_batch` (`Batch_Sequence_ID` ASC);
ALTER TABLE t_history_transactions ADD INDEX `FK_history_transaction_id` (`Transaction_ID` ASC);
ALTER TABLE `genericappdb`.`t_card_info` ADD INDEX `FK_t_card_info_transaction_id` (`Transaction_ID` ASC);