data = read.table("~/uni/analysis-time-series/carsmon.dat", header=TRUE)
x = log(data$count) # logarithm operation

plot(data$count, type='l')
title(main = "Number of registered private cars in Sweden")
plot(x, type='l')
title(main = "Number of registered private cars in Sweden (log)")

par(mfrow=c(1,2)) # Making the display of 2 plots

acf(x, lag.max = 50) # ACF
pacf(x, lag.max = 50) # PACF cuts off after lag 1