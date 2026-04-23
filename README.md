# dbt-order-analytics-bigquery

A production-style data transformation pipeline built with **dbt Cloud** and **Google BigQuery**. Raw e-commerce order data is loaded into BigQuery, cleaned through a staging layer, and transformed into a business-ready analytics table with classification logic for revenue, pricing, geography, and payment behaviour.

---

## Problem

Raw transactional order data coming into a warehouse is messy — inconsistent casing, ambiguous column names, and no business context. Analysts can't answer questions like *"which city tier drives the most revenue?"* or *"what share of orders are digital payments?"* from a raw table.

This pipeline solves that by creating a clean, well-documented transformation layer on top of the raw data so analysts always have a trusted, query-ready table.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Google BigQuery                       │
│                                                             │
│   ┌──────────────┐     ┌──────────────┐    ┌─────────────┐ │
│   │  Raw Source  │────▶│  stg_orders  │───▶│ orders_rpt  │ │
│   │   (orders)   │     │    (VIEW)    │    │   (TABLE)   │ │
│   └──────────────┘     └──────────────┘    └─────────────┘ │
│     BigQuery table       dbt staging         dbt mart       │
│     loaded via DDL       • rename cols       • revenue_tier │
│                          • cast types        • price_segment│
│                          • clean casing      • city_tier    │
│                                              • order_size   │
│                                              • payment_type │
└─────────────────────────────────────────────────────────────┘

        dbt Cloud orchestrates all model runs & tests
```

**Layer responsibilities:**

| Layer | Model | Materialisation | Purpose |
|---|---|---|---|
| Source | `orders` (BigQuery) | External table | Raw order records |
| Staging | `stg_orders` | View | Clean, rename, standardise |
| Mart | `orders_rpt` | Table | Business logic & classification |

---

## Tech Stack

| Tool | Role |
|---|---|
| **Google BigQuery** | Cloud data warehouse |
| **dbt Cloud** | Transformation, testing, documentation |
| **SQL** | All transformation logic |
| **YAML** | Schema definitions, data quality tests |

---

## Pipeline Flow

### Step 1 — Load raw data into BigQuery
Run the DDL in `models/DDLS/orders_ddl.sql` directly in BigQuery to create and populate the `orders` source table with 20 e-commerce order records across Indian cities.

### Step 2 — Staging layer (`stg_orders`)
`models/STAGING/stg_orders.sql` reads from the raw source and applies light cleaning:
- Renames `price` → `unit_price` for clarity
- Applies `INITCAP()` to `category` and `city` for consistent casing
- Applies `UPPER()` to `payment_mode` so values are always `UPI`, `CARD`, `CASH`
- Materialised as a **view** (no storage cost, always fresh)

### Step 3 — Mart layer (`transformed_orders` → aliased as `orders_rpt`)
`models/ORDERS/transformed_orders.sql` reads from `stg_orders` via `{{ ref() }}` and adds five business classification columns:

| Column | Logic |
|---|---|
| `revenue_tier` | `premium` ≥ ₹50k / `high` ≥ ₹10k / `medium` ≥ ₹3k / `low` |
| `price_segment` | `luxury` ≥ ₹30k / `mid-range` ≥ ₹5k / `budget` |
| `order_size` | `bulk` (3+ units) / `multi` (2) / `single` (1) |
| `city_tier` | Tier 1 Metro / Tier 1 / Tier 2 / Tier 3 |
| `payment_type` | `Digital` (UPI/CARD) or `Physical` (Cash) |

Materialised as a **table** for fast downstream query performance.

### Step 4 — Data quality tests
dbt tests run automatically on both layers:
- `stg_orders` — `unique` + `not_null` on `order_id`, `not_null` on `customer_id`, `unit_price`, `order_date`, `accepted_values` on `payment_mode`
- `orders_rpt` — `unique` + `not_null` on `order_id`

---

## How to Run

### Prerequisites
- A Google Cloud project with BigQuery enabled
- A dbt Cloud account connected to your BigQuery project
- The BigQuery dataset created in your GCP project

### 1. Load the source data
Open BigQuery console, replace `<dataset_name>` in `models/DDLS/orders_ddl.sql` with your dataset name, and run the script.

### 2. Configure dbt Cloud
- Connect dbt Cloud to your BigQuery project via a service account
- Set your profile to point to the correct dataset
- Update `schema: staging` in `models/STAGING/schema.yml` to match your BigQuery dataset name

### 3. Run the pipeline
```bash
# Run all models (staging → mart)
dbt run

# Run tests on all models
dbt test

# Generate and serve documentation
dbt docs generate
dbt docs serve
```

### 4. Verify output
Query the final table in BigQuery:
```sql
SELECT
    revenue_tier,
    city_tier,
    payment_type,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_revenue
FROM <dataset_name>.orders_rpt
GROUP BY 1, 2, 3
ORDER BY total_revenue DESC;
```

---

## Output / Results

The final `orders_rpt` table contains 20 rows with all original fields plus 5 derived classification columns, ready for BI analysis.

**Sample insights from the dataset:**
- Electronics dominates revenue — Camera (₹45k) and Laptop (₹75k) are the only `premium` tier orders
- Mumbai and Delhi (`Tier 1 Metro`) account for 8 out of 20 orders
- UPI is the most used payment method, making `Digital` the majority payment type
- Bulk orders (3+ units) include T-shirt and Mouse — both low `price_segment` products

**dbt lineage:** `orders (source)` → `stg_orders (view)` → `orders_rpt (table)`

Running `dbt docs generate` produces a full data catalog with column descriptions, test results, and a visual lineage graph for the entire pipeline.
