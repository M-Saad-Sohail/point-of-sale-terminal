-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
-- -----------------------------------------------------
-- Schema pos
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pos` ;

-- -----------------------------------------------------
-- Schema pos
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pos` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
SHOW WARNINGS;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`cash_flow_lines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cash_flow_lines` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`cash_flow_lines` (
  `id` INT NOT NULL,
  `line_type` ENUM('header', "line") NULL,
  `is_net_income` TINYINT NULL,
  `visible_index` INT NULL,
  `printed_no` VARCHAR(20) NULL,
  `line_text` VARCHAR(225) NULL,
  `value_type` ENUM('D', 'C') NULL,
  `balance_type` ENUM('D', 'C', 'total', 'per_period') NULL,
  `left_index` INT NULL,
  `right_index` INT NULL,
  `inserted_at` DATETIME NULL,
  `inserted_by` VARCHAR(225) NULL,
  `updated_at` INT NULL,
  `updated_by` VARCHAR(225) NULL,
  `cash_flow_linescol` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `cas` () VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`cash_flow_line_assignments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cash_flow_line_assignments` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`cash_flow_line_assignments` (
  `id` INT NOT NULL,
  `account_id` BIGINT UNSIGNED NULL,
  `cash_flow_line_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `cash_flow_fk_idx` (`cash_flow_line_id` ASC) VISIBLE,
  INDEX `account_fk_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `cash_flow_fk`
    FOREIGN KEY (`cash_flow_line_id`)
    REFERENCES `mydb`.`cash_flow_lines` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`cash_flow_adjustments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cash_flow_adjustments` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`cash_flow_adjustments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `transaction_id` INT UNSIGNED NOT NULL,
  `account_id` BIGINT UNSIGNED NOT NULL,
  `entry_type` ENUM('D', 'C') NOT NULL,
  `amount` DECIMAL UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `transaction_fk_idx` (`transaction_id` ASC) VISIBLE,
  INDEX `account_fk_idx` (`account_id` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;
USE `pos` ;

-- -----------------------------------------------------
-- Table `pos`.`balance_and_income_lines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`balance_and_income_lines` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`balance_and_income_lines` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `line_type` ENUM('base_header', 'balance_header', 'income_header', 'balance_line', 'income_line') CHARACTER SET 'ascii' NOT NULL,
  `visible_index` INT UNSIGNED NOT NULL,
  `printed_no` VARCHAR(20) CHARACTER SET 'utf8mb3' NOT NULL,
  `line_text` VARCHAR(255) CHARACTER SET 'utf8mb3' NOT NULL,
  `value_type` ENUM('D', 'C') CHARACTER SET 'ascii' NOT NULL,
  `left_index` INT UNSIGNED NOT NULL,
  `right_index` INT UNSIGNED NOT NULL,
  `inserted_at` DATETIME NOT NULL,
  `inserted_by` VARCHAR(255) CHARACTER SET 'utf8mb3' NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `updated_by` VARCHAR(255) CHARACTER SET 'utf8mb3' NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `balance_and_income_lines_line_type_idx` (`line_type` ASC) VISIBLE,
  INDEX `balance_and_income_lines_visible_index_idx` (`visible_index` ASC) VISIBLE,
  INDEX `balance_and_income_lines_left_index_idx` (`left_index` ASC) VISIBLE,
  INDEX `balance_and_income_lines_right_index_idx` (`right_index` ASC) VISIBLE,
  INDEX `balance_and_income_lines_value_type_idx` (`value_type` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 39
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`equity_columns`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`equity_columns` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`equity_columns` (
  `id` INT NOT NULL,
  `column_text` VARCHAR(225) NULL DEFAULT NULL,
  `visible_index` INT NULL DEFAULT NULL,
  `inserted_at` DATETIME NULL DEFAULT NULL,
  `inserted_by` VARCHAR(225) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `updated_by` VARCHAR(225) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`accounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`accounts` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`accounts` (
  `id` BIGINT UNSIGNED NOT NULL,
  `balance_and_income_line_id` INT UNSIGNED NULL DEFAULT NULL,
  `equity_column_id` INT NULL DEFAULT NULL,
  `account_name` VARCHAR(255) CHARACTER SET 'utf8mb3' NOT NULL,
  `account_type` SMALLINT UNSIGNED NOT NULL,
  `official_code` VARCHAR(20) CHARACTER SET 'utf8mb3' NOT NULL,
  `is_archived` TINYINT UNSIGNED NOT NULL,
  `inserted_at` DATETIME NOT NULL,
  `inserted_by` VARCHAR(255) CHARACTER SET 'utf8mb3' NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `updated_by` VARCHAR(255) CHARACTER SET 'utf8mb3' NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `accounts_account_type_idx` (`account_type` ASC) VISIBLE,
  INDEX `accounts_official_code_idx` (`official_code` ASC) VISIBLE,
  INDEX `accounts_balance_and_income_line_id_fk` (`balance_and_income_line_id` ASC) VISIBLE,
  INDEX `accounts_equity_column_id_fk` (`equity_column_id` ASC) VISIBLE,
  CONSTRAINT `accounts_balance_and_income_line_id_fk`
    FOREIGN KEY (`balance_and_income_line_id`)
    REFERENCES `pos`.`balance_and_income_lines` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `accounts_equity_column_id_fk`
    FOREIGN KEY (`equity_column_id`)
    REFERENCES `pos`.`equity_columns` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`documents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`documents` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`documents` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `document_date` DATE NOT NULL,
  `document_no` VARCHAR(100) NOT NULL,
  `description` VARCHAR(500) NOT NULL,
  `document_type` SMALLINT NOT NULL,
  `inserted_at` DATETIME NOT NULL,
  `inserted_by` VARCHAR(255) NULL DEFAULT NULL,
  `updated_at` DATETIME NOT NULL,
  `updated_by` VARCHAR(255) NULL DEFAULT NULL,
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `document_type` (`document_type` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`transactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`transactions` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`transactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(255) NOT NULL,
  `transaction_date` DATE NOT NULL,
  `document_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `document_id` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_document_id`
    FOREIGN KEY (`document_id`)
    REFERENCES `pos`.`documents` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`cash_flow_adjustments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`cash_flow_adjustments` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`cash_flow_adjustments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `transaction_id` INT UNSIGNED NOT NULL,
  `account_id` BIGINT UNSIGNED NOT NULL,
  `entry_type` ENUM('D', 'C') NOT NULL,
  `amount` DECIMAL(10,0) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `transaction_fk_idx` (`transaction_id` ASC) VISIBLE,
  INDEX `account_fk_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `cash_flow_adjustments_account_fk`
    FOREIGN KEY (`account_id`)
    REFERENCES `pos`.`accounts` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `cash_flow_adjustments_transaction_fk`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `pos`.`transactions` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`cash_flow_lines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`cash_flow_lines` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`cash_flow_lines` (
  `id` INT NOT NULL,
  `line_type` ENUM('header', 'line') NULL DEFAULT NULL,
  `is_net_income` TINYINT NULL DEFAULT NULL,
  `visible_index` INT NULL DEFAULT NULL,
  `printed_no` VARCHAR(20) NULL DEFAULT NULL,
  `line_text` VARCHAR(225) NULL DEFAULT NULL,
  `value_type` ENUM('D', 'C') NULL DEFAULT NULL,
  `balance_type` ENUM('D', 'C', 'total', 'per_period') NULL DEFAULT NULL,
  `left_index` INT NULL DEFAULT NULL,
  `right_index` INT NULL DEFAULT NULL,
  `inserted_at` DATETIME NULL DEFAULT NULL,
  `inserted_by` VARCHAR(225) NULL DEFAULT NULL,
  `updated_at` INT NULL DEFAULT NULL,
  `updated_by` VARCHAR(225) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`cash_flow_line_assignments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`cash_flow_line_assignments` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`cash_flow_line_assignments` (
  `id` INT NOT NULL,
  `account_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `cash_flow_line_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `cash_flow_fk_idx` (`cash_flow_line_id` ASC) VISIBLE,
  INDEX `account_fk_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `account_fk`
    FOREIGN KEY (`account_id`)
    REFERENCES `pos`.`accounts` (`id`),
  CONSTRAINT `cash_flow_fk`
    FOREIGN KEY (`cash_flow_line_id`)
    REFERENCES `pos`.`cash_flow_lines` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `pos`.`ledger_entries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pos`.`ledger_entries` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `pos`.`ledger_entries` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `transaction_id` INT UNSIGNED NOT NULL,
  `account_id` BIGINT UNSIGNED NOT NULL,
  `entry_type` ENUM('d', 'c') NOT NULL,
  `amount` DECIMAL(20,2) NOT NULL,
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `account_id` (`account_id` ASC) VISIBLE,
  UNIQUE INDEX `amount` (`amount` ASC) VISIBLE,
  INDEX `fk_ledger_entries_2` (`transaction_id` ASC) VISIBLE,
  CONSTRAINT `fk_ledger_entries_1`
    FOREIGN KEY (`account_id`)
    REFERENCES `pos`.`accounts` (`id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ledger_entries_2`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `pos`.`transactions` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
