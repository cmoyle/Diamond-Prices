# Cameron Moyle

# Predict Zion National Park Annual Visitors

# DATA:

# Title,Bookmark
# Zion NP,Bookmark this report: 
# https://irma.nps.gov/Stats/SSRSReports/Park%20Specific%20Reports/Annual%20Park%20Recreation%
# 20Visitation%20(1904%20-%20Last%20Calendar%20Year)
# Accessed Mon 8 Jan 2018

# Create Data Frame

zion <- read.csv(header = TRUE, text = '
Year,RecreationVisitors,TotalRecreationVisitors
1919,"1,814","111,311,078"
1920,"3,692","111,311,078"
1921,"2,937","111,311,078"
1922,"4,109","111,311,078"
1923,"6,408","111,311,078"
1924,"8,400","111,311,078"
1925,"16,817","111,311,078"
1926,"21,964","111,311,078"
1927,"24,303","111,311,078"
1928,"30,016","111,311,078"
1929,"33,383","111,311,078"
1930,"55,297","111,311,078"
1931,"59,186","111,311,078"
1932,"51,650","111,311,078"
1933,"48,763","111,311,078"
1934,"68,801","111,311,078"
1935,"97,280","111,311,078"
1936,"124,393","111,311,078"
1937,"137,404","111,311,078"
1938,"149,075","111,311,078"
1939,"158,063","111,311,078"
1940,"165,029","111,311,078"
1941,"192,805","111,311,078"
1942,"68,797","111,311,078"
1943,"44,089","111,311,078"
1944,"42,243","111,311,078"
1945,"78,280","111,311,078"
1946,"212,280","111,311,078"
1947,"273,953","111,311,078"
1948,"297,571","111,311,078"
1949,"307,881","111,311,078"
1950,"323,402","111,311,078"
1951,"331,079","111,311,078"
1952,"352,921","111,311,078"
1953,"389,445","111,311,078"
1954,"416,800","111,311,078"
1955,"406,800","111,311,078"
1956,"421,200","111,311,078"
1957,"525,100","111,311,078"
1958,"590,700","111,311,078"
1959,"585,000","111,311,078"
1960,"575,800","111,311,078"
1961,"604,700","111,311,078"
1962,"622,100","111,311,078"
1963,"681,100","111,311,078"
1964,"705,200","111,311,078"
1965,"763,600","111,311,078"
1966,"815,200","111,311,078"
1967,"788,400","111,311,078"
1968,"877,100","111,311,078"
1969,"904,300","111,311,078"
1970,"903,600","111,311,078"
1971,"897,000","111,311,078"
1972,"889,417","111,311,078"
1973,"993,800","111,311,078"
1974,"859,300","111,311,078"
1975,"1,055,200","111,311,078"
1976,"1,090,000","111,311,078"
1977,"1,105,900","111,311,078"
1978,"1,193,212","111,311,078"
1979,"1,040,528","111,311,078"
1980,"1,123,846","111,311,078"
1981,"1,288,808","111,311,078"
1982,"1,246,290","111,311,078"
1983,"1,273,030","111,311,078"
1984,"1,377,254","111,311,078"
1985,"1,503,272","111,311,078"
1986,"1,670,503","111,311,078"
1987,"1,777,619","111,311,078"
1988,"1,948,332","111,311,078"
1989,"1,998,856","111,311,078"
1990,"2,102,400","111,311,078"
1991,"2,236,997","111,311,078"
1992,"2,390,626","111,311,078"
1993,"2,392,580","111,311,078"
1994,"2,270,871","111,311,078"
1995,"2,430,162","111,311,078"
1996,"2,498,001","111,311,078"
1997,"2,445,534","111,311,078"
1998,"2,370,048","111,311,078"
1999,"2,449,664","111,311,078"
2000,"2,432,348","111,311,078"
2001,"2,217,779","111,311,078"
2002,"2,592,545","111,311,078"
2003,"2,458,792","111,311,078"
2004,"2,677,342","111,311,078"
2005,"2,586,665","111,311,078"
2006,"2,567,350","111,311,078"
2007,"2,657,281","111,311,078"
2008,"2,690,154","111,311,078"
2009,"2,735,402","111,311,078"
2010,"2,665,972","111,311,078"
2011,"2,825,505","111,311,078"
2012,"2,973,607","111,311,078"
2013,"2,807,387","111,311,078"
2014,"3,189,696","111,311,078"
2015,"3,648,846","111,311,078"
2016,"4,295,127","111,311,078"
')
tail(zion)

# remove the commas from within the numbers
zion$RecreationVisitors <- as.numeric(gsub(',','',zion$RecreationVisitors))
# Change visitors to millions
zion[,2] = zion[,2] / 10^6
# EDA
plot(RecreationVisitors ~ Year, data = zion, type = 'b', ylab = "Zion NP Annual Visitors (millions)")

# Analysis

# observed curvature in the time series, so we are applying a log-transformation
zion$lnVisitors <- log(zion[,2])
  
# Apply Filter to recent past to exclude data anamoly during WW2
zion1950 <- subset(zion,Year>1950)
plot(lnVisitors ~ Year, data = zion1950, type = 'b', ylab = "Log Zion NP Annual Visitors (millions)")

# Model: ARIMA(1,1,1) 

# Fit the Model
library(astsa)

zion1950.out <- sarima(zion1950$lnVisitors,1,1,1)
zion1950.out$ttable

#Compute predictions for the next five years 
zion1950.future <- sarima.for(zion1950$lnVisitors, n.ahead = 5, 1,1,1)
zion1950.future

# Compute 95% Prediction Intervals
L <- zion1950.future$pred - qnorm(0.975) * zion1950.future$se
U <- zion1950.future$pred + qnorm(0.975) * zion1950.future$se

cbind(zion1950.future$pred,L,U)

# Untransform
cbind(exp(zion1950.future$pred),exp(L),exp(U))

# Create a publication quality graphic 
# sarima.for does a good job, but the data is still
# in the Log-Transformation and we can do better

plot(RecreationVisitors~Year,data=zion,type="b",
     ylab="Zion NP Annual Visitors (in millions)",
     xlim=c(1990,2021),ylim=c(1,6.7))
lines(2017:2021,exp(zion1950.future$pred),col="darkorange2",type="b",pch=19)
lines(2017:2021,exp(L),col="darkorange2",lty=2)
lines(2017:2021,exp(U),col="darkorange2",lty=2)

# Research Task: Predict Future Values
# Data Features: Time Series, Correlation observed in past is expected to continue next 5 years

# Analysis Weaknesses: No explanatory variables, or analysis of why this trend is occuring

# Challenge 
#   Use ARIMA model to predict SuperBowl attendees for the next 5 years
#   Data located at https://www.statista.com/statistics/216526/super-bowl-us-tv-viewership/

#   Another research task would be predicting the known crimes in Chicago for the next 5 years 
#   Data located at https://catalog.data.gov/dataset/crimes-2001-to-present-398a4

