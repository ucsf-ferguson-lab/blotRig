# App server script

# library(shiny)
# library(lme4)
# library(lmerTest)
# library(tidyverse)
# library(DT)
# library(MASS)
# install.packages("MASS")

# source("appFunctions.R")

function(input, output, session) {
  disable("run")
  values<-reactiveValues()
  
  observeEvent(input$file_upload,{
    values$upload<-read.csv(input$file_upload[["datapath"]],fileEncoding="UTF-8-BOM")
    enable("run")
  })
  
  observeEvent(input$example,{
    values$upload<-read.csv("data/western_paper_data_06.01.23.csv",fileEncoding="UTF-8-BOM")
    enable("run")
    
    updateTextInput(session, "response", value = "TargetProtein")
    updateTextInput(session, "group", value = "Group")
    updateTextInput(session, "subject", value = "Subject")
  })
  
  output$view_table<-renderDataTable({
    DT::datatable(values$upload, caption = "Your data")
  })
  
  observeEvent(input$run,{
    df<-values$upload
    error<-FALSE
    
    if(!input$response %in% colnames(df)){
      ## error message
      print(error)
      error<-TRUE
    }
    
    if(!input$group %in% colnames(df)){
      ## error message
      error<-TRUE
    }
    
    if(!input$subject %in% colnames(df)){
      ## error message
      error<-TRUE
    }
    
    if(!error){
      formula_fit<-paste0(input$response,"~",input$group,"+(1|",input$subject,")")
      values$fit<-lmer(as.formula(formula_fit), data =df)
      
      output$results<-renderPrint({
        anova(values$fit)
      })
      
      updateTabsetPanel(session, inputId = "tabset", "Results")
    }

  })
  
}
