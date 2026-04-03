# Mini-projekt: DK1 electricity prices and load (2025)

# Research questions:
# How do electricity change over the year?
# Are there clear intraday price patterns? 
# How do load and prices vary across months? 

# Data on electricity prices and load for DK1 in 2025 is downloaded from ENTSO-E.
# Load is reported in hourly intervals, while prices are given in 15-minute intervals.
# The data is cleaned and aligned in order to compare the two series and identify market patterns.

# ---- Read data ----
load_2025 <- read.csv(file.choose())
price_2025 <- read.csv(file.choose())

# ---- Clean timestamps ----
load_2025$Time <- substr(load_2025$MTU..CET.CEST.,1,16)
load_2025$Time <- as.POSIXct(load_2025$Time,format="%d/%m/%Y %H:%M")

price_2025$Time <- substr(price_2025$MTU..CET.CEST.,1,16)                             
price_2025$Time <- as.POSIXct(price_2025$Time, format="%d/%m/%Y %H:%M")

# ---- Align both datasets to hourly observations ----
# This is achieved by calculating the average price of each hour by aggregating observations
price_2025$Hour <- format(price_2025$Time, "%Y-%m-%d %H")
load_2025$Hour <- format(load_2025$Time,"%Y-%m-%d %H")

avg_price_hourly <- aggregate(price_2025$Day.ahead.Price..EUR.MWh.,
                              by = list(price_2025$Hour),
                              FUN = mean)
colnames(avg_price_hourly) <- c("Hour","Price")

# ---- Merge load and prices by hour ----
data <- merge(load_2025,avg_price_hourly,by="Hour")

data$Load <- as.numeric(data$Actual.Total.Load..MW.)
data$Forecast <- data$Day.ahead.Total.Load.Forecast..MW.
data$Month <- format(data$Time, "%m")
data$HourOfDay <- as.numeric(format(data$Time, "%H"))

# ---- Daily average prices ----
avg_price_hourly$Date <- as.Date(avg_price_hourly$Hour)

avg_price_daily <- aggregate(avg_price_hourly$Price,
                             by = list(avg_price_hourly$Date),
                             FUN = mean)

colnames(avg_price_daily) <- c("Date","Price")

plot(avg_price_daily$Date,avg_price_daily$Price,
     type = "l",
     main = "Average prices throughout 2025 in DK1",
     xlab = "Month",
     ylab = "Price (EUR/MWh)")

# ---- Monthly average prices ----
avg_price_monthly <- aggregate(data$Price,
                               by = list(data$Month),
                               FUN = mean)

colnames(avg_price_monthly) <- c("Month", "AvgPrice")

barplot(avg_price_monthly$AvgPrice,
        main = "Average monthly prices in DK1 2025",
        xlab = "Month",
        ylab = "EUR/MWh",
        names.arg = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))

# ---- Intraday average price patterns ----
data$HourOfDay <- as.numeric(format(data$Time,"%H"))

hourly_price_pattern <- aggregate(data$Price,
                                      by = list(data$HourOfDay),
                                      FUN = mean)

colnames(hourly_price_pattern) <- c("HourOfDay","AvgPrice")

plot(hourly_price_pattern$HourOfDay,hourly_price_pattern$AvgPrice,
     type = "l",
     main = "Average price by hour of day",
     xlab = "Hour of day",
     ylab = "Price (EUR/MWh)")

# ---- Monthly average load ---- 
avg_load_monthly <- aggregate(data$Load,
                              by = list(data$Month),
                              FUN = function(x)mean(x,na.rm = TRUE))

colnames(avg_load_monthly) <- c("Month","AvgLoad")

barplot(avg_load_monthly$AvgLoad,
        main = "Average monthly load in DK1 2025",
        xlab = "Month",
        ylab = "MW",
        names.arg = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))














#----- Additional exploratory plots -----
data$HourOfDay <- factor(data$HourOfDay,levels = 0:23)

boxplot(data$Price ~ data$HourOfDay,
        main = "Distribution of electricity prices by hour of day",
        xlab = "Hour of day",
        ylab = "Price (EUR/MWh)",
        ylim = c(-30,350))

plot(data$Time,data$Price,
     type = "l",
     xlab = "Time",
     ylab = "Price (EUR/MWh)",
     main = "Electricy prices in DK1 2025")

png("avg_price_daily.png", width=800, height=500)

plot(avg_price_daily$Date,avg_price_daily$Price,
     type = "l",
     main = "Average prices throughout 2025 in DK1",
     xlab = "Month",
     ylab = "Price (EUR/MWh)")

dev.off()

png("avg_price_monthly.png", width=800, height=500)

barplot(avg_price_monthly$AvgPrice,
        main = "Average monthly prices in DK1 2025",
        xlab = "Month",
        ylab = "EUR/MWh",
        names.arg = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))

dev.off()

png("hourly_price_pattern.png", width=800, height=500)

plot(hourly_price_pattern$HourOfDay,hourly_price_pattern$AvgPrice,
     type = "l",
     main = "Average price by hour of day",
     xlab = "Hour of day",
     ylab = "Price (EUR/MWh)")

dev.off()

png("avg_load_monthly.png", width=800, height=500)

barplot(avg_load_monthly$AvgLoad,
        main = "Average monthly load in DK1 2025",
        xlab = "Month",
        ylab = "MW",
        names.arg = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))

dev.off()
