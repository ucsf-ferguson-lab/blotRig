## UI sections function

samplePlaner<-function(){
  fluidPage(
    wellPanel(
      h3("Sample planer"),
      tags$p(
        "The Sample planer helps to determine sample size for a given target experiment. This is achieved 
        through simulations from models derived from real control experiments. Select your target experiment
        below and simulate it hundreds of times to get an idea of the sample you need to have increse
        the chances of a replicable experiment"
      )
    ),
    fluidRow(
      column(3,
             wellPanel(
               h4("Experiment"),
               splitLayout(
                 selectInput("species", "Species", c("Rat")),
                 selectInput('sex', "Sex", c("Male", "Female"), selected = "Female")
               ),
               splitLayout(
                 selectInput('injuryType', "Type of Injury", c("Contusion")),
                 selectInput("injurySeverity", "Injury Severity", c("12.5mm", "25mm", "50mm"), 
                             selected = "25mm")
               ),
               selectInput("injuryLocation", "Injury Level", c("T9-T10"))
             ),
      ),
      column(9,
             tabsetPanel(
               tabPanel("Pre-simulated"),
               tabPanel("Simulate",
                        fluidRow(
                          column(4,
                                 wellPanel(
                                   h4("Simulation paramets"),
                                   tags$p(
                                     "The Sample planer model parameters control the target experiment, 
                 allowing to set the effect size of the expected % change between treatment 
                 and controls. The number of simulations control how many times the experiment 
                 is simulated per sample size (n) to calculate the experiemnt distribution. 
                 See About for details."
                                   ),
                                   textInput("timepoints", "Time points of analysis in days separated
                                             by - (e.g., 0-2-7-14)",
                                             value = "0-2-7-14-21-28"),
                                   splitLayout(
                                     selectInput("test", "Test", c("RMANOVA", "Spline model")),
                                     textInput("effect", "Effect size (% change)", value = "20")
                                   ),
                                   splitLayout(
                                     numericInput("minN", "Min n",value = 5, min = 3, max = 100, step = 1),
                                     numericInput("maxN", "Max n",value = 20, min = 3, max = 100, step = 1),
                                     numericInput("stepN", "Step n",value = 5, min = 1, max = 20, step = 1),
                                   ),
                                   sliderInput("nSim", "Number of simulations",100, 5000, 100, step = 50),
                                   tags$hr(),
                                   actionButton("runSim", "Simulate")
                                 )
                          ),
                          column(8, 
                                 plotlyOutput("SimPlot")
                          )) 
               )
             )
      )
    )
  )
}

analyzer<-function(){
  fluidPage(
    wellPanel(
      h4("Coming soon..."),
      tags$p(
        "We are working in this feature and we will make it available soon."
      )
    )
  )
}