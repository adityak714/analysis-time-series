#########################
library(stats)
library(here)

data = read.table(here('carsmon.dat'), header=TRUE)
x = log(data$count) # logarithm operation

plot(data$count, type='l')
title(main = "Number of registered private cars in Sweden")
plot(x, type='l')
title(main = "Number of registered private cars in Sweden (log)")

par(mfrow=c(1,2)) # Making the display of 2 plots
acf(x, lag.max = 50) # ACF
pacf(x, lag.max = 50) # PACF

## DIFFERENCING
lag = 1

dx = diff(x, lag=lag)
plot(dx, type='l')
title(main = paste("Number of registered private cars in Sweden diff =", lag, sep=" "))

par(mfrow=c(1,2)) # Making the display of 2 plots

acf(dx, lag.max = 20)
pacf(dx, lag.max = 20)

## SARIMA MODEL EXPLORATION

aic_vals <- c()

for(p in 0:4){
  for(q in 0:4){
    for(P in 0:4){
      for(Q in 0:4){
        tryCatch({
          smodel=arima(x,order=c(p,1,q), 
           seasonal=list(order=c(P,1,Q),period=12)
           ) # varying p,q,P,Q
          
          acf(smodel$residuals, lag.max = 40) # ACF
          pacf(smodel$residuals, lag.max = 40) # PACF
          
          tsdiag(smodel, gof.lag = 40)
          
          aic<-AIC(arima(x,order=c(p,1,q),seasonal=list(order=c(P,1,Q),period=12)))
          title(paste(p, q, P, Q, sep=","))
          aic_vals[paste(p, q, P, Q, sep=",")]<-aic
        }, error = function(e) {
          # Handle the error
          cat("An error occurred:", conditionMessage(e), "\n")
        }, finally = {
          cat("This block is always executed.\n")
        })
      }
    }
  }
}

# get the output (key-value output, where key=the configuration of the SARIMA, value=AIC)
aic_vals 

#########################
smodel=arima(x,order=c(3,1,3), 
         seasonal=list(order=c(0,1,1),period=12)
         )

acf(smodel$residuals, lag.max = 40) # ACF
pacf(smodel$residuals, lag.max = 40) # PACF

# Histogram
hist(smodel$residuals)
qqnorm(smodel$residuals)

tsdiag(smodel, gof.lag = 40) 

## FORECAST
library(forecast)
fc = forecast(smodel, h=40)
autoplot(fc)
