library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Soil Health Phosphorus Cost Savings"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           textInput(inputId = "prePractice", label = "Previous practice"),
           numericInput(inputId = "prePloss", label = "Previous practice P loss/ac/yr", value = 0),
           textInput(inputId = "newPractice", label = "New practice"),
           numericInput(inputId = "newPloss", label = "New practice P loss/ac/yr", value = 0),
           selectInput(inputId = "slope", label = "Dominant slope", choices = c("0-2%", "2-6%", "6-12%", ">12%")),
           selectInput(inputId = "streamDist", label = "Distance from stream", choices = c("0-300 ft", "301-1,000 ft", "1,001-5,000 ft", "5,001-10,000 ft", "10,001-20,000 ft", ">20,000 ft")),
           numericInput(inputId = "acres", label = "Acres transitioned", value = 0),
           textInput(inputId = "program", label = "Program name"),
           numericInput(inputId = "funds", label = "Public funds of cost-share project", value = 0),
           numericInput(inputId = "years", label = "Number of years new practice will be in place", value = 0),
           textInput(inputId = "town", label = "Nearby downstream municipality"),
           numericInput(inputId = "population", label = "Population of nearby downstream municipality", value = 0)
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)


