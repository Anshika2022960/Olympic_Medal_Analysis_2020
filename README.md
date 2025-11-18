# Olympic Medal and Participation Analysis 2020 using Snowflake and Power BI

## Overview
This project analyzes Olympic medal and participation data (Tokyo 2020) using Snowflake for data warehousing and Power BI for visualization.

The goal is to practice a full data pipeline:
**data ingestion → data warehouse → data modeling → BI dashboard → insights**. 
## Data Flow
1.Raw CSV files are uploaded to a Snowflake stage.
2.Data is copied into tables in the RAW schema.
3.SQL cleaning scripts create normalized tables in the ANALYTICS schema.
4.Power BI connects to Snowflake and uses the analytical views.
5.Measures and visuals are created to explore performance and participation.

## Dashboard Features

The main Power BI dashboard includes:
1.KPI cards showing total gold, silver, bronze, and overall medals
2.Pie chart of top 10 countries by total medals
3.Bar chart of athlete counts by NOC
4.Stacked bar chart of female vs male participation by discipline
5.World map of medal distribution by country
6.Line chart showing event-wise gold medal distribution
7.Slicers for NOC, discipline, medal type, and gender

## Tools Used
- **Snowflake** – Data modeling and cleaning
- **Power BI** – Dashboard and visualization
- **SQL** – Data queries

 ## Key Insights

Some sample insights discovered:

The United States leads the medal table with the highest total medals.
Athletics is the most medal-rich discipline across multiple countries.
Female participation is close to parity with male participation in several sports.
Host nations such as Japan show a strong overall performance.
  
## Project Dashboard
![Dashboard Preview](https://github.com/Anshika2022960/Olympic_Medal_Analysis_2020/blob/main/dashboard_preview.png)


[Monalisa Mohapatra] | Euron Internship | 2025
