
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
  output$distPlot <- renderPlot(musicnot(df1(), gridcolor=T, gridlinesize = 0.5, labels="name", colors=c("firebrick1", "dodgerblue", "seagreen", "darkgoldenrod1"), behav="yes"))
})
