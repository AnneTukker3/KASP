library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "KASP analysis"),
  dashboardSidebar(
    #sidebar navigation
    sidebarMenu(
      #dashboard tab in sidebar
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      #view chart tab in sidebar
      menuItem("Cluster plot", tabName = "clusters", icon = icon("chart-area")),
      #view results table tab in sidebar
      menuItem("Results", tabName = "results", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      #dashboard tab content
      tabItem(tabName = "dashboard",
              h1("Welcome to KASP analysis"),
              p("Upload Rotor-Gene Q data to start."),
              box(
                title = "Upload Rotor-Gene Q Excel file",
                width = 6, #box takes up half the dashboard
                solidHeader = TRUE,
                status = "warning", #colour yellow/orange
                
                fileInput( #file uploader
                  inputId = "file", 
                  label = "Drag and drop your Excel file here",
                  accept = c(".xlsx", ".xls"), #only accepts .xlsx and .xls files
                  multiple = FALSE), #accepts only 1 file at a time
                
                actionButton(
                  inputId = "analyse",
                  label = "Run analysis",
                  icon = icon("play"))
                )
              ),
      tabItem(tabName = "clusters",
              h1("View the scatterplot here"),
              p("On this page you can view and download the scatter plot."),
              p("Please check the clustering as the algorithm could have made mistakes."),
              box(
                title = "Scatterplot normalised FAM vs normalised HEX",
                width = 9,
                solidHeader = TRUE,
                status = "warning",
                
                plotOutput(
                  outputId = "scatter_plot",
                  height = "600px")
                 ),
              box(
                title = "Download scatter plot",
                width = 3,
                solidHeader = TRUE,
                status = "warning",
                
                downloadButton(
                  outputId = "plot_download_png",
                  label = "Download PNG",
                  icon = icon("download")
                ),
                
                downloadButton(
                  outputId = "plot_download_pdf",
                  label = "Download PDF",
                  icon = icon("download")
                )
              )
            ),
      tabItem(tabName = "results",
              h1("Results table"),
              p("On this page you can view and download the full results table."),
              box(
                title = "Results table",
                width = 9,
                solidHeader = TRUE,
                status = "warning",
                
                DT::DTOutput(
                  outputId = "results_table"
                )
                ),
              box(
                title = "Download results table",
                width = 3,
                solidHeader = TRUE,
                status = "warning",
                
                downloadButton(
                  outputId = "table_download_xls",
                  label = "Download Excel",
                  icon = icon("download")
                ),
                
                downloadButton(
                  outputId = "table_download_csv",
                  label = "Download csv",
                  icon = icon("download")
                )
              )
            )
    )
  ),
  skin = "yellow" 
)

#server
server <- function(input, output, session){
#-----------------------
  #sotre results for shiny
#-----------------------
  
  # Store results from the analysis
  plot_result <- reactiveVal(NULL)
  table_result <- reactiveVal(NULL)
  
#-----------------------
  #run the KASP analysis
#-----------------------
  
  #code to run when file is uploaded:
  observeEvent(input$analyse, {
    # Store the uploaded file path in an object called 'file'
    file <- input$file$datapath
    
    # Read Excel file
    raw_data <- readxl::read_excel(
      file,
      sheet = NULL,
      col_names = FALSE
    )
    #calculating the start row of every fluorensence colour
    green_row <- which(raw_data[[1]] == "Channel Cycling A.Green") +3
    orange_row <- which(raw_data[[1]] == "Channel Cycling A.Orange") +3
    yellow_row <- which(raw_data[[1]] == "Channel Cycling A.Yellow") +3
    
    #calculating the end row for each fluorescence colour
    green_end <- orange_row - 4
    orange_end <- yellow_row - 4
    yellow_end <- nrow(raw_data)
    
    #creating tables with fluoresence data for each colour (including blank lines at the end)
    green_df_raw <- raw_data[green_row:green_end,]
    colnames(green_df_raw) <- c("ID","Sample", "FAM")
    
    orange_df_raw <- raw_data[orange_row:orange_end,]
    colnames(orange_df_raw) <- c("ID","Sample", "ROX")
    
    yellow_df_raw <- raw_data[yellow_row:yellow_end,]
    colnames(yellow_df_raw) <- c("ID","Sample", "HEX")
    
    #joining FAM and ROX in 1 table 
    green_orange <- dplyr::left_join(green_df_raw, orange_df_raw, by= c("ID"="ID","Sample"="Sample")) #it triplicates the n/a rows?
    
    #joining HEX to FAM/ROX table
    all_colours <- dplyr::left_join(green_orange,yellow_df_raw) |>
      na.omit() |> #removing N/A rows
      dplyr::filter(,Sample != "BLANK") #removing blank readings
    
    #Adding columns for normalised values and calculating the normalised values. 
    norm_table <- dplyr::mutate(all_colours,norm_FAM = FAM / ROX,norm_HEX = HEX / ROX)
    
    #clustering
    cluster <- kmeans(norm_table |> dplyr::select(c(norm_HEX, norm_FAM)), centers = 4)
    norm_table2 <- norm_table
    norm_table2$cluster = cluster$cluster
    
    #creating ggplot
    plot <- ggplot2::ggplot(norm_table2, mapping = ggplot2::aes(x = norm_FAM, y = norm_HEX)) +
      ggplot2::geom_point() +
      ggrepel::geom_label_repel(ggplot2::aes(label = Sample, fill = Sample), size = 2.5,
                                max.overlaps = 20,
                                box.padding = 0.35,
                                point.padding = 0.025,
                                segment.colour = 'grey50',
                                segment.size = 0.2,
                                alpha = 0.8) +
      ggforce::geom_mark_ellipse(ggplot2::aes(fill = factor(cluster))) +
      ggplot2::theme_classic()
    
    # Save results for use elsewhere in Shiny
    plot_result(plot)
    table_result(norm_table)
  })
  
  # Display scatter plot
  output$scatter_plot <- renderPlot({ #output is displayed as a plot
    
    req(plot_result()) #no plot is displayed before the analysis is run
    
    plot_result() #retrieving the stored ggplot output
  })
  
  # Display results table
  output$results_table <- DT::renderDT({ #display the table as an interactive table
    
    req(table_result()) #no table is displayed before the analysis is run
    
    DT::datatable(table_result()) #retrieves the stored table
  })
  
  # Download scatter plot as PNG
  output$plot_download_png <- downloadHandler( #create a downloadable file and assigning it to the UI output
    
    #creating the dynamic file name with the date of the download:
    filename = function() {
      paste0("KASP_scatter_plot_", format(Sys.Date(), "%d-%m-%Y"), ".png")
    },
    
    content = function(file) { #content tells shiny how to generate the file
      
      req(plot_result()) #requires analysis to be run
      
      ggplot2::ggsave( 
        filename = file,
        plot = plot_result(),
        device = "png",
        width = 10,
        height = 8,
        dpi = 300 #resolution
      )
    }
  )
  
  # Download scatter plot as PDF
  output$plot_download_pdf <- downloadHandler( #create a downloadable file and assigning it to the UI output
    
    #creating the dynamic file name with the date of the download:
    filename = function() {
      paste0("KASP_scatter_plot_", format(Sys.Date(), "%d-%m-%Y"), ".pdf")
    },
    
    content = function(file) { #content tells shiny how to generate the file
      
      req(plot_result())
      
      ggplot2::ggsave(
        filename = file,
        plot = plot_result(),
        device = "pdf",
        width = 10,
        height = 8
      )
    }
  )
  
  #Download results table as Excel
  output$table_download_xls <- downloadHandler(
    
    filename = function() {
      paste0("KASP_results_table_", format(Sys.Date(), "%d-%m-%Y"), ".xlsx")
    },
    
    content = function(file) {
      
      req(plot_result())
      
      writexl::write_xlsx(
        x = table_result(),
        path = file
      )
    }
  )
  
  #Download results table as csv
  output$table_download_csv <- downloadHandler(
    
    filename = function() {
      paste0("KASP_results_table_",format(Sys.Date(), "%d-%m-%Y"), ".csv")
    },
    
    content = function(file) {
      
      rew(plot_result())
      
      write.csv(
        x = table_result(),
        file = file,
        row.names = FALSE
      )
    }
  )
}

#launching the app
shinyApp(ui = ui, server = server)