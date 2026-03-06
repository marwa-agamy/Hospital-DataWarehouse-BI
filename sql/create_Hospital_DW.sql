CREATE DATABASE Hospital_DW;
GO

USE Hospital_DW;
GO

/* =====================================================
   DIMENSION TABLES
===================================================== */

--Date Dimension
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter INT,
    month INT,
    month_name NVARCHAR(20),
    day INT,
    day_of_week NVARCHAR(20),
    is_weekend BIT
);

--Patient Dimension
CREATE TABLE dim_patient (
    patient_key INT IDENTITY PRIMARY KEY,
    patient_id INT,
    gender NVARCHAR(10),
    date_of_birth DATE,
    blood_group NVARCHAR(5),
    city NVARCHAR(50),
    contact_number NVARCHAR(30),
    start_date DATE,
    end_date DATE,
    is_current BIT
);

--Employee Dimension (Doctors Included)
CREATE TABLE dim_employee (
    employee_key INT IDENTITY PRIMARY KEY,
    employee_id INT,
    employee_name NVARCHAR(100),
    gender NVARCHAR(10),
    role NVARCHAR(50),
    date_of_joining DATE,
    specialization NVARCHAR(100),
    qualification NVARCHAR(100),
    experience_years INT,
    employment_type NVARCHAR(50),
    department_id INT,          
    department_name NVARCHAR(100),
    department_type NVARCHAR(50),
    floor_number INT,
    start_date DATE,
    end_date DATE,
    is_current BIT
);

--Ward Dimension
CREATE TABLE dim_ward (
    ward_key INT IDENTITY PRIMARY KEY,
    ward_id INT,
    ward_name NVARCHAR(100),
    ward_type NVARCHAR(50),
    total_beds INT,
    department_id INT,         
    department_name NVARCHAR(100),
    floor_number INT
);

--Bed Dimension
CREATE TABLE dim_bed (
    bed_key INT IDENTITY PRIMARY KEY,
    bed_id INT,
    bed_number NVARCHAR(10),
    bed_status NVARCHAR(20),
    ward_key INT,              
    department_id INT,         
    department_name NVARCHAR(100)
);

--Disease Dimension
CREATE TABLE dim_disease (
    disease_key INT IDENTITY PRIMARY KEY,
    disease_id INT,
    disease_name NVARCHAR(100),
    disease_category NVARCHAR(50)
);

--Diagnostic Test Dimension
CREATE TABLE dim_diagnostic_test (
    test_key INT IDENTITY PRIMARY KEY,
    test_id INT,
    test_name NVARCHAR(100),
    test_category NVARCHAR(50),
    standard_cost DECIMAL(12,2),
    department_name NVARCHAR(100)
);

--Drug Dimension (Manufacturer Merged)
CREATE TABLE dim_drug (
    drug_key INT IDENTITY PRIMARY KEY,
    drug_id INT,
    drug_name NVARCHAR(100),
    brand_name NVARCHAR(50),
    drug_category NVARCHAR(50),
    unit_cost DECIMAL(12,2),
    manufacturer_name NVARCHAR(100),
    manufacturer_country NVARCHAR(50),
    reliability_rating DECIMAL(3,2)
);

--Insurance Provider Dimension
CREATE TABLE dim_insurance_provider (
    insurance_provider_key INT IDENTITY PRIMARY KEY,
    insurance_provider_id INT,
    provider_name NVARCHAR(100),
    provider_type NVARCHAR(50),
    coverage_limit DECIMAL(12,2)
);


/* =====================================================
   FACT TABLES
===================================================== */

--Fact_Admission
CREATE TABLE fact_admission (
    admission_key INT IDENTITY PRIMARY KEY,
    admission_id INT,   
    patient_key INT,
    employee_key INT,   
    ward_key INT,
    bed_key INT,
    disease_key INT,
    admit_date_key INT,
    discharge_date_key INT,
    admission_type NVARCHAR(50),
    admission_status NVARCHAR(50),
    length_of_stay INT
);

--Fact_Billing
CREATE TABLE fact_billing (
    billing_key INT IDENTITY PRIMARY KEY,
    bill_id INT,                 
    admission_id INT,            
    patient_key INT,
    employee_key INT,            
    department_name NVARCHAR(100),
    bill_date_key INT,
    charge_type NVARCHAR(50),    
    reference_id INT,            
    line_amount DECIMAL(12,2),
    insurance_covered_amount DECIMAL(12,2),
    patient_payable_amount DECIMAL(12,2)
);

--Fact_Patient_Diagnostic
CREATE TABLE fact_patient_diagnostic (
    patient_diagnostic_key INT IDENTITY PRIMARY KEY,
    patient_diagnostic_id INT,
    admission_id INT,
    patient_key INT,
    test_key INT,
    employee_key INT,
    test_date_key INT,
    result_status NVARCHAR(50),
    test_cost DECIMAL(12,2)
);

--Fact_Prescription
CREATE TABLE fact_prescription (
    prescription_key INT IDENTITY PRIMARY KEY,
    prescription_id INT,
    admission_id INT,
    patient_key INT,
    employee_key INT,
    drug_key INT,
    dosage NVARCHAR(50),
    frequency NVARCHAR(50),
    duration_days INT
);

--Fact_Drug_Inventory
CREATE TABLE fact_drug_inventory (
    inventory_key INT IDENTITY PRIMARY KEY,
    drug_key INT,
    last_restock_date_key INT,
    current_stock INT,
    reorder_level INT,
    inventory_status NVARCHAR(20)
);

--Fact_Staff_Assignment
CREATE TABLE fact_staff_assignment (
    assignment_key INT IDENTITY PRIMARY KEY,
    employee_key INT,
    ward_key INT,
    staff_joining_date_key INT,
    shift NVARCHAR(50)
);

--Fact_Equipment_Maintenance
CREATE TABLE fact_equipment_maintenance (
    maintenance_key INT IDENTITY PRIMARY KEY,
    ward_key INT,
    maintenance_date_key INT,
    status NVARCHAR(30),
    downtime_hours INT,
    maintenance_cost DECIMAL(12,2)
);

--Fact_Patient_Satisfaction
CREATE TABLE fact_patient_satisfaction (
    satisfaction_key INT IDENTITY PRIMARY KEY,
    survey_id INT,
    admission_id INT,
    patient_key INT,
    employee_key INT,
    survey_date_key INT,
    satisfaction_score INT,
    cleanliness_score INT,
    staff_behavior_score INT,
    wait_time_score INT,
    would_recommend NVARCHAR(10)
);