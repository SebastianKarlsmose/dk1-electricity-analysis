# DK1 Electricity Prices and Load Analysis for 2025
In this project, I aim to analyze electricity prices and load for the Danish DK1 market for 2025. The goal is to clean and align the data and identify basic intraday and seasonal patterns in the electricity market. 
I am very excited to work further on this project by implementing regression models, which is the main topic in the second half of the statistics course on the 2nd semester in Economics at Aarhus University.

# --- Objective ---
- Clean and align price data to align with load data prior to analysis
- Examine how electricity prices change over the year 
- Identify intraday price patterns
- Compare seasonal variation in prices and load

# --- Data ---
- Source: ENTSO-E Transparency Platform
- Time period: January–December 2025
- Prices: 15-minute intervals
- Load: Hourly data

# --- Method ---
- Aggregated 15-minute prices into hourly averages
- Merged price and load datasets
- Computed daily and monthly averages
- Visualized trends using simple plots in R

# --- What the data showed ---
- Prices are higher in winter than in summer
- Clear intraday pattern with peaks in morning and evening
- Load follows seasonal demand patterns

# --- Plots ---
![Average Daily Prices](avg_price_daily.png)
![Average Monthly Prices](avg_price_monthly.png)
![Average Hourly Prices](hourly_price_pattern.png)
![Average Monthly Load](avg_load_monthly.png)
