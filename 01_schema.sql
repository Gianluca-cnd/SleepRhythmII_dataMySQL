-- ============================================================
-- FILE: sql/01_schema.sql
-- Description: Database schema for sleep rhythm clinical study
-- ============================================================

CREATE DATABASE IF NOT EXISTS sleep_study;
USE sleep_study;

DROP TABLE IF EXISTS sleep_rhythm;
DROP TABLE IF EXISTS demographic;

-- One row per participant
CREATE TABLE demographic (
    ID              INT           NOT NULL,
    age             DECIMAL(4,1)  COMMENT 'Calculated age at enrollment',
    height_cm       INT           COMMENT 'Height in cm',
    weight_kg       DECIMAL(5,1)  COMMENT 'Weight in kg',
    BMI             DECIMAL(4,1)  COMMENT 'Body Mass Index',
    BMI_category    TINYINT       COMMENT '1=Normal 2=Overweight 3=Obese 4=Underweight',
    BMI_simplified  TINYINT       COMMENT 'Simplified BMI grouping',
    eye_conditions  TINYINT       COMMENT '0=No 1=Has eye conditions',
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Multiple records per participant (longitudinal)
CREATE TABLE sleep_rhythm (
    record_id           INT       NOT NULL AUTO_INCREMENT,
    ID                  INT       NOT NULL COMMENT 'FK to demographic',
    sex                 TINYINT   COMMENT '0=Male 1=Female',
    has_diseases        TINYINT   COMMENT '0=No or negligible 1=Yes',
    distance_learning   TINYINT   COMMENT '0=No 1=Yes',
    DST                 TINYINT   COMMENT '0=No DST 1=DST active',
    trimester           TINYINT   COMMENT 'Registration trimester (1-4)',
    birth_year          SMALLINT  COMMENT 'Year of birth (anonymized)',
    PRIMARY KEY (record_id),
    FOREIGN KEY (ID) REFERENCES demographic(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
