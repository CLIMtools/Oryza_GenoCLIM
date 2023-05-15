[<img align="left" width="150" height="150" src="https://github.com/CLIMtools/Oryza_GenoCLIM/blob/main/www/Oryza_GenoCLIM_logo.png">](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/ "GenoCLIM")

# [[Oryza GenoCLIM V.1.0](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/ "Oryza GenoCLIM V.1.0")](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/)
[**[Oryza GenoCLIM V.1.0](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/ "Oryza GenoCLIM V.1.0")**](https://gramene.org/CLIMtools/oryza_v1.0/Oryza_GenoCLIM/) is a component of [**Oryza CLIMtools**](https://gramene.org/CLIMtools/oryza_v1.0/ "**Oryza CLIMtools**") that allows the user to explore the environmental variation associated to any gene or variant of interest in rice landraces

Enter any **[RAP gene ID](https://rapdb.dna.affrc.go.jp/index.html "RAP gene ID")** on the search box and retrieve any significant association with any of the more that 400 environmental parameters that we provide in our database. The user may use their desired significance threshold when considering any of these association.

In this version of GenoCLIM, we provide information on the predicted effect of SNPs on RNA structure. For this, we provide the SNPfold correlation coefficient. The SNPfold algorithm (Halvorsen et al., 2010) considers the ensemble of structures predicted by the RNA partition functions of RNAfold (Bindewald & Shapiro, 2006) for each reference and alternative sequence and quantifies structural differences between these ensembles by calculating a Pearson correlation coefficient on the base-pairing probabilities between the two sequences. The closer this correlation coefficient is to 1, the less likely it is that the RNA structure is changed by the SNP. The creators of SNPfold note (Corley et al., 2015) that for genome-wide prediction, the bottom 5% of the correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.445) are most likely to be riboSNitches and the top 5% of correlation coefficient values (corresponding in this CLIMtools dataset to a correlation coefficient of 0.99) are most likely to be non-riboSNitches.

-Halvorsen M, Martin JS, Broadaway S, Laederach A. Disease‐associated mutations that alter the RNA structural ensemble. PLoS Genet. 2010;6:e1001074.

-Bindewald, E, & Shapiro, BA. RNA secondary structure prediction from sequence alignments using a network of k-nearest neighbor classifiers. Rna. 2006;12:342-352.

## Data availability
Code and data for Oryza GenoCLIM 1.0 will be uploaded to Dryad and Zenodo upon publication. In the meantime, data is available in data folder of this GitHub repository. Please contact us with any questions/requests.


## Citation


[<img align="left" src="https://github.com/CLIMtools/GenoCLIM-V2/blob/main/Screen%20Shot2.png">](https://gramene.org/CLIMtools/arabidopsis_v2.0 "GenoCLIM")
