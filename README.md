# 🚀 ETL Workshop — Recruitment Data Analysis

## 📌 Project Description
This project implements a complete **ETL (Extract, Transform, Load) pipeline** using Python, MySQL, and Jupyter Notebook.  
The dataset represents **50,000 job applications** with attributes such as candidate information, application date, country, seniority, technology, and evaluation scores.  

The main objective was to **design a Data Warehouse with a Star Schema** and generate **KPIs and visualizations** to analyze recruitment trends.

---

## 🔄 ETL Pipeline

### 1. **Extract**
- Source: `candidates.csv` (semicolon separated)
- Tool: `pandas.read_csv`

### 2. **Transform** (Python + Pandas in Jupyter)
- Normalize column names (snake_case)
- Clean string fields
- Parse application dates
- Convert numeric fields (YOE, scores)
- Apply business rule:  
  `hired_flag = 1 if code_challenge_score >= 7 and technical_interview_score >= 7 else 0`
- Create natural key:  
  `application_nk = email + application_date`
- Sanity checks → 50,000 rows, 0 invalid dates, 13.4% hire rate

### 3. **Load** (MySQL with `mysql-connector-python`)
- **Star Schema** design:
  - **Dimensions**:  
    - `DimCandidate`  
    - `DimDate`  
    - `DimCountry`  
    - `DimTechnology`  
    - `DimSeniority`  
  - **Fact**:  
    - `FactApplication`  

---

## 🗂️ Data Warehouse (Star Schema)
```mermaid
erDiagram
    FactApplication {
        int application_key PK
        int candidate_key FK
        int date_key FK
        int country_key FK
        int technology_key FK
        int seniority_key FK
        int yoe
        int code_challenge_score
        int technical_interview_score
        int hired_flag
        varchar application_nk
    }

    DimCandidate {
        int candidate_key PK
        varchar email
        varchar first_name
        varchar last_name
    }

    DimDate {
        int date_key PK
        date date_value
        int year
        int quarter
        int month
        int day_of_month
        int day_of_week
        int iso_week
    }

    DimCountry {
        int country_key PK
        varchar country_name
    }

    DimTechnology {
        int technology_key PK
        varchar technology_name
    }

    DimSeniority {
        int seniority_key PK
        varchar seniority_level
        int seniority_order
    }

    FactApplication }o--|| DimCandidate : "candidate_key"
    FactApplication }o--|| DimDate : "date_key"
    FactApplication }o--|| DimCountry : "country_key"
    FactApplication }o--|| DimTechnology : "technology_key"
    FactApplication }o--|| DimSeniority : "seniority_key"


📊 KPIs Implemented
Hires by Technology → Top-demand skills (Game Development, DevOps).
Hires by Year → Stable until 2021, sharp drop in 2022.
Hires by Seniority → Balanced distribution, slightly more entry-level.
Hires by Country → Regional differences (Brazil leading but declining).
Global Hire Rate % → Only 13.4% of candidates hired.
Average Scores by Technology → Consistent performance across areas.


📈 Visualizations
Bar Chart → Hires by Technology
Line Chart → Hires by Year
Pie Chart → Hires by Seniority
Multi-Line Chart → Hires by Country over Time
Grouped Bar Chart → Average Scores by Technology
🛠️ Tech Stack
Python: pandas, matplotlib, mysql-connector-python, sqlalchemy
Database: MySQL 8 (dbngin + Workbench)
Notebook: Jupyter
Schema Design: dbdiagram.io
📌 Conclusions
The ETL pipeline was implemented successfully.
The Star Schema allowed efficient analytical queries.
KPIs and visualizations revealed meaningful insights about recruitment.
The global hire rate was very selective (~13%).
This project provided hands-on experience in Data Engineering & Analytics.
▶️ How to Run
Clone this repository:
git clone https://github.com/yourusername/etl-workshop.git
cd etl-workshop
Install dependencies:
pip install -r requirements.txt
Start MySQL server (via dbngin or local instance).
Execute schema creation:
mysql -u root -p < sql/ddl_star_schema.sql
Run Jupyter Notebook:
jupyter notebook ETL_Workshop.ipynb
✨ Author
👩‍💻 Daniela Marín Villacorte
Data Engineering Student — Universidad Autónoma de Occidente