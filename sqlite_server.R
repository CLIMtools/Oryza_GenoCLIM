shinyServer(function(input, output, session) {
    
    input_params <- reactive({
        params <- parseQueryString(session$clientData$url_search)
        list(
            genome = params$genome,
            locus = params$locus
        )
    })
    observe({
        input_values <- input_params()

        if (!is.null(input_values$genome)) {
            updateRadioButtons(session, "dataset", selected = input_values$genome)
        }
        if (!is.null(input_values$locus)) {
            updateTextInput(session, "locus_id", value = input_values$locus)
        }
    })
  descriptiondataset <-read_csv("data/datadescription.csv")
  
  
  
  output$a <- DT::renderDataTable(descriptiondataset, filter = 'top', options = list(
    pageLength = 100, autoWidth = TRUE))
  
  
  # shinyalert("The data will take a minute to load. Please be patient...", timer = 15000,
  #            showConfirmButton = FALSE)
             
  connection <- dbConnect(RSQLite::SQLite(), dbname = "data/geno_data.db")
             
  # Load the selected dataset
  db_table <- reactive({
    switch(input$dataset,           
           "Indica_merged_final" = "indica",
           "Japonica_merged_final" = "japonica"
     )
  })
  fdr_col <- reactive({
      switch(input$fdr_threshold,
          "0.01" = "FDR_01",
          "0.005" = "FDR_005",
          "0.001" = "FDR_001"
          )
  })
  fdr_cols = c("FDR_01", "FDR_005", "FDR_001")
  # Filter the dataset by Locus_ID
  df_fdr_filtered <- reactive({
    table <- db_table()
    col <- fdr_col()
    query <- paste0("SELECT * FROM ",table," WHERE ",col," == 1")
    if (nchar(input$locus_id) > 0) {
        query <- paste0(query," AND Locus_ID == '",input$locus_id,"'")
    }
    query <- paste0(query," LIMIT 10000 OFFSET 0;")
    df <- as.data.frame(dbGetQuery(connection, query))
    df <- df %>%
        select(-one_of(fdr_cols))
    df
  })
    
  
  # Show the selected columns in the data table
output$col_selector <- renderUI({
  print(input$show_columns)  # Add this line for debugging
  if (!is.null(input$show_columns) && input$show_columns == "Selected") {
    checkboxGroupInput("cols", "Select Columns:",
                       colnames(df_fdr_filtered()))
  }
})
  
  # Render the data table
  output$table <- renderDataTable({
    dat <- df_fdr_filtered()
    
    if (nrow(dat) == 0) {
      return(HTML("<h3 style='text-align:center;'>Sorry, we found no significant GxE associations for this gene</h3>"))
    }
    
    # shinyalert("Please wait a few seconds while the table loads...", timer = 2000,
    #            showConfirmButton = FALSE)
    numeric_cols <- sapply(dat, is.numeric)
    dat[, numeric_cols] <- round(dat[, numeric_cols], 3)
    
    if (is.null(input$show_columns) || input$show_columns == "All") {
      datatable(dat, 
                rownames = FALSE, 
                options = list(autoWidth = TRUE, 
                               dom = '<"lfpti"l<"search">rtip>', 
                               pageLength = 5, 
                               lengthMenu = NULL, 
                               scrollX = TRUE,  # Enable horizontal scrolling
                               columnDefs = list(list(className = 'dt-center', targets = "_all"))), callback = JS("
var tips = [ 'Source from which the environmental associated with the SNP was obtained from. See the tab with the description of climate variables for more information' ,'Chromosome', 
            'Position', 
            'Reference allele is a specific version of a genetic variant that is used as a standard of comparison in genetic studies. In this case, the japonica rice cultivar Nipponbare, whose genome has been sequenced and which is most commonly used in functional genomics',
            'The alternative allele is a term used to describe a version of a gene or genetic variant that is different from the reference allele. For example, if the reference allele at a SNP is the A allele, the alternative allele could be the G, C, or T', 
            'Minor allele frequency (MAF) is a measure of the frequency of a less common variant (allele) of a gene in a population. It is calculated as the number of rice varieties with the the minor allele divided by the total number of varieties with either allele (minor and major) at a given locus (position on a chromosome). MAF is an important measure in population genetics, as it provides information about the distribution and frequency of genetic variants in a population. Low MAFs may indicate that a variant is rare or has been recently introduced into the population, while high MAFs may indicate that a variant has been subject to positive or negative selection or has been in the population for a long time. MAF can also affect the power of a genetic association study, as low MAFs may make it difficult to detect a significant association between a variant and a trait. In genome-wide association studies (GWAS), MAF is often used as a criterion for filtering SNPs (single nucleotide polymorphisms) to include in the analysis. For example, in this study, SNPs with MAF less than 5% weren excluded from the analysis to reduce the risk of false positive results.',  
                      'SNP effect prediction according to SnpEff using a custom databased built from Ensembl Plants release-53 (http://plants.ensembl.org/). See http://snpeff.sourceforge.net/VCFannotationformat_v1.0.pdf for definitions',
             'Systematic locus identifiers were assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly. An ID (OsXXg#######) consists of the species name (Os for Oryza sativa), a two-digit number for chromosomes, the type of an identifier (g for genes), and a seven-digit number that indicates a sequential order of loci in a chromosome.See https://rapdb.dna.affrc.go.jp/notes/notes_gene_nomenclature.html',
          'Canonical transcript defined by SNPeff to select one “representative” transcript per gene for SNP effect prediction. Canonical transcripts are defined as the longest CDS of amongst the protein coding transcripts in a gene. If none of the transcripts in a gene is protein coding, then it is the longest cDNA.',
          'Current symbol for the gene locus assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly.',
          'Current Gene name for the gene locus assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly.',
          'Gene description for the gene locus assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly.',
           'score (-log(p-value)) resulting from a GxE association using GLM with PCA correcting for population structure. The higher the value is, the stronger the association is between genetic and environmental variation.',
           'Estimate local False Discovery Rate (FDR). FDR, or false discovery rate, is a statistical method used to control the number of false positive results in multiple hypothesis testing. In the context of a Genome-Wide Association study (GWAS), the FDR is used to adjust the significance threshold of a set of SNPs (single nucleotide polymorphisms) based on their p-values. The goal is to control the expected proportion of false positive associations among the significant SNPs, so as to reduce the risk of false discovery.',
            'Bonferroni correction is a multiple hypothesis testing correction method. In the context of a genome-wide association study (GWAS), the Bonferroni correction can be used to adjust the significance threshold of a set of SNPs (single nucleotide polymorphisms) based on their p-values. The Bonferroni correction can be conservative, as it assumes independence between tests, which may not always be the case in GWAS analysis. Therefore, other correction methods, such as FDR, are often used in place of or in addition to the Bonferroni correction to balance the trade-off between false positive and false negative errors.',
               'Correlation coefficient obtained using the SNPfold program. The closer this correlation coefficient is to 1, the less likely it is that the RNA structure is changed by the SNP. See text on the sidebar for a more detailed explanation.',
             'RNA structure prediction based on a correlation coefficient of 0.8',
            'The fixation index (FST) is a measure of genetic differentiation between populations. In this study we consider the genetic differentiation between Indica and Japonica landraces. A Higher FST indicate greater differentiation between populations, while lower values indicate greater genetic similarity. FST values typically range from 0 to 1, although the calculation with vcftools results in slightly negative numbers, with 0 indicating complete absence of differentiation and 1 indicating complete differentiation between Indica and Japonica populations.',
         'Tajimas D, calculated using a sliding window of 1 kb, is a statistic that measures the difference between the observed and expected levels of nucleotide diversity in a population. This index is calculated by comparing the number of pairwise differences among sequences in a sample (a measure of nucleotide diversity) to the expected number of differences based on the assumption of neutral evolution. A negative Tajimas D value indicates that the observed diversity is lower than expected, which could be due to a reduction in effective population size, selective sweeps, or other factors that affect the evolution of DNA sequences. A positive Tajimas D value indicates that the observed diversity is higher than expected, which could be due to the accumulation of mutations, the effects of balancing selection, or other factors.',
            'Nucleotide diversity (also known as Pi, or π) is a measure of the amount of genetic variation within a population. It is defined as the average number of nucleotide differences per site between any two randomly chosen sequences from a population. Higher values of nucleotide diversity indicate a greater amount of genetic variation within a population, while lower values indicate less variation.',
          
          'Description of the environmental associated with the SNP was obtained from. See the tab with the description of climate variables for more information'
          ],
    header = table.columns().header();
for (var i = 0; i < tips.length; i++) {
  $(header[i]).attr('title', tips[i]);
}
"))
    } else {
      datatable(dat, 
                rownames = FALSE, 
                options = list(autoWidth = TRUE, 
                               dom = '<"lfpti"l<"search">rtip>', 
                               pageLength = 5, 
                               lengthMenu = NULL, 
                               scrollX = TRUE,  # Enable horizontal scrolling
                               columnDefs = list(list(className = 'dt-center', targets = "_all"))),
                               callback = JS("
var tips = ['Chromosome', 
            'Position', 
            'Reference allele is a specific version of a genetic variant that is used as a standard of comparison in genetic studies. In this case, the japonica rice cultivar Nipponbare, whose genome has been sequenced and which is most commonly used in functional genomics',
            'The alternative allele is a term used to describe a version of a gene or genetic variant that is different from the reference allele. For example, if the reference allele at a SNP is the A allele, the alternative allele could be the G, C, or T', 
            'Minor allele frequency (MAF) is a measure of the frequency of a less common variant (allele) of a gene in a population. It is calculated as the number of rice varieties with the the minor allele divided by the total number of varieties with either allele (minor and major) at a given locus (position on a chromosome). MAF is an important measure in population genetics, as it provides information about the distribution and frequency of genetic variants in a population. Low MAFs may indicate that a variant is rare or has been recently introduced into the population, while high MAFs may indicate that a variant has been subject to positive or negative selection or has been in the population for a long time. MAF can also affect the power of a genetic association study, as low MAFs may make it difficult to detect a significant association between a variant and a trait. In genome-wide association studies (GWAS), MAF is often used as a criterion for filtering SNPs (single nucleotide polymorphisms) to include in the analysis. For example, in this study, SNPs with MAF less than 5% weren excluded from the analysis to reduce the risk of false positive results.',   
           'SNP effect prediction according to SnpEff using a custom databased built from Ensembl Plants release-53 (http://plants.ensembl.org/). See http://snpeff.sourceforge.net/VCFannotationformat_v1.0.pdf for definitions',
            'Correlation coefficient obtained using the SNPfold program. The closer this correlation coefficient is to 1, the less likely it is that the RNA structure is changed by the SNP. See text on the sidebar for a more detailed explanation.',
            'Systematic locus identifiers were assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly. An ID (OsXXg#######) consists of the species name (Os for Oryza sativa), a two-digit number for chromosomes, the type of an identifier (g for genes), and a seven-digit number that indicates a sequential order of loci in a chromosome.See https://rapdb.dna.affrc.go.jp/notes/notes_gene_nomenclature.html',
          'Canonical transcript defined by SNPeff to select one “representative” transcript per gene for SNP effect prediction. Canonical transcripts are defined as the longest CDS of amongst the protein coding transcripts in a gene. If none of the transcripts in a gene is protein coding, then it is the longest cDNA.',
           'Current symbol for the gene locus assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly.',
           'Current Gene name for the gene locus assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly.',
           'Gene description for the gene locus assigned to the Rice Annotation Project loci on the International Rice Genome Sequencing Project (IRGSP) genome assembly.',
          'score (-log(p-value)) resulting from a GxE association using GLM with PCA correcting for population structure. The higher the value is, the stronger the association is between genetic and environmental variation.',
           'Estimate local False Discovery Rate (FDR). FDR, or false discovery rate, is a statistical method used to control the number of false positive results in multiple hypothesis testing. In the context of a Genome-Wide Association study (GWAS), the FDR is used to adjust the significance threshold of a set of SNPs (single nucleotide polymorphisms) based on their p-values. The goal is to control the expected proportion of false positive associations among the significant SNPs, so as to reduce the risk of false discovery.',
            'Bonferroni correction is a multiple hypothesis testing correction method. In the context of a genome-wide association study (GWAS), the Bonferroni correction can be used to adjust the significance threshold of a set of SNPs (single nucleotide polymorphisms) based on their p-values. The Bonferroni correction can be conservative, as it assumes independence between tests, which may not always be the case in GWAS analysis. Therefore, other correction methods, such as FDR, are often used in place of or in addition to the Bonferroni correction to balance the trade-off between false positive and false negative errors.',
            'The fixation index (FST) is a measure of genetic differentiation between populations. In this study we consider the genetic differentiation between Indica and Japonica landraces. A Higher FST indicate greater differentiation between populations, while lower values indicate greater genetic similarity. FST values typically range from 0 to 1, although the calculation with vcftools results in slightly negative numbers, with 0 indicating complete absence of differentiation and 1 indicating complete differentiation between Indica and Japonica populations.',
         'Tajimas D, calculated using a sliding window of 1 kb, is a statistic that measures the difference between the observed and expected levels of nucleotide diversity in a population. This index is calculated by comparing the number of pairwise differences among sequences in a sample (a measure of nucleotide diversity) to the expected number of differences based on the assumption of neutral evolution. A negative Tajimas D value indicates that the observed diversity is lower than expected, which could be due to a reduction in effective population size, selective sweeps, or other factors that affect the evolution of DNA sequences. A positive Tajimas D value indicates that the observed diversity is higher than expected, which could be due to the accumulation of mutations, the effects of balancing selection, or other factors.',
            'Nucleotide diversity (also known as Pi, or π) is a measure of the amount of genetic variation within a population. It is defined as the average number of nucleotide differences per site between any two randomly chosen sequences from a population. Higher values of nucleotide diversity indicate a greater amount of genetic variation within a population, while lower values indicate less variation.',
          'Source from which the environmental associated with the SNP was obtained from. See the tab with the description of climate variables for more information' ,'Description of the environmental associated with the SNP was obtained from. See the tab with the description of climate variables for more information'
          ],
    header = table.columns().header();
for (var i = 0; i < tips.length; i++) {
  $(header[i]).attr('title', tips[i]);
}
"))
    }
  })
  
  
  
  # Download option
  output$download_data <- downloadHandler(
    filename = function() {
      paste("filtered_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(df_fdr_filtered(), file, row.names = FALSE)
    }
  )
  # Render the plot
  output$scatter_plot <- renderPlotly({
    if (nchar(input$locus_id) == 0) return()
    df <- df_fdr_filtered()
    if (nrow(df) == 0) {
      return(shinyalert("Sorry, we found no significant GxE associations for this gene", type = "info", timer = 2000,
                        showConfirmButton = FALSE))
    }
    
    title_text <- paste("Locus ID: ", input$locus_id, "<br>", 
                        "Description: ", df$Description[1])
    
    p <- ggplot(df, aes(x = Pos, y = score, color = Environment, shape = EFFECT)) +
      geom_point(alpha = 0.5, size = 3) +
      labs(
        y = "E x G analysis (-log10 P-value)",
        x = "Position (bp)",
        title = title_text
      ) +
      theme_minimal() +
      theme(
        legend.position = "none",
        axis.line = element_line(linewidth = 1, colour = "black"),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
        axis.text = element_text(family = "Arial", color = "black", size = 12),
        axis.title = element_text(family = "Arial", color = "black", face = "bold", size = 14),
        plot.title = element_text(family = "Arial", color = "blue", face = "bold", size = 18)
      )
    
    ggplotly(p) %>%
      layout(title = list(text = title_text, x = 0.5, y = 1.05, font = list(size = 12)),
             margin = list(l = 40, r = 40, t = 60, b = 40))
  })
  
})