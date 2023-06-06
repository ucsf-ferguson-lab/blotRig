## App ui script
## Libraries
library(shiny)
library(shinythemes)
library(shinyjs)
library(sortable)

source("appSections.R")

## UI
shinyUI(navbarPage(title = "blobRig",
                   theme = shinytheme("cerulean"),
                   footer = includeHTML("footer.html"),
                   fluid = TRUE, 
                   collapsible = TRUE,
                   useShinyjs(),
                   # position = c("fixed-top"),
                   
                   # ----------------------------------
                   # Home panel
                   tabPanel("Home",
                            includeHTML("home.html"),
                   ),
                   
                   # ----------------------------------
                   tabPanel("Analize",
                            analyzer(),
                   ),
                   
                   # ----------------------------------
                   # TODO ( add About section)
                   tabPanel("About",
                            includeHTML("about.html")
                   )
                   
))
