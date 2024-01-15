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
library(shinyWidgets)

shinyUI(fluidPage(
    tags$head(includeHTML("google-analytics.html"),
    tags$link(rel="stylesheet", type="text/css",href="style.css"),
    tags$script('!function(d,s,id){var js,fjs=d.getElementsByTagName(s)    [0],p=/^http:/.test(d.location)?\'http\':\'https\';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");')
    
  ),
  # Add custom CSS to style the horizontal scroll bar
  tags$style(HTML("
  /* Custom CSS for DataTable horizontal scroll bar */
  .dataTables_wrapper {
    overflow-x: auto;
  }
  .dataTables_scrollHeadInner, .dataTables_scrollBody {
    width: 100% !important;
  }
  .dataTables_scrollHeadInner table, .dataTables_scrollBody table {
    width: 100%;
  }
  ::-webkit-scrollbar {
    height: 12px;
    width: 12px;
  }
  ::-webkit-scrollbar-thumb {
    background-color: black; /* Change to the desired color */
  }
  /* Style for the scrollbar in the top of the table */
  .dataTables_scrollHead::-webkit-scrollbar,
  .dataTables_scrollHead::before {
    height: 12px;
    width: 12px;
  }
  .dataTables_scrollHead::-webkit-scrollbar-thumb,
  .dataTables_scrollHead::before {
    background-color: black; /* Change to the desired color */
  }
  
  /* Additional styles for the table */
  .dataTables_wrapper {
    font-family: 'Arial', sans-serif;
  }
  .dataTables_wrapper table {
    border-collapse: collapse;
    width: 100%;
    margin: 0 auto;
    clear: both;
  }
  .dataTables_wrapper thead th {
    background-color: #3498db; /* Blue header color */
    color: #fff; /* White text color */
    font-weight: bold;
  }
  .dataTables_wrapper tbody td {
    padding: 8px;
    text-align: center;
  }
  .dataTables_wrapper tbody tr:nth-child(even) {
    background-color: #f2f2f2; /* Alternate row color */
  }
  .dataTables_wrapper tbody tr:hover {
    background-color: #d1e0e0; /* Hovered row color */
  }
"))
  
  ,
  useShinyjs(),
  
  uiOutput("app"),
  headerPanel(
    list(
      tags$head(
        tags$style(
          "body {background-color: white;}",
          ".app-header {background-color: #3498db; padding: 50px;}",
          ".app-title {color: white; font-size: 80px; margin-bottom: 10px;}",
          ".app-subtitle {color: #2c3e50; font-size: 30px;}"
        )
      ),
      HTML(
        '<div class="app-header">
        <img src="Oryza_GenoCLIM_logo2.png" height="225px" style="float:left; margin-left: -50px; margin-top: -40px;"/>
        <div style="display: flex; flex-direction: column; margin-left: 10px;">
          <p class="app-title">Oryza GenoCLIM</p>
          <p class="app-subtitle">Find Your Gene’s Environmental Association</p>
        </div>
      </div>'
      )
    )
  ),
  theme = shinytheme("readable") , 
    tabsetPanel(              
    tabPanel(type = "pills", title = "Find your gene",( sidebarLayout(
    sidebarPanel(wellPanel(a(h4(radioButtons("dataset", "Dataset:",
                   c("Indica" = "Indica_merged_final",
                     "Japonica" = "Japonica_merged_final")),
      inline = TRUE, 
      wellPanel(a(HTML("<p style='text-align: center; font-size: 15px;'>Filter by Locus ID. The GxE information for your gene of interest will be displayed in the data table and the reactive plot underneath.</p>"),
      textInput("locus_id", label = NULL, width = "100%", placeholder = "Enter Locus ID (RAP)"))),
      radioButtons("fdr_threshold", "FDR Threshold:",
                   c("0.001"= 0.001,"0.005" = 0.005, "0.01" = 0.01), selected = 0.01),
      downloadButton("download_data", "Download GxE (.csv)")))),
      wellPanel(a(h4("Considerations before using this tool", style = "font-size: 14px; color: white;"), href = "Considerations.pdf"),  style = "background-color: #3498db; padding: 11px;color: white;"
      ),
      wellPanel(a(h4("Methodology", style = "font-size: 14px; color: white;"), href = "Methodology.pdf"),
                style = "background-color: #3498db; padding: 10px; color: white;"
      ),
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
                   style = "background-color: #3498db; width:100%; padding: 10px")
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


