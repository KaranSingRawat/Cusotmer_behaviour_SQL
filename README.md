# 🧠 Advanced Customer Analytics Using SQL

Welcome to the **Advanced Customer Analytics Project**, where I’ve used SQL to perform deep data analysis on customer behavior. 
This project is focused on generating business insights through revenue trends, customer segmentation, retention, and churn prediction — all using raw SQL queries.

---

## 📊 Project Goals

- Identify key trends in revenue over time
- Understand customer purchasing behavior
- Segment customers based on LTV, RFM, and cohort analysis
- Analyze retention rates across time periods
- Prepare churn signals for future predictive modeling

---

## 🗂️ Dataset Overview

The project uses data from three main tables:

- `customers` – Customer demographic and registration details
- `orders` – Transaction records including amount and date
- `products` (optional) – Product-level insights (not primary for this version)

---

## ✅ Completed Tasks

### 1. 📈 Revenue Trend Analysis
- Monthly and yearly revenue
- Month-over-month (MoM) and year-over-year (YoY) changes
- Revenue growth status (Up, Down, No Change)

### 2. 💸 Customer Lifetime Value (LTV)
- Total revenue per customer
- Ranked and categorized customers into Low, Medium, and High LTV

### 3. 🧩 RFM Segmentation
- Classified customers based on:
  - **Recency** (How recently they purchased)
  - **Frequency** (How often they purchased)
  - **Monetary** (How much they spent)
- Built customer profiles (e.g., Premium, Low Profile, etc.)

### 4. 📆 Cohort Analysis
- Grouped customers by first purchase month
- Tracked retention behavior across monthly intervals
- Created a structure to visualize retention matrix

### 5. ⚠️ Churn Indicators (Pre-Modeling)
- Calculated:
  - Recency (days since last purchase)
  - Total orders and revenue
  - Average order value and average gap between orders
- Identified behavioral flags for potential churn

---

## 📌 Tools Used

- **SQL (T-SQL / MySQL / PostgreSQL compatible)**  
- **DBMS**: Microsoft SQL Server   

