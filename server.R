
server <- function(input, output, session) { # this is an edit
  
  #Disable menuitem when the app loads--------
  addCssClass(selector = "a[data-value='myP']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='importance']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='publicProgram']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='context']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='share']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='share2']", class = "inactiveLink")
  
  # practices tab----------------
  edgeOfieldPsav <- reactiveVal()
  
  observeEvent(input$selfData, {
    #toggleElement("ownerLand", "open")
    updateTabItems(session, "tabs", "practices")
    js$activateTab("ownerLand")
  })
  
  shinyjs::disable("practiceButton")
  observeEvent(list(input$prePloss, input$newPloss), {
    
    req(input$acres)
    req(input$newPractice)
    req(input$prePloss)
    req(input$newPloss)
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
    
    ##TODO can I get the text to show up after calculations?
    req(input$slope)
    req(input$streamDist)
    shinyjs::enable("myPbutton")
    TPdeliveryFactor <- filter(tpfact, domSlope == input$slope, distStream == input$streamDist)$tpfactor
    pCreditAc <- edgeOfieldPsav() * TPdeliveryFactor
    pCreditTotalArea <- pCreditAc * input$acres
    
    output$myPtext <- renderText({
      
      ##TODO can
      # print(pCreditAc)
      # req(pCreditAc > 0)
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
    
    req(input$program)

    shinyjs::enable("publicProgramButton")
   
    reimbursed <- input$reimbursement * input$acres
    projectPsavings <- (input$prePloss - input$newPloss)*input$acres
    conservationCost <- reimbursed/projectPsavings ##TODO check that this is the function?
    percentPay <- 100*(conservationCost/savings()) ##TODO check that this is the function?
    percentPay(percentPay)
    #the cost/lb P is off. Its dividing the cost for the total project 
    #(40 acres at $25/acre) by the P savings from one acre (4 lbs) 
    #instead of the P savings for the whole project (160 lbs).
    
    programName <- if(input$program == "Other") {
      input$otherProgramName
    } else (input$program)

    output$moneyBack <- renderText({

      paste0("The ", programName, " reimbursed me a total of $", format(reimbursed, big.mark = ","),
             ". The phosphorus reduction from the conservation program cost $", format(round(conservationCost,2), big.mark = ","), "/lb P.
             That is ", round(percentPay, 2), "% of what ", input$town, " pays to remove P from wastewater.")
    })

  }, ignoreInit = TRUE)
  
  output$otherProgram <- renderUI({
    
    req(input$program == "Other")
    
    textInput(inputId = "otherProgramName", label = "Write in program name")
    
  })
  
  # text reactive vals--------------
  postText1_1 <- reactiveVal()
  postText2_1 <- reactiveVal()
  postText3_1 <- reactiveVal()
  #postText4 <- reactiveVal()
  
  observeEvent(input$publicProgramButton, {
    
    updateTabItems(session, "tabs", "context")
    #removeCssClass(selector = "a[data-value='context']", class = "inactiveLink")
    removeCssClass(selector = "a[data-value='share']", class = "inactiveLink")
    
    edgeOfFieldPsav <- input$prePloss - input$newPloss
    TPdeliveryFactor <- filter(tpfact, domSlope == input$slope, distStream == input$streamDist)$tpfactor
    print(TPdeliveryFactor)
    pCreditAc <- edgeOfFieldPsav * TPdeliveryFactor
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
    programCost <- input$reimbursement * input$acres
    
    postText1_1(paste("I used", input$program, "to transition", input$acres, "acres to", input$newPractice, 
                    "and reduced my phosphorus footprint by", edgeOfFieldPsav, "lbs.")) 
    
    postText2_1(paste0(input$town, ", near our farm, pays around $", format(savings(), big.mark = ","), "/lb to remove
                     P from wastewater before it enters back into waterways"))
    
    postText3_1(paste0("Preventing P runnoff on my farm using ", input$program, " cost $", format(programCost, big.mark = ","), 
                     ". That's just ", round(percentPay(), 2), "% of the cost of municipal P treatment."))
    
    
  })

  #share tab------------------------------
  imageLoc <- reactiveVal("www/SharePhoto1.png")
  
  imageVal <- reactive({
    image_convert(image_read(imageLoc()), "jpeg") %>%
    image_scale("550")
  })
  
  imageLoc2 <- reactiveVal("www/MFAI Logo Black Transparent .png")
  ## convert the img location to an img value
  imageVal2 <- reactive({
    image_convert(image_read(imageLoc2()), "jpeg") %>%
      image_scale("150")
  })
  
  observeEvent(input$upload, {
    if (length(input$upload$datapath)) {
      ## set the image location
      imageLoc(input$upload$datapath)
    }
    updateCheckboxGroupInput(session, "effects", selected = "")
  })
  
  observe({
    info <- image_info(imageVal())
    updateTextInput(session, "size", value = paste0(info$width, "x", info$height, "!"))
  })
  
  # image logic-------------------
  updatedImageLoc1_a <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    # if("flip" %in% input$effects)
    #   image <- image_flip(image)
    # 
    # if("flop" %in% input$effects)
    #   image <- image_flop(image)
    
    wrapped_text1 <- stringr::str_wrap(postText1_1(), width = 35)
    
    # addText
    tmpfile <- image %>%
      #image_scale("600") %>%
      # image_scale(input$scale) %>%
      # image_rotate(input$rotation) %>%
      #image_composite(logo, gravity = "southeast", offset = "+20+0") %>%
      image_annotate(text = wrapped_text1, color = "black", weight = 700, #, location = "+15+40"
                     font = "Helvetica", size = 28, gravity = "west", location = "+15-40") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  updatedImageLoc1_b <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    # if("flip" %in% input$effects)
    #   image <- image_flip(image)
    # 
    # if("flop" %in% input$effects)
    #   image <- image_flop(image)
    
    wrapped_text2 <- stringr::str_wrap(postText2_1(), width = 35)
    wrapped_text3 <- stringr::str_wrap(postText3_1(), width = 35)
    
    # addText
    tmpfile <- image %>%
      #image_scale("600") %>%
      # image_scale(input$scale) %>%
      # image_rotate(input$rotation) %>%
      #image_composite(logo, gravity = "southeast", offset = "+20+0") %>%
      image_annotate(text = wrapped_text2, color = "black", weight = 700,
                     font = "Helvetica", size = 24, location = "+20+60") %>%
      image_annotate(text = wrapped_text3, color = "black", weight = 400, 
                     font = "Helvetica", size = 24, location = "+35+275") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  updatedImageLoc1_c <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    # if("flip" %in% input$effects)
    #   image <- image_flip(image)
    # 
    # if("flop" %in% input$effects)
    #   image <- image_flop(image)
    
    slide3 <- "We’re paying for clean water one way or another. 
    That’s why it makes so much sense for elected officials to support farmers 
    like me as we transition to conservation practices like managed grazing!"
    wrapped_text3 <- stringr::str_wrap(slide3, width = 35)
    
    # addText
    tmpfile <- image %>%
      #image_scale("600") %>%
      # image_scale(input$scale) %>%
      # image_rotate(input$rotation) %>%
      #image_composite(logo, gravity = "southeast", offset = "+20+0") %>%
      image_annotate(text = wrapped_text3, color = "black", weight = 400,
                     font = "Helvetica", size = 24, location = "+40+150") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  updatedImageLoc1_d <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    # if("flip" %in% input$effects)
    #   image <- image_flip(image)
    # 
    # if("flop" %in% input$effects)
    #   image <- image_flop(image)
    
    slide4a <- "I calculated this data using the new MFAI Phosphorus Calculator"
    slide4b <- "Learn more and make your own calculations at michaelfields.org/phosphorus "
    wrapped_text4a <- stringr::str_wrap(slide4a, width = 38)
    wrapped_text4b <- stringr::str_wrap(slide4b, width = 38)
    
    # addText
    tmpfile <- image %>%
      #image_scale("600") %>%
      # image_scale(input$scale) %>%
      # image_rotate(input$rotation) %>%
      image_composite(logo, gravity = "southwest", offset = "+20+10") %>%
      image_annotate(text = wrapped_text4a, color = "black", weight = 400,
                     font = "Helvetica", size = 26, location = "+15+75") %>%
      image_annotate(text = wrapped_text4b, color = "black", weight = 400, 
                     font = "Helvetica", size = 26, location = "+15+200") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  # render images-------------------
  observeEvent(input$contextButton, {
    
    updateTabItems(session, "tabs", "share")
    removeCssClass(selector = "a[data-value='share']", class = "inactiveLink")
    # A plot of fixed size
    output$img1_a <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc1_a(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
    output$img1_b <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc1_b(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
    output$img1_c <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc1_c(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
    output$img1_d <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc1_d(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
  })
  
  #download images-----------------------
  output$downloadImage <- downloadHandler(
    filename = "MFAI_image.zip",
    contentType = "application/zip",
    content = function(file) {
      ## copy the file from the updated image location to the final download location
      temp_dir <- tempdir()
      
      # Generate and save the images in the temporary directory
      image1_path <- file.path(temp_dir, "image1.jpeg")
      image2_path <- file.path(temp_dir, "image2.jpeg")
      image3_path <- file.path(temp_dir, "image3.jpeg")
      image4_path <- file.path(temp_dir, "image4.jpeg")
      
      # Copy the images to the temporary directory
      file.copy(updatedImageLoc1_a(), image1_path)
      file.copy(updatedImageLoc1_b(), image2_path)
      file.copy(updatedImageLoc1_c(), image3_path)
      file.copy(updatedImageLoc1_d(), image4_path)
      
      # Create zip file
      orig_wd <- getwd()
      setwd(temp_dir)
      zip(zipfile = file, files = c("image1.jpeg", "image2.jpeg", "image3.jpeg", "image4.jpeg"))
      setwd(orig_wd)
    }
  )
  
  # sample data story-----------------
  observeEvent(input$sampleData, {
    updateTabItems(session, "tabs", "sampleStory1")
    js$activateTab("sampleData")
  })
  
  observeEvent(input$sampleStory1button, {
    updateTabItems(session, "tabs", "sampleField")
  })
  
  observeEvent(input$sampleFieldButton, {
    updateTabItems(session, "tabs", "sampleP")
  })
  
  observeEvent(input$samplePbutton, {
    updateTabItems(session, "tabs", "sampleImportance")
  })
  
  observeEvent(input$sampleImportanceButton, {
    updateTabItems(session, "tabs", "sampleCompare")
  })
  
  # sample compare--------
  ## reactive vals----------
  samplePsave <- reactiveVal()
  sampleCost <- reactiveVal()
  sampleCompareCost <- reactiveVal()
  postText1_2 <- reactiveVal()
  postText2_2 <- reactiveVal()
  postText3_2 <- reactiveVal()
  
  # sample practices----------------
  shinyjs::disable("compareButton")
  observeEvent(input$samplePractices, {
    
    newPractice <- filter(dropdownOptions, practice == input$samplePractices) 
    pSave <- newPractice$Psaved
    samplePsave(pSave)
    
    output$compare1text <- renderText({
      
      paste("Transitioning from corn/soy, spring cultivation, no cover crop to", tolower(input$samplePractices), "saves",
             pSave, "lbs P/acre.")
      
      shinyjs::enable("compareButton")
      removeCssClass(selector = "a[data-value='share2']", class = "inactiveLink")
      
    })
    
    practiceAbbr <- newPractice$practiceShort
    cost <- newPractice$projectCost
    sampleCost(cost)
    print(sampleCost())
    
    output$compare2text <- renderText({
      
      paste0("Using a contract from NRCS Environmental Quality Incentives Program to do ", practiceAbbr, " costs $",
             format(cost, big.mark = ","), ".")

    })
    
    compare <- newPractice$compareCost
    sampleCompareCost(compare)

    output$compare3text <- renderText({
      
      paste0("Compared to the nearby town's wastewater treatment cost of $1,000/lb P, the EQIP program cost just ",
            round(compare,2), "% of the treatment cost.")


    })
    
    # text for sample photos---------------
    postText1_2(paste("Transitioning from corn/soy, spring cultivation, no cover crop to", tolower(input$samplePractices), "saves",
                      pSave, "lbs P/acre.")) 
    
    postText2_2(paste0("Using a contract from NRCS Environmental Quality Incentives Program to do ", practiceAbbr, " costs $",
                       format(cost, big.mark = ","), "."))
    
    postText3_2(paste0("Compared to the nearby town's wastewater treatment cost of $1,000/lb P, the EQIP program cost just ",
                        round(compare,2), "% of the treatment cost."))
    
    
  }, ignoreInit = TRUE)
  
  observeEvent(input$compareButton, {
    updateTabItems(session, "tabs", "paying")
  })
  
  observeEvent(input$payingButton, {
    updateTabItems(session, "tabs", "context2")
  })
  
  updatedImageLoc2_a <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    wrapped_text1_2 <- stringr::str_wrap(postText1_2(), width = 50)
    
    # addText
    tmpfile <- image %>%
      image_composite(logo, gravity = "southeast", offset = "+20+0") %>%
      image_annotate(text = wrapped_text1_2, color = "black", weight = 700,
                     font = "Helvetica", size = 24, location = "+15+40") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  updatedImageLoc2_b <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    wrapped_text2 <- stringr::str_wrap(postText2_2(), width = 55)
    wrapped_text3 <- stringr::str_wrap(postText3_2(), width = 55)
    
    # addText
    tmpfile <- image %>%
      image_composite(logo, gravity = "southeast", offset = "+20+0") %>%
      image_annotate(text = wrapped_text2, color = "black", weight = 700,
                     font = "Helvetica", size = 20, location = "+10+40") %>%
      image_annotate(text = wrapped_text3, color = "black", weight = 400, boxcolor = "#fefefe",
                     font = "Helvetica", size = 20, location = "+10+250") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  updatedImageLoc2_c <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    slide3 <- "We’re paying for clean water one way or another. 
    That’s why it makes so much sense for elected officials to support farmers 
    like me as we transition to conservation practices like managed grazing!"
    wrapped_text3 <- stringr::str_wrap(slide3, width = 55)
    
    # addText
    tmpfile <- image %>%
      image_composite(logo, gravity = "southeast", offset = "+20+0") %>%
      image_annotate(text = wrapped_text3, color = "black", weight = 500,
                     font = "Helvetica", size = 20, location = "+10+50") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  updatedImageLoc2_d <- reactive({
    ## retrieve the imageVal
    image <- imageVal()
    logo <- imageVal2()
    
    slide4a <- "I calculated this data using the new MFAI Phosphorus Calculator"
    slide4b <- "Learn more and make your own calculations at michaelfields.org/phosphorus "
    wrapped_text4a <- stringr::str_wrap(slide4a, width = 55)
    wrapped_text4b <- stringr::str_wrap(slide4b, width = 55)
    
    # addText
    tmpfile <- image %>%
      image_composite(logo, gravity = "southeast", offset = "+20+0") %>%
      image_annotate(text = wrapped_text4a, color = "black", weight = 500,
                     font = "Helvetica", size = 20, location = "+10+75") %>%
      image_annotate(text = wrapped_text4b, color = "black", weight = 500, boxcolor = "#fefefe",
                     font = "Helvetica", size = 20, location = "+10+300") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile
  })
  
  
  observeEvent(input$context2Button, {
    
    updateTabItems(session, "tabs", "share2")
    removeCssClass(selector = "a[data-value='share2']", class = "inactiveLink")
    # A plot of fixed size
    output$img2_a <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc2_a(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
    output$img2_b <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc2_b(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
    output$img2_c <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc2_c(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
    output$img2_d <- renderImage(
      {
        # Return a list
        list(src = updatedImageLoc2_d(), contentType = "image/jpeg")
      }, 
      ## DO NOT DELETE THE FILE!
      deleteFile = FALSE
    )
    
  })
  
  output$downloadImage2 <- downloadHandler(
    filename = "MFAI_sample.zip",
    contentType = "application/zip",
    content = function(file) {
      ## copy the file from the updated image location to the final download location
      temp_dir <- tempdir()
      
      # Generate and save the images in the temporary directory
      sample1_path <- file.path(temp_dir, "sample1.png")
      sample2_path <- file.path(temp_dir, "sample2.png")
      sample3_path <- file.path(temp_dir, "sample3.png")
      sample4_path <- file.path(temp_dir, "sample4.png")
      
      # Copy the images to the temporary directory
      file.copy(updatedImageLoc2_a(), sample1_path)
      file.copy(updatedImageLoc2_b(), sample2_path)
      file.copy(updatedImageLoc2_c(), sample3_path)
      file.copy(updatedImageLoc2_d(), sample4_path)
      
      # Create zip file
      orig_wd <- getwd()
      setwd(temp_dir)
      zip(zipfile = file, files = c("sample1.png", "sample2.png", "sample3.png", "sample4.png"))
      setwd(orig_wd)
    }
  )
  
}