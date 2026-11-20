# Options to deploy shiny app

## Option 1: Locally using R invisibly in background
- Install R and required packages on the computer
- Create a desktop shortcut that launches the application without the user needing to interact with R

## Option 2: Locally using a shiny desktop project
- Using the template repository: https://github.com/derryleng/Shiny_Desktop_App
- Create an executable file for windows that downloads the app locally -> all processing happens on the local machine.

## Option 3: Hosting an internal website 
- Using the existing network
- Only approved devices would be able to access it
- Would probably only be useful if more people need to work with it
- Shiny server: deploy the app on existing server - R would need to be installed on a company managed linux server
