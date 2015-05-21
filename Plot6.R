## Exploratory Data Analysis
## Course Project 2
## https://class.coursera.org/exdata-014/human_grading/view/courses/973508/assessments/4/submissions
## Date: 2015-05-19

library(dplyr)
library(ggplot2)

## Preparation - acquire the data set over Internet
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipfile <- "data/NEI_data.zip"
if(!file.exists("data")) {
  dir.create("data")
}
if(!file.exists(zipfile)) {
  download.file(url, destfile=zipfile, method="curl")
}

pm25_file <- "data/summarySCC_PM25.rds"
scc_file <- "data/Source_Classification_Code.rds"
if(!file.exists(pm25_file) | !file.exists(scc_file)) {
  unzip(zipfile, exdir="data")
}

PM25 <- readRDS(pm25_file)
SCC  <- readRDS(scc_file)

## Question 6 -- Compare Baltimore City and Los Angeles PM2.5 Emissions
##               From motor vehicle sources
# Compute  PM2.5 emission in Baltimore City & Los Angeles
PM25_BCLA <- PM25[(PM25$fips == "24510"| PM25$fips == "06037"), ]
PM25_BCLA$County <- ifelse(PM25_BCLA$fips=="24510", "Baltimore", "Los Angeles")
scc_vehicle <- SCC[grep("vehicle", SCC$EI.Sector, ignore.case=T),]
pm25_vehicle <- merge(scc_vehicle, PM25_BCLA, by="SCC")

# Group by and Summarise
pm25_groups <- group_by(pm25_vehicle, County, year)
summarised <- summarise(pm25_groups, Emissions=sum(Emissions))

# Group summarised data to find the first value of each group
sum_groups <- group_by(summarised, County)
ref_groups <- summarise(summarised, RefEmission=first(Emissions))

# Compute the emission change ratio, relative to the value in 1999.
m <- merge(summarised, ref_groups, by="County")
m$Ratio <- m$Emissions/m$RefEmission

# Plotting
p <- qplot(year, Ratio, data=m, color=County, geom=c("line","point"),
           xlab="Year",ylab="Emission Change Rate", 
           main="Baltimore vs Los Angeles Vehicle PM2.5 Emission Changes")
print(p)
png("plot6.png")
print(p)
dev.off()

