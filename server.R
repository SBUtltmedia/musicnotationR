
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source('R/musicnot.R')

shinyServer(function(input, output) {
  newdf <- read.csv("data-raw/reformat.csv", stringsAsFactors=F)
  df1 <- reactive({
    mintime <- input$timeper[1]
    maxtime <- input$timeper[2]
    df1 <- newdf %>% filter(Time >= mintime & Time <= maxtime)
    ranks <- input$checkGroup
    if (input$graphtype == 1) {
      if (input$winloser == 1) {
        df1 <- df1[((df1$winner %in% ranks) == T),]
      }
      else if (input$winloser == 2) {
        df1 <- df1[((df1$winner %in% ranks) == T | (df1$loser %in% ranks) == T),]
      }
      else {
        df1 <- df1[((df1$loser %in% ranks) == T),]
      }
    }
    else {
      if (input$winloser == 1) {
        df1 <- df1[(df1$winner %in% ranks ==T) & (df1$loser %in% ranks ==T),]    
        df1 <- df1[((df1$winner %in% ranks) == T),]
      }
      else if (input$winloser == 2) {
        df1 <- df1[(df1$winner %in% ranks ==T) & (df1$loser %in% ranks ==T),]    
        df1 <- df1[((df1$winner %in% ranks) == T | (df1$loser %in% ranks) == T),]
      }
      else {
        df1 <- df1[(df1$winner %in% ranks ==T) & (df1$loser %in% ranks ==T),]    
      }
      df1 <- df1[((df1$loser %in% ranks) == T),]
    }    
  })
  
  max_time <- nrow(newdf)
  
  output$distPlot <- renderPlot(musicnot(df1(), gridcolor=T, gridlinesize = 0.5, labels="name", colors=c("firebrick1", "dodgerblue", "seagreen", "darkgoldenrod1"), behav="yes"))
  output$timeper <- renderUI({
    sliderInput("timeper", label = h3("Time Period"), 1, max_time, value = c(1,max_time), step=max_time / 100, ticks=T)
  })

  output$checkGroup <- renderUI({
    checkboxGroupInput("checkGroup", label = h3("Ranks to Include"), 
         choices = sort(unique(c(newdf$winner, newdf$loser))),
         selected = c(1),
         inline = T)
  })
})
