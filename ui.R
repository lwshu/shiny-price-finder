library(shiny)
shinyUI(fluidPage(
  
  titlePanel("promo_prc plot&table"),
  
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        radioButtons("radio", label = h5("Compare between different stores or different items"),
                     choices = list("Store" = 1, "Item" = 2),selected = 1,inline = TRUE)
      ),
      helpText("Please select Store ID, Division Number, Item Number and time range."),
      fluidRow(
        column(4, 
               selectizeInput("store_no",label = h5("Store ID"),choices=list(1333,3976,1594,2888,2432),multiple = TRUE)),
                 
        column(4, 
               selectInput("div_no", label = h5("Division Number"), 
                           choices = list("2"=2,"3"=3,"4"=4,"6"=6,"7"=7,"8"=8,"9"=9,"12"=12,"14"=14,"16"=16,"17"=17,"18"=18,"19"=19,"20"=20,"22"=22,"24"=24,"25"=25,"26"=26,"28"=28,"29"=29,"31"=31,"32"=32,"33"=33,"34"=34,"36"=36,"37"=37,"38"=38,"39"=39,"40"=40,"41"=41,"42"=42,"43"=43,"44"=44,"45"=45,"46"=46,"48"=48,"49"=49,"52"=52,"53"=53,"54"=54,"57"=57,"67"=67,"71"=71,"74"=74,"75"=75,"76"=76,"77"=77,"82"=82,"86"=86,"88"=88,"96"=96
                           ), selected = 26)) ,
        column(4, 
               numericInput("item_no", 
                            label = h5("Item Number"), 
                            value = 88732)) 
      ),
      fluidRow(
        column(10,
               dateRangeInput("daterange", "Date range:",
                              start  = "2015-12-01",
                              end    = "2015-12-31",
                              min    = "2015-12-01",
                              max    = "2016-01-31",
                              format = "yyyy-mm-dd",
                              separator = " to ")),
        downloadButton('downloadData', 'Download Table')
      )

    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
        tabPanel("Price Table",dataTableOutput("disTable")
                               ),
        tabPanel("Price Plot",  plotOutput("disPlot"))
      
    )
  )
)))