# Brazilian E-Commerce Sales Analysis (SQL)

End-to-end SQL analysis of the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle (about 100k orders, 2016-2018).

## Business Questions

1. How does monthly revenue trend over time?
2. Which product categories generate the most revenue?
3. What share of customers come back to order again?
4. Which states face the worst delivery delays?

## Tech Stack

- **Database:** PostgreSQL
- **Language:** SQL
- **SQL concepts used:** JOINs, GROUP BY, HAVING, CTEs, date functions (`DATE_TRUNC`, `EXTRACT`), window functions (`LAG`, `RANK`, `SUM OVER`), conditional aggregation (`FILTER`), `COALESCE`

## Project Structure

```
olist-sales-analysis-sql/
├── data/                         # put Kaggle CSVs here (not committed)
├── sql/
│   ├── 01_schema_and_load.sql        # create tables + load CSVs
│   ├── 02_data_quality_checks.sql    # nulls, invalid dates, orphan rows
│   ├── 03_monthly_revenue_trends.sql # revenue, AOV, MoM growth
│   ├── 04_top_product_categories.sql # top 10 categories by revenue
│   ├── 05_repeat_customer_rate.sql   # repeat-customer rate
│   └── 06_delivery_delays_by_state.sql
└── README.md
```

## How to Run

1. Download the dataset from Kaggle and place the CSVs in `data/` (see `data/README.md`).
2. Create a database: `createdb olist`
3. Run the scripts in order from the project root:

```bash
psql -d olist -f sql/01_schema_and_load.sql
psql -d olist -f sql/02_data_quality_checks.sql
psql -d olist -f sql/03_monthly_revenue_trends.sql
psql -d olist -f sql/04_top_product_categories.sql
psql -d olist -f sql/05_repeat_customer_rate.sql
psql -d olist -f sql/06_delivery_delays_by_state.sql
```

## Method Notes

- Only orders with status `delivered` are included in revenue and delivery metrics.
- Revenue is the sum of item `price` (freight is excluded).
- Olist creates a new `customer_id` for every order, so repeat customers are identified with `customer_unique_id`.
- Delay is measured as actual delivery date minus estimated delivery date. States with fewer than 100 delivered orders are excluded from the delay ranking.

## Key Findings

> Run the queries and fill in your own numbers below.

- **Revenue trend:** _(e.g. growth pattern, peak month)_
- **Top categories:** _(e.g. top 3 categories and their share of revenue)_
- **Repeat customers:** _(repeat rate %, and what it suggests)_
- **Delivery delays:** _(states with the highest late-order %)_

## Author

Aditya, B.Tech Mechanical Engineering, NIT Durgapur
