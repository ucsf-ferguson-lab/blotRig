#' Run blotRig
#' @export
start_blotrig <- function(){
    #load packages
    library(shiny)
    library(lme4)
    library(lmerTest)
    library(tidyverse)
    library(DT)
    library(shinythemes)
    library(shinyjs)
    library(sortable)

    #start shiny app from subdir
    appdir <- system.file("appfiles",package="blotRig")
    shiny::runApp(appdir)
}
