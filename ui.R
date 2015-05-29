
# This is the user-interface definition of a Shiny web application.
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Portfolio Optimization Analysis"),

  sidebarLayout(
    sidebarPanel(img(src = "cfrm-logo.png", height = 60, width = 270),
                 
                 br(),
                 
                 selectInput("number",
                             label="Number of assets to generate efficient frontier",
                             choices=c("6","5","4","3","2"),
                             selected="6"), 
                 
                 numericInput("rf",label="Risk free rate",0,min=0,
                              max=1,step=0.001),
                 p("Warning: if ", span("risk free rate",style="color:blue"), " is too large, tangent line might not exist"),
                 
                 br(),
                 
                 strong("Efficient Frontier Optoins"),
                 
                 checkboxInput("efo1",label="Assets Names",value=TRUE),
                 
                 checkboxInput("efo3",label="Chart Assets",value=TRUE),
                 
                 checkboxInput("efo2",label="Tangent Line",value=TRUE),
                 
                 br(),
                 
                 strong("Constraints Options:"),
                 
                 checkboxInput("lo",label="Long-only",value=TRUE),
                 
                 checkboxInput("box",label="Box",value=FALSE),
                 
                 sliderInput("range",label="Box Constraint:",min=-1,max=1,value=c(-0.5,0.7),step=0.01),
                 
                 p("Note: this project use ", span("MinVar optimization method", style="color:blue"),
                   " to conduct portfolio analysis")
                             
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Eficient Frontier", plotOutput("ef"),br(),br(),strong("Key Functions:"),
                 code("portfolio.spec"),code("add.constraint"),code("add.objective"),
                 code("chart.EfficientFrontierOverlay")), 
        tabPanel("Weight Plot", plotOutput("wp")), 
        tabPanel("Tangent Line & SR for Long-only",plotOutput("tg")),
        tabPanel("Returns Plot", plotOutput("rp"))
      )
    )
  )
))
