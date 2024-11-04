library(shiny)
library(tidyverse)
library(shinydashboard)
library(dashboardthemes)
library(bslib)
library(base64enc)
library(shinyBS)
library(shinyjs)
library(magick)
library(stringr)

#https://forum.posit.co/t/r-shiny-app-gallery-app-that-lets-user-upload-multiple-images-and-display-them-dynamically-multiple-images-like-a-grid/30288

#https://forum.posit.co/t/download-the-output-of-shiny-with-the-download-button/24517/2


tpfact <- read_csv("data/TPdelivery.csv") %>%
  mutate_if(is.character, as.factor)

dropdownOptions <- read_csv("data/sampleData.csv", na = "na")%>%
  mutate_if(is.character, as.factor)

#options(shiny.maxRequestSize = 30*1024^2)
conservationProgramNames <- c(" ", "County Conservation Practice Cost-share", "NRCS Agricultural Conservation Easement Program (ACEP)", 
                              "NRCS Conservation Reserve Enhancement Program (CREP)", "NRCS Conservation Reserve Program (CRP)",
                              "NRCS Conservation Stewardship Program (CSP)", "NRCS Environmental Quality Incentives Program (EQIP)",
                              "WI DATCP Producer-Led Watershed Protection Grants","WI Farmland Preservation Program", "WI Water Quality Trading",
                              "Other")


jsCode <- "
shinyjs.disableTab = function() {
    var tabs = $('#tabs').find('li:not(.active) a');
    tabs.bind('click.tab', function(e) {
        e.preventDefault();
        return false;
    });
    tabs.addClass('disabled');
}
shinyjs.enableTab = function(param) {
    var tab = $('#tabs').find('li:not(.active):nth-child(' + param + ') a');
    tab.unbind('click.tab');
    tab.removeClass('disabled');
}"







