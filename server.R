
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source('R/musicnot.R')

shinyServer(function(input, output) {
  flies <- read.csv("data-raw/flies.csv", stringsAsFactors=F)
  output$distPlot <- renderPlot(musicnot(flies, gridcolor=T, gridlinesize = 0.5, labels="name", colors=c("firebrick1", "dodgerblue", "seagreen", "darkgoldenrod1"), behav="yes"))

})
