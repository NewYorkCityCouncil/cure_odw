# run 00_read_data.Rmd
# read in shootings data
cure_data <- read.csv("data/output/cure_data.csv") %>%
  select("precinct", "shootings_count", "shootings_per_person" , "year")
cure_data$year <- as.character(cure_data$year)

# making map on categories of cohorts
# too many cohorts when grouping by month & year
length(unique(program_dates$date_text))
unique(programs_21$year)

# join to precinct

cohort_shp <- left_join(precinct.shp,
                        programs_21 %>%
                          select(1:6, 9:11)) %>%
  mutate(year = paste0(rep(20,nrow(.)),year),
         year = case_when(year=="20NA" ~ NA,
                          TRUE ~ year),
         lab_lat = st_coordinates(st_centroid(geometry))[,1],
         lab_lon = st_coordinates(st_centroid(geometry))[,2]
         ) %>%  #fixing year & labels for map
  filter(!grepl("2019", NA)) %>%  # remove 2019 precincts but keep NA
  left_join(cure_data, by= c('precinct', 'year')) # add pre shooting numbers

label_shp <- cohort_shp %>% filter(!is.na(year))

# to remove entries for precincts with more than one Cure program 
label_shp_unique <- label_shp[!(label_shp$precinct == 73 & label_shp$year == "2020"), ] 
label_shp_unique <- label_shp_unique[!(label_shp_unique$precinct == 75 & label_shp_unique$year == "2015"), ]
label_shp_unique <- label_shp_unique[!(label_shp_unique$precinct == 114 & label_shp_unique$year == "2021"), ]

# Create color palete
pal = colorFactor(
  palette = c("#666666", "#AF6D46", "#B3B3FF","#1F3A70", "#BA9F64", "#1850B5","#660000", "darkgreen"), # nycc_pal interpolates...
  domain = label_shp$year,
  na.color = "#F9F9F9",
  reverse = T
)

# function to generate map labels
generate_map_labels <- function(label_shp) {
  map_labels <- paste0("When entering Cure, there have been about <b>",
                       round(label_shp$shootings_per_person * 100000),
                       " shootings</b> for every 100K people in <b>",
                       label_shp$neighborhood_area_serviced, "</b> (Precinct ",
                       label_shp$precinct, ")",
                       "<hr>",
                       "<br>","<b>Precint: </b>",
                       label_shp$precinct,
                       "<br>","<b>Community Organization: </b>",
                       label_shp$organization,
                       "<br>","<b>Program Name: </b>",
                       label_shp$program_name,
                       "<br>","<b>Council District(s): </b>",
                       label_shp$council_district,
                       "<br>","<b>Neighborhood Area Serviced: </b>",
                       label_shp$neighborhood_area_serviced,
                       "<br>","<b>Year Entering: </b>",
                       label_shp$year,
                       "<br>","<b>Number of Shootings: </b>",
                       label_shp$shootings_count)
  return(map_labels)
}

# making table for each year
label_shp_2012 <- filter(label_shp_unique, year == 2012)
label_shp_2013 <- filter(label_shp_unique, year == 2013)
label_shp_2014 <- filter(label_shp_unique, year == 2014)
label_shp_2015 <- filter(label_shp_unique, year == 2015)
label_shp_2016 <- filter(label_shp_unique, year == 2016)
label_shp_2019 <- filter(label_shp_unique, year == 2019)
label_shp_2021 <- filter(label_shp_unique, year == 2021)

# use the function to generate map labels for each year
map_labels_2012 <- generate_map_labels(label_shp_2012)
map_labels_2013 <- generate_map_labels(label_shp_2013)
map_labels_2014 <- generate_map_labels(label_shp_2014)
map_labels_2015 <- generate_map_labels(label_shp_2015)
map_labels_2016 <- generate_map_labels(label_shp_2016)
map_labels_2019 <- generate_map_labels(label_shp_2019)
map_labels_2021 <- generate_map_labels(label_shp_2021)
map_labels_all <- generate_map_labels(label_shp_unique)

# map
m <- leaflet(options = leafletOptions(minZoom = 11, maxZoom = 13,
                                      zoomControl = FALSE,
                                      dragging = T)) %>%
  htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }") %>%
 # addCouncilStyle() %>% not working
  setMapWidgetStyle(list(background= "white")) %>%
  addPolygons(data = precinct.shp,
              weight = 1,
              fillColor = "#F9F9F9",
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA") %>%
  addPolygons(data = label_shp_unique, group = "All Cure Precincts",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_all, HTML)) %>%
  addPolygons(data = label_shp_2012, 
              group = "2012",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_2012, HTML)) %>%
  addPolygons(data = label_shp_2013,
              group = "2013",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_2013, HTML)) %>%
  addPolygons(data = label_shp_2014,
              group = "2014",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_2014, HTML)) %>%
  addPolygons(data = label_shp_2015,
              group = "2015",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_2015, HTML)) %>%
  addPolygons(data = label_shp_2016,
              group = "2016",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_2016, HTML)) %>%
  addPolygons(data = label_shp_2019,
              group = "2019",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_2019, HTML)) %>%
  addPolygons(data = label_shp_2021,
              group = "2021",
              weight = 1,
              fillColor = ~pal(year),
              fillOpacity = 1,
              stroke = T,
              color = "#CACACA",
              popup = ~lapply(map_labels_2021, HTML)) %>%
  addLabelOnlyMarkers(lat = label_shp_unique$lab_lon,
                      lng = label_shp_unique$lab_lat,
                      label = label_shp_unique$precinct,
                      labelOptions = labelOptions(permanent = TRUE,
                                                  noHide = TRUE,
                                                  textOnly = TRUE,
                                                  textsize = 10,
                                                  direction = "center",
                                 style = list(color = "#FFFFFF"))) %>%
  # addLegendFactor(data = label_shp, position = "topleft",
  #                 pal= pal,
  #                 shape = "rect",
  #                 orientation = "horizontal",
  #                 values = label_shp$year,
  #                 title = "Precincts Entering Cure by Cohort Year",
  #                 opacity = 1) %>% # remove legend for website
  addLayersControl(options = layersControlOptions(collapsed = T),
                   position = "topleft",
                   baseGroups = c("All Cure Precincts",
                                  "2012", "2013","2014",
                                  "2015", "2016", "2019", "2021"))

m

saveWidget(m, file = "visuals/cohort_map.html")
