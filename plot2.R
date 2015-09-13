
library(dplyr)
library(lubridate)
# load the data into testdf (assumes its in the working directory and uncompressed)
testdf <- read.table("household_power_consumption.txt",sep = ";", header = TRUE,
                     stringsAsFactors = FALSE)

# create new column combining date and time
testdf <- mutate(testdf, datntime = paste(testdf$Date, testdf$Time))
# convert that to a true date time
testdf$datntime <-strptime(testdf$datntime, format = "%d/%m/%Y %H:%M:%S")
# convert again to POSIXct
testdf$datntime <- as.POSIXct(testdf$datntime)
# convert Date colmn to Date format
testdf$Date <- as.Date(testdf$Date, '%d/%m/%Y')
# filter the frame down to the two dates we want
testdf <- testdf %>% filter(Date >= "2007-02-01") %>% filter(Date < "2007-02-03")
# convert the Global_active_power to numeric for plotting
testdf$Global_active_power <- as.numeric(testdf$Global_active_power)

# noww we have got hte data that we want will have to create the R files
# to produce the files that we want with base R plotting

# device is png file 480 * 480 pixels
png(filename = "plot2.png", width = 480, height = 480)
# second plot is line plot of power against datetime
plot(testdf$datntime, testdf$Global_active_power, type = "l",
     xlab='', ylab='Global Active Power (kilowatts)')

# not forgetting to turn the png device off
dev.off()