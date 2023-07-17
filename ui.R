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

#load gelFunctions
source("./src/gelFunctions.R")

#load appFunctions
source("./src/appFunctions.R")

#load appSections
source("./src/appSections.R")

#load server
source("server.R")

## UI
shinyUI(navbarPage(title = "blobRig",
                   theme = shinytheme("cerulean"),
                   footer = includeHTML("./frontend/footer.html"),
                   fluid = TRUE, 
                   collapsible = TRUE,
                   useShinyjs(),
                   # position = c("fixed-top"),
                   
                   # ---------------------------------- home
                   tabPanel("Home",
                            includeHTML("./frontend/home.html"),
                   ),
                   
                   # ---------------------------------- Gel
                   tabPanel("Gel Creator",
                            gelCreatorPage(),
                   ),
                   
                   # ---------------------------------- analyze
                   tabPanel("Analyze",
                            analyzer(),
                   ),
                   
                   # ---------------------------------- about
                   tabPanel("About",
                            includeHTML("./frontend/about.html")
                   )
))
