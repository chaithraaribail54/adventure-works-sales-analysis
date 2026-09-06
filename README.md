# Adventure Works Cycles - Sales Data Analysis

## Executive Summary
Adventure Works Cycles is a multinational manufacturing enterprise specializing in metal and composite bicycles distributed across North American, European, and Asian commercial markets. This data analysis project analyzes sales performance across global territories, product categories, customer segments, and time dimensions to identify growth opportunities, support market expansion, and optimize overall cost of sales.

## Data Model Architecture
The data model uses a star-schema framework connecting the core `SALES` fact dataset to four primary dimension tables:

* **Fact Table**: `SALES` (Contains transactional measures, revenue, quantities, and key foreign references)
* **Dimension Tables**:
  * `DimCustomer`: Demographics, customer attributes, and geographic details
  * `DimDate`: Time-series attributes (Year, Quarter, Month, Day) for trend analysis
  * `DimProduct`: Product metadata, categories, subcategories, and manufacturing costs
  * `DimSalesTerritory`: Regional and international sales territory breakdown

               ┌──────────────────┐
               │   DimCustomer    │
               └────────┬─────────┘
                        │
               ┌────────┴─────────┐
               │     DimDate      │
               └────────┬─────────┘
┌──────────┐            │            ┌────────────────────┐
│  SALES   ├────────────┼────────────┤  DimSalesTerritory │
└──────────┘            │            └────────────────────┘
               ┌────────┴─────────┐
               │    DimProduct    │
               └──────────────────┘
