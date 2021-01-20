library(shiny)
library(shinythemes)
library(shinycustomloader)
library(leaflet)
library(DT)
library(ggplot2)
library(dplyr)
library(sf)
library(plotly)

ui <- fluidPage(
    theme = shinytheme('united'),
    
    titlePanel('COVID-19 Dashboard - Social Determinants of Public Health'),
    p('How are the COVID-19 cases related to the social determinants of public health?'),
    hr(),
    
    fluidRow(
        column(
            width = 3,
            uiOutput('regions')
        ),
        column(
            width = 9,
            uiOutput('variables')
        )
    ),
    
    tabsetPanel(
        id = 'tab',
        
        tabPanel(
            'Cases',
            
            h3('Total Cases up to December 19th, 2020'),
            p('Select a region and a variable from above. Mouse over individual countries for info.'),
            
            withLoader(
                leafletOutput('map_cases', width = '90%'),
                loader = 'pacman'
            )
        ),
        tabPanel(
            'Population',
            
            h3('Population Map'),
            p('Select a region and a variable from above. Mouse over individual countries for info.'),
            
            withLoader(
                leafletOutput('map_population', width = '90%'),
                loader = 'pacman'
            ),
            
            hr(),
            
            h3('Correlation Analysis'),
            p('This is how the selected variable is correlated with the total number of confirmed cases. Mouse over individual points for country info.'),
            
            withLoader(
                plotlyOutput('correlation_population', width = '90%'),
                loader = 'pacman'
            )
        ),
        tabPanel(
            'Health',
            
            h3('Health Map'),
            p('Select a region and a variable from above. Mouse over individual countries for info.'),
            
            withLoader(
                leafletOutput('map_health', width = '90%'),
                loader = 'pacman'
            ),
            
            hr(),
            
            h3('Correlation Analysis'),
            p('This is how the selected variable is correlated with the total number of confirmed cases. Mouse over individual points for country info.'),
            
            withLoader(
                plotlyOutput('correlation_health', width = '90%'),
                loader = 'pacman'
            )
        ),
        tabPanel(
            'Education',
            
            h3('Education Map'),
            
            p('Select a region and a variable from above. Mouse over individual countries for info.'),
            withLoader(
                leafletOutput('map_education', width = '90%'),
                loader = 'pacman'
            ),
            
            hr(),
            
            h3('Correlation Analysis'),
            p('This is how the selected variable is correlated with the total number of confirmed cases. Mouse over individual points for country info.'),
            
            withLoader(
                plotlyOutput('correlation_education', width = '90%'),
                loader = 'pacman'
            )
        ),
        tabPanel(
            'Economy',
            
            h3('Economy Map'),
            p('Select a region and a variable from above. Mouse over individual countries for info.'),
            
            withLoader(
                leafletOutput('map_economy', width = '90%'),
                loader = 'pacman'
            ),
            
            hr(),
            
            h3('Correlation Analysis'),
            p('This is how the selected variable is correlated with the total number of confirmed cases. Mouse over individual points for country info.'),
            
            withLoader(
                plotlyOutput('correlation_economy', width = '90%'),
                loader = 'pacman'
            )
        ),
        tabPanel(
            'Happiness',
            
            h3('Happiness Map'),
            p('Select a region and a variable from above. Mouse over individual countries for info.'),
            
            withLoader(
                leafletOutput('map_happiness', width = '90%'),
                loader = 'pacman'
            ),
            
            hr(),
            
            h3('Correlation Analysis'),
            p('This is how the selected variable is correlated with the total number of confirmed cases. Mouse over individual points for country info.'),
            
            withLoader(
                plotlyOutput('correlation_happiness', width = '90%'),
                loader = 'pacman'
            )
        ),
        tabPanel(
            'Data',
            
            h3('COVID-19 Cases and All Variables'),
            p('Below is the data used for this project. You may select a region from above. You may also browse, sort and search in the table below.'),
            
            withLoader(
                DTOutput('data'),
                loader = 'pacman'
            ),
            
            h3('Data Sources'),
            tags$ul(
              tags$li('Best Healthcare ranking: ', a('https://www.who.int/healthinfo/paper30.pdf', target = '_blank')),
              tags$li('Current health expenditure (% of GDP): ', a('https://data.worldbank.org/indicator/SH.XPD.CHEX.GD.ZS', target = '_blank')),
              tags$li('Hospital beds: ', a('https://www.kaggle.com/ikiulian/global-hospital-beds-capacity-for-covid19?select=hospital_beds_global_v1.csv', target = '_blank')),
              tags$li('Covid test: ', a('https://ourworldindata.org/coronavirus-testing#how-many-tests-are-performed-each-day', target = '_blank')),
              tags$li('Doctors and Nurses: ', a('https://data.oecd.org/healthres/doctors.htm#indicator-chart', target = '_blank')),
              tags$li('Novel Coronavirus (COVID-19) Cases Data: ', a('https://data.humdata.org/dataset/novel-coronavirus-2019-ncov-cases', target = '_blank')),
              tags$li('The World Bank: ', a('https://data.worldbank.org/indicator', target = '_blank')),
              tags$li('World Happiness Report: ', a('https://www.kaggle.com/unsdsn/world-happiness', target = '_blank')),
              tags$li('Government Expenditure on Education: ', a('https://data.worldbank.org/indicator/SE.XPD.TOTL.GD.ZS?view=chart', target = '_blank')),
              tags$li('Adult female literacy rate: ', a('https://data.worldbank.org/indicator/SE.ADT.LITR.FE.ZS?view=chart', target = '_blank')),
              tags$li('Adult male literacy rate: ', a('https://data.worldbank.org/indicator/SE.ADT.LITR.MA.ZS?view=chart', target = '_blank')),
              tags$li('Youth female literacy rate: ', a('https://data.worldbank.org/indicator/SE.ADT.1524.LT.FE.ZS?view=chart', target = '_blank')),
              tags$li('Youth male literacy rate: ', a('https://data.worldbank.org/indicator/SE.ADT.1524.LT.MA.ZS?view=chart', target = '_blank')),
              tags$li('Adult total literacy rate: ', a('https://data.worldbank.org/indicator/SE.ADT.LITR.ZS?view=chart', target = '_blank')),
              tags$li('Youth total literacy rate: ', a('https://data.worldbank.org/indicator/SE.ADT.1524.LT.ZS?view=chart ', target = '_blank')),
              tags$li('Cause of death, by communicable diseases and maternal, prenatal and nutrition conditions (% of total): ', a('https://data.worldbank.org/indicator/SH.DTH.COMM.ZS', target = '_blank')),
              tags$li('Cause of death, by injury (% of total): ', a('https://data.worldbank.org/indicator/SH.DTH.INJR.ZS?view=map', target = '_blank')),
              tags$li('Cause of death, by non-communicable diseases (% of total): ', a('https://data.worldbank.org/indicator/SH.DTH.NCOM.ZS', target = '_blank')),
              tags$li('Death rate, crude (per 1,000 people): ', a('https://data.worldbank.org/indicator/SP.DYN.CDRT.IN', target = '_blank')),
              tags$li('Diabetes prevalence (% of population ages 20 to 79): ', a('https://data.worldbank.org/indicator/SH.STA.DIAB.ZS', target = '_blank')),
              tags$li('Immunization, DPT (% of children ages 12-23 months): ', a('https://data.worldbank.org/indicator/SH.IMM.IDPT', target = '_blank')),
              tags$li('Immunization, HepB3 (% of one-year-old children): ', a('https://data.worldbank.org/indicator/SH.IMM.HEPB', target = '_blank')),
              tags$li('Immunization, measles (% of children ages 12-23 months): ', a('https://data.worldbank.org/indicator/SH.IMM.MEAS', target = '_blank')),
              tags$li('Life expectancy at birth, total (years): ', a('https://data.worldbank.org/indicator/SP.DYN.LE00.IN', target = '_blank')),
              tags$li('Prevalence of anemia among children (% of children under 5): ', a('https://data.worldbank.org/indicator/SH.ANM.CHLD.ZS', target = '_blank')),
              tags$li('Prevalence of undernourishment (% of population): ', a('https://data.worldbank.org/indicator/SN.ITK.DEFC.ZS', target = '_blank')),
              tags$li('Risk of impoverishing expenditure for surgical care (% of people at risk): ', a('https://data.worldbank.org/indicator/SH.SGR.IRSK.ZS', target = '_blank'))
            )              
        ),
        tabPanel(
            'User Guide',
            
            h3('How to Use The App?'),
            
            tags$ol(
                tags$li('Click', a('https://rickysoo.shinyapps.io/wqd7001/', target = '_blank'), 'to Covid-19 Dashboard – Social Determinants of Public Health landing page.'),
                
                tags$li('The landing page is a world map indicate the number of total Covid-19 cases as of December 19, 2020 for all countries.'),
                
                tags$li('Selection of confirmed cases, recovered cases and death cases is available at top right.'),
                tags$img(src = 'step3.png'),
                
                tags$li('Select the region from drop down to zoom in the world map by region.'),
                tags$img(src = 'step4.png'),
                
                tags$li('There are 5 different categories of social determinants of health (SDH) namely Population, Health, Education, Economy and Happiness. Click on the tab, to observe the correlation between Covid-19 cases and SDH.'),
                tags$img(src = 'step5.png'),
                
                tags$li('Correlation analysis scatter plot will be displayed below the map.'),
                tags$img(src = 'step6.png'),
                
                tags$li('Click on region to select or deselect the region.'),
                tags$img(src = 'step7.png'),
                
                tags$li('Click on Toggle Spike Lines to toggle the lines to axis X & Y with details.'),
                tags$img(src = 'step8a.png'),
                tags$img(src = 'step8b.png'),
                
                tags$li('Click show closest data on hover to show the details of the data point.'),
                tags$img(src = 'step9.png'),
                
                tags$li('Click compare data on hover to compare data point sitting near the same vertical line.'),
                tags$img(src = 'step10.png'),
                
                tags$li('There are multiple datasets available for each category.'),

                h4('Population'),
                tags$img(src = 'step11a.png'),

                h4('Health'),
                tags$img(src = 'step11b.png'),
                
                h4('Education'),
                tags$img(src = 'step11c.png'),
                
                h4('Economy'),
                tags$img(src = 'step11d.png'),
                
                h4('Happiness'),
                tags$img(src = 'step11e.png'),
                
                tags$li('The dataset for each country is available under Data tab.'),
                tags$img(src = 'step12.png'),
                
                tags$li('Enter the country name/region to search the data by country/region.'),
                tags$img(src = 'step13.png'),
                
                tags$li('Click on expand icon the view data of each variables.'),
                tags$img(src = 'step14a.png'),
                tags$img(src = 'step14b.png')
            ),
        ),
        tabPanel(
            'Codebook',
            
            h3('Variables Used'),
            p('This table explains the variables used for the data.'),
            
            withLoader(
                tableOutput('notes'),
                loader = 'pacman'
            )
        )
    ),
    
    hr(),
    p(
        'Brought to you by Lim Lee Wen (17081783), Lim Wen Yan (S2019787), Samuel Wong Ing Shiing (S2018282), Soo Chee Kiong (17083991) | ',
        a('GitHub', href = 'https://github.com/rickysoo/wqd7001', target = '_blank')
  )
)
