
server <- function(input, output, session) {
  
  #Disable menuitem when the app loads--------
  addCssClass(selector = "a[data-value='myP']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='importance']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='publicProgram']", class = "inactiveLink")
  #addCssClass(selector = "a[data-value='context']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='share']", class = "inactiveLink")
  
  # practices tab----------------
  edgeOfieldPsav <- reactiveVal()
  
  observeEvent(input$selfData, {
    updateTabItems(session, "tabs", "practices")
  })
  
  shinyjs::disable("practiceButton")
  observeEvent(input$prePloss | input$newPloss, {
    
    edgeOfieldPsav(input$prePloss - input$newPloss)
    shinyjs::enable("practiceButton")
    
    output$edgeOfFieldText <- renderText({
      
      paste("My new practices save", input$prePloss - input$newPloss, "lbs of phosphorus per acre from leaving my fields.")
      
    })

  }, ignoreInit = TRUE)
  
  observeEvent(input$practiceButton, {
    
    updateTabItems(session, "tabs", "myP")
    removeCssClass(selector = "a[data-value='myP']", class = "inactiveLink")
    
  })
  
  # myP tab--------------------------------
  shinyjs::disable("myPbutton")
  observeEvent(list(input$slope, input$streamDist), {
    
    shinyjs::enable("myPbutton")
    TPdeliveryFactor <- filter(tpfact, domSlope == input$slope, distStream == input$streamDist)$tpfactor
    pCreditAc <- edgeOfieldPsav() * TPdeliveryFactor
    pCreditTotalArea <- pCreditAc * input$acres
    
    output$myPtext <- renderText({
      
      paste0("That means that ", TPdeliveryFactor*100, "% of P that leaves my field ends up in the nearby surface water. My conservation practices save ",
            format(pCreditAc, big.mark = ","), " lbs P/acre from entering surface water, and a total of ", format(pCreditTotalArea, big.mark = ","),
            " lbs P/year for the total acreage.")
      
    })
    
  }, ignoreInit = TRUE)
  
  observeEvent(input$myPbutton, {
    
    updateTabItems(session, "tabs", "importance")
    removeCssClass(selector = "a[data-value='importance']", class = "inactiveLink")
    
  })
  
  #importance tab-------------------------
  shinyjs::disable("importanceButton")
  savings <- reactiveVal()
  observeEvent(input$population, {
    
    shinyjs::enable("importanceButton")
    savings <- if(input$population > 9999) {500} else
      if(input$population > 999) {1000} else
        if(input$population > 0) {1500}
    savings(savings)
    
    output$townPays <- renderText({
      
      paste0("My nearest municipality will likely pay around $", format(savings, big.mark = ","), " lb/P to remove P from wastewater.")
      
    })
    
  }, ignoreInit = TRUE)
  
  observeEvent(input$importanceButton, {
    
    updateTabItems(session, "tabs", "publicProgram")
    removeCssClass(selector = "a[data-value='publicProgram']", class = "inactiveLink")
    
  })
  
  # publicProgram tab------------------------
  percentPay <- reactiveVal()
  shinyjs::disable("publicProgramButton")
  observeEvent(input$reimbursement, {

    shinyjs::enable("publicProgramButton")
   
    reimbursed <- input$reimbursement * input$acres
    conservationCost <- reimbursed/(input$prePloss - input$newPloss) ##TODO check that this is the function?
    percentPay <- 100*(conservationCost/savings()) ##TODO check that this is the function?
    percentPay(percentPay)

    output$moneyBack <- renderText({

      paste0("The ", input$program, " reimbursed me a total of $", format(reimbursed, big.mark = ","),
             ". The phosphorus reduction from the conservation program cost $", format(round(conservationCost,2), big.mark = ","), "/lb P.
             That is ", round(percentPay, 2), "% of what ", input$town, " pays to remove P from wastewater.")
    })

  }, ignoreInit = TRUE)
  
  postText1 <- reactiveVal()
  postText2 <- reactiveVal()
  postText3 <- reactiveVal()
  postText4 <- reactiveVal()
  
  observeEvent(input$publicProgramButton, {
    
    updateTabItems(session, "tabs", "context")
    #removeCssClass(selector = "a[data-value='context']", class = "inactiveLink")
    removeCssClass(selector = "a[data-value='share']", class = "inactiveLink")
    
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
    savingsComp <- savings() - dollPerLbAcYr 
    netSavTransAcres <- savings() * pCreditTotalArea
    netSavTranLife <- savings() * pCreditLife
    
    postText1(paste0("Using ", input$program, ", I transitioned ", input$acres, " acres to ", input$newPractice, ".")) 
    
    postText2(paste0("That resulted in ", edgeOfieldPsav," pound P/acre reduction."))
    
    
    postText3(paste0(input$town, ", near our farm, pays around ", format(savings(), big.mark = ","), "/lb P."))
    
    postText4(paste0("That's ", round(percentPay(), 2), "% of the treatment cost."))
    
  })
  

  #share tab------------------------------
  imageLoc <- reactiveVal("www/daylight-environment-fall-259843.jpg")
  
  imageVal <- reactive({
    image_convert(image_read(imageLoc()), "jpeg")
  })
  
  updatedImageLoc <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    
    # addText
    tmpfile <- image %>%
      image_scale("500") %>%
      image_annotate(text = postText1(), color = "white", boxcolor = "black",
                     font = "Helvetica", size = 16, location = "+5+5") %>%
      image_annotate(text = postText2(), color = "white", boxcolor = "black",
                     font = "Helvetica", size = 16, location = "+5+35") %>%
      image_annotate(text = postText3(), color = "white", boxcolor = "black",
                     font = "Helvetica", size = 16, location = "+5+65") %>%
      image_annotate(text = postText4(), color = "white", boxcolor = "black",
                     font = "Helvetica", size = 16, location = "+5+95") %>%
      image_annotate(text = "We're paying for clean water one way or another.", 
                     color = "white", boxcolor = "black",
                     font = "Helvetica", size = 16, location = "+5+125") %>%
      image_annotate(text = "That's why it makes so much sense for our elected officials to",
                     color = "white", boxcolor = "black",
                     font = "Helvetica", size = 16, location = "+5+145") %>%
      image_annotate(text = "support farmers as they transition to conservation practices.",
                     color = "white", boxcolor = "black",
                     font = "Helvetica", size = 16, location = "+5+165") %>%               
      image_annotate(text = "I calculated this from a tool at michaelfields.org/phosphorus.",
                     color = "white", boxcolor = "black", font = "Helvetica", size = 12, location = "+5+240") %>%
      image_annotate(text = "If you’re a farmer you can enter your own data, or you can see a sample scenario. 
                     Help spread the word! @michael_fields_ag",
                     color = "white", boxcolor = "black", font = "Helvetica", size = 12, location = "+5+260") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  
  
  observeEvent(input$contextButton, {
    
    updateTabItems(session, "tabs", "share")
    removeCssClass(selector = "a[data-value='share']", class = "inactiveLink")
    
    # A plot of fixed size
    output$img <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
    
    # output$postText <- renderText({
    #   
    #   HTML(paste0("Conservation programs can help farmers adopt practices that reduce phosphorus runoff. 
    #          Too much phosphorus can cause explosive growth of cyanobacteria (often referred to as blue-green algae) that is 
    #          harmful to humans and causes “dead zones” in the Gulf of Mexico and the Great Lakes. Using ", 
    #          input$program, ", I transitioned ", input$acres, " acres to ", input$newPractice, ". That resulted in ", edgeOfieldPsav, 
    #          " pound P/acre reduction. ", input$town, ", near our farm, pays around ", format(savings(), big.mark = ","), "/lb P. That's ",
    #          round(percentPay(), 2), "% of the treatment cost. We're paying for clean water one way or another. That's why it makes
    #          so much sense for our elected officials to support farmers as they transition to conservation practices. An ounce of 
    #          prevention is worth a pound of cure, and sometimes 2 or 3 pounds! 
    #          <br/> 
    #          I calculated this from a tool at michaelfields.org/phosphorus. If you’re a farmer you can enter your own data, 
    #          or you can see a sample scenario. Help spread the word! @michael_fields_ag"))
    # })
    
  })
  
  output$downloadImage <- downloadHandler(
    filename = "MFAI_image.jpeg",
    contentType = "image/jpeg",
    content = function(file) {
      ## copy the file from the updated image location to the final download location
      file.copy(updatedImageLoc(), file)
    }
  )
  
  observeEvent(input$sampleData, {
    updateTabItems(session, "tabs", "sampleStory1")
  })
}