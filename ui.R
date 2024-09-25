# Define UI for application that draws a histogram
ui <- dashboardPage(
  
  # tags$head(
  #   tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  # ),
 
  
  dashboardHeader(title = "Soil Health Phosphorus Cost Savings"),
                  # tags$li(a(href = 'https://www.michaelfields.org/',
                  #           img(src = "MFAI Logo White (Transparent BG).png", height = "30px"),
                  #           style = "padding-top:10px; padding-bottom:10px;"),
                  #         class = "dropdown")),
  
  dashboardSidebar(
    useShinyjs(),
    sidebarMenu(
      # tabNames--------------------
      id = "tabs",
      tags$head(tags$style(".inactiveLink {
                            pointer-events: none;
                           cursor: default;
                           }")),
      menuItem(text = "Introduction", tabName = "intro"),
      menuItem(text = "I will enter my own data", tabName = "ownerLand", 
               menuSubItem(text = "Practices on my land", tabName = "practices"),
               menuSubItem(text = "My land, my phosphorus", tabName = "myP"),
               menuSubItem(text = "Importance", tabName = "importance"),
               menuSubItem(text = "Public program", tabName = "publicProgram"),
               menuSubItem(text = "Context", tabName = "context"),
               menuSubItem(text = "Share!", tabName = "share")),
      menuItem(text = "Show me sample data", tabName = "sampleData",
               menuSubItem("Sample story", tabName = "sampleStory1"),
               menuSubItem(text = "Sample field", tabName = "sampleField"),
               menuSubItem(text = "Sample phosphorus", tabName = "sampleP"),
               menuSubItem(text = "Sample importance", tabName = "sampleImportance"),
               menuSubItem(text = "Compare practices", tabName = "sampleCompare"),
               menuSubItem(text = "Paying", tabName = "paying"),
               menuSubItem(text = "Context", tabName = "context2"),
               menuSubItem(text = "Share!", tabName = "share2")
               )
      )
    ),
  
  dashboardBody(
    useShinyjs(),
    # to manually open the drop down menu
    extendShinyjs(text = "shinyjs.activateTab = function(name){
                     setTimeout(function(){
                       $('a[href$=' + '\"#shiny-tab-' + name + '\"' + ']').click();
                     }, 200);
                   }", functions = c("activateTab")
    ),
    shinyDashboardThemes(
      theme = "poor_mans_flatly"
    ),
    tabItems(
      # intro page-------------------
      tabItem(tabName = "intro",
              h3("Federal and state programs that fund soil health practices save public money"),
              hr(style = "margin-top:0px"),
              fluidRow(
                column(8,
                       h4("How?"),
                       br(),
                       h4(HTML("Let's talk about <b>phosphorus</b> - the P in NPK fertilizer. It’s an important crop 
                      nutrient, but it can cause major problems once it leaves farm fields. Too much phosphorus 
                      can cause explosive growth of cyanobacteria (often referred to as blue-green algae) that 
                      is harmful to humans and causes “dead zones” in the Gulf of Mexico and the Great Lakes."))
                       ),
                column(4,
                       tags$img(src = "deadFish.png", height = "200px"),
                       tags$figcaption("A dead fish in a Great Lakes dead zone"))
              ),
              fluidRow(
                column(6, 
                       h4("Agricultural practices can make a huge difference in how much phosphorus leaves a farm field. 
                 Conservation programs can help farmers adopt practices that reduce phosphorus runoff."),
                 br(),
                 h4("This tool uses your data to compare the price of different ways to reduce phosphorus in surface water.")),
                column(6,
                       br(),
                       br(),
                       tags$img(src = "deadZone.jpeg", height = "200px"),
                       tags$figcaption("The dead zone in the Gulf of Mexico"))
              ),
              br(),
              helpText("Use the buttons at the bottom of each page to help you navigate through this tool."),
              fluidRow(
                column(width = 6,
                       actionButton("selfData", label = "I will enter my own data")),
                column(width = 6,
                       actionButton("sampleData", "Show me sample data"))
              ),
              br(),
              fluidRow(
                column(width = 3,
                       #tags$li(a(href = 'https://www.michaelfields.org/',
                        tags$img(src = "MFAI Logo Black Transparent .png", height = "200px")
                        #style = "padding-top:10px; padding-bottom:10px;"
                        #),
                      #class = "dropdown")
                )
              )
              #img(src = "MFAI Logo Black Transparent .png", height = "200px")
              ),
      # practices page----------------------
      tabItem(tabName = "practices",
              h3(strong("I use conservation practices on my farm")),
              hr(style = "margin-top:0px"),
              numericInput(inputId = "acres", label = "How many acres did you transition to conservation practices?", value = NULL),
              textInput(inputId = "newPractice", label = "What conservation practice are you using?"),
              #textInput(inputId = "prePractice", label = "What was the previous land management?"),
              numericInput(inputId = "prePloss", label = "How many pounds of P loss/ac/yr were estimated from your previous practice?", value = NULL),
              numericInput(inputId = "newPloss", label = "How many pounds of P loss/ac/yr are estimated from your conservation practice?", value = NULL),
              br(),
              span(textOutput("edgeOfFieldText"), style = "font-size:20px; font-family:arial; font-style:italic"),
              br(),
              actionButton("practiceButton", "Next")
      ),
      # my land my P-------------------------
       tabItem(tabName = "myP",
               h3(strong("My land, my phosphorous")),
               hr(style = "margin-top:0px"),
               h4("How much edge-of-field P runoff is delivered to surface water depends on a couple of key factors:"),
               h4("1) average slope along the flow path to the stream"),
               fluidRow(
                 column(12,
                        selectInput(inputId = "slope", label = "My average slope", choices = c(" ", "0-2%", "2-6%", "6-12%", ">12%")),
                        offset = 2)
               ),
               h4("2) distance from the stream"),
               fluidRow(
                 column(12,
                        selectInput(inputId = "streamDist", label = "My distance from the stream", choices = c(" ", "0-300 ft", "300-1,000 ft", "1,001-5,000 ft", "5,001-10,000 ft", "10,001-20,000 ft", ">20,000 ft")),
                        offset = 2)
               ),
               span(textOutput("myPtext"), style = "font-size:20px; font-family:arial; font-style:italic"),
               br(),
               actionButton("myPbutton", "Next")
               
      ),
      # importance----------------------
      tabItem(tabName = "importance",
              h3(strong("Why does that matter")),
              hr(style = "margin-top:0px"),
              h4(HTML("Municipal wastewater treatment costs are a good measure for how important it is to reduce phosphorus in our waterways. 
                 We’re willing to pay hundreds of dollars per pound to remove phosphorus from wastewater before it enters back into waterways. 
                 <i> That’s how much it matters to reduce P in water.</i>")),
              h4("In Wisconsin, in general if a city has over 10,000 residents, treatment costs around $500/lb P. For towns between 1,000 and
                 10,000, the cost is around $1,000/lb P. For towns smaller than 1,000 people, the cost is around $1,500/lb P."),
              fluidRow(
                column(6,
                       textInput(inputId = "town", label = "Nearest downstream municipality"),
                       numericInput(inputId = "population", label = "Population of nearby downstream municipality", value = NULL),
                       span(textOutput("townPays"), style = "font-size:20px; font-family:arial; font-style:italic")),
                column(6,
                       tags$img(src = "townPays.png", height = "250px")
                       )
                ),
              br(),
              actionButton("importanceButton", "Next")
              ),
      # public program------------------------
      tabItem(tabName = "publicProgram",
              h3(strong("I used public funds to transition to conservation practices")),
              hr(style = "margin-top:0px"),
              selectInput(inputId = "program", label = "Program name", choices = c(" ", conservationProgramNames, "Other")),
              uiOutput("otherProgram"),
              numericInput(inputId = "reimbursement", "Reimbursement rate ($/acre)", value = NULL),
              span(textOutput("moneyBack"), style = "font-size:20px; font-family:arial"),
              br(),
              fluidRow(
                column(12,
                       h5(HTML("We’re paying for clean water <i>one way or another</i>. 
                               That’s why it makes so much sense for our elected officials to support 
                               farmers as they transition to conservation practices.")),
                       offset = 1)
                ),
              br(),
              actionButton("publicProgramButton", "Next")
              ),
      # context---------------
      tabItem(tabName = "context",
              h3(strong("But this is just talking about phosphorus.")),
              hr(style = "margin-top:0px"),
              h4("We just looked at one narrow slice of the benefits to society of agriculture conservation 
                 programs."),
              h4("The same practices that reduce phosphorus runoff can also:"),
              tags$li(HTML("Reduce <b>nitrate leaching</b>. Nitrate pollution in drinking water may cost Wisconsin up 
                      to $80 million in medical expenses, $14 million in lost earnings due to colorectal 
                      cancer attributed to nitrates, and $8 million of caretaker time.")), 
              br(),
              fluidRow(
                column(8,
                       tags$li(HTML("Increase <b>carbon sequestration</b> to help mitigate climate change and help farmers be more 
                      resilient to weather extremes. <i>Crop insurance costs are estimated to rise by 29% in the 
                      next decade. In 2023, Wisconsin farms received $252 million in crop insurance subsidies 
                      and $17.8 million in disaster relief programs</i>.")), 
                      br(),
                      tags$li(HTML("Increase <b>water infiltration</b> and reduce flood risk. </i>One study shows that every $1 spent 
                      on pre-disaster mitigation saves $4-7 in disaster relief. Wisconsin had 17 “billion-dollar
                      disasters” from 2021-2023</i>."))),
                column(4,
                       #uiOutput("bankErosionPhoto")
                       tags$img(src = "bankErosion.png", height = "250px"),
                       tags$figcaption("A road washed out after"),
                       tags$figcaption("flooding in Vermont, 2023"))
                #)
              ),
              br(),
              actionButton("contextButton", "Next")
              ),
      #share------------------------
      tabItem(tabName = "share",
              h3(strong("Help spread the word and build support for important conservation programs like EQIP, CSP, county conservation,
                        and many others")),
              hr(style = "margin-top:0px"),
              h4("Share your results! Click the download button and then upload the photos on social media."),
              helpText("Use the image provided or upload your own image as a background."),
              bsCollapse(id = "newPhoto",
                         bsCollapsePanel("Change photo", style = "default", # default, info, warning
                                         fileInput("upload", "Upload your own image", accept = c('image/png', 'image/jpeg')),
                                         sliderInput("scale", "Adjust the size", min = 10, max = 1000, value = 550, step = 10),
                                         sliderInput("rotation", "Fix the rotation", 0, 360, 0, step = 90),
                                         checkboxGroupInput("effects", "Fix the orientation",
                                                            choices = list("flip", "flop"))
                         )),
              br(),
              imageOutput("img1_a"),
              br(), br(),br(),br(),br(),br(),br(),br(),
              imageOutput("img1_b"),
              br(), br(),br(),br(),br(),br(),br(),br(),
              imageOutput("img1_c"),
              br(), br(),br(),br(),br(),br(),br(),br(),
              imageOutput("img1_d"),
              #span(textOutput("postText"), style = "font-size:20px; font-family:arial"),
              br(), br(),br(),br(),br(),br(),br(),br(),
              downloadButton(outputId = "downloadImage")),
      #sampleStory1---------------
      tabItem(tabName = "sampleStory1",
              fluidRow(style = 'margin-left: 2%;',
                column(6, 
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "400px"),
                       hr(style = "margin-top:0px"),
                       br(),
                       h2("How big a difference do soil health practices make in phosphorus reductions?"),
                       br(),
                       actionButton("sampleStory1button", "Next")),
                column(6,
                       br(),
                       br(),
                       tags$img(src = "rowCrop.jpg", height = "500px"),
                       tags$figcaption("No-till corn field in Southern Wisconsin"))
                )
              ),
      # sample field----------------
      tabItem(tabName = "sampleField",
              h3(strong("To demonstrate, we'll look at modeling data from this 102.8 acre field outside a town of 2,500
                        people in southern Wisconsin")),
              hr(style = "margin-top:0px"),
              br(),
              fluidRow(
                column(6,
                       h4(HTML("<b>Soil:</b> Moderately eroded, silt loam")),
                       h4(HTML("<b>Average slope along the flow path to the stream:</b> 2-6%")),
                       h4(HTML("<b>Distance from stream:</b> 1,001-5,000 ft")),
                       h4(HTML("<b>Wisconsin P Index Delivery to Water Ratio:</b> 91%")),
                       br(),
                       h4(HTML("<b>Default practice:</b> corn/soy rotation, spring cultivation, no cover crop,
                               100% of UW recommended N and P fertilizer applications.")),
                       br(),
                       h4(HTML("<b>Soil loss:</b> 5.83 tons/acre/year")),
                       br(),
                       actionButton("sampleFieldButton", "Next")),
                column(6,
                       tags$img(src = "sampleFarm.png"),
                       tags$figcaption("Map of the field in southern WI pictured in 
                                       the previous slide. Outcomes from different 
                                       practices were modeled in GrazeScape 
                                       from UW Grassland 2.0.")))),
      # sample P-------------------
      tabItem(tabName = "sampleP",
              h3(strong("What about phosphorous?")),
              hr(style = "margin-top:0px"),
              fluidRow(
                column(6,
                       br(),
                       br(),
                       h4(HTML("<b>Edge-of-field phosphorus loss:</b> 7.86 lbs/P/ac, 801.72 lbs P/year")),
                       h4(HTML("<b>Phosphorus delivered to stream:</b> 7.15 lbs P/ac, 735 lbs P/year")),
                       br(),
                       br(),
                       br(),
                       br(),
                       actionButton("samplePbutton", "Next")),
                column(6,
                       tags$img(src = "sampleP.jpg"),
                       tags$figcaption("The muddy waters of the Pecatonica River in June 2024"))
              )),
      #sample importance----------------
      tabItem(tabName = "sampleImportance",
              h3(strong("Why does that matter")),
              hr(style = "margin-top:0px"),
              h4(HTML("Municipal wastewater treatment costs are a good measure for how important it is to reduce phosphorus in our waterways. 
                 We’re willing to pay hundreds of dollars per pound to remove phosphorus from wastewater before it enters back into waterways. 
                 <i> That’s how much it matters to reduce P in water.</i>")),
              h4("In Wisconsin, in general if a city has over 10,000 residents, treatment costs around $500/lb P. For towns between 1,000 and
                 10,000, the cost is around $1,000/lb P. For towns smaller than 1,000 people, the cost is around $1,500/lb P."),
              h4("In our example with a town of about 2,500, it would cost around $1,000/lb P. Our 102.8 acre field is delivering 735 lb P/year
                 to the nearby stream."),
              br(),
              h3(HTML("To remove an equivalent amount of P would cost the town around <b>$735,000</b>")),
              br(),
              actionButton("sampleImportanceButton", "Next")),
      # sample compare-------------------
      tabItem(tabName = "sampleCompare",
              h3(strong("Let's compare scenarios to see how much phosphorus is reduced with different crop rotations and management practices")),
              h4(style = "margin-top:0px"),
              fluidRow(
                column(6,
                       selectInput(inputId = "samplePractices", label = "Practices",
                                   choices = c("", "Corn-soy, spring tillage, small grain cover",
                                               "Corn-soy, no-till, no cover",
                                               "Corn-soy, no-till, small grain cover",
                                               "Pasture, managed grazing")),
                       br(),
                       br(),
                       actionButton("compareButton", "Next")),
                column(6,
                       span(textOutput("compare1text"), style = "font-size:20px; font-family:arial; font-style:italic"),
                       br(),
                       span(textOutput("compare2text"), style = "font-size:20px; font-family:arial; font-style:italic"),
                       br(),
                       span(textOutput("compare3text"), style = "font-size:20px; font-family:arial; font-style:italic")))),
      # paying---------------
      tabItem(tabName = "paying",
              h3(strong("Using public funds to help transition more acres to conservation practices saves money.")),
              hr(style = "margin-top:0px"),
              br(),
              h4(HTML("We're paying for clean water <i>one way or another</i>. That's why it makes so much sense
                      for our elected officials to support farmers as they transition to conservation practices.")),
              br(),
              br(),
              actionButton("payingButton", "Next")),
      # context2----------------
      tabItem(tabName = "context2",
              h3(strong("But this is just talking about phosphorus.")),
              hr(style = "margin-top:0px"),
              h4("We just looked at one narrow slice of the benefits to society of agriculture conservation 
                 programs."),
              h4("The same practices that reduce phosphorus runoff can also:"),
              tags$li(HTML("Reduce <b>nitrate leaching</b>. Nitrate pollution in drinking water may cost Wisconsin up 
                      to $80 million in medical expenses, $14 million in lost earnings due to colorectal 
                      cancer attributed to nitrates, and $8 million of caretaker time.")), 
              br(),
              fluidRow(
                column(8,
                       tags$li(HTML("Increase <b>carbon sequestration</b> to help mitigate climate change and help farmers be more 
                      resilient to weather extremes. <i>Crop insurance costs are estimated to rise by 29% in the 
                      next decade. In 2023, Wisconsin farms received $252 million in crop insurance subsidies 
                      and $17.8 million in disaster relief programs</i>.")), 
                      br(),
                      tags$li(HTML("Increase <b>water infiltration</b> and reduce flood risk. </i>One study shows that every $1 spent 
                      on pre-disaster mitigation saves $4-7 in disaster relief. Wisconsin had 17 “billion-dollar
                      disasters” from 2021-2023</i>."))),
                column(4,
                       tags$img(src = "bankErosion.png", height = "250px"),
                       tags$figcaption("A road washed out after flooding in Vermont, 2023"))
              ),
              br(),
              actionButton("context2Button", "Next")),
      # share2-------------------------
      tabItem(tabName = "share2",
              h3(strong("Help spread the word and build support for important conservation programs like EQIP, CSP, county conservation,
                        and many others")),
              hr(style = "margin-top:0px"),
              h4("Share your results! Click the download button and then upload the photos on social media."),
              br(),
              imageOutput("img2_a"),
              br(),
              imageOutput("img2_b"),
              br(),
              imageOutput("img2_c"),
              br(),
              imageOutput("img2_d"),
              #span(textOutput("postText"), style = "font-size:20px; font-family:arial"),
              br(),
              downloadButton(outputId = "downloadImage2"))
    )
  )
)

   
    # bsCollapse(id = "inputs",
    #            bsCollapsePanel("Practices and P loss", 
    #                            textInput(inputId = "prePractice", label = "Previous practice"),
    #                            numericInput(inputId = "prePloss", label = "Previous practice P loss/ac/yr", value = 0),
    #                            textInput(inputId = "newPractice", label = "New practice"),
    #                            numericInput(inputId = "newPloss", label = "New practice P loss/ac/yr", value = 0),
    #                            style = "success"),
    #            bsCollapsePanel("Site characteristics", 
    #                            selectInput(inputId = "slope", label = "Dominant slope", choices = c("0-2%", "2-6%", "6-12%", ">12%")),
    #                            selectInput(inputId = "streamDist", label = "Distance from stream", choices = c("0-300 ft", "300-1,000 ft", "1,001-5,000 ft", "5,001-10,000 ft", "10,001-20,000 ft", ">20,000 ft")),
    #                            numericInput(inputId = "acres", label = "Acres transitioned", value = 0),
    #                            style = "success"),
    #            bsCollapsePanel("Program characteristics",
    #                            textInput(inputId = "program", label = "Program name"),
    #                            numericInput(inputId = "funds", label = "Public funds of cost-share project", value = 0),
    #                            numericInput(inputId = "years", label = "Number of years new practice will be in place", value = 0),
    #                            style = "success"),
    #            bsCollapsePanel("Geography",
    #                            textInput(inputId = "town", label = "Nearby downstream municipality"),
    #                            numericInput(inputId = "population", label = "Population of nearby downstream municipality", value = 0),
    #                            style = "success")
    # ),
    # ##TODO will have action button disabled until photo upload?
    # #disabled(
    # actionButton(inputId = "calc", "Calculate"),
    # #),
    # br(),
    # br(),
    # fileInput(inputId = "upload", label = "Upload an image of your farm", accept = c('image/png', 'image/jpeg')),
    # 
    #   #fluidRow(
    #   # column(1,
    #   img(src = "MFAI Logo Black Transparent .png"),
    #   textOutput("postText1"),
    #   br(),
    #   textOutput("postText2"),
    #   br(),
    #   textOutput("postText3"),
    #   br(),
    #   #imageOutput("image",width = 300, height = 500),
    #   # #textInput("txt", "Enter the text to display below:",
    #   # #          value = 52),
    #   downloadButton('downloadImage', 'Download Image')
#     
#   )
# )