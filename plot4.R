
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
# to produce the files that we want with base R pltting

# device is png file 480 * 480 pixels
png(filename = "plot4.png", width = 480, height = 480)

# 4 plots to be added to a 2 * 2 grid with upper margin
par(mfrow = c(2,2))

# first sub plot is line plot of power against datetime
plot(testdf$datntime, testdf$Global_active_power, type = "l",
     xlab='', ylab='Global Active Power')

# second sub-plot is datetime against voltage
testdf$Voltage <- as.numeric(testdf$Voltage)
plot(testdf$datntime, testdf$Voltage, type = "l",
     xlab='datetime', ylab='Voltage')

# third sub-plot is the sub metering all on one graph
testdf$Sub_metering_1 <- as.numeric(testdf$Sub_metering_1)
testdf$Sub_metering_2 <- as.numeric(testdf$Sub_metering_2)

plot(testdf$datntime, testdf$Sub_metering_1, type ="l", 
     ylab = 'Energy sub metering', xlab = '')
lines(testdf$datntime,testdf$Sub_metering_2, type = "l", col = "red")
lines(testdf$datntime, testdf$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty= 1, col = c("black","red", "blue"),
       legend = c("Sub Metering 1", "Sub Metering 2","Sub Metering 3"),
       bty = "n")

# fourth sub-plot is global reactive power against datetime
testdf$Global_reactive_power <- as.numeric(testdf$Global_reactive_power)
plot(testdf$datntime, testdf$Global_reactive_power, type = "l",
     xlab='datetime', ylab='Global_reactive_power')

# not forgetting to turn the png device off
dev.off()