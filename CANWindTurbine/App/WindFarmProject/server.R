#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(tidyverse)
library(plotly)

WF_Map <- read.csv("CAN_WindFarm.csv")

# Fix year data
WF_Map <- WF_Map %>% mutate(year = case_when(
        str_detect(commissioning_date, "[/....]") ~ str_sub(commissioning_date, -4), TRUE ~ commissioning_date))


#ProjChoices <- WF_Map %>% group_by(project_name) %>% summarize(n = n()) %>% arrange(desc(n)) %>% mutate(item = paste(project_name," (", n, ")", sep="")) %>% select(c("project_name", "item"))
#manuChoices <- WF_Map %>% group_by(manufacturer) %>% summarize(n = n()) %>% arrange(desc(n)) %>% mutate(item = paste(manufacturer," (", n, ")", sep="")) %>% select(c("manufacturer", "item")) 

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    
    output$WFMap <- renderLeaflet({
        #man <- strsplit(as.character(input$manu), "[ (]")[[1]][1]
        WF_Map[WF_Map$manufacturer == input$manu,] %>% leaflet() %>% addTiles() %>% addCircles()    
    })

    output$scatter <- renderPlotly({

        WF_Map[WF_Map$manufacturer == input$manu,] %>% 
            plot_ly( x = ~rotor_diameter_m, y = ~hub_height_m, text = ~manufacturer, type = 'scatter', mode = 'markers', marker = list(size = ~turbine_rated_capacity_k_w*.02, opacity = 0.2,color = 'rgb(80, 208, 255)'))%>% 
            layout(plot_bgcolor='transparent',paper_bgcolor='transparent', font = list(family = "verdana"), xaxis = list(showgrid = FALSE, title = "Rotor Diameter (m)"), yaxis = list(showgrid = FALSE, title = "Hub Height (m)"))
    })
    
    output$bar <- renderPlotly({

        WF_Map[WF_Map$manufacturer == input$manu,] %>% group_by(project_name) %>% summarize(n = n()) %>% arrange(desc(n)) %>% slice_head(n=10) %>% 
            plot_ly(x = ~n, y = ~reorder(project_name, n), type = 'bar', orientation = 'h')# %>% 
            #layout(plot_bgcolor='transparent',paper_bgcolor='transparent',annotations = list(x = ~n, y=~reorder(project_name, n), text=~n, xanchor="left", yanchor="center", showarrow=FALSE), font = list(family = "verdana"), yaxis=list(title = ""), xaxis=list(showline = FALSE, showticklabels = FALSE, showgrid = FALSE,title = "", domain=list(.25,1)))
    })
    
    output$model <- renderPlotly({

        WF_Map[WF_Map$manufacturer == input$manu,] %>% group_by(year, model) %>% summarize(n = n()) %>% arrange(desc(n)) %>% 
            plot_ly(x = ~year, y = ~n, type = 'bar', color=~model)%>% 
            layout(plot_bgcolor='transparent',paper_bgcolor='transparent',font = list(family = "verdana"), xaxis = list(title = 'Year'), yaxis = list(title = 'Turbine Count'), barmode = 'stack')
    })
})
