-- CREATE DATABASE etl_workshop;
-- USE etl_workshop;

DROP TABLE IF EXISTS FactApplication;
DROP TABLE IF EXISTS DimCandidate;
DROP TABLE IF EXISTS DimDate;
DROP TABLE IF EXISTS DimCountry;
DROP TABLE IF EXISTS DimTechnology;
DROP TABLE IF EXISTS DimSeniority;

-- Dimensiones
CREATE TABLE DimCandidate (
  candidate_key INT AUTO_INCREMENT PRIMARY KEY,
  email         VARCHAR(320) NOT NULL UNIQUE,
  first_name    VARCHAR(100),
  last_name     VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE DimDate (
  date_key      INT PRIMARY KEY,       -- yyyymmdd
  date_value    DATE NOT NULL,
  year          INT,
  quarter       INT,
  month         INT,
  day_of_month  INT,
  day_of_week   INT,
  iso_week      INT
) ENGINE=InnoDB;

CREATE TABLE DimCountry (
  country_key   INT AUTO_INCREMENT PRIMARY KEY,
  country_name  VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE DimTechnology (
  technology_key  INT AUTO_INCREMENT PRIMARY KEY,
  technology_name VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE DimSeniority (
  seniority_key   INT AUTO_INCREMENT PRIMARY KEY,
  seniority_level VARCHAR(50) NOT NULL UNIQUE,
  seniority_order INT
) ENGINE=InnoDB;

-- Hechos
CREATE TABLE FactApplication (
  application_key           BIGINT AUTO_INCREMENT PRIMARY KEY,
  candidate_key             INT NOT NULL,
  date_key                  INT NOT NULL,
  country_key               INT NOT NULL,
  technology_key            INT NOT NULL,
  seniority_key             INT NOT NULL,
  yoe                       INT,
  code_challenge_score      INT,
  technical_interview_score INT,
  hired_flag                TINYINT(1) NOT NULL,
  application_nk            VARCHAR(255) UNIQUE,

  CONSTRAINT fk_fact_candidate  FOREIGN KEY (candidate_key)  REFERENCES DimCandidate(candidate_key),
  CONSTRAINT fk_fact_date       FOREIGN KEY (date_key)       REFERENCES DimDate(date_key),
  CONSTRAINT fk_fact_country    FOREIGN KEY (country_key)    REFERENCES DimCountry(country_key),
  CONSTRAINT fk_fact_tech       FOREIGN KEY (technology_key) REFERENCES DimTechnology(technology_key),
  CONSTRAINT fk_fact_seniority  FOREIGN KEY (seniority_key)  REFERENCES DimSeniority(seniority_key),

  INDEX ix_fact_date (date_key),
  INDEX ix_fact_country (country_key),
  INDEX ix_fact_tech (technology_key),
  INDEX ix_fact_seniority (seniority_key)
) ENGINE=InnoDB;

-- Semillas opcionales para evitar NULLs
INSERT IGNORE INTO DimCountry(country_name) VALUES ('Unknown');
INSERT IGNORE INTO DimTechnology(technology_name) VALUES ('Unknown');
INSERT IGNORE INTO DimSeniority(seniority_level, seniority_order) VALUES ('Unknown', 0);