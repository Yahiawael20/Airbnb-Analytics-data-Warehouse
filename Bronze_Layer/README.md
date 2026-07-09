# 🥉 Bronze Layer - Data Ingestion

## 📌 Overview
The Bronze Layer contains raw data imported directly from source CSV files into SQL Server without any transformation.

---

## 📂 Data Source
- Source: Airbnb CSV dataset
- Files located in: `Dataset/` folder

---

## ⚙️ Import Method

Data was imported using **SQL Server Import and Export Wizard**.

### Steps:

1. Open SQL Server Management Studio (SSMS)
2. Right-click on the target database
3. Select:

Tasks → Import Data

4. Choose Data Source:
- Flat File Source
- Select CSV file

5. Configure columns and data types

6. Choose Destination:
- SQL Server Native Client
- Select database

7. Specify table name (e.g., `Bronze_Listings`)

8. Run the import process

---

## 📸 Screenshots
Screenshots are included in this folder to illustrate:
- File selection
- Column mapping
- Data preview
- Final import result

---

## 📌 Notes

- No transformations were applied in this layer
- Data is stored exactly as received from source
- This layer acts as a backup/reference for raw data

---

## 🎯 Purpose

- Preserve original data
- Ensure traceability
- Enable reprocessing if needed
