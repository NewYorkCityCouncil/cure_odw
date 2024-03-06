# uploading data
shootings_06_12 <- read.csv('data/output/NYC-precinct-shootings_mean_2006_2012.csv')
precinct.shp <- st_read("data/input/Police\ Precincts/geo_export_ece0487d-79ca-4c55-898e-8333b6d2b0bc.shp")
precinct.shp <- st_transform(precinct.shp,'+proj=longlat +datum=WGS84')

# just precincts in cure
program_dates <- read.csv('data/output/programMerge.csv')
precincts_in_cure <- unique(program_dates$precinct)

# joining shootings per person data with precinct shape file
shootings_06_12.shp <- precinct.shp %>%
  left_join(shootings_06_12, by=c("precinct"))
shootings_06_12.shp <- shootings_06_12.shp %>%
  st_as_sf() %>% st_transform('+proj=longlat +datum=WGS84')

# converting NaN to 0
shootings_06_12.shp[is.na(shootings_06_12.shp)] <- 0

# check column distribution
plot(density(shootings_06_12.shp$shootings_per_100K, na.rm = T))
hist(shootings_06_12.shp$shootings_per_100K, breaks = 20)

# will use jenks for bins
int_prct <- classIntervals(shootings_06_12.shp$shootings_per_100K,
                           n = 5, style = 'jenks')

#blue_pal <- c('#e7eefb', '#cdd4f5',  '#98a3ea', '#5675dd', '#1d5fd6')


# use the custom palette function in colorBin
palPct <- colorBin(
  palette = "nycc_blue",
  bins = int_prct$brks,
  domain = shootings_06_12.shp$shootings_per_100K,
  na.color = "#E6E6E6",
  reverse = FALSE
)

# finding the centroids of all of the precincts for labeling
shootings_06_12.shp <- shootings_06_12.shp %>%
  mutate(lab_lat = st_coordinates(st_centroid(geometry,
                                              of_largest_polygon = T))[,1],
         lab_lon = st_coordinates(st_centroid(geometry,
                                              of_largest_polygon = T))[,2])

# labels when clicking on the map
map_labels <- paste0("<b>Precinct: </b>",
                     shootings_06_12.shp$precinct,
                     "<br>","<b>Shootings Per 100K: </b>",
                     round(shootings_06_12.shp$shootings_per_100K, 2))
# cure precinct control
cure_pcts<- HTML('<div> <span style="display:inline-block;background:#ffffff;border:2px solid #333333;height :0.8rem;width:0.8rem;margin-right:0.5rem;"></span> Cure Precincts </div>')

# fitler version
filter_light <- shootings_06_12.shp %>%
  filter(precinct %in% precincts_in_cure) %>%
  filter(shootings_per_100K <= 51.3)

filter_dark <- shootings_06_12.shp %>%
  filter(precinct %in% precincts_in_cure) %>%
  filter(shootings_per_100K > 51.3)

# creating the choropleth
m <- leaflet(options = leafletOptions(minZoom = 11, maxZoom = 13,
                                      zoomControl = FALSE,
                                      dragging = T)) %>%
  htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }") %>% # moving zoom control to the right
  setView(-73.984865, 40.710542, zoom = 11) %>%
  setMapWidgetStyle(list(background = "white"))  %>% # white background
  addPolygons(data = shootings_06_12.shp, # adding shootings by precinct
              weight = 0.3, opacity = 1,
              fillColor = ~palPct(shootings_per_100K),
              stroke = T, color = "#CACACA",
              fillOpacity = 1,
              popup = ~map_labels,
              smoothFactor = 0) %>%
  addPolylines(data = boro, weight = 0.7, # read in boro in 00_read_data.Rmd
               stroke = TRUE,
               color = "#666666") %>%
  addPolylines(data = shootings_06_12.shp %>%
                 filter(precinct %in% precincts_in_cure),
               highlightOptions = highlightOptions(bringToFront = T),
               smoothFactor = 0.5,
               color = "#333333",
               stroke = TRUE,
               opacity = 1,
               weight = 2) %>%
  addLegend_decreasing(position ="topleft", # adding a legend
                       pal= palPct,
                       values = shootings_06_12.shp$shootings_per_100K,
                       title = "Shootings Per 100K",
                       labFormat = labelFormat(digits = 1),
                       opacity = 1,
                       decreasing=TRUE) %>%
  addControl(cure_pcts, position = "topleft") %>%
  addLabelOnlyMarkers(lat = filter_light$lab_lon, # adding precinct labels
                      lng = filter_light$lab_lat,
                      label = filter_light$precinct,
                      labelOptions = labelOptions(permanent = TRUE,
                                                  noHide = TRUE,
                                                  textOnly = TRUE,
                                                  textsize = 4,
                                                  direction = "auto",
                                                  style = list(color = "#23417D",
                                                               "font-family" = google_font('Open Sans'),
                                                               "font-weight" = "normal"))) %>%
  addLabelOnlyMarkers(data = filter_dark,
                      lat = filter_dark$lab_lon, # adding precinct labels
                      lng = filter_dark$lab_lat,
                      label = filter_dark$precinct,
                      labelOptions = labelOptions(permanent = TRUE,
                                                  noHide = TRUE,
                                                  textOnly = TRUE,
                                                  textsize = 4,
                                                  direction = "center",
                                                  style = list(color = "#FFFFFF",
                                                               "font-family" = google_font('Open Sans'),
                                                               "font-weight" = "normal")))



m

saveWidget(m, file = "visuals/avg_shootings_map.html")

