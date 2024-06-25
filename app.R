library(shiny)
library(tidyverse)
library(bslib)
library(base64enc)
library(shinyBS)

tpfact <- read_csv("data/TPdelivery.csv") %>%
  mutate_if(is.character, as.factor)

#options(shiny.maxRequestSize = 30*1024^2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  ),
  shinyjs::useShinyjs(),
  titlePanel("Soil Health Phosphorus Cost Savings"),
  sidebarLayout(
    sidebarPanel(
      h4("Enter your inputs"),
      helpText("Click each section to open"),
      bsCollapse(id = "inputs",
                 bsCollapsePanel("Practices and P loss", 
                                 textInput(inputId = "prePractice", label = "Previous practice"),
                                 numericInput(inputId = "prePloss", label = "Previous practice P loss/ac/yr", value = 0),
                                 textInput(inputId = "newPractice", label = "New practice"),
                                 numericInput(inputId = "newPloss", label = "New practice P loss/ac/yr", value = 0),
                                 style = "success"),
                 bsCollapsePanel("Site characteristics", 
                                 selectInput(inputId = "slope", label = "Dominant slope", choices = c("0-2%", "2-6%", "6-12%", ">12%")),
                                 selectInput(inputId = "streamDist", label = "Distance from stream", choices = c("0-300 ft", "300-1,000 ft", "1,001-5,000 ft", "5,001-10,000 ft", "10,001-20,000 ft", ">20,000 ft")),
                                 numericInput(inputId = "acres", label = "Acres transitioned", value = 0),
                                 style = "success"),
                 bsCollapsePanel("Program characteristics",
                                 textInput(inputId = "program", label = "Program name"),
                                 numericInput(inputId = "funds", label = "Public funds of cost-share project", value = 0),
                                 numericInput(inputId = "years", label = "Number of years new practice will be in place", value = 0),
                                 style = "success"),
                 bsCollapsePanel("Geography",
                                 textInput(inputId = "town", label = "Nearby downstream municipality"),
                                 numericInput(inputId = "population", label = "Population of nearby downstream municipality", value = 0),
                                 style = "success")
                 ),
      ##TODO will have action button disabled until photo upload?
      #disabled(
        actionButton(inputId = "calc", "Calculate"),
      #),
      br(),
      br(),
      fileInput(inputId = "upload", label = "Upload an image of your farm", accept = c('image/png', 'image/jpeg')),
      ),
    mainPanel(
      #fluidRow(
       # column(1,
               img(src = "MFAI Logo Black Transparent .png"),
      textOutput("postText1"),
      br(),
      textOutput("postText2"),
      br(),
      textOutput("postText3"),
      br(),
      #imageOutput("image",width = 300, height = 500),
      # #textInput("txt", "Enter the text to display below:",
      # #          value = 52),
      downloadButton('downloadImage', 'Download Image')
      )
  )
)


server <- function(input, output) {


  observeEvent(input$calc,{
    edgeOfieldPsav <- input$prePloss - input$newPloss
    TPdeliveryFactor <- filter(tpfact, domSlope == input$slope, distStream == input$streamDist)$tpfactor
    print(TPdeliveryFactor)
    pCreditAc <- edgeOfieldPsav * TPdeliveryFactor
    print(pCreditAc)
    pCreditTotalArea <- pCreditAc * input$acres
    print(pCreditTotalArea)
    pCreditLife <- pCreditTotalArea * input$years
    print(pCreditLife)
    dollPerLbAcYr <- input$funds/pCreditTotalArea/input$years
    print(dollPerLbAcYr)
    savings <- if(input$population > 9999) {500} else
      if(input$population > 999) {1000} else
      if(input$population > 0) {1500}
    savingsComp <- savings - dollPerLbAcYr 
    netSavTransAcres <- savings * pCreditTotalArea
    netSavTranLife <- savings * pCreditLife

    output$postText1 <- renderText({
      
      paste0("The smaller the municipality, the higher the cost of removing phosphorus can be. An estimated cost for ", 
            input$town, ", based on their population of around ", format(input$population, big.mark = ","), ", is around $", 
            format(savings, big.mark = ","), " per pound of phosphorus.")
    })
    
    output$postText2 <- renderText({
      
      paste0("For comparison, my contract with the ", input$program, " cost around $", 
             round(dollPerLbAcYr, 2), " per pound of phosphorous.")
    })
    
    output$postText3 <- renderText({
      
      paste0("I saved state and local goverments approximately $", format(netSavTransAcres, big.mark = ","), " this year
             by using the ", input$program, " to transition ", input$acres, " acres to ", input$newPractice,
             " from ", input$prePractice, ".")
    })

  })
  
 
}

# Run the application 
shinyApp(ui = ui, server = server)


