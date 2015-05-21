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

## Question 3  -- Baltimore City PM2.5 Emissions by Source Types 

# Compute  PM2.5 emission in Baltimore City
PM25_BC <- PM25[PM25$fips == "24510", ]
# Group by and Summarise
pm25_groups <- group_by(PM25_BC, type, year)
summarised <- summarise(pm25_groups, Emissions=sum(Emissions))
summarised$type <- as.factor(summarised$type)

# Plotting
p <- qplot(year, Emissions, data=summarised, color=type, geom=c("line","point"),
           xlab="Year",ylab="Total Emissions", main="Baltimore City PM2.5 Changes By Type")
print(p)
png("plot3.png")
print(p)
dev.off()

