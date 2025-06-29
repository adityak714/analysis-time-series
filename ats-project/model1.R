#########################
library(stats)
library(forecast)
library(tseries)
library(here)

data = read.csv(here('powerconsumption.csv'), header=TRUE)
data$AggPowerConsumption = data$PowerConsumption_Zone1 + data$PowerConsumption_Zone2 + data$PowerConsumption_Zone3
x = ts(log(data$AggPowerConsumption[40000:44380]))

par(mfrow=c(3,1)) # Making the display of 2 plots
plot(x)

lag = 1
slag = 144 # seasonality of roughly 1440 minutes, roughly equal to a day.
dx = diff(x, lag=lag)

#########################

par(mfrow=c(2,2)) # Making the display of 2 plots
acf(x, lag.max = 30) # ACF
pacf(x, lag.max = 30) # PACF

#########################

par(mfrow=c(2,2)) # Making the display of 2 plots
acf(dx, lag.max = 30) # ACF
pacf(dx, lag.max = 30) # PACF

#########################

start.time <- Sys.time()
fit1 <- arima(x,order=c(0,0,0), seasonal=list(order=c(2,1,0),period=144))
fit2 <- arima(x,order=c(1,1,0), seasonal=list(order=c(0,0,0),period=144))
fit3 <- arima(x,order=c(3,1,0), seasonal=list(order=c(0,1,1),period=144))
# Seasonal AR cannot be combined with non-seasonal AR (model fails to train)
end.time <- Sys.time()

summary(fit1)
summary(fit2)
summary(fit3)
res1 <- residuals(fit1)
res2 <- residuals(fit2)

par(mfrow=c(2,2)) # Making the display of 2 plots
qqnorm(res1)
qqline(res1, col='red')
qqnorm(res2)
qqline(res2, col='red')
tsdiag(fit2, gof.lag = 30)
pacf(res2)
tsdiag(fit3, gof.lag = 30)
pacf(res2)
time.taken <- round(end.time - start.time,2)
time.taken

forecasted <- forecast(fit3, h=288)

par(mfrow=c(2,1))
x_test <- ts(log(data$AggPowerConsumption[40000:44668]))
plot(
    x_test, 
    type="l", col="black", lty=1, 
    xlim=c(0, length(x) + length(forecasted$mean)), 
    ylab="Log Power Consumption", 
    xlab="Time", 
    main="Original and Forecasted Time Series"
)
lines(
    (length(x) + 1):(length(x) + length(forecasted$mean)), 
    forecasted$mean, 
    col="blue", 
    lty=2
)
plot(forecasted)