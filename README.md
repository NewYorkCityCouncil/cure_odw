# Cure Violence Program in NYC
## Neighborhood Investments and Public Safety

An associated webpage for this analysis can be found here https://council.nyc.gov/data/cure/.

### Background
In the wake of a rebound in shootings and homicides since the Covid-19 pandemic, as well as high profile cases of gun violence across the country, violent crime has become a top concern for many New Yorkers. Overall, New York City has a lower violent crime rate than most other large American cities—a rate that is near historic lows, with shootings and homicides down 23.2% and 11.4% respectively from last year. However, violent crime remains an ongoing issue in several hotspots around the city.

Cure Violence takes an evidence-based, public health approach to gun violence by attempting to detect and interrupt conflicts before they escalate, identify and treat high risk individuals (those most likely to commit gun violence and/or become victims of a shooting), and change social norms. According to the NYC DOH “this differs from a criminal justice approach, which does not address how inequity and structural racism can diminish these factors and lead to gun violence in a community.”

While researchers have evaluated the success of Cure Violence in individual NYC precincts, there has not yet been an city-wide analysis of the program’s impact across all affected precincts. The Data Team hoped to fill this gap by conducting our own analysis of Cure Violence across New York City.

### Goal
The Council’s Data Team presents an in-house statistical analysis of the Cure Violence program which analyzes impacts across all involved precincts. Methodology and data are presented, with the results suggesting that the program is effective at reducing shootings in New York City.

### Data
- [NYPD Shooting Incident Data (Historic)](https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Historic-/833y-fsy8)
- [NYPD Arrests Data (Historic)](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrests-Data-Historic-/8h9b-rp9u)
- [NYC Precinct Population Data](https://johnkeefe.net/nyc-police-precinct-and-census-data)

### Methods
#### Structure and Model
We model the impact of Cure through the use of a linear model. Precincts entered the Cure Violence program at different points in time from 2012 and 2019, which produces a time-varying introductory process known as a step-wedge design.

Longitudinal data on shootings spanning from 2006 to 2020 are analyzed. Because of the impact of Covid-19 on crime levels, the 2020 shooting and arrest rates are extrapolated using the pre-Covid data as well as the past 7-year annual time distribution of shootings. What culminated was a segmented regression model, which is used for “statistically modeling interrupted time series data to draw more formal conclusions about the impact of an intervention or event on the measure of interest.” More specifically, a segmented negative-binomial model was used.

#### Outcome of Interest
Our measure of interest is variation in the number of shootings in each precinct. We include a random effect for precincts to account for correlation within group samples. We are also interested in accounting for anything that may have impacted overall tendency for crime to occur. This could include economic or policy changes. Arrest data is used as a proxy for this, and included as a covariate in the model.

There are two parameters of interest: the level and the trend impact of Cure. The level parameter, i.e. immediate impact, refers to the change in shootings immediately and consistently present since the first year that the program was introduced into the precinct. The trend impact estimates any time-varying rate of change in shootings since introduction to the program, i.e. a strengthening or weakening of the impact of the intervention over time.

### Results
After adjusting for precinct populations and number of arrests, we see a statistically significant non-time dependent impact. We find that the expected impact of introducing Cure to a precinct is a 16.64% decrease in shootings, and we have confidence that this is not a random fluctuation, but actually due to the intervention. For the trend impact, we see a 5% additional yearly decrease in shootings, but this decrease is not statistically significant, and therefore we don’t have confidence in attributing this additional effect to the Cure program.

### Limitations
It is important to note that we only adjusted for yearly arrests per precinct and precinct populations but were not able to take into account any other possible confounding variables. There were no interaction terms explored, nor a lag time to allow the intervention to take effect. Because of the impact of Covid-19 on crime levels, we extrapolated any data points after March 15th, 2020.

### Future Work
The City Council's Data Team hopes to further expand on this analysis to better understand the impact of the Cure violence program, and possibly other neighborhood investments, on crime rates. We are currently exploring different models, specifically an event study, to further support the efficacy of the programs as well as researching the possibility of spillover effects.

### Scripts
Code
- 00_load_dependencies.R Load packages neccessary for analysis
- 00_read_data.Rmd Read in data files found in data folder
- 01_cohort_map.R Map of precincts with cure violence programs
- 01_map_shootings_2021.Rmd Map 2021 shootings per person by precinct and outline
- 02_create_cure_analysis_dataset.Rmd Create dataset used for modeling/analysis
- 02_precinct-shooting-averages-dataset_2006_2012.ipynb Calculate shooting averages by precinct for 2006-2012
- 02_precinct-shootings-change-dataset_2011_2020.ipynb Calculate shooting averages by precinct for 2011-2020
- 03_model.Rmd Run mixed negative binomial model with offset
- 04_map-shooting-averages_by-precinct_2006_2012.R Map shooting averages by precinct
- 04_wedge-table_precinct-shootings-change_2011-2020.R Create wedge table for shootings
- eventStudy_ek.Rmd Additional work using event study and exploring spillover effects

