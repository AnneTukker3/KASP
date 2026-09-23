# Project Plan

This file will contain the plan for this project, separated in logical phases. A more detailed to-do list will be created in addition to this file. 


## Phase 1: Foundation
- [x] Create Github repo
- [x] Create README, Licence, and .gitignore files
- [x] Create data folder and add to .gitignore
- [x] Add one sentence project aim to README
- [x] Decide on a basic project structure
- [ ] Create DISCRIPTION file

**Project aim:** Create an R/Shiny application that converts raw QIAGEN Rotor-Gene Q KASP assay output into a standardised table, 
calculates normalised fluorescence values, generates KASP scatter plots, and exports the processed results without requiring the user to write any R code.

## Phase 2: Understand the Rotagene output

- [x] Look at a few different Rotor-Gene output files
- [ ] Work out how the output files are structured:
    - [ ] Which column has Rotor-Gene ID's + what name does that column have?
    - [ ] Which column has sample names stored + what name does that column have?
    - [ ] How are rotor positions represented? - think about how we can get R to extract how many positions have data
    - [ ] In what way are the different fluorensce spectra stored? - how can we get R to distinguish which data rows contain which colour fluorensce data
      - [ ] How do blank positions appear in the output?
      - [ ] Are all Rotor-Gene outputs formatted the same? - look at minor difference that could become a problem in the R script.
- [ ] Write up a format_notes.md file

## Phase 3: Define the desired output the R script needs to make

- [x] Decide exact column names for the final output:
   ID | Sample | FAM | ROX | HEX | norm FAM | norm HEX
    - ID = rotor position
    - Sample = sample name/variety
    - FAM = green fluorensce data
    - ROX = oragne fluorensce data
    - HEX = yelloy fluorescence data
    - norm FAM = normalise FAM (FAM/ROX)
    - norm HEX = normalise HEX (HEX/ROX)
- [ ] Can blank readings happen? if so, how to handle them?
- [ ] Can ROX be 0 or missing? what to do if that happens?

## Phase 4: Build core R functions:

- [ ] read_rotorgene_file
     - import the rotorgene output
     - identify the required columns/data
- [ ] extract_ids
     - identify how many positions have data - has to be a number between 1 and 72
     - extract sample names
- [ ] extract_fluorescence
     - extract FAM, ROX, and HEX - can this be done in 1 function?
     - identifier could be: Green, Orange, Yellow (columns under Green until the word Orange is found are FAM)     
- [ ] combine_kasp_data
     - match fluorescence values with IDs and Sample names
- [ ] normalise_fluorescence
     - calculate FAM/ROX
     - calculate HEX/ROX
- [ ] validate_kasp_data
     - initial check to determine that all fluorescence channels exist
     - check if all IDs and sample names match
     - check if FAM, ROX, HEX values are usable
     - flag any missing or unexpected values
- [ ] create_kasp_table
     - produce the final clean dataframe
- [ ] export_kasp_table
     - export a csv file - is .csv or .xlsx preferred?
- [ ] Errors should be clear and useful (for people that don't know R to understand)

## Phase 5: Build the KASP plot
*When the pipeline for generating the clean table works, we can start building the plot*

- [ ] create a plot using ggplot
     - [ ] X-axis = normalised FAM
     - [ ] Y-axis = normalised HEX
     - [ ] Colour points by variety / sample group - Make samples from the same variety the same colour
     - [ ] Add axis labels and title 
     - [ ] Use classic theme
     - [ ] use ggrepel to make a line and give it the name of the variety
     - [ ] output the plot as PNG or PDF?

## Phase 6: Test the pipeline
*Determine all functions work independently (and together) before starting to build a shiny dashboard*

- [ ] Test a few different rotor gene output files (1 smaller run, 1 bigger run, 1 full run)
- [ ] Test around with various files that have issues such as missing rotor positions, blank sample names, missing FAM/HEX/ROX values, etc
- [ ] Test an incorrect file upload
- [ ] Compare the produced table with a table Jeremy made
- [ ] confirm normalisation calculations are correct.

## Phase 7: Build shiny dashboard
*When underlying R function are confirmed to be working*

- [ ] Create basic Shiny app
- [ ] Drag-and-drop file upload
- [ ] Automatically detect number of samples
- [ ] Button to start or  process file (or shoudl it start automatically after upload)
- [ ] Display preview of cleaned table
- [ ] Display KASP scatter plot
- [ ] Show warnings/errors clearly in the interface
- [ ] Add download button for:
   - [ ] CSV
   - [ ] Excel
   - [ ] plot
- [ ] Reset / upload another assay button

## Phase 8: Make it easy to use for non-R users

- [ ] User should never need to open RStudio
- [ ] Avoid requiring the user to manually specify rows/columns
- [ ] Detect relevant data automatically wherever possible
- [ ] Give understandable error messages
- [ ] Add basic instructions:
   - [ ] Export results from Rotor-Gene Q
   - [ ] Drop the file into the app
   - [ ] Check the table / plot
   - [ ] Download results
- [ ] Test with someone who has never used R - rRecord where they get confused and improve the interface
