library(shiny)
library(ggplot2)
library(grid)
library(dplyr)

shinyUI(fluidPage(
  headerPanel("Time Ordered Network of Social Interactions"),
  plotOutput("distPlot"),
  hr(),
  br(),
  br(),
  
  fluidRow(
    column(5,
           
           uiOutput("checkGroup"),
           
           radioButtons("winloser", "Who to include",
                        choices = list("Winners only" = 1, 
                                       "Winners & Losers" = 2,
                                       "Losers only" = 3), 
                        selected = 2,
                        inline=T),

           radioButtons("graphtype", "Graph Type",
                        choices = list("All individuals" = 1, 
                                       "Only selected (min 2 indivs need to be checked)" = 2), 
                        selected = 1,
                        inline=T)
    ),
    
    column(4,
           uiOutput("timeper")
    ),
    
    column(3,
           radioButtons("linewt", label = h3("Line & Arrow Weight"),
                        choices = list("Heavy" = 1, "Light" = 2), 
                        selected = 1,
                        inline=T),
           
           radioButtons("horizline", label = h3("Grid Line Color"),
                        choices = list("Colors" = 1, "Gray" = 2), 
                        selected = 2,
                        inline=T)
    )
  ),
  
  br(),
  
  wellPanel(
    
    helpText("This music notation plot for visualizing the temporal sequence and directionality of social interaction data is based upon ", 
             a(href ="http://www.frontiersinzoology.com/content/3/1/18", "this 2006 paper by Ivan Chase",target = "_blank")),
    
    helpText(h5("Author: James Curley")),
    
    helpText(p("Please contact",
               a(href ="https://twitter.com/jalapic", "James on twitter",target = "_blank"),
               " or at his",
               a(href ="http://curleylab.psych.columbia.edu/curley.html", "research page", target = "_blank"),
               ", for more information, to suggest improvements or report errors.")),
    
    helpText(p("All code are available at ",
               a(href ="https://github.com/jalapic/shinyapps", "my GitHub page",target = "_blank")
    ))
  ) 
))