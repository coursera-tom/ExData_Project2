## Exploratory Data Analysis
## Course Project 2
## https://class.coursera.org/exdata-014/human_grading/view/courses/973508/assessments/4/submissions
## Date: 2015-05-19


# Preparation - acquire the data set over Internet
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

## Question 1 --- Total PM2.5 Emissions in U.S.
pm25_split <- split(PM25$Emissions, PM25$year)
pm25_yearly <- sapply(pm25_split, sum)

# plotting
plot(names(pm25_yearly), pm25_yearly, type="b", main="Total U.S. PM2.5 Emissions",
     xlab="Year", ylab="PM2.5 emission (tons)", col="blue")

png("plot1.png")
plot(names(pm25_yearly), pm25_yearly, type="b", main="Total U.S. PM2.5 Emission",
     xlab="Year", ylab="PM2.5 emission (tons)", col="blue")
dev.off()
