using Plots
using DataFrames
using CSV
using Dates

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
df.YMD = string.(df.Year, "/", lpad.(df." Month",2,"0"), "/", lpad.(df." Day",2, "0"))
df.MD = string.(lpad.(df." Month",2,"0"), "/", lpad.(df." Day",2, "0"))

df.datetime = DateTime.(df.YMD, dateformat"yyyy/mm/dd")
#index north and south datasets
gdf_northsouth = groupby(df, :hemisphere)

df_north = gdf_northsouth[(hemisphere="north",)]
df_south = gdf_northsouth[(hemisphere="south",)]

#Convert datetime to days of the year, allow for correct plotting
day_of_year_north = Dates.dayofyear(df_north.datetime)

gdf_north = groupby(df_north, :Year)
gdf_south = groupby(df_south, :Year)


nm = names(gdf_north)

p = plot() 
#Plot each year's data as a line
for df_north_year in gdf_north
    plot!(df_north_year.MD, df_north_year[!, nm[4]], label="")
end

xlabel!("Day of Year")
ylabel!("Extent (10^6 km^2")
title!("Sea Ice Extent in Northern Hemisphere")

display(p)

# Create a DateTime object
#dt = DateTime(2023, 7, 17)

# Get the day of the year
day_of_year_north = Dates.dayofyear(df_north.datetime)


println(day_of_year)  # Output: 198

# north_index = df[1:13177, :]
# south_index = df[13178:26354, :]

# #clean up columns a bit
# select!(north_index, Not([:" Source Data"]))
# select!(south_index, Not([:" Source Data"]))

# #Make first time series plot of YMD vs Extent in north and south
# #Extent units: 10^6 km^2
# x = north_index."YMD"
# y = north_index."     Extent"
# plot(x, y)

# x = south_index."YMD"
# y = south_index."     Extent"
# plot(x, y)



