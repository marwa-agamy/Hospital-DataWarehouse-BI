# 🏥 HMIS Data Warehouse & Business Intelligence Solution

## 📌 Project Overview

This project demonstrates the design and implementation of a **complete end-to-end Business Intelligence solution** for a Hospital Management Information System (HMIS).

The project simulates a real-world enterprise BI architecture where data is collected from multiple heterogeneous sources, processed using ETL pipelines, stored in a dimensional Data Warehouse, and analyzed through reporting and visualization tools.

The solution covers the full BI lifecycle:

- Data ingestion
- Multi-source integration
- ETL processing
- Data warehouse modeling
- Semantic modeling
- Reporting and visualization

The goal of the project is to transform raw operational healthcare data into a structured analytical model that supports reporting, performance monitoring, and decision-making.

---

# 📊 Data Sources

## 1️⃣ Primary Dataset (Kaggle)

The core dataset was obtained from Kaggle and contains:

- 19 CSV files
- Healthcare operational data including:
  - Admissions
  - Patients
  - Employees
  - Billing
  - Prescriptions
  - Diagnostics
  - Drug Inventory
  - Wards
  - Diseases

## Python Data Loading

Before starting the ETL pipeline, the CSV files were first loaded into SQL Server using **Python**.

Python was used to:

- Read CSV files
- Insert data into SQL Server tables

The data was loaded into the following database: Hospital
This database represents the **raw operational source layer**.
---

## 2️⃣ Additional Data Sources

To simulate real-world enterprise data integration scenarios, additional heterogeneous sources were included:

- Excel files
- Flat files (CSV / Text)

These sources were later integrated into the ETL pipeline using SSIS.

---

# 🏗 Architecture Overview

The architecture follows a layered approach:

`Source Layer → Staging Layer (Hospital_Staging) → Data Warehouse Layer (Hospital_DW) → Semantic Layer (SSAS Tabular) → Reporting Layer (SSRS & Power BI)`
---

# ⚙️ ETL Process (SSIS)

SQL Server Integration Services (SSIS) was used to build the ETL pipelines.

The ETL process was implemented in two main stages.

---

# Stage 1: Load Data to Staging Area

Data was extracted from:

- Hospital database (loaded by Python)
- Excel file
- Flat file

And loaded into the staging database: Hospital_Staging


The staging layer acts as an intermediate storage area where raw data is prepared before entering the Data Warehouse.

---

## Transformations Applied in SSIS

Several SSIS transformations were used during the ETL process:

- Data Conversion
- Derived Column
- Lookup Transformation
- Data Cleansing
- Column Mapping
- Error Output Handling

These transformations were used to:

- Standardize data formats
- Handle null values
- Validate records
- Map business keys to surrogate keys
- Prepare data for dimensional modeling

---

# Stage 2: Load Data Warehouse

A second SSIS package was created to load data from: Hospital_Staging → Hospital_DW

---

## ETL Workflow Design

To ensure correct execution order:

- **Dimension tables and Fact tables were separated into different Sequence Containers**
- **Precedence constraints** were used to control execution order

This ensures:

- Dimension tables load first
- Fact tables load afterward
- Lookups always find valid dimension keys

The ETL process was intentionally designed to run **sequentially instead of parallel execution** to maintain referential integrity.

---

# 🏛 Data Warehouse Design

The analytical database created is: Hospital_DW


The data warehouse follows **Dimensional Modeling principles**.

---

# Schema Type

The model follows a:

**Galaxy Schema (Fact Constellation)**

This means multiple fact tables share common dimensions.

---

# 📊 Fact Tables

The Data Warehouse contains several fact tables representing different hospital business processes.

### Transaction Fact Tables

These capture individual operational events:

- **Fact_Billing**
- **Fact_Prescriptions**
- **Fact_Patient_Diagnostics**

---

### Accumulating Snapshot Fact

Tracks lifecycle events.

Example:

**Fact_Admissions**

Tracks:

- admission date
- discharge date
- admission status
- length of stay

---

### Periodic Snapshot Fact

Tracks system status over time.

Example:

**Fact_Drug_Inventory**

Tracks:

- current stock
- reorder level
- inventory status
- last restock date

---

### Other Fact Tables

Additional analytical facts include:

- Fact_Staff_Assignments
- Fact_Patient_Satisfaction
- Fact_Equipment_Maintenance

---

# 📂 Dimension Tables

The Data Warehouse includes the following dimensions:

- Dim_Patient
- Dim_Employee
- Dim_Date
- Dim_Drug
- Dim_Disease
- Dim_Ward
- Dim_Bed

---

## Dimension Design Features

Dimensions include:

- Surrogate keys
- Business attributes
- Cleaned descriptive fields
- Relationships to fact tables

---

# 🧠 Semantic Layer (SSAS Tabular)

After building the Data Warehouse, a **Tabular Model** was developed using **SQL Server Analysis Services (SSAS)**.

The semantic layer simplifies data access for reporting tools.

---

## Model Improvements

Several improvements were made inside the SSAS model:

- Renamed dimension and fact tables to be **user-friendly**
- Created relationships between tables
- Organized tables logically
- Added calculated columns
- Created DAX measures
- Implemented business calculations

---

# DAX Calculations

Several calculations were implemented using **DAX (Data Analysis Expressions)**.

### Example Calculated Column

Patient Age:

```DAX
age = DATEDIFF(Patients[date_of_birth],TODAY(),YEAR)
Age Group =SWITCH(
    TRUE(),
    Patients[age] <= 15, "0-15",
    Patients[age] <= 35, "16-35",
    Patients[age] <= 60, "36-60",
    Patients[age] <= 80, "61-80",
    "80+"
)
```

### Example Measures

Total Billing:

```DAX
Total Billing = SUM(Billings[line_amount])
```

Total Admissions:

```DAX
Total Admissions = COUNT(Admissions[admission_key])
```

Average Length of Stay:

```DAX
Avg Length of Stay = AVERAGE(Admissions[length_of_stay])
```

Total Drug Stock :
```DAX
Total Drug Stock = SUM(Drug_Inventory[current_stock])
```
---

# 📊 Reporting Layer

The reporting layer of this project was implemented using:

- SQL Server Reporting Services (SSRS)
- Power BI

This layer provides both **operational reports** and **interactive dashboards** based on the Data Warehouse and SSAS Tabular model.

---
# 📊 Power BI Dashboard – Hospitalya

## 📌 Project Overview

**Hospitalya** is a multi-page **Power BI Business Intelligence solution** designed to provide hospital administrators with a **360-degree view** of clinical, financial, and operational data.

The project transforms complex healthcare datasets into **actionable insights**, with a strong focus on:

- Resource optimization  
- Revenue growth  
- Operational efficiency  
- Data-driven decision-making  

---

# 🚀 Key Dashboard Modules

## 🏥 1. Executive Overview (Hospitalya Main)

Provides a high-level summary of hospital performance.

### Key Features:

- **KPIs Dashboard**
  - Total Admissions: 45K  
  - Revenue: 1.48 Billion  
  - Patient Volume  

- **Financial Trends**
  - Yearly revenue analysis (2020–2026)
  - Revenue categorized by:
    - Drugs  
    - Procedures  
    - Room Charges  
    - Tests  

- **Operational Mix**
  - Admissions distribution by department:
    - Surgery  
    - Emergency  
    - Pediatrics  
    - Others  

---

## 👩‍⚕️ 2. Patient Analytics

Focuses on patient demographics and experience.

### Key Features:

- **Demographics Analysis**
  - Gender distribution (53% Female)
  - Age group segmentation  

- **Patient Satisfaction Metrics**
  - Wait Time  
  - Cleanliness  
  - Staff Behavior  

- **Geospatial Insights**
  - Top-performing cities by patients  

---

## 👨‍⚕️ 3. Employee Performance 

Analyzes workforce efficiency and allocation.

### Key Features:

- **Staffing Overview**
  - 500+ employees categorized by:
    - Doctors  
    - Nurses  
    - Pharmacists
    - Technicians 
    - Adminis  

- **Shift Optimization**
  - Sankey Diagram visualizing:
    - Morning shift  
    - Evening shift  
    - Night shift  

- **Medical Specialization**
  - Doctor qualifications:
    - MBBS
    - DM
    - MD  
    - MS  
  - Compared against department needs  

---

## 💊 4. Drug Usage & Inventory 

Monitors drug stock and supply chain performance.

### Key Features:

- **Inventory Control**
  - 131K+ drug stock units  
  - 8 drug categories  

- **Advanced Tooltip**
  - Custom report page tooltip
  - Displays:
    - Inventory Status (Low / Normal)  
  - Enables proactive reordering  

- **Supplier Trends**
  - Top manufacturing countries:
    - Switzerland  
    - India  
    - Germany  

---

## 🏢 5. Ward & Facility Operations

Provides insights into hospital infrastructure.

### Key Features:

- **Bed Capacity**
  - Total beds: 415  
  - Occupancy rate: 65%  

- **Maintenance Monitoring**
  - Equipment status:
    - Operational  
    - Down  
  - Maintenance costs: $3M  

---

## 🧪 6. Diagnostic Test Insights

Analyzes diagnostic services and revenue streams.

### Key Features:

- **Revenue Analysis**
  - Pathology vs. Radiology  

- **Time-Series Analysis**
  - Monthly diagnostic trends (Jan–Dec)  
  - Custom sorting applied for chronological order  

---

# 🛠️ Technical Implementation

## 📊 Data Modeling 

- **Sorting Logic**
  - Implemented *Sort by Column* for:
    - Months  
    - Years  
  - Ensures correct chronological visualization  

---

## 🎨 UI/UX & Dashboard Design

- **Custom Navigation**
  - Floating navigation bar  
  - App-like user experience  

- **Consistent Branding**
  - Rounded containers  
  - Soft shadow effects  

- **Interactive Features**
  - Cross-filtering  
  - Slicers (Age Groups, Years)  
  - Custom tooltips  

---

# 📈 Business Value

The dashboard provides significant value to hospital management:

### ✅ Operational Efficiency
- Optimizes staff shift distribution  
- Reduces burnout  
- Improves patient care coverage  

### 💰 Financial Insights
- Tracks revenue streams accurately  

### 📦 Inventory Risk Mitigation
- Identifies low stock early  
- Prevents critical drug shortages  

### 📊 Data-Driven Decisions
- Enables quick insights across departments  
- Improves strategic planning  

---

# 🏆 Project Highlights

- Multi-page interactive Power BI dashboard  
- Advanced DAX calculations  
- Real-world healthcare use case  
- Strong focus on UI/UX design  
- Business-oriented insights and KPIs  
