package_list <- list(
  'ggplot2',
  'forecast',
  'bsts',
  'prophet',
  'repr',
  'lubridate',
  'magrittr',
  'multipanelfigure'
)
req_inst <- function(package_name) {
  if(!require(package_name, character.only = TRUE)) {
    install.packages(package_name, repos='https://cran.revolutionanalytics.com')   
  }
}

sapply(package_list, req_inst)


theme_set(theme_bw())


#params
holdoutMth <- 6

#common column names
dataset$OrderDateMonth <- as.Date(dataset$OrderDateMonth)
colnames(dataset) <- c("ds", "y")
min_date <- min(dataset$ds)
max_date <- max(dataset$ds)
t <- ts(dataset$y, frequency=12, start=c(year(min_date),month(min_date)))

split_date_start <- max_date - months(holdoutMth)
split_date_end <- split_date_start + days(1)
t.train <- window(t, end = c(year(split_date_start), month(split_date_start)))
t.test <- window(t, start = c(year(split_date_end), month(split_date_end)), end = c(year(max_date), month(max_date)))

#eda - time series decomposition
#t_stl <- stl(t, s.window = "periodic", robust = TRUE)
#plot(t_stl)





#forecasting


#arima
forecast_stl_arima <- stlf(t.train, method="arima")
#Plot the results
options(repr.plot.width=8, repr.plot.height=4)
p1 <- autoplot(t.train , ylab = "Total", series = "Train") + labs(title = "STL + ARIMA") + scale_x_yearmon() + autolayer(t.test, series="Test") +
  autolayer(ts(forecast_stl_arima$mean,frequency=12, start=c(year(split_date_end), month(split_date_end))), series="Prediction")


#bsts
trend_seasonal <- AddSemilocalLinearTrend(list(),t.train)
trend_seasonal <- AddSeasonal(trend_seasonal,t.train, nseasons = 12)
model_bsts <- bsts(t.train,state.specification = trend_seasonal, niter = 1000)

forecast_bsts <- predict.bsts(model_bsts, horizon = 24)
options(repr.plot.width=8, repr.plot.height=4)
p2 <- autoplot(t.train , ylab = "Total", series = "Train") + labs(title = "BSTS") + scale_x_yearmon() + autolayer(t.test, series="Test") +
  autolayer(ts(forecast_bsts$mean,frequency=12, start=c(year(split_date_end), month(split_date_end))), series="Prediction")


#prophet
FBTrain <- data.frame(ds = as.Date(as.yearmon(time(t.train))), y=as.matrix(t.train))
m <- prophet(FBTrain,yearly.seasonality=TRUE)
future <- make_future_dataframe(m, periods = 24, freq = 'month')
forecast <- predict(m, future)

ProphetForecast <- ts(forecast$yhat,frequency=12, start=c(year(min_date),month(min_date)))
ProphetForecast <- window(ProphetForecast, start = c(year(split_date_end), month(split_date_end)))
options(repr.plot.width=8, repr.plot.height=4)
p3 <- autoplot(t.train , ylab = "Total", series = "Train") + labs(title = "Prophet") + scale_x_yearmon() + autolayer(t.test, series="Test") +
  autolayer(ProphetForecast, series="Prediction")



mp <- multi_panel_figure(columns = 1, rows = 3, panel_label_type = "none")
# show the layout

mp %<>%
  fill_panel(p1, column = 1, row = 1) %<>%
  fill_panel(p2, column = 1, row = 2) %<>%
  fill_panel(p3, column = 1, row = 3)
mp