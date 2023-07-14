using Plots
using DataFrames
using CSV

df = CSV.read("/Users/jsadler/Desktop/JacksCodingProjects/SeaIce/seaice.csv", DataFrame)

#find all column names
#note that dataset uses north and southern hemispheres
#Column names: "Year"
# " Month"
# " Day"
# "     Extent"
# "    Missing"
# " Source Data"
# "hemisphere"
# "YMD"
show(df, allcols=true)

#Concatenate Year, Month and Day columns into a new column Y/M/D.
df.YMD = string.(df.Year, "/", df." Month", "/", df." Day")

#index north and south datasets
north_index = df[1:13177, :]
south_index = df[13178:26354, :]

#clean up columns a bit
select!(north_index, Not([:" Source Data"]))
select!(south_index, Not([:" Source Data"]))

#Make first time series plot of YMD vs Extent in north and south
#Extent units: 10^6 km^2
x = north_index."YMD"
y = north_index."     Extent"
plot(x, y)

x = south_index."YMD"
y = south_index."     Extent"
plot(x, y)


