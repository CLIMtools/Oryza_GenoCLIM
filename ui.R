library(scales)
library(shiny)
library(shinyalert)
library(DT)
library(ggplot2)
library(dplyr)
library(readr)
library(ggrepel)
library(plotly)
library(shinythemes)
library(shinyjs)
library(ggdark)
library(shinycssloaders)
library(jquerylib)
library(shinydashboard)
library(RSQLite)
library(sqldf)
library(feather)

shinyUI(fluidPage(
  
  # Add Javascript
  tags$head(
    tags$link(rel="stylesheet", type="text/css",href="style.css"),
    tags$head(includeScript("google-analytics.js")),
    tags$script('!function(d,s,id){var js,fjs=d.getElementsByTagName(s)    [0],p=/^http:/.test(d.location)?\'http\':\'https\';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");')
    
  ),
  useShinyjs(),
  
  uiOutput("app"),
  headerPanel(
    list(
      tags$head(tags$style("body {background-color: white;}")),
      HTML(
        '<div style="display: flex; align-items: center; height: 200px;">
        <img src="Oryza_GenoCLIM_logo.png" height="150px" style="float:left"/>
        <div style="display: flex; flex-direction: column;">
          <p style="color: blue; font-size: 60px;">Oryza GenoCLIM</p>
          <p style="color: black; font-size: 30px;">Find Your Gene’s Environmental Association</p>
        </div>
      </div>'
      )
    )
  )
  
  ,
  
  theme = shinytheme("readable") , 
  
  tabsetPanel(              
    tabPanel(type = "pills", title = "Find your gene",( sidebarLayout(
    sidebarPanel(
      wellPanel(a(h4(radioButtons("dataset", "Dataset:",
                   c("Indica" = "Indica_merged_final",
                     "Japonica" = "Japonica_merged_final")),
      inline = TRUE, 
      textInput("locus_id", "Filter by Locus ID. The GxE information for your gene of interest will be displayed in the data table and the reactive plot underneath."),
  
      radioButtons("fdr_threshold", "FDR Threshold:",
                   c("0.001"= 0.001,"0.005" = 0.005, "0.01" = 0.01), selected = 0.01),
      downloadButton("download_data", "Download GxE")))),
      wellPanel(a(div(id = "snpfold_info", style = "display: none;",
                      h4("SNPfold Correlation Coefficient (SNPfold CC)"),
                      h6(style = "text-align: justify;",
                         "The SNPfold algorithm (Halvorsen et al., 2010) considers the ensemble of structures predicted by the RNA partition functions of RNAfold (Bindewald & Shapiro, 2006) for each reference and alternative sequence and quantifies structural differences between these ensembles by calculating a Pearson correlation coefficient on the base-pairing probabilities between the two sequences. The closer this correlation coefficient is to 1, the less likely it is that the RNA structure is changed by the SNP. The creators of SNPfold note (Corley et al., 2015) that for genome-wide prediction, the bottom 5% of the correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.445) are most likely to be riboSNitches and the top 5% of correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.99) are most likely to be non-riboSNitches. Correlation coefficients are provided for all SNPs within protein-coding genes, unless the SNP was located < 40 nt from a transcript end, in which case the correlation coefficient is indicated as “not calculated.” The correlation coefficient for SNPs within upstream regions are indicated as “non applicable.”"),
                      h6("-Halvorsen M, Martin JS, Broadaway S, Laederach A. Disease‐associated mutations that alter the RNA structural ensemble. PLoS Genet. 2010;6:e1001074."),
                      h6("-Bindewald, E, & Shapiro, BA. RNA secondary structure prediction from sequence alignments using a network of k-nearest neighbor classifiers. Rna. 2006;12:342-352.")
      ),
      
      # Add a button to toggle the visibility of the div

      actionButton("toggle_snpfold_info", 
                   label = HTML("<p style='color:white; font-size:16px; display: inline-block; white-space: normal; overflow: hidden; text-overflow: clip; max-width: 100%;'>What is the SNPfold Correlation Coefficient?</p>"), 
                   style = "background-color: blue; width:100%; padding: 10px")
      ,
      
      
      # Use JavaScript/jQuery to toggle the visibility of the div when the button is clicked
      tags$script(
        "$(document).on('click', '#toggle_snpfold_info', function() {
     $('#snpfold_info').toggle();
   });"
      ))
),
      wellPanel(a("Tweets by @ClimTools", class="twitter-timeline"
                  , href = "https://twitter.com/ClimTools"), style = "overflow-y:scroll; max-height: 1000px"
      ),
      wellPanel( h6('Contact us: clim.tools.lab@gmail.com')), wellPanel(tags$a(div(
        img(src = 'github.png',  align = "middle"), style = "text-align: center;"
      ), href = "https://github.com/CLIMtools/"))
   ,
    
      uiOutput("col_selector"),
      uiOutput("color_selector")
    ),
    
    mainPanel(tags$style(type="text/css",
                         ".shiny-output-error { visibility: hidden; }",
                         ".shiny-output-error:before { visibility: hidden; }"
    ),
    
    # Create a new row for the table.
    
    fixedRow(column(12,h4("Mouse-over column names and wait for the pop-up for a more detailed description of variables"),
      dataTableOutput("table"), plotlyOutput("scatter_plot", width = '100%',)
    )))
  )
)), 
tabPanel(title = "Description of climate variables",  mainPanel(fixedRow(
  width = 12,
  withSpinner(DT::dataTableOutput("a"))
))),

tabPanel(title = "About",  mainPanel(
  h1(div("About Oryza GenoCLIM", style = "color:blue; text-align: center; font-family: Arial, sans-serif;")), 
  h3(div("Oryza GenoCLIM is an SHINY component of CLIMtools V2.0, that provides an intuitive tool to explore the environmental variation associated to any gene or variant of interest in Arabidopis.", 
         style = "color:grey; text-align: justify; font-family: Arial, sans-serif;")),
  h3(div("Oryza GenoCLIM allows the user to input the locus ID, genetic position or keyword within a particular locus description to explore its association with any oif the multiple environmental variables available from CLIMtools.", 
         style = "color:grey; text-align: justify; font-family: Arial, sans-serif;")),
  div(style = "display: flex; justify-content: center;",
      tags$a(img(src='climtools.png', width = 150, height = 150, style="margin-right: 10px; border: 1px solid black;"), href="http://www.personal.psu.edu/sma3/CLIMtools.html"),
      tags$a(img(src='PSU.png', width = 250, height = 150, style="margin-right: 10px; border: 1px solid black;"), href="http://www.personal.psu.edu/sma3/CLIMtools.html"),
      tags$a(img(src='Gramene.jpg', width = 250, height = 150, style="margin-right: 10px; border: 1px solid black;"), href="https://www.gramene.org/")
  )
))

  )
))


