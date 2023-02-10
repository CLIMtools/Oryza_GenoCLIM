[<img align="left" width="150" height="150" src="https://github.com/CLIMtools/Oryza_GenoCLIM/www/Oryza_GenoCLIM_logo.png">](https://rstudio.aws.science.psu.edu:3838/aaf11/GenoCLIM/ "GenoCLIM")

# [Oryza GenoCLIM](https://gramene.org/CLIMtools/arabidopsis_v2.0/GenoCLIM-V2/ "GenoCLIM")
[**Oryza GenoCLIM**](https://gramene.org/CLIMtools/arabidopsis_v2.0/GenoCLIM-V2/) (https://gramene.org/CLIMtools/arabidopsis_v2.0/GenoCLIM-V2/) is an SHINY(https://shiny.rstudio.com/) component of [**AOryza CLIMtools**](https://gramene.org/CLIMtools/arabidopsis_v2.0/) (https://gramene.org/CLIMtools/arabidopsis_v2.0/) that allows the user to explore the environmental variation associated to any gene or variant of interest in *Arabidopis thaliana*.

Enter any gene ID on the search box and retrieve any significant association with any of the more that 400 environmental parameters that we provide in our database. The user may use their desired significance threshold when considering any of these association.

This tool provides information on the q-values for all associated variants for the user to impose a particular FDR if desired. We recommend the exploration of the FDR parameters for these ExG association using our [FDRCLIM](https://rstudio.aws.science.psu.edu:3838/aaf11/FDRCLIM/ "FDRCLIM") tool.

In this version of GenoCLIM, we provide information on the predicted effect of SNPs on RNA structure. For this, we provide the SNPfold correlation coefficient. The SNPfold algorithm (Halvorsen et al., 2010) considers the ensemble of structures predicted by the RNA partition functions of RNAfold (Bindewald & Shapiro, 2006) for each reference and alternative sequence and quantifies structural differences between these ensembles by calculating a Pearson correlation coefficient on the base-pairing probabilities between the two sequences. The closer this correlation coefficient is to 1, the less likely it is that the RNA structure is changed by the SNP. The creators of SNPfold note (Corley et al., 2015) that for genome-wide prediction, the bottom 5% of the correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.445) are most likely to be riboSNitches and the top 5% of correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.99) are most likely to be non-riboSNitches.


## [Data availability](https://datadryad.org/stash/dataset/doi:10.5061/dryad.mw6m905zj)
Code and data for CLIMtools V2.0 have been uploaded to Dryad and Zenodo https://datadryad.org/stash/dataset/doi:10.5061/dryad.mw6m905zj 


## Citation
-**Ferrero‑Serrano, Á, Sylvia, MM, Forstmeier, PC, Olson, AJ, Ware, D,Bevilacqua, PC & Assmann, SM. (2022) Experimental demonstration and pan‑structurome prediction of climate‑associated riboSNitches in Arabidopsis. Genome Biology. DOI: 10.1186/s13059‐022‐02656‐4.

-**Ferrero-Serrano, Á & Assmann SM.** (2019) Phenotypic and genome-wide association with the local environment of Arabidopsis. Nature Ecology & Evolution. doi: 10.1038/s41559-018-0754-5.


[<img align="left" src="https://github.com/CLIMtools/GenoCLIM-V2/blob/main/Screen%20Shot2.png">](https://gramene.org/CLIMtools/arabidopsis_v2.0 "GenoCLIM")
