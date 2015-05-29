# This is the server logic for a Shiny web application.
library(shiny)
library(PerformanceAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(ROI.plugin.glpk)
library(mpo)
library(zoo)

shinyServer(function(input, output){
  
  output$ef<-renderPlot({
    returns = midcap.ts[, 1:input$number]
    fund<-colnames(returns)
    
    # construct different types of portfolios
    pspec.lo = portfolio.spec(assets=fund)
    pspec.lo = add.constraint(pspec.lo, type="full_investment")
    pspec.lo = add.constraint(pspec.lo, type="long_only")
    pspec.box = add.constraint(pspec.lo, type="box",min=input$range[1],max=input$range[2])
    pspec.box = add.objective(pspec.box, type="risk",name="var")
    
    if((input$lo==TRUE) && (input$box==TRUE)){
      pspec.list=combine.portfolios(list(pspec.lo,pspec.box))
      chart.EfficientFrontierOverlay(returns,pspec.list,type="mean-StdDev",
                                   match.col="StdDev",xlim=c(0,0.2),lty=c(1,2),
                                   legend.loc="topleft",legend.labels=c("Long-only","Box"),
                                   chart.assets=input$efo3,labels.assets=input$efo1)
                                   
      
      
    }
  
    if((input$lo==FALSE) && (input$box==TRUE)){
      pspec.list=combine.portfolios(list(pspec.box))
      chart.EfficientFrontierOverlay(returns,pspec.list,type="mean-StdDev",
                                     match.col="StdDev",xlim=c(0,0.2),lty=c(1,2),
                                     legend.loc="topleft",legend.labels=c("Box"),
                                     chart.assets=input$efo3,labels.assets=input$efo1)
                                     
    }
  
    if((input$lo==TRUE) && (input$box==FALSE)){
      pspec.list=combine.portfolios(list(pspec.lo))
      chart.EfficientFrontierOverlay(returns,pspec.list,type="mean-StdDev",
                                     match.col="StdDev",xlim=c(0,0.2),lty=c(1,2),
                                     legend.loc="topleft",legend.labels=c("Long-only"),
                                     chart.assets=input$efo3,labels.assets=input$efo1)
                                     
                                     
    }
    
  })
  
  output$wp<-renderPlot({
    returns<- midcap.ts[,1:input$number]
    fund<-colnames(returns)
    
    # construct different types of portfolios
    pspec.lo = portfolio.spec(assets=fund)
    pspec.lo = add.constraint(pspec.lo, type="full_investment")
    pspec.lo = add.constraint(pspec.lo, type="long_only")
    pspec.box = add.constraint(pspec.lo, type="box",min=input$range[1],max=input$range[2])
    pspec.box = add.objective(pspec.box, type="risk",name="var")
    
    if((input$lo==TRUE) && (input$box==TRUE)){
      efront.lo=create.EfficientFrontier(returns,pspec.lo,type="mean-StdDev",
                                         n.portfolios=30)
      efront.box=create.EfficientFrontier(returns,pspec.box,type="mean-StdDev",
                                         n.portfolios=30)
      par(mfrow=c(2,1))
      chart.EF.Weights(efront.lo,match.col="StdDev",colorset=topo.colors(10))
      chart.EF.Weights(efront.box,match.col="StdDev",colorset=topo.colors(10))
    }
    
    if((input$lo==FALSE) && (input$box==TRUE)){
      efront.box=create.EfficientFrontier(returns,pspec.box,type="mean-StdDev",
                                          n.portfolios=30)
      chart.EF.Weights(efront.box,match.col="StdDev",colorset=topo.colors(10))
    }
    
    if((input$lo==TRUE) && (input$box==FALSE)){
      efront.lo=create.EfficientFrontier(returns,pspec.lo,type="mean-StdDev",
                                         n.portfolios=30)
      chart.EF.Weights(efront.lo,match.col="StdDev",colorset=topo.colors(10))
    }
  })
  
  output$rp<-renderPlot({
    returns<- midcap.ts[,1:input$number]
    plot.zoo(returns)
    
  })
  
  output$tg<-renderPlot({
    returns = midcap.ts[, 1:input$number]
    fund<-colnames(returns)
    
    # construct different types of portfolios
    pspec.lo = portfolio.spec(assets=fund)
    pspec.lo = add.constraint(pspec.lo, type="full_investment")
    pspec.lo = add.constraint(pspec.lo, type="long_only")
    pspec.lo=add.objective(pspec.lo,type="risk",name="var")
    efront.lo=create.EfficientFrontier(returns,pspec.lo,type="mean-StdDev",
                                       n.portfolios=30)
    chart.EfficientFrontier(efront.lo,match.col="StdDev",type="l",cex=.6,
                            rf=input$rf,tangent.line=input$efo2)
  })
  })

