# Open Data Week Event

## Building Safer Communities – Evaluating Cure Violence Program’s Impact in NYC
(March 19, 2024 at 6pm) 

[Event Link](https://2024.open-data.nyc/event/building-safer-communities-evaluating-cure-violence-programs-impact-in-nyc/) |
[Panelist Bios](https://docs.google.com/document/d/1S1RpwWvjlZOSx-pfOdtpbCPXDWc-XfsFPf1SXxGr0wQ/edit?usp=sharing) | A webpage for this analysis can be found [here](https://council.nyc.gov/data/cure/).
***

### Background
Despite a continuing decline from pandemic highs, violent crime remains a top concern for many New Yorkers. Overall, New York City has a lower violent crime rate than most other large American cities—a rate that is near historic lows, with shootings and homicides down 25% and 11.9%, respectively, between 2022 and 2023. Nevertheless, violent crime remains an ongoing issue in several hotspots around the city.

Over the past few decades, many community-based programs have tested different strategies to reduce crime without the involvement of the criminal legal system. Many of these programs aim to address vulnerable populations’ basic needs such as education, housing, healthcare, and employment. It is possible that such interventions may be just as effective, if not more, at lowering long-term crime rates than traditional approaches to public safety. As policymakers in New York City and beyond make decisions about implementing and funding similar programs in their own cities, it is critical to rigorously evaluate these strategies in order to make data-driven conclusions about their efficacy.

One such program is Cure Violence, which defines violence (particularly gun violence) as a public health issue and seeks to treat it like an infectious disease. Cure Violence takes an evidence-based, public health approach to gun violence by attempting to detect and interrupt conflicts before they escalate, identify and treat high risk individuals (those most likely to commit gun violence and/or become victims of a shooting), and change social norms.

### Goal
The Council’s Data Team presents an in-house statistical analysis of Cure Violence, which analyzes the program's impact across all pariticpating police precincts in New York City. Methodology and data are presented, with the results suggesting that the program is effective at reducing shootings in New York City, making Cure Violence an effective component of the city’s collection of strategies to reduce gun violence.

### Data
- [NYPD Shooting Incident Data (Historic)](https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Historic-/833y-fsy8)
- [NYPD Arrests Data (Historic)](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrests-Data-Historic-/8h9b-rp9u)
- [NYC Precinct Population Data](https://johnkeefe.net/nyc-police-precinct-and-census-data)

### Methods
#### Structure and Model
The Data Team conducted a longitudinal analysis from 2006 to 2023 utilizing Historic and Year-to-Date shooting incident data to assess Cure’s effect on gun violence in NYC. According to data provided to us by the Mayor’s Office of Criminal Justice, there were 28 police precincts that received a Cure program from 2012 to 2021. The start dates for these programs were scattered throughout the 2012-2021 period, as seen in the following map.

We are interested in gun violence at the police precinct-year level, so we collapsed the data to this level by counting the number of shootings per precinct per year. If a precinct had no shootings in a given year, we fill in a zero for that observation. Thus, we have a balanced panel of 1,368 observations for the 76 police precincts across 2006-2023.

Our context involves over-dispersed count data (i.e., number of shootings) which can have low and zero values. Additionally, the typical number of shootings per year varies considerably across precincts. Given this, we analyzed the impact of Cure using Negative Binomial regression models, which handle count data and provide a relative measure of shootings.

### Results
Cure and control precincts’ gun violence levels appear to have followed roughly parallel time trends in the years prior to Cure. Given this, we assume they would have followed parallel time trends throughout 2006-2023 in the absence of Cure—i.e., that precincts without Cure can serve as appropriate controls.
To assess this assumption more formally, the following chart shows the results from an event study specification. The chart shows that, before Cure implementation, Cure and control precincts were following roughly parallel time trends.

Relative to the year before, in the year a precinct received Cure there was a sharp reduction in the gap in shootings between Cure and control precincts of 18.1% (p-value=0.004) on average.

We also see a reduction in the gap in shootings of 17.3% (p-value=0.005) in the first year post-Cure, a reduction of 18.5% (p-value=0.020) in the second year post-Cure, and an average reduction of 15.9% (p-value=0.004) in years after that.

Based on this analysis, Cure appears to have an immediate impact on gun violence. Furthermore, the Cure-aligned reduction in gun violence persists in the years after Cure implementation. This analysis strongly suggests that Cure helps to reduce gun violence and that this effect is long-lasting.

### Limitations
- Our study was not a randomized controlled trial, which is considered the gold standard for assessing the causal effect of an intervention or treatment. 
- We analyzed the effect of Cure at the precinct-level, yet each program covers a smaller catchment area within their precinct. Due to lack of available data on catchment area boundaries, using gun violence data at the precinct-level was the next best option. This may have ultimately led our study to underestimate the effectiveness of Cure, given that it assumes areas (in Cure precincts) outside of the catchment area are treated.
- Due to the interpersonal nature of Cure, Covid may have reduced the effectiveness of Cure. If this is the case, by including precincts that received Cure in 2019 and 2021, we may be underrepresenting Cure’s effectiveness.
- Our study assumed that the implementation of Cure was homogeneous across all precincts, which is likely untrue. 
- Given that Cure is just one element of New York City's Crisis Management System (CMS), it is challenging to parse out the impact of Cure alone. While Cure is considered the core of CMS, each precinct has a different mix of wrap-around services operating alongside Cure.

### Scripts
Code
- 00_load_dependencies.R Load packages neccessary for analysis
- 00_read_data.Rmd Read in data files found in data folder
- 01_cohort_map.R Map of precincts with Cure Violence programs
- 01_eventStudy_ek.Rmd Additional work using event study and exploring spillover effects
- 02_create_cure_analysis_dataset.Rmd Create dataset used for modeling/analysis
- 02_precinct-shooting-averages-dataset_2006_2012.ipynb Calculate shooting averages by precinct for 2006-2012
- 03_model.Rmd Run mixed negative binomial model with offset
- 04_map-shooting-averages_by-precinct_2006_2012.R Map shooting averages by precinct (7-year average)

