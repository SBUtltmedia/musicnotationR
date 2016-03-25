
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
    players <- input$playerGroup
    behaviors <- input$behaviorGroup
    df1 <- newdf %>% filter(Time >= mintime & Time <= maxtime & behavior %in% behaviors)
    if (input$graphtype == 1) {
      if (input$winloser == 1) {
        df1 <- df1[((df1$winner %in% players) == T),]
      }
      else if (input$winloser == 2) {
        df1 <- df1[((df1$winner %in% players) == T | (df1$loser %in% players) == T),]
      }
      else {
        df1 <- df1[((df1$loser %in% players) == T),]
      }
    }
    else {
      if (input$winloser == 1) {
        df1 <- df1[(df1$winner %in% players ==T) & (df1$loser %in% players ==T),]    
        df1 <- df1[((df1$winner %in% players) == T),]
      }
      else if (input$winloser == 2) {
        df1 <- df1[(df1$winner %in% players ==T) & (df1$loser %in% players ==T),]    
        df1 <- df1[((df1$winner %in% players) == T | (df1$loser %in% players) == T),]
      }
      else {
        df1 <- df1[(df1$winner %in% players ==T) & (df1$loser %in% players ==T),]    
      }
      df1 <- df1[((df1$loser %in% players) == T),]
    }    
  })
  
  max_time <- nrow(newdf)
  
  output$distPlot <- renderPlot(musicnot(df1(), gridcolor=T, gridlinesize = 0.5, labels="name", colors=c("firebrick1", "dodgerblue", "seagreen", "darkgoldenrod1"), behav="yes"))
  output$timeper <- renderUI({
    sliderInput("timeper", label = h3("Time Period"), 1, max_time, value = c(1,max_time), step=max_time / 100, ticks=T)
  })

  playerChoices <- sort(unique(c(newdf$winner, newdf$loser)))
  behevaiorChoices <- sort(unique(newdf$behavior))
  
  output$playerGroup <- renderUI({
    checkboxGroupInput("playerGroup", label = h3("Players to Include"), 
         choices = playerChoices,
         selected = playerChoices,
         inline = T)
  })
  
  output$behaviorGroup <- renderUI({
    checkboxGroupInput("behaviorGroup", label = h3("Behaviors to Include"), 
                       choices = behevaiorChoices,
                       selected = behevaiorChoices,
                       inline = T)
  })
})
