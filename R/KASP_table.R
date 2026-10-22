#reading in raw data and storing it under 'file'
file <- "~/Tozer_Seeds_BioInformatics/KASP/data/raw/KASP_Recycling_Template-290925-JP_FOA4_SNP6_extreme12-sbeadex_2025-12-01_recycling_result_1.xlsx" 

#reading excel file
raw_data <- readxl::read_excel(file, sheet = NULL, col_names = FALSE)

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
