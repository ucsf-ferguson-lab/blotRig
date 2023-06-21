## UI sections function
analyzer<-function(){
  fluidPage(
    fluidRow(
      column(3,
             wellPanel(
               
               #upload csv file
               h4("Upload data"),
               fileInput("file_upload", "Upload your file (.csv)", accept = "*.csv"),
               
               #use example dataset
               actionButton("example", label = "Use example"),
               hr(),
               
               #select vars (can replace w/ drop-down menu)
               textInput("response", "Name Response variable"),
               textInput("group", "Name Group variable"),
               textInput("subject", "Name Subject variable"),
               
               #run analysis
               actionButton("run", label = "Run analysis")
             )
      ),
      column(9,
             #show uploaded csv contents
             tabsetPanel(id = "tabset",
               tabPanel("Your Data",
                 wellPanel(
                   DT::dataTableOutput("view_table")
                 )),
               
               #show results (convert to table)
               tabPanel("Results",
                  wellPanel(
                    verbatimTextOutput("results")
                  )
               )
            )
      )
    )
  )
}