setwd("C:/Users/lshu0/Documents/shiny")
source("priceTable.R")
str_dt<-"2015-12-09"
end_dt<-"2015-12-26"
div_no<-26
item_no<-88732
store_no<-c(1333,3976,1594,2888,2432)

df<-priceTable(str_dt,end_dt,div_no,item_no,store_no)

runApp("C:/Users/lshu0/Documents/shiny")
xxx<-printPrice(str_dt,end_dt,div_no,store_no)


