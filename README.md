# KASP Genotyping analysis tool
An interactive shiny application for analysing and visualising Kompetitive Allele Specific PCR (KASP) genotyping data.

## Overview
This tool was developed to simplify and automate the analysis of KASP genotyping data generated using a Rotor-Gene Q real-time PCR instrument.

KASP is a fluorescence-based genotyping technique used to identify genetic variation, particularly single nucleotide polymorphisms (SNPs).
The technique two allele-specific fluorescent signals (FAM and HEX) to distinguish between homozygous and heterozygous genotypes.

The application processes raw fluorescence readings, applies background corrections, identifies genotype clusters, and produces visualisations with downloadable results.
It is designed to support plant breeding and molecular-marker assisted selection by improving the efficiency and reproducibility of the genotype analysis.

## Installation
There are two ways to run the KASP analysis tool:

1. Windows executable: recommended for windows users without R experience.
2. R/shiny installation: for users who want to run/modify the application directly from its code source.

### Windows executable 
A windows executable file (.exe) is available in the Windows download folder to make the application accessible for users without any R experience.

**installation instructions:**
1. Navigate to the "Windows download" folder in the GitHub repository.
2. Download the KASP-analysis_setup.exe file.
3. Follow the downloading instructions.
4. OPTIONAL: Add a desktop shortcut for easy access to the application.
5. Launch the application

**important:** The executable is intended for windows computers. There are no separate R installations required, upon first launch the application installs the necessary packages.

### Run from R (Experienced R users)
Users familiar with R can download the source code and run the application directly.
1. Make sure R is installed on the computer, R can be downloaded here: https://cran.r-project.org/.
2. Download the repository as a ZIP or clone the repository using:
   git clone
3. Install required packages.
The application uses the following packages:
shiny
shinydashboard
readxl
dplyr
ggplot2
ggrepel
ggforce
DT
writexl

- the packages can be installed by running this command in the R console:
  install.packages(c(
  "shiny",
  "shinydashboard",
  "readxl",
  "dplyr",
  "ggplot2",
  "ggrepel",
  "ggforce",
  "DT",
  "writexl"
 ))

4. Launch the application
Open the downloaded app.R file, which can be found in the shiny folder of the repository.
Click Run APP to launch the application or run shiny::runApp("app.R") in the R console.

## How to use
### Dashboard page
Export the fluorescence readings from the Rotor-Gene Q instrument, the dataset should contain the sample identifiers and the corresponding fluorescence values for the FAM and HEX channels.
The Rotor-Gene Q output has to be an excel file to be able to be uploaded to the KASP application.
Upload the file in the designated box on the dashboard page - make sure to read the instructions in the messages box.

When the file is successfully uploaded, click run analysis.

### Cluster plot page
Once the analysis has been run, the cluster plot can be viewed on this page.
The cluster plot can be viewed with or without the R-assigned clusters, and the download buttons for the PNG and PDF work for whichever view is selected at the moment of download.

### Results page
The results page will show an interactive table with the FAM, HEX, and ROX values per sample and the normalised values. 
The table is available for download as an excel or csv file.

## Development
Developed as part of a plant breeding bioinformatics workflow at Tozer Seeds, using R and Shiny to improve the reproducibility and efficiency of KASP genotype analysis.
