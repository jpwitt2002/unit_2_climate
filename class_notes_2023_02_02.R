# JPW 2023-02-02
library("lubridate")
# lets finish loops 
# while loops :)

x=1
while(x>0){
  x=x+1
}
# infinite loop no no 

x=4
while(x>0){
  x=x-1
  print(x)
}


# fishing game 

total_catch_lb = 0
n_fish = 0
while(total_catch_lb < 50){
  n_fish = n_fish+1
  new_fish_weight = rnorm(n=1, mean=2, sd=1)
  total_catch_lb = total_catch_lb + new_fish_weight
}

n_fish
total_catch_lb



# arctic sea ice
# spoiler alert it's melting

url = 'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/N_seaice_extent_daily_v3.0.csv'
arctic_ice = read.delim(url, skip=2, sep=",", header=FALSE, 
                        col.names = c("Year", "Month", "Day", "Extent", 
                                      "Missing", "Source_Data"))
head(arctic_ice)
# date not decimal, that's bad
# lubridate to the rescue!

arctic_ice$date = make_date(year=arctic_ice$Year,
                            month=arctic_ice$Month, 
                            day=arctic_ice$Day)
head(arctic_ice)

plot(Extent~date, data=arctic_ice, type="l", 
     ylab="Arctic sea ice extent (x10^6 km^2")

# Creating annual average

tail(arctic_ice)

arctic_ice_averages = data.frame(Year=seq(min(arctic_ice$Year)+1, max(arctic_ice$Year)-1), 
                                 extent_annual_avg = NA, 
                                 extent_5yr_avg = NA)
#mean(arctic_ice$Extent[arctic_ice$Year==1979])
dim(arctic_ice_averages)[1]

for(i in seq(dim(arctic_ice_averages)[1])){
  arctic_ice_averages$extent_annual_avg[i] = mean(arctic_ice$Extent[arctic_ice$Year == arctic_ice_averages$Year[i]])
}

head(arctic_ice_averages)
plot(extent_annual_avg~Year, data = arctic_ice_averages, type="l")

# that graph wasnt good enough
# 5 yr average ice extent
dim(arctic_ice_averages)[1]-2

for(i in seq(from=3, to=dim(arctic_ice_averages)[1]-2)){
  years = seq(from=arctic_ice_averages$Year[i]-2, to=arctic_ice_averages$Year[i]+2)
  arctic_ice_averages$extent_5yr_avg[i] = mean(arctic_ice$Extent[arctic_ice$Year %in% years])
}


arctic_ice_averages$date = make_date(year=arctic_ice_averages$Year, month = 7, day=1)

plot(Extent~date, data=arctic_ice, type="l", 
     ylab="Arctic sea ice extent (x10^6 km^2") +
lines(extent_annual_avg~date, data = arctic_ice_averages, type="l", col="blue") + 
  lines(x=arctic_ice_averages$date, y=arctic_ice_averages$extent_5yr_avg, col="red")


