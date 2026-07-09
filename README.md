# 🏡 Airbnb Data Warehouse & Analytics Project

## 📊 Overview
This project presents an end-to-end Data Warehouse solution for analyzing Airbnb data.  
It follows the Medallion Architecture (Bronze, Silver, Gold) to transform raw data into meaningful business insights.

---

## 🏗️ Architecture

- **Bronze Layer** → Raw data ingestion (imported as-is from source files)
- **Silver Layer** → Data cleaning and transformation
- **Gold Layer** → Final business-ready tables for analytics
- **Dashboard** → Data visualization using Power BI

---

## 📁 Project Structure
---

## ⚙️ Technologies Used

- SQL Server
- SSMS (SQL Server Management Studio)
- Power BI
- CSV Data Sources

---

## 🔄 Data Pipeline

1. Import raw data into Bronze layer
2. Clean and transform data into Silver layer
3. Build fact and dimension tables in Gold layer
4. Connect Gold layer to Power BI for visualization

---   

## 📈 Dashboard

The dashboard provides insights such as:
- Pricing trends
- Number of listings
- Superhost analysis
- Location-based insights

<img src="Dashboard/Dashbord photos/Overview Analysis.png" width="800"/>

<img src="Dashboard/Dashbord photos/Location Analysis.png" width="800"/>


## 🚀 How to Run

1. Import dataset into SQL Server (Bronze Layer)
2. Run SQL scripts in order (Silver → Gold)
3. Open Power BI file and connect to database

---

## 📌 Notes

- Bronze layer keeps raw data without modification
- Transformations are applied only in Silver layer
- Gold layer is optimized for analytics

