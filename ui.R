#single script to start app

#load req libraries
library(shiny)
library(lme4)
library(lmerTest)
library(tidyverse)
library(DT)
library(shinythemes)
library(shinyjs)
library(sortable)

#load appFunctions
source("appFunctions.R")

#load appSections
source("appSections.R")

#load server
source("server.R")

## UI
shinyUI(navbarPage(title = "blobRig",
                   theme = shinytheme("cerulean"),
                   footer = includeHTML("footer.html"),
                   fluid = TRUE, 
                   collapsible = TRUE,
                   useShinyjs(),
                   # position = c("fixed-top"),
                   
                   # ---------------------------------- home
                   tabPanel("Home",
                            includeHTML("home.html"),
                   ),
                   
                   # ---------------------------------- Gel
                   tabPanel("Gel Creator",
                   ),
                   
                   # ---------------------------------- analyze
                   tabPanel("Analyze",
                            analyzer(),
                   ),
                   
                   # ---------------------------------- about
                   tabPanel("About",
                            includeHTML("about.html")
                   )
                   
))
