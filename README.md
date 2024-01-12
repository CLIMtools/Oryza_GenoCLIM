[<img align="left" width="200" height="150" src="https://github.com/CLIMtools/Oryza_GenoCLIM/blob/main/www/Oryza_GenoCLIM_logo.png">](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/ "GenoCLIM")

# [Oryza GenoCLIM V.1.0](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/ "Oryza GenoCLIM V.1.0")
[**Oryza GenoCLIM V.1.0**](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/ "Oryza GenoCLIM V.1.0") is a component of [**Oryza CLIMtools**](https://gramene.org/CLIMtools/oryza_v1.0/ "**Oryza CLIMtools**") that allows the user to explore the environmental variation associated to any gene or variant of interest in rice landraces. The database provides climate associations of genetic variants, and the user can query their ‘gene of interest’ within the Indica or Japonica varieties in an interactive database. The user can enter any **[RAP gene ID](https://rapdb.dna.affrc.go.jp/index.html "RAP gene ID")** on the search box and retrieve any significant association with any of the more than 400 environmental parameters that we provide in our database. The results shown can be filtered according to different FDR thresholds and sorted based on their association score or any of the other population genetic indicators provided for these associations. Additionally, Oryza GenoCLIM provides a plot to visualize the results interactively.

We provide information on the predicted effect of SNPs on RNA structure. For this, we provide the SNPfold correlation coefficient. The SNPfold algorithm (Halvorsen et al., 2010) considers the ensemble of structures predicted by the RNA partition functions of RNAfold (Bindewald & Shapiro, 2006) for each reference and alternative sequence and quantifies structural differences between these ensembles by calculating a Pearson correlation coefficient on the base-pairing probabilities between the two sequences. The closer this correlation coefficient is to 1, the less likely it is that the SNP changes the RNA structure. The creators of SNPfold note (Corley et al., 2015) that for genome-wide prediction, the bottom 5% of the correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.445) are most likely to be riboSNitches and the top 5% of correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.99) are most likely to be non-riboSNitches.


-Bindewald, E, & Shapiro, BA. RNA secondary structure prediction from sequence alignments using a network of k-nearest neighbor classifiers. Rna. 2006;12:342-352.
-Corley M, Solem A, Qu K, Chang HY, Laederach A. Detecting riboSNitches with RNA folding algorithms: a genome-wide benchmark. Nucleic Acids Res. 2015;43(3):1859-68.
-Halvorsen M, Martin JS, Broadaway S, Laederach A. Disease‐associated mutations that alter the RNA structural ensemble. PLoS Genet. 2010;6:e1001074.

Before running this app, please ensure that the files in the data folder are "unzipped."

## [<span style="color:blue">Data availability</span>](https://github.com/CLIMtools/Oryza_GenoCLIM/tree/main/data)
Code and data for Oryza GenoCLIM 1.0 will be uploaded to Dryad and Zenodo upon publication. In the meantime, data is available in the data folder of this GitHub repository. Don't hesitate to get in touch with us (aaf11@psu.edu) with any questions/requests.


## [<span style="color:blue">Citation</span>](https://www.biorxiv.org/content/10.1101/2023.05.10.540241v1)

-Ángel Ferrero-Serrano, David Chakravorty, Kobie J Kirven & Sarah M Assmann (2022). Oryza CLIMtools: An Online Portal for Investigating Genome-Environment Associations in Rice. bioRxiv 2023.05.10.540241; doi: https://doi.org/10.1101/2023.05.10.540241

[<img align="left" src="https://github.com/CLIMtools/Oryza_GenoCLIM/blob/main/www/screenshot1.png">](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/ "GenoCLIM")
