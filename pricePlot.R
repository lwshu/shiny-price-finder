pricePlot<-function(str_dt,end_dt,div_no,item_no,store_no){
  
  
  library(data.table)
  mydf <- fread("query_result.csv", header = T, sep = ',')
  mydf<-as.data.frame(mydf)
  cols<-c(1:4,7:10)
  mydf<-mydf[,cols]
  mydf<-mydf[with(mydf,order(store_id,div_no,item_no,load_dt)),]
  mydf<-within(mydf, div_item<- paste(div_no, item_no, sep="_"))
  
  str_dt<-as.Date(str_dt,"%Y-%m-%d")
  end_dt<-as.Date(end_dt,"%Y-%m-%d")
  div_item<-paste(toString(div_no),toString(item_no),sep="_")
  
  
  library(reshape)
  dat<-mydf[,c(1,9,8,5)]
  dat<-data.frame(dat$store_id,dat$div_item,as.Date(dat$load_dt,"%m/%d/%Y"),dat$promo_prc)
  colnames(dat) <- c("store_id","div_item", "load_dt","promo_prc")
  dat<-dat[dat$store_id %in% store_no & dat$div_item %in% div_item,]
  dat<-dat[with(dat,order(store_id,load_dt)),c(1,3,4)]
  result<-cast(dat, load_dt ~ store_id,mean)
  
  
  output<-result[result$load_dt>=str_dt & result$load_dt<=end_dt,]
  output[,1] <- as.character(output[,1])
  

  library(ggplot2)
  output <- melt(output ,  id.vars = 'date', variable.name = 'store_id')
  colnames(output) <- c("load_date","price","store_id")
  p<-  ggplot(output,aes(x=load_date,y=price,label=price,group = 1))+
    geom_line()+geom_point(shape = 1)+
    facet_grid(store_id ~ .,scales = "free")+geom_text(hjust=0,vjust=1)
  print(p)
}
