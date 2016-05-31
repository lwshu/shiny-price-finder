priceTable<-function(str_dt,end_dt,div_no,item_no,store_no){
  
  
  library(data.table)
  mydf <- fread("query_result.csv", header = T, sep = ',')
  mydf<-as.data.frame(mydf)
  cols<-c(1:4,7:10)
  mydf<-mydf[,cols]
  #mydf<-mydf[with(mydf,order(store_id,div_no,item_no,load_dt)),]
  mydf<-within(mydf, div_item<- paste(div_no, item_no, sep="_"))
  
  str_dt<-as.Date(str_dt,"%Y-%m-%d")
  end_dt<-as.Date(end_dt,"%Y-%m-%d")
  div_item<-paste(toString(div_no),toString(item_no),sep="_")
  
  
  library(reshape)
  dat<-mydf[,c(1,9,8,5,7)]
  #dat<-data.frame(dat$store_id,dat$div_item,as.Date(dat$load_dt,"%m/%d/%Y"),dat$promo_prc,dat$price_source)
  colnames(dat) <- c("store_id","div_item", "load_dt","promo_prc","price_src")
  dat<-dat[dat$store_id %in% store_no & dat$div_item %in% div_item,]
  price_tbl<-dat[,c(1,3,4)]#with(dat,order(store_id,load_dt))
  src_tbl<-dat[,c(1,3,5)]#with(dat,order(store_id,load_dt))
  
  price_tbl$promo_prc<-as.numeric(price_tbl$promo_prc)
  price_tbl<-cast(price_tbl, load_dt ~ store_id,mean)
  
  library(gdata)
  src_tbl$price_src<-factor(src_tbl$price_src)
  map<-mapLevels(x=src_tbl$price_src)
  src_tbl$price_src<-as.integer(src_tbl$price_src)
  src_tbl<-cast(src_tbl, load_dt ~ store_id,max)
  mapLevels(x=src_tbl[,-1]) <- map
  
  price_tbl<-price_tbl[price_tbl$load_dt>=str_dt & price_tbl$load_dt<=end_dt,]
  src_tbl<-src_tbl[src_tbl$load_dt>=str_dt & src_tbl$load_dt<=end_dt,]
  return(list(s=src_tbl,p=price_tbl))
  
}

