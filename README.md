# E-commerce Database Normalization & Relational Data Analysis

## Project Objective
The objective of this project is to take a raw, flat transactional e-commerce dataset (`ecommerce_dataset_updated.csv`) and architect a structured, relational database schema inside MySQL. By breaking down data redundancy, implementing strict primary and foreign key constraints, and writing advanced analytical queries, this project delivers fast, business-critical insights regarding category performance, customer segmentation, and payment channel efficiency.

---

## Technical Architecture & Database Normalization

### The Challenge with Flat Files
The raw transactional data originally housed all data fields—including unique user identifiers, specific product categories, pricing structures, and transaction records—inside a single, flat spreadsheet table. In a real-world enterprise pipeline, querying a flat data table of that size causes extreme data redundancy, risks data anomalies during updates, and severely limits operational search speed.

### The Solution: Star Schema Normalization
To optimize storage architecture and implement proper data integrity, the raw dataset was normalized and decoupled into three distinct relational tables using explicit data type constraints (`VARCHAR(50)` for structural primary keys):

1. **`users` (Dimension Table):** Stores unique, distinct customer system strings (`User_ID`).
2. **`products` (Dimension Table):** Maps distinct products (`Product_ID`), catalog groupings (`Category`), and original pricing figures (`price_rs`).
3. **`orders` (Central Fact Table):** Records transaction-specific rows linked back to the dimension components using foreign key maps. Contains transactional parameters like discounts, final basket totals, payment methods, and purchase dates.

---

## Analytical Queries & Business Value Uncovered

The repository script (`ecommerce_analysis_queries.sql`) contains five advanced analytical modules written to extract commercial value from the database:

### 1. High-Value Catalog Filtering (`SELECT`, `WHERE`, `ORDER BY`)
* **Objective:** Isolates premium inventory lines across targeted lifestyle domains (Sports, Beauty, and Clothing) priced over 400 Rs to assist marketing with high-margin product tracking.

### 2. Category Revenue Performance Matrix (`INNER JOIN`, `GROUP BY`, Aggregates)
* **Objective:** Combines data across tables to calculate overall order volumes, gross revenue streams, and average discount percentages handed out by category.
* **Business Insight:** Pinpoints exactly which operational segments dominate revenue generation and whether heavy promotional discounts are chewing into categorical profits.

### 3. Customer VIP Segmentation (Advanced Nested Subqueries)
* **Objective:** Implements a double-nested subquery within a `HAVING` clause to mathematically calculate the storewide customer lifetime spend average and filter out only the elite "VIP" users who exceed that threshold.
* **Business Insight:** Provides the customer-success team with an immediate target list for automated loyalty reward campaigns.

### 4. Business Intelligence Reporting Layer (`CREATE VIEW`)
* **Objective:** Establishes a permanent virtual data abstraction layer (`view_payment_mode_metrics`) tracking transaction tallies, aggregate sales volumes, and average ticket sizes grouped by individual financial channels.
* **Business Insight:** Simplifies business logic—allowing administrative team members to monitor digital payment channel efficiency using a single basic lookup line.

### 5. Performance Engineering Optimization (`CREATE INDEX`)
* **Objective:** Builds a physical B-Tree lookup index (`idx_order_product_mapping`) mapped to the database's most heavily crossed operational foreign key field (`product_id`).
* **Business Insight:** Speeds up relational search and table join execution processing speeds as transactional volumes grow from thousands to millions of entries.

---

## Project Repository File Structure
* **`ecommerce_dataset_updated.csv`**: The underlying raw, multi-dimensional transactional comma-separated data source.
* **`ecommerce_analysis_queries.sql`**: The production-ready MySQL workbench script containing the database drop schemas, structural table alterations, foreign key bindings, and analytical algorithms.
* **`sql-outputs/`**: A folder containing high-resolution snapshots showcasing the final validated query result grids and successful green execution logs inside MySQL Workbench.
