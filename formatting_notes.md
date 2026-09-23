# Formatting notes about standard Rotor-Gene output files 

## Column name
- Rotor positions are displayed in column A and column name is 'ID' -> input are numbers from 1 up to 72
- Sample names are displayed in column B and column name is 'Page 1' -> input can be a number or a name
- Fluorescence values are displayed in column C and column name is '1'

## Fluorescence spectra
- The different coloured spectra are all displayed in column C below each other.
- There is no set row where each colour start 
- we can potentially tell R to search for the row with Channel Cycling A.(colour) because this is the common header used to separate the difference coloured spectra.
  - e.g. the orange column names start 2 rows below the header Channel 'Cycling A.Orange' -> could R print the row number that that header is found in and than do that number +2 to know where to start?
- Channel Cycling A.Green always is written in row 23 -> this is the only constant as the starting place of the next colour depends on how big the run was.
  - This means that for the fluorescent Green data, the ID/Page 1/1 table always start at row 25.

## Blanks
- Some files only display the rotor positions that had a sample in, other files display all 72 positions but blank positions are marked with 'BLANK' in the Page 1 column.
- Apart from the way blank positions are displayed, all raw data files are formatted the same.  

I got this information by comparing 4 different raw data files. 
