# Seafood-Export-Market-Analysis
This project analyzes New Zealand aquaculture export data (FY23–25) to support strategic business decisions for Sanford. It includes a Power BI report and SQL ETL scripts to answer key business questions on market growth, product profitability, and pricing strategy.

# Methodology: ETL and Data Model
# 1. Data Consolidation and Cleaning
   Source: Three separate CSV files, one for each fiscal year (FY23, FY24, FY25), were used, containing Species, Product, Country, Volume (kg), and Value (NZD).

   ETL Tool: A SQL script (SQLQuery_1.sql) was used for the ETL process to ensure data consistency and quality.

# 2. ETL Steps (SQLQuery_1.sql)
   The SQL script performed the following critical steps to prepare the data for the analytical model:

   Staging: Data was loaded into an exports_staging table.

   Quality: Null Year values were imputed/corrected (UPDATE exports_staging SET Year = 202X WHERE YEAR IS NULL;).

   String Cleanup: Extraneous quotation marks were removed from text fields (Product, Country) to prevent model issues.

   Final Table & Pre-Calculation: Data was loaded into the final exports table, where the essential profitability metric, Price_per_kg, was calculated directly (Value / Volume) to enhance model performance.

# 3. Power BI Data Model
   The final report uses a simplified model with a single consolidated exports fact table.

# Power BI & Key DAX Measures
   The insights are driven by three primary DAX measures, ensuring accurate calculations across all filters (Country, Species, Product).

# Measure	DAX Function	Purpose
   Total Export Value	SUM('exports'[Value])	The foundational measure for total revenue.
   Avg Price per kg	DIVIDE([Total Export Value], SUM('exports'[Volume]), BLANK())	The key Pricing/Profitability metric.
   YoY Export Value Growth %	Time intelligence for Growth relative to a non-date Year column.	

# Export to Sheets
DAX for Year-over-Year Growth
The following robust DAX was implemented to correctly calculate YoY growth using the discrete Year column (FY23, FY24, FY25) instead of standard calendar functions:

# Key Business Insights
The following insights address the core business questions and were derived from the final Power BI report visualizations (e.g., scatter plots of Price vs. Growth, and detailed matrix tables).

# 1. Right Market: Which countries offer best growth/pricing?

The ideal market is categorized as one showing both high Avg Price per kg and high YoY Export Value Growth %.

    
# 2. Right Product: Which species/products are most profitable?

Profitability is defined by the highest Avg Price per kg across all segments.

   
# 3. Right Price: What's the optimal pricing strategy by market?

The optimal strategy dictates where to sell high-value products and where to focus on volume/efficiency.

     
# Repository Structure
├── Power_BI_Assessment_1.pbix # Final Power BI Report File

├── SQLQuery_1.sql             
└── README.md                  
