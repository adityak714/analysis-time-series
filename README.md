## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax
for authoring HTML, PDF, and MS Word documents. For more details on
using R Markdown see <http://rmarkdown.rstudio.com>.When you click the
**Knit** button a document will be generated that includes both content
as well as the output of any embedded R code chunks within the document.

<hr/>

The number of registered private cars in Sweden for the years 1977 until
February 2025, monthly data, is given in the second column of the file
`carsmon.dat` at Studium.

Find a suitable ARIMA (or SARIMA) model for these data, or a
transformation thereof. Analyze the model residuals carefully, in order
to make sure that the model provides a good description of the data.

It might be a good idea to try transformations, like the logarithm.

    #########################
    data = read.table("~/uni/analysis-time-series/regist-cars-arima/carsmon.dat", header=TRUE)
    x = log(data$count) # logarithm operation

    plot(data$count, type='l')
    title(main = "Number of registered private cars in Sweden")

![](ha-1_files/figure-markdown_strict/unnamed-chunk-1-1.png)

    plot(x, type='l')
    title(main = "Number of registered private cars in Sweden (log)")

![](ha-1_files/figure-markdown_strict/unnamed-chunk-1-2.png)

    par(mfrow=c(1,2)) # Making the display of 2 plots

    acf(x, lag.max = 50) # ACF
    pacf(x, lag.max = 50) # PACF cuts off after lag 1

![](ha-1_files/figure-markdown_strict/unnamed-chunk-1-3.png)

## Differencing

![](ha-1_files/figure-markdown_strict/unnamed-chunk-2-1.png)![](ha-1_files/figure-markdown_strict/unnamed-chunk-2-2.png)

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.

## Additional Seasonal Differencing

    slag = 1

    sdx = diff(dx, lag=slag)
    plot(sdx, type='l')
    title(main = paste("Number of registered private cars in Sweden diff-12, and sdiff =", slag, sep=" "))

![](ha-1_files/figure-markdown_strict/unnamed-chunk-3-1.png)

    par(mfrow=c(1,2)) # Making the display of 2 plots

    acf(sdx, lag.max = 50) # ACF
    pacf(sdx, lag.max = 50) # PACF cuts off after lag 1

![](ha-1_files/figure-markdown_strict/unnamed-chunk-3-2.png)

    #########################
    # Oscillations in ACF, with peak-to-peak difference of around 11-12 timesteps (months)
    # So ARIMA(11,12,0) model
    smodel=arima(dx, 
               order=c(10,0,0), 
               seasonal=list(order=c(0,0,11),period=slag)
               )

    #10 - -5401 aic
    #11 - -5581 aic

    acf(smodel$residuals, lag.max = 50) # ACF

![](ha-1_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    pacf(smodel$residuals, lag.max = 50) # PACF cuts off after lag 1

![](ha-1_files/figure-markdown_strict/unnamed-chunk-4-2.png)

    # Histogram
    # par(mfrow=c(1,3))
    hist(smodel$residuals)

![](ha-1_files/figure-markdown_strict/unnamed-chunk-4-3.png)

    qqnorm(smodel$residuals)

![](ha-1_files/figure-markdown_strict/unnamed-chunk-4-4.png)

    tsdiag(smodel, gof.lag = 50) 

![](ha-1_files/figure-markdown_strict/unnamed-chunk-4-5.png)

    summary(smodel)

    ##           Length Class  Mode     
    ## coef       22    -none- numeric  
    ## sigma2      1    -none- numeric  
    ## var.coef  484    -none- numeric  
    ## mask       22    -none- logical  
    ## loglik      1    -none- numeric  
    ## aic         1    -none- numeric  
    ## arma        7    -none- numeric  
    ## residuals 566    ts     numeric  
    ## call        4    -none- call     
    ## series      1    -none- character
    ## code        1    -none- numeric  
    ## n.cond      1    -none- numeric  
    ## nobs        1    -none- numeric  
    ## model      10    -none- list
