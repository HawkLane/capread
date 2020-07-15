

# Before running the script you will have to install a few packages
# install.packages("ggplot2")
# install.packages("anytime")
# install.packages("mongolite")

library(mongolite)

# These are the inputs we can change
off <- function(starttime)
{
	parts <- strsplit(starttime,":")
	partarr <- unlist(parts)
	minutes <- partarr[2]
	firstch <- substring(minutes,1,1)
	if (firstch=="0")
	{
		minutes<-substring(minutes,2,2)
	}
	minutes <- strtoi(minutes)
	return (minutes %% 5)
}

adjuststart <- function(starttime)
{
	parts <- strsplit(starttime,":")
	partarr <- unlist(parts)
	minutes <- partarr[2]
	firstch <- substring(minutes,1,1)
	if (firstch=="0")
	{
		minutes<-substring(minutes,2,2)
	}
	newmins <- strtoi(minutes)
	if ((newmins > 0) & ((newmins%%5)>0))
	{
	newmins <- newmins - 5
	if (newmins<0)
	{
		hourparts<-strsplit(partarr[1],"T")
		hourarr<-unlist(hourparts)
		hour<-hourarr[2]
		print("adjusting")
		print(starttime)
		print(hour)
		firstch<-substring(hour,1,1)
		if (firstch=="0")
		{
			hour=substring(hour,2,2)
		}
		hourint=strtoi(hour)
		hourint=hourint-1
		print(hour)
		print(hourint)
		if (hourint<10)
		{
			newh=paste("0",toString(newhour),sep="")
		}
		else
		{
			newh=toString(hourint)
			newhour=paste(hourarr[1],"T",newh,sep="")
		}
		newmins<-60+newmins
	}
	else
	{
		newhour=partarr[1]
	}
	newmst <- toString(newmins)
	if (newmins < 10)
	{
		newmst <- paste("0",newmst,sep="")
	}
	newtime <- paste(newhour,":",newmst,":",partarr[3],sep="")
	return (newtime)
	}
	else
	{
		return (starttime)
	}
}

calcend <- function(starttime,runmins)
{
	parts <- strsplit(starttime,":")
	partarr <- unlist(parts)
	minutes <- partarr[2]
	firstch <- substring(minutes,1,1)
	if (firstch=="0")
	{
		minutes<-substring(minutes,2,2)
	}
	newmins <- strtoi(minutes)
	newmins <- newmins + runmins
	if (newmins>=60)
	{
		hour<-partarr[1]
		print(hour)
		firstch<-substring(hour,1,1)
		if (firstch=="0")
		{
			hour=substring(hour,2,2)
		}
		hourint=strtoi(hour)
		hourint=hourint+1
		if (hourint<10)
		{
			newhour=paste("0",toString(hourint),sep="")
			print(newhour)
		}
		else
		{
			newhour=toString(hourint)
		}
		newmins<-newmins-60
	}
	else
	{
		newhour=partarr[1]
	}
	newmst <- toString(newmins)
	if (newmins < 10)
	{
		newmst <- paste("0",newmst,sep="")
	}
	newtime <- paste(newhour,":",newmst,sep="")
	return (newtime)	
}

#loggers<-matrix(c("SumaCare_901997","SumaCare_AC1DA5","SumaCare_90279C","SumaCare_901997","SumaCare_AC1DA5","SumaCare_90279F"),nrow=2,ncol=3,byrow=TRUE)
print(loggers)
lcols<-c(2,2,2,2,2,2,2,2,2,2,2,2)

loggers1<-c("SumaCare_4163D7","SumaCare_416532","SumaCare_47B842","SumaCare_415517","SumaCare_608994")
loggers2<-c("SumaCare_4163D7","SumaCare_416532","SumaCare_41DEC6","SumaCare_415517","SumaCare_608994")
st<-c("10:30","10:35","11:00","11:05")
#,"08:50","08:55","09:25","09:30","11:30","11:35","12:05","12:16","12:30","12:36","12:45","12:50","13:05","13:15","13:25","13:31","13:40","13:45","13:55","14:00")
nmins<-c(5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5)
#etimes<-c("12:43","12:48","13:00","13:05","13:18","13:26","13:35","13:40","13:51","14:17","14:37","14:58")
volumes<-c("0","400","0","400")
#volumes<-c("0","400","0","400","0","400","0","400","0","400","0","400")
nruns<-length(st)
Collections <- c(
#"DeviceStatusLogs",
"CapacitanceMeasurements",
"AccelerometerMeasurements",
"")
prefixes <- c(
#"D",
"C",
"A",
"")


dbServer <- "sandbox-germany" # Options for dbServer: "phase1", "sandbox", "prod"
db <- "wac_labtests" # This is the "Care Home Id" seen on the "Manage Care Home" or Login screen

########################################

if(dbServer == "phase1") {
  URL <- "mongodb://wear-and-care-dev-db:PXacAYVu5VWG32aBKFYb3TyznYI6o1TEJQGz3rsqsN3Gfl5haRg6yiKIqVlj0FAAfm5lt9eOlkqT090LY8JuGg==@wear-and-care-dev-db.documents.azure.com:10255/?ssl=true&replicaSet=globaldb&appName=@wear-and-care-dev-db@"
  db="wacv1"
} else if (dbServer == "sandbox") {
  URL <- "mongodb://wear-and-care-v2-db:SXVAtXGOBHMdT8io7a9WrcULh2XLCYQf5ih17NRFIN7T5IHsErHq7YfxvGKHYtRWWi1TxmbwKqKHdk3pi7M00A==@wear-and-care-v2-db.documents.azure.com:10255/?ssl=true&replicaSet=globaldb&appName=@wear-and-care-v2-db@"
} else if (dbServer == "prod") {
  URL <- "mongodb://wear-and-care-prod-db:y1xw9xS26Jn2QxYdI86p8TCEXPd3iKXEw1NUtgsrBCIolNfHJwxB97Pg9C7nprtV5oz1HQv8H3K0UqJyreNxeA==@wear-and-care-prod-db.documents.azure.com:10255/?ssl=true&replicaSet=globaldb&appName=@wear-and-care-prod-db@"
} else if (dbServer == "sandbox-germany") {
  URL <- "mongodb://r-script-exporter:rVdQUoQrjeSqJFZpklEtbaLR7TZFwnJcaxKEhdgCiWNSlaga9FRGwT2Jrh1vHFMoD4eGv2aRG1Q5dmQk@cs30328.dogadoserver.de:27017,cs30328.dogadoserver.de:27018,cs30328.dogadoserver.de:27019/?ssl=true&readPreference=primary&replicaSet=myReplicaSet&authSource=admin"
}


setupSequences <- function(sequenceNumbers, lengths) 
  as.vector(unlist(mapply(
    function(seqNum, len)
      seqNum:(seqNum+len-1),
    sequenceNumbers,
    lengths)))

setupDatetimes <- function(datetimes, lengths, by)
  as.vector(unlist(mapply(
    function(date, len) 
      rep(date, len) + seq(from = 0, length.out = len, by = by),
    datetimes,
    lengths)))

setupCharging <- function(chargingReadings, lengths) 
  as.vector(unlist(mapply(
    function(charge, len) 
      rep(charge,len),
    chargingReadings,
    lengths)))

setupAccellerometer <- function(accs)
  unlist(accs)

setupCapacitance <- function(caps)
  unlist(caps)

setupVoltage <- function(volts)
  unlist(volts)

toSigned8bit <- function(x) if(x > 127) x - 256 else x

setupAccPoints <- function(mask, shift)
  function (acc)
    sapply(bitwAnd(bitwShiftR(acc, shift), mask), toSigned8bit)

setupX <- setupAccPoints(0xFF, 24)
setupY <- setupAccPoints(0xFF, 16)
setupZ <- setupAccPoints(0xFF, 8)

handleCapacitanceMeasurements <- function(data) {
  lens <- sapply(data$Values, length)
  seqs <- setupSequences(data$Seq, lens)
  dates <- setupDatetimes(data$Datetime, lens, 1/10)
  caps <- setupCapacitance(data$Values)
  if(Plot) {
    require(ggplot2)
    library(anytime)
    datetime = anytime(dates)
    data = data.frame(datetime, caps)
    print(ggplot(aes(x = datetime, y = caps), data = data) + geom_line())
  }
  return (cbind(seqs, dates, caps))
}

handleAccelerometerMeasurements <- function(data) {
  lens <- sapply(data$Values, length)
  seqs <- setupSequences(data$Seq, lens)
  dates <- setupDatetimes(data$Datetime, lens, 1/10)
  acc <- setupAccellerometer(data$Values)
  x <- setupX(acc)
  y <- setupY(acc)
  z <- setupZ(acc)
  if(Plot) {
    require(ggplot2)
    library(anytime)
    datetime = anytime(dates)
    data = data.frame(datetime,x,y,z)
    
    print(ggplot(data=data) +
            geom_line(data=data,aes(x = datetime,y=x), colour = 'red', show.legend = TRUE) +
            geom_line(data=data,aes(x = datetime,y=y), colour = 'green', show.legend = TRUE) +
            geom_line(data=data,aes(x = datetime,y=z), colour = 'blue', show.legend = TRUE) +
            xlab('datetime') +
            ylab('acc') + theme(legend.position = 'top'))
  }
  return (cbind(seqs, dates, x, y, z))
}

handleDeviceStatusLogs <- function(data) {
  lens <- sapply(data$Voltage, length)
  seqs <- setupSequences(data$Seq, lens)
  dates <- setupDatetimes(data$Datetime, lens, 100)
  milliVolts <- setupVoltage(data$Voltage)
  charging <- setupCharging(data$Charging, lens)
  inCharger <- setupCharging(data$InCharger, lens)	
  temperature <- setupCharging(data$Temperature, lens)
  charge <- setupCharging(data$Charge, lens)
  if(Plot) {
    require(ggplot2)
    library(anytime)
    datetime = anytime(dates)
    data = data.frame(datetime,milliVolts)
    print(ggplot(aes(x = datetime, y = milliVolts), data = data) + geom_line())
  }
  return (cbind(seqs, dates, milliVolts, charging, inCharger, temperature, charge))
}



Plot <- FALSE
WriteCsv <- TRUE
samplefreq <- 10
nloggers<-length(loggers1)
nruns<-length(st)
for (round in 1:nruns)
{
vol <- volumes[round]
lrow<-lcols[round]
RealStartTime <- paste("2019-08-16T",st[round],":00Z",sep="")
StartTime <- adjuststart(RealStartTime)
omstart <- off(StartTime)
offsetstart <- samplefreq*omstart*60
starttime<-st[round]
etime<-calcend(starttime,nmins[round])
print(round)
EndTime <- paste("2019-08-16T",etime,":00Z",sep="")
omend <- off(EndTime)
offsetend <- samplefreq*omend*60

for (lindex in 1:nloggers)
{
if (round%%2==1)
{
DeviceId<-loggers1[lindex]
}
else
{
DeviceId<-loggers2[lindex]
}
for(collectionName in Collections) {
  if(collectionName == "") next
  collection <- mongo(collection=collectionName, db=db, url = URL, options = ssl_options(weak_cert_validation = TRUE))
  query <-paste('{"DeviceId":"',DeviceId,'", "Datetime":{"$gt":{"$date":"',StartTime,'"},"$lt":{"$date":"',EndTime,'"}}}',sep="")
  data <- collection$find(query)
  
  if(length(data) == 0) {
    print("No data")
    next
  }
  func <- switch(collectionName, 
                "CapacitanceMeasurements" = handleCapacitanceMeasurements,
                "AccelerometerMeasurements" = handleAccelerometerMeasurements,
                "DeviceStatusLogs" = handleDeviceStatusLogs)
  res <- func(data)
  nrows <- NROW(res)
  print(paste("initial",nrows))
  if (offsetstart>0)
  {	
  	res0<-tail(res,-offsetstart)
  }
  else
  {
	res0<-res
  }
 if (offsetend>0)
  {	
  	res1<-tail(res,-offsetend)
  }
  else
  {
	res1<-res0
  }
  nrows <- NROW(res1)
  print(paste("final",nrows))
 # res<-(res[offsetstart+1:nrows-offsetend,])
  if(WriteCsv) {
   prefix<-substr(collectionName,1,1)
   filename<-paste("816",vol,round,lindex,prefix,".csv",sep="")
   write.csv(res1, file = filename)
  }
 }
}
}

