library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
      
    dataInput <- reactive({
      source("priceTable.R")
      st_n=input$store_no
      d_n=input$div_no
      i_n=input$item_no
      str_dt<-as.character(input$daterange)[1]
      end_dt<-as.character(input$daterange)[2]
      priceTable(str_dt,end_dt,d_n,i_n,st_n)
      
    })
  
  
    output$disPlot <- renderPlot({   
       table<-dataInput()
       output<-table$p
       output <- melt(output ,  id.vars = 'date', variable.name = 'store_id')
       colnames(output) <- c("load_date","price","store_id")
       p<-  ggplot(data=output,aes(x=load_date,y=price,label=price,group=1))+
         geom_line()+geom_point(shape = 1)+
         facet_grid(store_id ~ .,scales = "free")+geom_text(hjust=0,vjust=-1,size=4,angle = 25)
       print(p)
      
    }, height=700)
      
    output$disTable <- renderDataTable({  
      result<-dataInput()
      col_no=ncol(result$p)
      output=data.frame(load_dt=result$p$load_dt)
      for (i in 2:col_no){
        output[paste(colnames(result$p)[i],"price",sep=".")]<-result$p[,i]
        output[paste(colnames(result$s)[i],"source",sep=".")]<-result$s[,i]
      }
      output
      })
    
    output$downloadData <- downloadHandler(
      filename = function() {'price table.csv'},
      content = function(file) {
        result<-dataInput()
        col_no=ncol(result$p)
        output=data.frame(load_dt=result$p$load_dt)
        for (i in 2:col_no){
          output[paste(colnames(result$p)[i],"price",sep=".")]<-result$p[,i]
          output[paste(colnames(result$s)[i],"source",sep=".")]<-result$s[,i]
        }
        write.csv(output, file)
      })
})