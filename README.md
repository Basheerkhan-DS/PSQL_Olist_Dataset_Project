# Olist E‑commerce Analytics Project

A complete end‑to‑end SQL project built using the Olist E‑commerce public dataset. This project demonstrates data cleaning, transformation, modeling, and business analytics using PostgreSQL.

---

##  **Project Overview**

The goal of this project is to convert raw Olist CSV files into a fully cleaned, analytics‑ready database and produce meaningful business KPIs such as:

* Revenue insights
* Customer behavior metrics (RFM, repeat purchase behavior)
* Delivery performance
* Seller performance
* Product and category insights
* Payment patterns

This project is designed to demonstrate **SQL mastery**, **data modeling**, and **analytical thinking**.

---

##  **Repository Structure**

```
Olist-SQL-Analytics/
│
├── data/                       # Raw Olist CSVs
├── sql/
│   ├── 01_create_tables.sql    # Schema creation
│   ├── 02_import_data.sql      # COPY commands for loading CSVs
│   ├── 03_clean_views.sql      # Cleaned views for each table
│   ├── 04_transformed_views.sql# Analytical/derived views
│   └── 05_business_kpis.sql    # Final KPI queries
│
├── powerbi/
│   └── olist_dashboard.pbix    # Optional dashboard (if added)
│
├── README.md                   # Project documentation
└── .gitignore
```

---

## 🧰 **Tools & Technologies Used**

* **PostgreSQL** (main transformation + analytics)
* **SQL (CTEs, Window functions, Views, Aggregations)**
* **Power BI** (optional dashboard)
* **Git & GitHub** (version control)

---

## 🗂️ **Dataset Description**

The project uses Olist's Brazilian E‑commerce Public Dataset, including:

* Orders
* Customers
* Order Items
* Payments
* Sellers
* Products
* Geolocation
* Reviews

Each file contains transactional data from real e‑commerce activity.

---

##  **How to Run This Project**

### **1. Clone the repository**

```bash
git clone https://github.com/your-username/olist-sql.git
cd olist-sql
```

### **2. Create database**

```sql
CREATE DATABASE olist_db;
```

### **3. Create all tables**

```bash
psql -d olist_db -f sql/01_create_tables.sql
```

### **4. Import all CSV data**

```bash
psql -d olist_db -f sql/02_import_data.sql
```

### **5. Run cleaning files**

```bash
psql -d olist_db -f sql/03_clean_views.sql
```

### **6. Create analytical views**

```bash
psql -d olist_db -f sql/04_transformed_views.sql
```

### **7. Run business KPI queries**

```bash
psql -d olist_db -f sql/05_business_kpis.sql
```

---

##  **Data Cleaning Steps Implemented**

### ** Standardized date fields**

Converted timestamp fields into DATE using `DATE()`.

### ** Handled nulls & missing delivery timestamps**

Applied `COALESCE` where appropriate.

### ** Created clean versions of key tables**

Examples:

* `orders_clean`
* `customers_clean`
* `order_items_clean`
* `payments_clean`

### ** Removed duplicates & inconsistent rows**

Using `DISTINCT` and primary key enforcement.

---

##  **Data Modeling (Star‑Schema Inspired)**

This project follows a fact/dimension‑based structure:

### ** Dimensions**

* dim_customer
* dim_seller
* dim_product
* dim_date

### ** Facts**

* fact_orders
* fact_payments
* fact_order_items
* fact_reviews

---

## **Key Business KPIs Implemented**

### **🔹 Revenue Metrics**

* Daily / monthly revenue trends
* Revenue per category
* Seller revenue ranking
* Average ticket size

### **🔹 Customer Behavior Metrics**

* RFM scores
* Repeat purchase rate
* Customer lifetime value (CLV)

### **🔹 Operations Metrics**

* Delivery delays & SLA performance
* Average shipping time
* Review score impact on delivery

### **🔹 Product Insights**

* Top selling products
* Products with high return/review issues

---

##  Example SQL (Clean View Creation)

```sql
CREATE OR REPLACE VIEW orders_clean AS
SELECT
    order_id,
    customer_id,  
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    DATE(order_purchase_timestamp) AS order_purchase_date,
    DATE(order_delivered_customer_date) AS delivered_date,
    DATE(order_estimated_delivery_date) AS estimated_delivery_date
FROM orders;
```

---

## 📘 Example SQL (RFM Query Snippet)

```sql
WITH last_purchase AS (
  SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS last_purchase_dt,
    COUNT(DISTINCT o.order_id) AS frequency,
    SUM(oi.total_item_revenue) AS monetary
  FROM customers_clean c
  JOIN orders_clean o ON c.customer_id = o.customer_id
  JOIN order_items_clean oi ON o.order_id = oi.order_id
  GROUP BY c.customer_unique_id
)
SELECT * FROM last_purchase;
```

---

## 📈 Power BI Dashboard (Optional)

If the `.pbix` file is added, it contains:

* Revenue trend visuals
* Seller performance scorecards
* Customer RFM segmentation
* Delivery delay heatmaps

Folder: `powerbi/`

---

## 🔐 Privacy Note

All data used comes from a **public, anonymized dataset**. No personal user data is included.

---

## 📄 Future Enhancements

* Add ML forecasting (Prophet or Python)
* Add stored procedures for automation
* Add data QA scripts
* Deploy using Docker

---

## 📬 Contact

For queries or collaboration, feel free to connect:
**Email:** [pathabasheerkhan@gmail.com](mailto:pathabasheerkhan@gmail.com)

---

### ⭐ If you use this project, consider giving it a star on GitHub!
