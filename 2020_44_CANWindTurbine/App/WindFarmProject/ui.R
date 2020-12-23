#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(shinyWidgets)
library(tidyverse)
library(plotly)

WF_Map <- read.csv("CAN_WindFarm.csv")
manuChoices <- WF_Map %>% group_by(manufacturer) %>% summarize(n = n()) %>% arrange(desc(n)) %>% mutate(item = paste(manufacturer," (", n, ")", sep="")) %>% select(c("manufacturer", "item"))
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    setBackgroundColor(
        color = c("#DBE4E3", "#FFFFFF"),
        gradient = c("linear"),
        direction = c("bottom"),
        shinydashboard = FALSE
    ),
    

    
    # Title
    #titlePanel("Wind Turbine Manufacturer Explorer"),
    div("Wind Turbine Manufacturers For Canadian Wind Farm Projects", style = "font-size: 22px;font-weight: bold;font-family:verdana,arial;color:#000000"),
    
    # NArrow row at top for inputs
    fluidRow(
        column(width = 12,align="center",
               
               tags$table(style = "width: 100%",
                tags$tr(tags$td(style = "width: 50%", align = "right",
                    div("Select Manufacturer: ", style = "font-size: 14px;font-weight: bold;font-family:verdana,arial;color:#595254")),
                tags$td(selectInput("manu", "", choices = manuChoices$manufacturer,selected = 4)))),
        ),
        
    ),

    # Large row at the bottom for charts
    fluidRow(
        column(width = 6, align="center",

               div("Turbine locations", style = "font-size: 14px;font-weight: bold;font-family:verdana,arial;color:#1E75B4"),
               leafletOutput("WFMap")
             
        ),
        column(width = 6, align="center",
               
               div("Turbine Capacity by Rotor Size & Hub Height", style = "font-size: 14px;font-weight: bold;font-family:verdana,arial;color:#1E75B4"),
               plotlyOutput("scatter")
               
        )
           
    ),
    
    fluidRow(
        column(width = 6, align="center",
               br(),br(),
               div("Turbine Model & Year Commissioned", style = "font-size: 14px;font-weight: bold;font-family:verdana,arial;color:#1E75B4"),
               plotlyOutput("model")
               
               
        ),
        column(width = 6, align="center",
               br(),br(),
               div("Manufacturer's Top Projects by Turbine Count", style = "font-size: 14px;font-weight: bold;font-family:verdana,arial;color:#1E75B4"),
               plotlyOutput("bar")
               
        )
        
    ),
    fluidRow(
        column(width = 12,align="left",
            br(),  
            br(),  
            br(),   
            div("About: This is a ShinyApp to showcase data visualizations for Tidy Tuesday.", style = "font-size: 14px;font-weight: normal;font-family:verdana,arial;color:#595254"),
            tags$a(href="http://github.com/rfordatascience/tidytuesday", "TidyTuesday Github"),
            br(),
            tags$a(href="https://twitter.com/hashtag/TidyTuesday", "TidyTuesday Twitter"),
            br(),
            br(),
            div("Source: ", style = "font-size: 14px;font-weight: normal;font-family:verdana,arial;color:#595254"),
            tags$a(href="https://open.canada.ca/data/en/dataset/79fdad93-9025-49ad-ba16-c26d718cc070", "Government of Canada"),
            br(),
            br(),
            div("Created By: Mike Wehinger", style = "font-size: 14px;font-weight: normal;font-family:verdana,arial;color:#595254"),
            tags$a(href="http://github.com/mikeShout", "Mike's Github"),
            br(),
            tags$a(href="http://www.myshout.io", "Mike's Website")
        ),
        
    )
))
