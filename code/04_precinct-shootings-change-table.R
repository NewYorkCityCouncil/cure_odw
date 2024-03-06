# run 00_read_data.Rmd
# read in cleaned shootings data -----------
cure_data <- read.csv("data/output/shootings-change-from-start-year_by-precinct.csv") %>%
  replace(is.na(.), "")  %>% # remove NAs
  mutate(across(2:9, as.numeric)) # make all numeric

# clean column names
names(cure_data)[2:11] <- seq(2011, 2020, 1)

# check values' distribution for color binning-classification
# c <- unlist(list(cure_data$`2011`,cure_data$`2012`, cure_data$`2013`, cure_data$`2014`, cure_data$`2015`, cure_data$`2016`, cure_data$`2017`, cure_data$`2018`, cure_data$`2019`, cure_data$`2020`))
# hist(c, breaks = 30)
# hist(c, breaks = 7)
###### gt table ---------

gt_table <- cure_data %>%
  gt(rowname_col = "precinct",
     groupname_col = "groupname") %>%

  # gtExtras::gt_plt_sparkline(sparkline) %>%
  tab_header(title = "% Change in Shootings from Year Before Precincts entered Cure Violence Program",
        subtitle = "In Order by Year of Entry") %>%
  tab_stubhead(label = "Precinct") %>%
  gt_theme_nytimes() %>%
  sub_missing(missing_text = "") %>%
  data_color(columns = starts_with("20"),
             rows = everything(),
             method = "numeric",
             colors =
               scales::col_bin(
                 bins = c(-100,-50,-10,-1,0,1,20,100,150,350),
                 na.color = "transparent",
                 palette = nycc_pal("diverging", reverse = T)(7)),
             contrast_algo = "wcag") %>%
  fmt_percent(columns = starts_with("20"),
              decimals = 0, scale_values = F) %>%
  tab_style(style = list(cell_text(weight = "bold"),
                         cell_borders(sides = c("left", "right"),
                                      style = "double",
                                      color = "#e6e6e6",
                                      weight = px(2))),
            locations = cells_body(rows = c(1:2),
                         columns = "2012")) %>%
  tab_style(style = list(cell_text(weight = "bold"),
                         cell_borders(sides = c("left", "right"),
                                      style = "double",
                                      color = "#e6e6e6",
                                      weight = px(2)) ),
            locations = cells_body(rows = c(3:4),
                                   columns = "2013")) %>%
  tab_style(style = list(cell_text(weight = "bold"),
                         cell_borders(sides = c("left", "right"),
                                      style = "double",
                                      color = "#e6e6e6",
                                      weight = px(2))),
            locations = cells_body(rows = c(5),
                                   columns = "2014")) %>%
  tab_style(style = list(cell_text(weight = "bold"),
                         cell_borders(sides = c("left", "right"),
                                      style = "double",
                                      color = "#e6e6e6",
                                      weight = px(2)) ),
            locations = cells_body(rows = c(6:11),
                                   columns = "2015")) %>%
  tab_style(style = list(cell_text(weight = "bold"),
                         cell_borders(sides = c("left", "right"),
                                      style = "double",
                                      color = "#e6e6e6",
                                      weight = px(2)) ),
            locations = cells_body(rows = c(12:17),
                                   columns = "2016")) %>%
  tab_style(style = list(cell_text(weight = "bold"),
                         cell_borders(sides = c("left", "right"),
                                      style = "double",
                                      color = "#e6e6e6",
                                      weight = px(2)) ),
            locations = cells_body(rows = c(18:21),
                                   columns = "2019")) %>%
  tab_style(style = cell_borders(sides = "bottom",
                                 style = "double",
                                 color = "#CACACA",
                                 weight = px(2)),
            locations = cells_body(columns = "precinct",
                                   rows = c(2,4,5,11,17)) )  %>%
  tab_style(style = cell_text(color = "#222222",
                              size = px(13),
                              font = google_font("Open Sans")),
            locations = cells_column_labels())  %>%
  opt_table_font(font = list(google_font(name = "Open Sans") )) %>%
  rm_header()


gtsave(gt_table, "visuals/precinct-shootings-change-table.html")
