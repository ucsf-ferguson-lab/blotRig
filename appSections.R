## UI sections function
analyzer<-function(){
  fluidPage(
    fluidRow(
      column(3,
             wellPanel(
               h4("Upload data"),
               fileInput("file_upload", "Upload your file (.csv)", accept = "*.csv"),
               actionButton("example", label = "Use example"),
               hr(),
               textInput("response", "Name Response variable"),
               textInput("group", "Name Group variable"),
               textInput("subject", "Name Subject variable"),
               actionButton("run", label = "Run analysis")
             )
      ),
      column(9,
             tabsetPanel(id = "tabset",
               tabPanel("Your Data",
                 wellPanel(
                   DT::dataTableOutput("view_table")
                 )),
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