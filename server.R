
server <- function(input, output, session) { # this is an edit
  
  #Disable menuitem when the app loads--------
  addCssClass(selector = "a[data-value='myP']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='importance']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='publicProgram']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='context']", class = "inactiveLink")
  addCssClass(selector = "a[data-value='share']", class = "inactiveLink")
  # addCssClass(selector = "a[data-value='share2']", class = "inactiveLink")
  
  # practices tab----------------
  edgeOfFieldPsav <- reactiveVal()
  
  observeEvent(input$selfData, {
    #toggleElement("ownerLand", "open")
    updateTabItems(session, "tabs", "practices")
    js$activateTab("ownerLand")
  })
  
  shinyjs::disable("practiceButton")
  
  observeEvent(list(input$prePloss, input$newPloss), {
    
    # req(input$acres)
    # req(input$newPractice)
    # req(input$prePloss)
    # req(input$newPloss)
    psav <- round((input$prePloss - input$newPloss)/1.2, 1)
    edgeOfFieldPsav(psav)
    #shinyjs::enable("practiceButton")
    
    output$edgeOfFieldText <- renderText({
      
      paste("My new practices save", edgeOfFieldPsav(), "lbs of phosphorus per acre from leaving my fields.")
      
    })

  }, ignoreInit = TRUE)
  
  observe({
    req(input$acres)
    req(input$newPractice)
    req(input$prePloss)
    req(input$newPloss)
    
    shinyjs::enable("practiceButton")
  })
  
  observeEvent(input$practiceButton, {
    
    updateTabItems(session, "tabs", "myP")
    removeCssClass(selector = "a[data-value='myP']", class = "inactiveLink")
    
  })
  
  # myP tab--------------------------------
  shinyjs::disable("myPbutton")
  observe({
    input$slope
    input$streamDist
    if(input$slope != " " & input$streamDist != " "){
  #observeEvent(list(input$slope, input$streamDist), {
      print(input$slope)
      print(input$streamDist)
    

      req(input$slope)
      req(input$streamDist)
      shinyjs::enable("myPbutton")
      TPdeliveryFactor <- filter(tpfact, domSlope == input$slope, distStream == input$streamDist)$tpfactor
      pCreditAc <- edgeOfFieldPsav() * TPdeliveryFactor
      pCreditTotalArea <- pCreditAc * input$acres
    
      output$myPtext <- renderText({
      
        paste0("That means that ", TPdeliveryFactor*100, "% of P that leaves my field ends up in the nearby surface water. My conservation practices save ",
              format(pCreditAc, big.mark = ","), " lbs P/acre from entering surface water, and a total of ", format(pCreditTotalArea, big.mark = ","),
              " lbs P/year for the total acreage.")
      })
    }
   
  }) 
  #}, ignoreInit = TRUE)
  
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
  #observeEvent(input$reimbursement, {
  observe({
     
    req(input$program)
    req(input$reimbursement)

    shinyjs::enable("publicProgramButton")
   
    reimbursed <- input$reimbursement * input$acres
    projectPsavings <- edgeOfFieldPsav()*input$acres
    conservationCost <- reimbursed/projectPsavings ##TODO check that this is the function?
    percentPay <- 100*(conservationCost/savings()) ##TODO check that this is the function?
    percentPay(percentPay)
    #the cost/lb P is off. Its dividing the cost for the total project 
    #(40 acres at $25/acre) by the P savings from one acre (4 lbs) 
    #instead of the P savings for the whole project (160 lbs).
    
    #programs <- input$program
    #print(programs)
    #print(length(programs))
    programName <- if(input$program == "Other") {
      input$otherProgramName
    } else (input$program)

    output$moneyBack <- renderText({

      paste0("The ", programName, " reimbursed me a total of $", format(reimbursed, big.mark = ","),
             ". The phosphorus reduction from the conservation program cost $", format(round(conservationCost,2), big.mark = ","), "/lb P.
             That is ", round(percentPay, 2), "% of what ", input$town, " pays to remove P from wastewater.")
    })

  })#, ignoreInit = TRUE)
  
  output$otherProgram <- renderUI({
    
    req(input$program == "Other")
    
    textInput(inputId = "otherProgramName", label = "Write in program name")
    
  })
  
  
  #postText4 <- reactiveVal()
  
  observeEvent(input$publicProgramButton, {
    
    updateTabItems(session, "tabs", "context")
    removeCssClass(selector = "a[data-value='context']", class = "inactiveLink")
    removeCssClass(selector = "a[data-value='share']", class = "inactiveLink")
    
  })

  # text reactive vals--------------
  postText1_1 <- reactiveVal()
  postText2_1 <- reactiveVal()
  postText3_1 <- reactiveVal()
  
  observe({
    if(input$slope != " " & input$streamDist != " " & !is.na(input$acres) & 
       !is.na(input$reimbursement) & input$program != " "){ 
    
    programName <- if(input$program == "NRCS Agricultural Conservation Easement Program (ACEP)") { 
      "ACEP" }else if(input$program == "NRCS Conservation Reserve Enhancement Program (CREP)") {
        "CREP"} else if(input$program == "NRCS Conservation Reserve Program (CRP)") {
          "CRP"} else if(input$program == "NRCS Conservation Stewardship Program (CSP)") {
            "CSP"} else if(input$program == "NRCS Environmental Quality Incentives Program (EQIP)") {
              "EQIP"} else if(input$program == "Other") {
                input$otherProgramName} else {
                  input$program}
    print(programName)
    TPdeliveryFactor <- filter(tpfact, domSlope == input$slope, distStream == input$streamDist)$tpfactor
    pCreditAc <- edgeOfFieldPsav() * TPdeliveryFactor
    pCreditTotalArea <- pCreditAc * input$acres
    netSavTransAcres <- savings() * pCreditTotalArea
    programCost <- input$reimbursement * input$acres

    postText1_1(paste("I used", programName, "to transition", input$acres, "acres to", tolower(input$newPractice),
                    "and reduced my phosphorus footprint by", edgeOfFieldPsav(), "lbs/acre."))

    postText2_1(paste0(str_to_title(input$town), ", near our farm, pays around $", format(savings(), big.mark = ","), "/lb to remove
                     P from wastewater before it enters back into waterways"))

    postText3_1(paste0("Preventing P runnoff on my farm using ", programName, " cost $", format(programCost, big.mark = ","),
                     ". That's just ", round(percentPay(), 2), "% of the cost of municipal P treatment."))
    }

  })

  #share tab------------------------------
  ##blank images----------------
  image1 <- reactiveVal("www/slide1.png")
  
  imageVal1 <- reactive({
    image_convert(image_read(image1()), "jpeg") %>%
    image_scale("550")
  })
  
  image2 <- reactiveVal("www/slide2.png")
  
  imageVal2 <- reactive({
    image_convert(image_read(image2()), "jpeg") %>%
      image_scale("550")
  })
  
  image3 <- reactiveVal("www/slide3.png")
  
  imageVal3 <- reactive({
    image_convert(image_read(image3()), "jpeg") %>%
      image_scale("550")
  })
  
  image4 <- reactiveVal("www/slide4.png")
  
  imageVal4 <- reactive({
    image_convert(image_read(image4()), "jpeg") %>%
      image_scale("550")
  })
  

  # image logic-------------------
  ##slide1--------------------------
  updatedImageLoc1_a <- reactive({
    ## retrieve the imageVal
    image1 <- imageVal1()
    
    wrapped_text1 <- stringr::str_wrap(postText1_1(), width = 23)
    
    # addText
    tmpfile1 <- image1 %>%
      image_annotate(text = wrapped_text1, color = "white", weight = 700, #, location = "+15+40"
                     font = "Helvetica", size = 34, gravity = "west", location = "+80-0") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile1
  })
  
  ##slide2--------------
  updatedImageLoc1_b <- reactive({
    ## retrieve the imageVal
    image2 <- imageVal2()
    
    wrapped_text2 <- stringr::str_wrap(postText2_1(), width = 30)
    wrapped_text3 <- stringr::str_wrap(postText3_1(), width = 30)
    
    # addText
    tmpfile2 <- image2 %>%
      image_annotate(text = wrapped_text2, color = "white", weight = 700,
                     font = "Helvetica", size = 26, location = "+75+90") %>%
      image_annotate(text = wrapped_text3, color = "#ffbd59", weight = 700, 
                     font = "Helvetica", size = 24, location = "+75+265") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile2
  })
  
  ##slide3---------------
  updatedImageLoc1_c <- reactive({
    ## retrieve the imageVal
    image3 <- imageVal3()
    
    # slide3 <- "We’re paying for clean water one way or another.
    # That’s why it makes so much sense for elected officials to support farmers
    # like me as we transition to conservation practices like managed grazing!"
    # wrapped_text3 <- stringr::str_wrap(slide3, width = 35)
    
    # addText
    tmpfile3 <- image3 %>%
      # image_annotate(text = wrapped_text3, color = "black", weight = 400,
      #                font = "Helvetica", size = 24, location = "+40+150") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile3
  })
  
  ##slide4--------------
  updatedImageLoc1_d <- reactive({
    ## retrieve the imageVal
    image4 <- imageVal4()

    # slide4a <- "I calculated this data using the new MFAI Phosphorus Calculator"
    # slide4b <- "Learn more and make your own calculations at michaelfields.org/phosphorus "
    # wrapped_text4a <- stringr::str_wrap(slide4a, width = 38)
    # wrapped_text4b <- stringr::str_wrap(slide4b, width = 38)
    
    # addText
    tmpfile4 <- image4 %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    ## return only the tmp file location
    tmpfile4
  })
  
  # render images-------------------
  observeEvent(input$contextButton, {
    
    updateTabItems(session, "tabs", "share")
    removeCssClass(selector = "a[data-value='share']", class = "inactiveLink")
    
  })
  
  observe({ ##TODO change so that observeEvents are for tabUpdates and observe does the work
    if(input$tabs == "context") {
  
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
    }
    
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
  #postText1_2 <- reactiveVal()
  #postText2_2 <- reactiveVal()
  #postText3_2 <- reactiveVal()
  
  # sample practices----------------
  shinyjs::disable("compareButton")
  observeEvent(input$samplePractices, {
    
    newPractice <- filter(dropdownOptions, practice == input$samplePractices) 
    pSave <- newPractice$Psaved
    samplePsave(pSave)
    
    shinyjs::enable("compareButton")
    removeCssClass(selector = "a[data-value='share2']", class = "inactiveLink")
    
    output$compare1text <- renderText({
      
      paste("Transitioning from corn/soy, spring cultivation, no cover crop to", tolower(input$samplePractices), "saves",
             pSave, "lbs P/acre.")
      
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
    
    # # text for sample photos
    # postText1_2(paste("Transitioning from corn/soy, spring cultivation, no cover crop to", tolower(input$samplePractices), "saves",
    #                   pSave, "lbs P/acre.")) 
    # 
    # postText2_2(paste0("Using a contract from NRCS Environmental Quality Incentives Program to do ", practiceAbbr, " costs $",
    #                    format(cost, big.mark = ","), "."))
    # 
    # postText3_2(paste0("Compared to the nearby town's wastewater treatment cost of $1,000/lb P, the EQIP program cost just ",
    #                     round(compare,2), "% of the treatment cost."))
    
    
  }, ignoreInit = TRUE)
  
  observeEvent(input$compareButton, {
    updateTabItems(session, "tabs", "paying")
  })
  
  observeEvent(input$payingButton, {
    updateTabItems(session, "tabs", "context2")
  })
  #share 2 tab------------------------------
  ##sample images----------------
  sample1 <- reactiveVal("www/sample1.png")
  
  imageSample1 <- reactive({
    image_convert(image_read(sample1()), "jpeg") %>%
      image_scale("550") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
  })
  
  sample2 <- reactiveVal("www/sample2.png")
  
  imageSample2 <- reactive({
    image_convert(image_read(sample2()), "jpeg") %>%
      image_scale("550") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
  })
  
  sample3 <- reactiveVal("www/sample3.png")
  
  imageSample3 <- reactive({
    image_convert(image_read(sample3()), "jpeg") %>%
      image_scale("550") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
  })
  
  sample4 <- reactiveVal("www/sample4.png")
  
  imageSample4 <- reactive({
    image_convert(image_read(sample4()), "jpeg") %>%
      image_scale("550") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
  })
  
  sample5 <- reactiveVal("www/sample5.png")
  
  imageSample5 <- reactive({
    image_convert(image_read(sample5()), "jpeg") %>%
      image_scale("550") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
  })
  
  sample6 <- reactiveVal("www/sample6.png")
  
  imageSample6 <- reactive({
    image_convert(image_read(sample6()), "jpeg") %>%
      image_scale("550") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
  })
  
  
  observeEvent(input$context2Button, {
    
    updateTabItems(session, "tabs", "share2")
    #removeCssClass(selector = "a[data-value='share2']", class = "inactiveLink")
    
  })
  
  output$img2_a <- renderImage(
    {
      # Return a list
      list(src = imageSample1(), contentType = "image/jpeg")
    }, 
    ## DO NOT DELETE THE FILE!
    deleteFile = FALSE
  )
  
  output$img2_b <- renderImage(
    {
      # Return a list
      list(src = imageSample2(), contentType = "image/jpeg")
    }, 
    ## DO NOT DELETE THE FILE!
    deleteFile = FALSE
  )
  
  output$img2_c <- renderImage(
    {
      # Return a list
      list(src = imageSample3(), contentType = "image/jpeg")
    }, 
    ## DO NOT DELETE THE FILE!
    deleteFile = FALSE
  )
  
  output$img2_d <- renderImage(
    {
      # Return a list
      list(src = imageSample4(), contentType = "image/jpeg")
    }, 
    ## DO NOT DELETE THE FILE!
    deleteFile = FALSE
  )
  
  output$img2_e <- renderImage(
    {
      # Return a list
      list(src = imageSample5(), contentType = "image/jpeg")
    }, 
    ## DO NOT DELETE THE FILE!
    deleteFile = FALSE
  )
  
  output$img2_f <- renderImage(
    {
      # Return a list
      list(src = imageSample6(), contentType = "image/jpeg")
    }, 
    ## DO NOT DELETE THE FILE!
    deleteFile = FALSE
  )
  
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
      sample5_path <- file.path(temp_dir, "sample5.png")
      sample6_path <- file.path(temp_dir, "sample6.png")
      
      # Copy the images to the temporary directory
      file.copy(imageSample1(), sample1_path)
      file.copy(imageSample2(), sample2_path)
      file.copy(imageSample3(), sample3_path)
      file.copy(imageSample4(), sample4_path)
      file.copy(imageSample5(), sample5_path)
      file.copy(imageSample6(), sample6_path)
      
      # Create zip file
      orig_wd <- getwd()
      setwd(temp_dir)
      zip(zipfile = file, files = c("sample1.png", "sample2.png", "sample3.png", "sample4.png",
                                    "sample5.png", "sample6.png"))
      setwd(orig_wd)
    }
  )
  
}