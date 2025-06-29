#########################
library(stats)
library(forecast)
library(here)

# here('powerconsumption.csv')
data = read.csv(here('powerconsumption.csv'), header=TRUE)
data$AggPowerConsumption = data$PowerConsumption_Zone1 + data$PowerConsumption_Zone2 + data$PowerConsumption_Zone3
x = data$AggPowerConsumption[40000:44380]

# Chosen data points train: 40000-50000 (remaining 2415 for testing)
lag = 12
slag = 144 # seasonality of roughly 1440 minutes, roughly equal to a day.
dx = diff(x, lag=lag)

par(mfrow=c(1,1)) # Making the display of 2 plots
plot(x, type='l')
title(main = "Power Consumption Z1+Z2+Z3")