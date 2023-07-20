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

#create gel
gelCreatorPage <- function(){
  fluidPage(
    fluidRow(
      column(
        3,wellPanel(
          h4("Gel Loadings"),
          h5("Instructions:"),
          fileInput("samples_upload","1. Upload your samples in a .csv file",accept="*.csv"),
          #can't have negatives
          numericInput("num_lanes","2. Enter number of lanes per gel:",1,min=1),
          #≥1 technical rep
          numericInput("num_reps","3. Enter number of technical replications:",1,min=1),
          h5("Allow a few seconds for content to automatically update."),
          h5("Click on another tab to refresh the pages within `Gel Loadings`."),
          h5("Click on `csv` button to download a copy of the gel and/or template as a csv file.")
        )
      ),
      column(
        9,tabsetPanel(id="gelinfo",
          tabPanel(
            "View uploaded samples",
            DT::dataTableOutput("view_samples"),
            h4("Maximum number of samples:"),
            textOutput("num_samples")
          ),
          tabPanel(
            "Duplicate sample names",
            h4("Number of duplicate sample names:"),
            textOutput("num_dupes"),
            h4("The following sample names are duplicated:"),
            textOutput("dupe_names")
          ),
          tabPanel(
            "Gels",
            h4("Each row represents a single gel."),
            DT::dataTableOutput("gel_orders")
          ),
          tabPanel(
            "User Template",
            DT::dataTableOutput("gel_template")
          )
        )
      )
    )
  )
}


