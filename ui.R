# Define UI for application that draws a histogram
ui <- dashboardPage(
 
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
    includeCSS("www/style.css"),
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
              fluidRow(
                column(9,
                       h2("Federal and state programs that fund soil health practices save public money"),
                       hr(style = "margin-top:0px"),
                       fluidRow(
                         column(6,
                                h3("How?"),
                                h3(HTML("Let's talk about <b>phosphorus</b> - the P in NPK fertilizer. It’s an important crop 
                                        nutrient, but it can cause major problems once it leaves farm fields. Too much phosphorus 
                                        can cause explosive growth of cyanobacteria (often referred to as blue-green algae) that 
                                        is harmful to humans and causes “dead zones” in the Gulf of Mexico and the Great Lakes.")),
                                h3("Agricultural practices can make a huge difference in how much phosphorus leaves a farm field. 
                                   Conservation programs can help farmers adopt practices that reduce phosphorus runoff."),
                                h3("This tool uses your data to compare the price of different ways to reduce phosphorus in surface water.")),
                         column(4,
                                tags$img(src = "deadZone.jpeg", height = "200px"),
                                tags$figcaption("The dead zone in the Gulf of Mexico"),
                                br(),
                                tags$img(src = "deadFish.png", height = "250px"),
                                tags$figcaption("A dead fish in a Great Lakes dead zone"))),
                      helpText("Use the buttons at the bottom of each page to help you navigate through this tool."),
                      fluidRow(
                        column(width = 4,
                               actionButton("selfData", label = "I will enter my own data")),
                        column(width = 3,
                               actionButton("sampleData", "Show me sample data"))
                        )
                      )
                ),
              fluidRow(
                column(width = 3,
                        tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
                )
              ),
              
      # practices page----------------------
      tabItem(tabName = "practices",
              fluidRow(
                column(9,
                       h2(strong("Conservation practices I use on my farm")),
                       hr(style = "margin-top:0px"),
                       div(style = "font-size:16px",
                           numericInput(inputId = "acres", label = "How many acres did you transition to conservation practices?", value = NULL),
                           tags$style("#acres {font-size:14px;}")),
                       div(style = "font-size:16px",
                           textInput(inputId = "newPractice", label = HTML(paste0("What conservation practice are you using?",tags$sup("1")))),
                           tags$style("#newPractice {font-size:14px;}")),
                       helpText(HTML(paste0(tags$sup("1"), "Examples include: grazing, cover crops, no-till, reduced tillage, buffer strips, and grassed waterways."))),
                       div(style = "font-size:16px",
                           numericInput(inputId = "prePloss", label = HTML(paste0("How many pounds of P loss/ac/yr were estimated from your previous practice?", tags$sup("2"))), value = NULL),
                           tags$style("#prePloss {font-size:14px;}")),
                       div(style = "font-size:16px",
                           numericInput(inputId = "newPloss", label = HTML(paste0("How many pounds of P loss/ac/yr are estimated from your conservation practice?", tags$sup("2"))), value = NULL),
                           tags$style("#newPloss {font-size:14px;}")),
                       helpText(HTML(paste0(tags$sup("2"), "To determine your P loss/ac/yr, create a scenario with", tags$a(href="https://snapplus.wisc.edu/", " SnapPlus"), ", or ",
                                            tags$a(href="https://scapetools.grasslandag.org/", "GrazeScape.")), "If you are outside of Wisconsin, work with your technical service provider.")),
                       br(),
                       span(textOutput("edgeOfFieldText"), style = "font-size:24px; font-family:arial; font-style:italic"),
                       br(),
                       actionButton("practiceButton", "Next"))
              ),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )
      ),
      # my land my P-------------------------
       tabItem(tabName = "myP",
               fluidRow(
                 column(9,
                        h2(strong("My land, my phosphorous")),
                        hr(style = "margin-top:0px"),
                        h3("How much edge-of-field P runoff is delivered to surface water depends on a couple of key factors:"),
                        h3(HTML(paste0("1) average slope along the flow path to the stream", tags$sup("1")))),
                        fluidRow(
                          column(12,
                                 div(style = "font-size:16px",
                                     selectInput(inputId = "slope", label = "My average slope", choices = c(" ", "0-2%", "2-6%", "6-12%", ">12%")),
                                     offset = 2))
                        ),
                        h3(HTML(paste0("2) distance from the stream", tags$sup("1")))),
                        fluidRow(
                          column(12,
                                 div(style = "font-size:16px",
                                     selectInput(inputId = "streamDist", label = "My distance from the stream", choices = c(" ", "0-300 ft", "300-1,000 ft", "1,001-5,000 ft", "5,001-10,000 ft", "10,001-20,000 ft", ">20,000 ft")),
                                     offset = 2))
                        ),
                        helpText(HTML(paste0("To find slope and stream distance, visit the ", tags$a(href = "https://websoilsurvey.nrcs.usda.gov/app/WebSoilSurvey.aspx", 
                                                                                                     "Web Soil Survey")))),
                        span(textOutput("myPtext"), style = "font-size:24px; font-family:arial; font-style:italic"),
                        br(),
                        actionButton("myPbutton", "Next")
                        )),
               fluidRow(
                 column(width = 3,
                        tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
               )
      ),
      # importance----------------------
      tabItem(tabName = "importance",
              fluidRow(
                column(9,
                       h2(strong("Why does that matter")),
                       hr(style = "margin-top:0px"),
                       h3(HTML("Municipal wastewater treatment costs are a good measure for how important it is to reduce phosphorus
                               in our waterways. We’re willing to pay hundreds of dollars per pound to remove phosphorus from 
                               wastewater before it enters back into waterways. <i>That’s how much it matters to reduce P in 
                               water.</i>")),
                       h3("In Wisconsin, in general if a city has over 10,000 residents, treatment costs around $500/lb P. For 
                          towns between 1,000 and 10,000, the cost is around $1,000/lb P. For towns smaller than 1,000 people, 
                          the cost is around $1,500/lb P."),
                       br(),
                       fluidRow(
                         column(6,
                                div(style = "font-size:16px",
                                    textInput(inputId = "town", label = "Nearest downstream municipality"),
                                    tags$style("#town {font-size:14px;}")),
                                div(style = "font-size:16px",
                                    numericInput(inputId = "population", label = "Population of nearby downstream municipality", value = NULL),
                                    tags$style("#population {font-size:14px;}")),
                                span(textOutput("townPays"), style = "font-size:24px; font-family:arial; font-style:italic")),
                         column(5, 
                                tags$img(src = "townPays.png", height = "250px"))),
                       br(),
                       actionButton("importanceButton", "Next")
                       )),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px")))
              ),
      # public program------------------------
      tabItem(tabName = "publicProgram",
              fluidRow(
                column(9,
                       h2(strong("Public funds I used to transition to conservation practices")),
                       hr(style = "margin-top:0px"),
                       div(style = "font-size:16px",
                           selectInput(inputId = "program", label = "Program name", 
                                       choices = conservationProgramNames)), #multiple = TRUE, selected = " ")),
                       uiOutput("otherProgram"),
                       div(style = "font-size:16px",
                           numericInput(inputId = "reimbursement", "Reimbursement rate ($/acre)", value = NULL),
                           tags$style("#reimbursement {font-size:14px;}")),
                       br(),
                       fluidRow(
                         column(9, 
                                span(textOutput("moneyBack"), style = "font-size:24px; font-family:arial"),
                                #br(),
                                h3(HTML("We’re paying for clean water <i>one way or another</i>. 
                               That’s why it makes so much sense for our elected officials to support 
                               farmers as they transition to conservation practices.")))),
                       br(),
                       actionButton("publicProgramButton", "Next"))
              ),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )),
      # context---------------
      tabItem(tabName = "context",
              fluidRow(
                column(9,
                       h2(strong("It's not just phosphorus...")),
                       hr(style = "margin-top:0px"),
                       h3("We just looked at one narrow slice of the benefits to society of agriculture conservation 
                 programs."),
                 h3("The same practices that reduce phosphorus runoff can also:"),
                 br(),
                 fluidRow(
                   column(6,
                          div(style = "font-size:18px",
                              tags$li(HTML("Reduce <b>nitrate leaching</b>. Nitrate pollution in drinking water may cost Wisconsin up 
                      to $80 million in medical expenses, $14 million in lost earnings due to colorectal 
                      cancer attributed to nitrates, and $8 million of caretaker time.")),
                      br(),
                      tags$li(HTML("Increase <b>carbon sequestration</b> to help mitigate climate change and help farmers be more 
                      resilient to weather extremes. <i>Crop insurance costs are estimated to rise by 29% in the 
                      next decade. In 2023, Wisconsin farms received $252 million in crop insurance subsidies 
                      and $17.8 million in disaster relief programs</i>.")),
                      br(),
                      tags$li(HTML("Increase <b>water infiltration</b> and reduce flood risk. </i>One study shows that every $1 spent 
                      on pre-disaster mitigation saves $4-7 in disaster relief. Wisconsin had 17 “billion-dollar
                      disasters” from 2021-2023</i>.")))),
                   column(3,
                          tags$img(src = "bankErosion.png", height = "250px"),
                          tags$figcaption("A road washed out after flooding in Vermont, 2023"))#,
                          #tags$figcaption(""))
                 ),
                 br(),
                 actionButton("contextButton", "Next"))
              ),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
                )
              ),
      #share------------------------
      tabItem(tabName = "share",
              fluidRow(
                column(9,
                       h2(strong("Help spread the word and build support for important conservation programs like EQIP, CSP, county conservation,
                        and many others")),
                       hr(style = "margin-top:0px"),
                       h3("Share your results! Click the download button and then upload the photos on social media."),
                       h4("Be sure to tag us!"),
                       h4("IG: ", tags$a(href="https://www.instagram.com/michael_fields_ag/#", "@michael_fields_ag")),
                       h4("FB: ", tags$a(href="https://www.facebook.com/MichaelFieldsAgriculturalInstitute", "@Michael Fields Agricultural Institute")),
                       h4("We love to see your stories!"), 
                       br(),
                       imageOutput("img1_a"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img1_b"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img1_c"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img1_d"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       downloadButton(outputId = "downloadImage"))
              ),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )),
      #sampleStory1---------------
      tabItem(tabName = "sampleStory1",
              fluidRow(
                column(9, 
                       h2("How big a difference do soil health practices make in phosphorus reductions?"),
                       hr(style = "margin-top:0px"),
                       br(),
                       tags$img(src = "rowCrop.jpg", height = "450px"),
                       tags$figcaption("No-till corn field in Southern Wisconsin"),
                       br(),
                       actionButton("sampleStory1button", "Next"),
                       fluidRow(
                         column(width = 3,
                                tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
                       )))
              ),
      # sample field----------------
      tabItem(tabName = "sampleField",
              fluidRow(
                column(9,
                       h2(strong("To demonstrate, we'll look at modeling data from this 102.8 acre field outside a town of 2,500
                        people in southern Wisconsin")),
                       hr(style = "margin-top:0px"),
                       br(),
                       fluidRow(
                         column(6,
                                h3(HTML("<b>Soil:</b> Moderately eroded, silt loam")),
                                h3(HTML("<b>Average slope along the flow path to the stream:</b> 2-6%")),
                                h3(HTML("<b>Distance from stream:</b> 1,001-5,000 ft")),
                                h3(HTML("<b>Wisconsin P Index Delivery to Water Ratio:</b> 91%")),
                                br(),
                                h3(HTML("<b>Default practice:</b> corn/soy rotation, spring cultivation, no cover crop,
                               100% of UW recommended N and P fertilizer applications.")),
                               br(),
                               h3(HTML("<b>Soil loss:</b> 5.83 tons/acre/year")),
                               br(),
                               actionButton("sampleFieldButton", "Next"),
                               ),
                         column(6,
                                tags$img(src = "sampleFarm.png"),
                                tags$figcaption("Map of the field in southern WI pictured in 
                                       the previous slide. Outcomes from different practices were
                                       modeled in GrazeScape from UW Grassland 2.0.")#,
                                #tags$figcaption("")
                                )
                         )
                       )),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )),
      # sample P-------------------
      tabItem(tabName = "sampleP",
              fluidRow(
                column(9,
                       h2(strong("What about phosphorous?")),
                       hr(style = "margin-top:0px"),
                       fluidRow(
                         column(6,
                                br(),
                                br(),
                                h3(HTML("<b>Edge-of-field phosphorus loss:</b> 7.86 lbs/P/ac, 801.72 lbs P/year")),
                                h3(HTML("<b>Phosphorus delivered to stream:</b> 7.15 lbs P/ac, 735 lbs P/year"))),
                         column(6,
                                tags$img(src = "sampleP.jpg", height = "450px"),
                                tags$figcaption("The muddy waters of the Pecatonica River in June 2024"))
                       ))
              ),
              fluidRow(
                column(width = 3,
                       actionButton("samplePbutton", "Next"),
                       br(),
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )),
      #sample importance----------------
      tabItem(tabName = "sampleImportance",
              fluidRow(
                column(9, 
                       h2(strong("Why does that matter")),
                       hr(style = "margin-top:0px"),
                       h3(HTML("Municipal wastewater treatment costs are a good measure for how important it is to reduce phosphorus in our waterways. 
                 We’re willing to pay hundreds of dollars per pound to remove phosphorus from wastewater before it enters back into waterways. 
                 <i> That’s how much it matters to reduce P in water.</i>")),
                 h3("In Wisconsin, in general if a city has over 10,000 residents, treatment costs around $500/lb P. For towns between 1,000 and
                 10,000, the cost is around $1,000/lb P. For towns smaller than 1,000 people, the cost is around $1,500/lb P."),
                 h3("In our example with a town of about 2,500, it would cost around $1,000/lb P. Our 102.8 acre field is delivering 735 lb P/year
                 to the nearby stream."),
                 br(),
                 h3(HTML("To remove an equivalent amount of P would cost the town around <b>$735,000</b>")),
                 br(),
                 actionButton("sampleImportanceButton", "Next"))
              ),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )),
      # sample compare-------------------
      tabItem(tabName = "sampleCompare",
              fluidRow(
                column(9,
                       h2(strong("Let's compare scenarios to see how much phosphorus is reduced with different crop rotations and management practices")),
                       hr(style = "margin-top:0px"),
                       fluidRow(
                         column(6,
                                div(style = "font-size:16px",
                                selectInput(inputId = "samplePractices", label = "Practices",
                                            choices = c("", "Corn-soy, spring tillage, small grain cover",
                                                        "Corn-soy, no-till, no cover",
                                                        "Corn-soy, no-till, small grain cover",
                                                        "Pasture, managed grazing"))),
                                br(),
                                br(),
                                actionButton("compareButton", "Next")),
                         column(6,
                                span(textOutput("compare1text"), style = "font-size:22px; font-family:arial; font-style:italic"),
                                br(),
                                span(textOutput("compare2text"), style = "font-size:22px; font-family:arial; font-style:italic"),
                                br(),
                                span(textOutput("compare3text"), style = "font-size:22px; font-family:arial; font-style:italic")),
                                ))),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )),
      # paying---------------
      tabItem(tabName = "paying",
              fluidRow(
                column(9,
                       h2(strong("Using public funds to help transition more acres to conservation practices saves money")),
                       hr(style = "margin-top:0px"),
                       br(),
                       h3(HTML("We're paying for clean water <i>one way or another</i>.")),
                       h3("That's why it makes so much sense for our elected officials to support farmers 
                          as they transition to conservation practices."),
                      br(),
                      br(),
                      actionButton("payingButton", "Next"))),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )),
      # context2----------------
      tabItem(tabName = "context2",
              fluidRow(
                column(9,
                       h2(strong("It's not just phosphorus...")),
                       hr(style = "margin-top:0px"),
                       h3("We just looked at one narrow slice of the benefits to society of agriculture conservation 
                 programs."),
                 h3("The same practices that reduce phosphorus runoff can also:"),
                 br(),
                 fluidRow(
                   column(6,
                          div(style = "font-size:18px",
                              tags$li(HTML("Reduce <b>nitrate leaching</b>. Nitrate pollution in drinking water may cost Wisconsin up 
                      to $80 million in medical expenses, $14 million in lost earnings due to colorectal 
                      cancer attributed to nitrates, and $8 million of caretaker time.")),
                      br(),
                      tags$li(HTML("Increase <b>carbon sequestration</b> to help mitigate climate change and help farmers be more 
                      resilient to weather extremes. <i>Crop insurance costs are estimated to rise by 29% in the 
                      next decade. In 2023, Wisconsin farms received $252 million in crop insurance subsidies 
                      and $17.8 million in disaster relief programs</i>.")),
                      br(),
                      tags$li(HTML("Increase <b>water infiltration</b> and reduce flood risk. </i>One study shows that every $1 spent 
                      on pre-disaster mitigation saves $4-7 in disaster relief. Wisconsin had 17 “billion-dollar
                      disasters” from 2021-2023</i>.")))),
                   column(3,
                          tags$img(src = "bankErosion.png", height = "250px"),
                          tags$figcaption("A road washed out after flooding in Vermont, 2023"))
                 ),
                 br(),
                 actionButton("context2Button", "Next"))
              ),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              )
      ),
      # share2-------------------------
      tabItem(tabName = "share2",
              fluidRow(
                column(9,
                       h2(strong("Help spread the word and build support for important conservation programs like EQIP, CSP, county conservation,
                        and many others")),
                       hr(style = "margin-top:0px"),
                       h3("Share this story! Click the download button and then upload the photos on social media."),
                       h4("Be sure to tag us!"),
                       h4("IG: ", tags$a(href="https://www.instagram.com/michael_fields_ag/#", "@michael_fields_ag")),
                       h4("FB: ", tags$a(href="https://www.facebook.com/MichaelFieldsAgriculturalInstitute", "@Michael Fields Agricultural Institute")),
                       h4("We love to see your stories!"), 
                       br(),
                       imageOutput("img2_a"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img2_b"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img2_c"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img2_d"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img2_e"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       imageOutput("img2_f"),
                       br(), br(),br(),br(),br(),br(),br(),br(),
                       downloadButton(outputId = "downloadImage2"))
              ),
              fluidRow(
                column(width = 3,
                       tags$img(src = "MFAI Logo Black Transparent .png", height = "200px"))
              ))
    )
  )
)

  