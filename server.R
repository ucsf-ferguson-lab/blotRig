# App server script

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
  
  #store uploaded samples + other data
  alldata <- reactiveValues()

  #read + show uploaded samples
  output$view_samples <- renderDataTable({
    req(input$samples_upload)
    alldata[["samples"]] <- read_csv(input$samples_upload$datapath)
    DT::datatable(alldata$samples,caption="Uploaded samples")
  })
  
  alldata[["dupes"]] <- reactive({
    listDupes(alldata$samples)
  })
  
  #show all duplicates
  output$dupe_names <- renderPrint({
    cat(paste(alldata$dupes(),collapse="\n"))
  })
  
  output$num_dupes <- renderText({
    length(alldata$dupes())
  })
  
  #display order of samples on gel
  output$gel_orders <- renderDataTable({
    #create baseline gel
    temp <- gelBaseline(
      totalSamples = 16,
      perLine = 8,
      entryID = as.vector(t(alldata$samples))
    ) %>%
      addCols(
        numLanes = 11
      ) %>%
      shiftLanes()
    
    #center & save
    alldata[["gel_order"]] <- centerSamples(temp)
    
    DT::datatable(alldata$gel_order,caption="Order of Samples on gel")
  })
  
  #create user template
  output$gel_template <- renderDataTable({
    alldata[["user_template"]] <- finalizedDF(
      inputGel = alldata[["gel_order"]],
      sourceDF = alldata$samples,
      numReps = 2
    )
  })
}
